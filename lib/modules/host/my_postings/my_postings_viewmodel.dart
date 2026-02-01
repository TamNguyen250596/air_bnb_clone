import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';
import '../../../commons/extensions/stream_extension.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/posting_repository.dart';

// ========== My Postings ViewModel ==========
class MyPostingsViewModel extends BaseChangeNotifier {

  // ========== Constructor ==========
  MyPostingsViewModel({
    required PostingRepository postingRepository,
    required AuthRepository authRepository,
  }) : _postingRepository = postingRepository,
        _authRepository = authRepository {
    _setUpInitialData();
    _observeData();
  }

  // ========== Private Properties ==========
  final PostingRepository _postingRepository;
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String _errorMessage = "";
  List<BaseItemModel> _postings = [];

  // ========== Public Getters ==========
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<BaseItemModel> get postings => _postings;

  // ========== Private Methods ==========
  void _setUpInitialData() {
    _postings.add(BaseItemModel("create_a_listing"));
    notifyListeners();
  }

  Future<void> _observeData() async {
    final hostId = await _authRepository.userId;
    if (hostId == null) {
      return;
    }

    _postingRepository
        .observePostings(hostId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((postings) {
          _postings.clear();
          _postings = _createPostings(postings.results);
          notifyListeners();
    }).addTo(subscriptions);
  }

  List<BaseItemModel> _createPostings(RealmResults<Posting> entities) {
    List<BaseItemModel> postings  = entities
        .where((entity) => entity.isValid)
        .map((entity) => BaseItemModel(
              entity.id,
              imageUrl: entity.images.first,
              title: entity.name ?? "NA",
              tag: "posting",
              object: entity
            ))
        .toList();
    postings.add(BaseItemModel("create_a_listing"));
    return postings;
  }
}

