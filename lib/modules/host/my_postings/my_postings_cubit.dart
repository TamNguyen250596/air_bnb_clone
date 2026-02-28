import 'dart:async';
import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/posting_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';
import '../../../data/models/realm_models/posting/posting.dart';

class MyPostingsState {
  const MyPostingsState({
    this.postings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<BaseItemModel> postings;
  final bool isLoading;
  final String? errorMessage;
}

class MyPostingsCubit extends Cubit<MyPostingsState> {
  MyPostingsCubit({
    required PostingRepository postingRepository,
    required AuthRepository authRepository,
  })  : _postingRepository = postingRepository,
        _authRepository = authRepository,
        super(const MyPostingsState()) {
    _setUpInitialData();
    _observeData();
  }

  final PostingRepository _postingRepository;
  final AuthRepository _authRepository;
  StreamSubscription? _postingsSubscription;

  @override
  Future<void> close() {
    _postingsSubscription?.cancel();
    return super.close();
  }

  void _setUpInitialData() {
    emit(MyPostingsState(
      postings: [BaseItemModel("create_a_listing")],
    ));
  }

  Future<void> _observeData() async {
    final hostId = await _authRepository.userId;
    if (hostId == null) return;

    _postingsSubscription = _postingRepository
        .observePostings(hostId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((postings) {
      final list = _createPostings(postings.results);
      emit(MyPostingsState(postings: list));
    });
  }

  List<BaseItemModel> _createPostings(RealmResults<Posting> entities) {
    final list = entities
        .where((entity) => entity.isValid)
        .map((entity) => BaseItemModel(
              entity.id,
              imageUrl: entity.images.first,
              title: entity.name ?? "NA",
              tag: "posting",
              object: entity,
            ))
        .toList();
    list.add(BaseItemModel("create_a_listing"));
    return list;
  }
}
