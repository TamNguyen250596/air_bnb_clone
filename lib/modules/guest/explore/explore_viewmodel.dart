import 'dart:async';
import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';
import 'package:air_bnb_clone/data/models/item/posting_grid_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/repositories/posting_repository.dart';
import 'package:rxdart/rxdart.dart';

class ExploreViewModel extends BaseChangeNotifier {

  // Constructor
  ExploreViewModel({
    required PostingRepository postingRepository,
  }) : _postingRepository = postingRepository {
    _observeSearchTxt();
    _searchTxtController.add("");
  }

  // Private Properties
  final PostingRepository _postingRepository;
  final _searchTxtController = BehaviorSubject<String>();
  List<PostingGridItemModel> _postings = [];
  bool _isLoading = false;
  String _errorMessage = "";

  // Public Getters
  List<PostingGridItemModel> get postings => _postings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Public Methods
  void setSearchTxt(String searchTxt) {
    _searchTxtController.add(searchTxt);
  }

  Posting? getPostingEntity(PostingGridItemModel item) {
    if (item.object is Posting) {
      return item.object as Posting;
    } else {
      return null;
    }
  }

  void _reset() {
    _errorMessage = "";
    _isLoading = false;
  }

  // Private Methods
  void _observeSearchTxt() {
    _searchTxtController
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen((searchTxt) {
      _searchPostings(searchTxt);
    }).addTo(subscriptions);
  }

  Future<void> _searchPostings(String searchTxt) async {
    try {
      _setLoading(true);
      _reset();
      final results = await _postingRepository.getPostingsForExplore(searchTxt);
      _postings = _createPostings(results);
    } catch (e) {
      _setError(e.toString());
      _postings = [];
    } finally {
      _setLoading(false);
    }
  }

  List<PostingGridItemModel> _createPostings(Iterable<Posting> entities) {
    return entities
        .where((entity) => entity.isValid)
        .map((entity) => PostingGridItemModel(
              entity.id,
              imageUrl: entity.images.isNotEmpty ? entity.images.first : "",
              title: entity.name ?? "NA",
              des: entity.description ?? "NA",
              tag: "posting",
              object: entity,
              price: entity.price != null ? "\$${entity.price!.toStringAsFixed(0)} / day" : "",
              rating: entity.rating ?? 0.0,
              ratingStr: entity.rating?.toString() ?? "",
            ))
        .toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
