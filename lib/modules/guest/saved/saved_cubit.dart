import 'dart:async';
import 'dart:developer' as developer;

import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/models/item/posting_grid_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/favourite_posting/favourite_posting.dart';
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/favourite_posting_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';

class SavedState {
  const SavedState({
    this.postings = const [],
    this.isLoading = false,
  });

  final List<PostingGridItemModel> postings;
  final bool isLoading;

  SavedState copyWith({
    List<PostingGridItemModel>? postings,
    bool? isLoading,
  }) {
    return SavedState(
      postings: postings ?? this.postings,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SavedCubit extends Cubit<SavedState> {
  SavedCubit({
    required FavouritePostingRepository favouritePostingRepository,
    required AuthRepository authRepository,
  })  : _favouritePostingRepository = favouritePostingRepository,
        _authRepository = authRepository,
        super(const SavedState(isLoading: true)) {
    _observeFavourites();
  }

  final FavouritePostingRepository _favouritePostingRepository;
  final AuthRepository _authRepository;
  StreamSubscription<RealmResultsChanges<FavouritePosting>>? _favouritesSubscription;

  Future<void> _observeFavourites() async {
    final userId = await _authRepository.userId;
    if (userId == null) {
      emit(const SavedState(postings: [], isLoading: false));
      return;
    }

    emit(const SavedState(postings: [], isLoading: true));

    _favouritesSubscription = _favouritePostingRepository
        .observeFavouritePostings(userId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((changes) {
      emit(
        state.copyWith(
          postings: _favouritesToGridItems(changes.results),
          isLoading: false,
        ),
      );
    });
  }

  List<PostingGridItemModel> _favouritesToGridItems(
    RealmResults<FavouritePosting> results,
  ) {
    return results
        .where((f) => f.isValid)
        .where((f) {
          final p = f.posting;
          return p != null && p.isValid;
        })
        .map(_favouriteToGridItem)
        .toList();
  }

  PostingGridItemModel _favouriteToGridItem(FavouritePosting favourite) {
    final entity = favourite.posting!;
    return PostingGridItemModel(
      favourite.id,
      imageUrl: entity.images.isNotEmpty ? entity.images.first : "",
      title: entity.name ?? "NA",
      des: entity.description ?? "NA",
      tag: "posting",
      object: favourite,
      price: entity.price != null
          ? "\$${entity.price!.toStringAsFixed(0)} / day"
          : "",
      rating: entity.rating ?? 0.0,
      ratingStr: entity.rating?.toString() ?? "",
      isFavorite: true,
    );
  }

  Posting? getPostingEntity(PostingGridItemModel item) {
    if (item.object is FavouritePosting) {
      final posting = (item.object as FavouritePosting).posting;
      if (posting != null && posting.isValid) {
        return posting;
      }
    }
    return null;
  }

  Future<void> deleteSavedFavourite(PostingGridItemModel item) async {
    emit(state.copyWith(isLoading: true));
    final o = item.object;
    if (o is! FavouritePosting) {
      return;
    }
    try {
      await _favouritePostingRepository.deleteFavouritePosting(o.id);
    } catch (e, st) {
      developer.log('deleteSavedFavourite failed', error: e, stackTrace: st);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  @override
  Future<void> close() async {
    await _favouritesSubscription?.cancel();
    return super.close();
  }
}
