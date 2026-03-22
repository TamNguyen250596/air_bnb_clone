import 'dart:async';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/conversation/conversation.dart';
import 'package:air_bnb_clone/data/models/realm_models/message/message.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';
import '../../../commons/extensions/stream_extension.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/message_repository.dart';
import '../../../data/repositories/user_repository.dart';

class ChatState {
  ChatState({
    this.conversationName = '',
    this.messages = const [],
    this.isLoading = true,
    this.currentUserId,
  });

  final String conversationName;
  final List<BaseItemModel> messages;
  final bool isLoading;
  final String? currentUserId;

  ChatState copyWith({
    String? conversationName,
    List<BaseItemModel>? messages,
    bool? isLoading,
    String? currentUserId,
  }) {
    return ChatState(
      conversationName: conversationName ?? this.conversationName,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required Conversation? conversation,
    required MessageRepository messageRepository,
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _conversation = conversation,
        _messageRepository = messageRepository,
        _authRepository = authRepository,
        _userRepository = userRepository,
        super(
          ChatState(
            conversationName: conversation?.name ?? '',
            isLoading: conversation != null,
          ),
        ) {
    _observeMessages();
  }

  final Conversation? _conversation;
  final MessageRepository _messageRepository;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<RealmResultsChanges<Message>>? _messagesSubscription;

  /// Sender ids currently being loaded via [UserRepository.getUser] (dedupes concurrent fetches).
  final Set<String> _inFlightSenderIds = {};

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _inFlightSenderIds.clear();
    return super.close();
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final conv = _conversation;
    if (conv == null) return;
    final userId = await _authRepository.userId;
    if (userId == null) return;

    await _messageRepository.createMessage({
      'conversation_id': conv.id,
      'sender_id': userId,
      'text': trimmed,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> _observeMessages() async {
    final conv = _conversation;
    if (conv == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final userId = await _authRepository.userId;
    emit(
      state.copyWith(
        currentUserId: userId,
        conversationName: conv.name ?? state.conversationName,
      ),
    );

    _messagesSubscription = _messageRepository
        .observeMessagesByConversationId(conv.id)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((changes) {
      if (isClosed) return;
      final currentUserId = state.currentUserId ?? userId;
      final list = _messagesToItems(changes.results, currentUserId);
      emit(
        state.copyWith(
          messages: list,
          isLoading: false,
        ),
      );
      _prefetchMissingSenders(changes.results);
    });
  }

  /// Sync map; [imageUrl] comes from linked [Message.sender] only. Realm observe should
  /// re-fire after [UserRepository.getUser] hydrates users.
  List<BaseItemModel> _messagesToItems(
    RealmResults<Message> entities,
    String? currentUserId,
  ) {
    return entities
        .where((e) => e.isValid)
        .map(
          (m) => BaseItemModel(
            m.id,
            title: m.text ?? '',
            des: _formatMessageTime(m.createdAt),
            tag: m.senderId == currentUserId ? 'sent' : 'received',
            imageUrl: m.sender?.imageUrl ?? '',
            object: m,
          ),
        )
        .toList();
  }

  void _prefetchMissingSenders(RealmResults<Message> entities) {
    final toFetch = <String>{};
    for (final m in entities.where((e) => e.isValid)) {
      if (m.sender != null) continue;
      final sid = m.senderId;
      if (sid == null || sid.isEmpty) continue;
      if (_inFlightSenderIds.contains(sid)) continue;
      toFetch.add(sid);
    }
    if (toFetch.isEmpty) return;

    for (final sid in toFetch) {
      _inFlightSenderIds.add(sid);
    }

    unawaited(_loadSendersParallel(toFetch));
  }

  Future<void> _loadSendersParallel(Set<String> ids) async {
    await Future.wait(
      ids.map((id) async {
        try {
          await _userRepository.getUser(id);
        } catch (_) {
          // User missing or network; Realm/message observe may still update later.
        } finally {
          _inFlightSenderIds.remove(id);
        }
      }),
    );
  }

  String _formatMessageTime(DateTime? at) {
    if (at == null) return '';
    final t =
        '${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}';
    return '${at.day}/${at.month}/${at.year} $t';
  }
}
