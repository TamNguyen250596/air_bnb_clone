import 'dart:async';
import 'package:air_bnb_clone/data/models/realm_models/conversation/conversation.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/conversation_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';
import '../../../commons/extensions/stream_extension.dart';
import '../../../data/models/item/base_item_model.dart';

class InboxState {
  const InboxState({
    this.isLoading = false,
    this.errorMessage,
    this.conversations = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<BaseItemModel> conversations;
}

class InboxCubit extends Cubit<InboxState> {

  // Construct
  InboxCubit({
    required AuthRepository authRepository,
    required ConversationRepository conversationRepository,
  })  : _authRepository = authRepository,
        _conversationRepository = conversationRepository,
        super(const InboxState()) {
    _observeData();
  }

  // Properties
  final AuthRepository _authRepository;
  final ConversationRepository _conversationRepository;
  StreamSubscription<RealmResultsChanges<Conversation>>? _conversationsSubscription;

  // Life cycle
  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }

  // Public Method
  /// Returns the [Conversation] for an inbox row; null if the item is not backed by a valid conversation.
  Conversation? conversationFor(BaseItemModel item) {
    final o = item.object;
    if (o is Conversation && o.isValid) return o;
    return null;
  }

  // Private Method
  Future<void> _observeData() async {
    final userId = await _authRepository.userId;
    if (userId == null) return;

    _conversationsSubscription = _conversationRepository
        .observeConversations(userId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((changes) {
      final list = _createConversations(changes.results);
      emit(InboxState(conversations: list));
    });
  }

  List<BaseItemModel> _createConversations(RealmResults<Conversation> entities) {
    return entities
        .where((entity) => entity.isValid)
        .map((entity) => BaseItemModel(
              entity.id,
              imageUrl: entity.avatar ?? "",
              title: entity.lastMessage ?? '',
              des: _formatDdMmYy(entity.lastMessageAt ?? entity.createdAt),
              tag: 'conversation',
              object: entity,
            ))
        .toList();
  }

  /// Formats as `dd/MM/yy` (e.g. `09/03/25`).
  String _formatDdMmYy(DateTime? at) {
    if (at == null) return '';
    final dd = at.day.toString().padLeft(2, '0');
    final mm = at.month.toString().padLeft(2, '0');
    final yy = (at.year % 100).toString().padLeft(2, '0');
    return '$dd/$mm/$yy';
  }
}
