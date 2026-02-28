import 'dart:async';
import 'package:air_bnb_clone/data/models/item/posting_grid_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/repositories/posting_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class ExploreState {
  const ExploreState({
    this.postings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<PostingGridItemModel> postings;
  final bool isLoading;
  final String? errorMessage;
}

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required PostingRepository postingRepository})
      : _postingRepository = postingRepository,
        super(const ExploreState()) {
    _observeSearchTxt();
    _searchTxtController.add("");
  }

  final PostingRepository _postingRepository;
  final _searchTxtController = BehaviorSubject<String>();
  StreamSubscription? _searchSubscription;

  @override
  Future<void> close() {
    super.close();
    _searchSubscription?.cancel();
    return _searchTxtController.close();
  }

  void setSearchTxt(String searchTxt) {
    _searchTxtController.add(searchTxt);
  }

  void _observeSearchTxt() {
    _searchSubscription?.cancel();
    _searchSubscription = _searchTxtController
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen(_searchPostings);
  }

  Future<void> _searchPostings(String searchTxt) async {
    emit(ExploreState(postings: state.postings, isLoading: true));
    try {
      final results = await _postingRepository.getPostingsForExplore(searchTxt);
      final postings = _createPostings(results);
      emit(ExploreState(postings: postings, isLoading: false));
    } catch (e) {
      emit(ExploreState(
        postings: [],
        isLoading: false,
        errorMessage: e.toString(),
      ));
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
              price: entity.price != null
                  ? "\$${entity.price!.toStringAsFixed(0)} / day"
                  : "",
              rating: entity.rating ?? 0.0,
              ratingStr: entity.rating?.toString() ?? "",
            ))
        .toList();
  }

  Posting? getPostingEntity(PostingGridItemModel item) {
    if (item.object is Posting) {
      return item.object as Posting;
    }
    return null;
  }
}
