import 'dart:async';
import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/models/item/review_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/review/review.dart';
import 'package:air_bnb_clone/data/repositories/review_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';

class ViewReviewState {
  const ViewReviewState({
    this.reviews = const [],
  });

  final List<ReviewItemModel> reviews;

  ViewReviewState copyWith({List<ReviewItemModel>? reviews}) {
    return ViewReviewState(
      reviews: reviews ?? this.reviews,
    );
  }
}

class ViewReviewCubit extends Cubit<ViewReviewState> {
  ViewReviewCubit({
    required ReviewRepository reviewRepository,
    required Map<String, dynamic> extra,
  })  : _reviewRepository = reviewRepository,
        targetType = extra['targetType'] as String,
        targetId = extra['targetId'] as String,
        super(const ViewReviewState()) {
    _observeReviews();
  }

  final String targetType;
  final String targetId;
  final ReviewRepository _reviewRepository;
  StreamSubscription<RealmResultsChanges<Review>>? _reviewsSubscription;

  @override
  Future<void> close() async {
    await _reviewsSubscription?.cancel();
    return super.close();
  }

  void _observeReviews() {
    _reviewsSubscription?.cancel();
    _reviewsSubscription = _reviewRepository
        .observeReviewsForTarget(
          targetType: targetType,
          targetId: targetId,
        )
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((changes) {
      emit(state.copyWith(reviews: _reviewsToItems(changes.results)));
    });
  }

  List<ReviewItemModel> _reviewsToItems(RealmResults<Review> results) {
    return results
        .where((r) => r.isValid)
        .map(
          (review) => ReviewItemModel(
            review.id,
            rating: review.rating,
            title: _reviewerDisplayName(review),
            des: review.comment ?? '',
            imageUrl: review.user?.imageUrl ?? '',
            tag: 'review',
            object: review,
          ),
        )
        .toList();
  }

  String _reviewerDisplayName(Review review) {
    final u = review.user;
    if (u == null || !u.isValid) {
      return 'Guest';
    }
    final full = u.fullName?.trim();
    if (full != null && full.isNotEmpty) {
      return full;
    }
    final combined = '${u.firstName ?? ''} ${u.lastName ?? ''}'.trim();
    return combined.isEmpty ? 'Guest' : combined;
  }
}
