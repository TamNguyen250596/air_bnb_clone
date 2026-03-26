import 'dart:async';
import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/models/item/review_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/review/review.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';
import '../../../data/models/realm_models/user/user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/review_repository.dart';

class ViewProfileState {
  const ViewProfileState({
    this.hostId = '',
    this.displayName = '',
    this.greetingName = '',
    this.imageUrl = '',
    this.bio = '',
    this.location = '',
    this.canReview = false,
    this.reviewRating = 0.0,
    this.recentReviews = const [],
  });

  final String hostId;
  final String displayName;
  final String greetingName;
  final String imageUrl;
  final String bio;
  final String location;
  final bool canReview;
  final double reviewRating;
  final List<ReviewItemModel> recentReviews;

  ViewProfileState copyWith({
    String? hostId,
    String? displayName,
    String? greetingName,
    String? imageUrl,
    String? bio,
    String? location,
    bool? canReview,
    double? reviewRating,
    List<ReviewItemModel>? recentReviews,
  }) {
    return ViewProfileState(
      hostId: hostId ?? this.hostId,
      displayName: displayName ?? this.displayName,
      greetingName: greetingName ?? this.greetingName,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      canReview: canReview ?? this.canReview,
      reviewRating: reviewRating ?? this.reviewRating,
      recentReviews: recentReviews ?? this.recentReviews,
    );
  }
}

class ViewProfileCubit extends Cubit<ViewProfileState> {
  ViewProfileCubit({
    required Map<String, dynamic> extra,
    required AuthRepository authRepository,
    required ReviewRepository reviewRepository,
  })  : _host = extra['host'] as User,
        canReview = extra['canReview'] ?? false,
        _authRepository = authRepository,
        _reviewRepository = reviewRepository,
        super(const ViewProfileState()) {
    _setupInitialValues();
  }

  final User _host;
  final bool canReview;
  final AuthRepository _authRepository;
  final ReviewRepository _reviewRepository;
  StreamSubscription<RealmResultsChanges<Review>>? _recentReviewsSubscription;

  @override
  Future<void> close() async {
    await _recentReviewsSubscription?.cancel();
    return super.close();
  }

  void setReviewRating(double value) {
    emit(state.copyWith(reviewRating: value));
  }

  void _setupInitialValues() {
    if (!_host.isValid) return;
    final fullName = _host.fullName?.trim() ?? '';
    final combined = '${_host.firstName ?? ''} ${_host.lastName ?? ''}'.trim();
    final displayName = fullName.isNotEmpty
        ? fullName
        : (combined.isNotEmpty ? combined : 'Host');
    final greetingName = (_host.firstName?.trim().isNotEmpty ?? false)
        ? _host.firstName!.trim()
        : displayName;
    final locationParts = [_host.city, _host.country]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final location = locationParts.isEmpty ? 'Location not provided' : locationParts.join(', ');
    emit(
      state.copyWith(
        displayName: displayName,
        hostId: _host.id,
        greetingName: greetingName,
        imageUrl: _host.imageUrl ?? '',
        bio: (_host.bio?.trim().isNotEmpty ?? false) ? _host.bio!.trim() : 'No bio yet.',
        location: location,
        canReview: canReview
      ),
    );
    _observeRecentReviews();
  }

  void _observeRecentReviews() {
    _recentReviewsSubscription?.cancel();
    _recentReviewsSubscription = _reviewRepository
        .observeReviewsForTarget(
          targetType: 'user',
          targetId: _host.id,
          limit: 3,
        )
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((changes) {
      emit(state.copyWith(recentReviews: _reviewsToItems(changes.results)));
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

  Future<void> submitReview(String? comment) async {
    if (comment == null) return;
    final userId = await _authRepository.userId;
    if (userId == null) return;

    final data = {
      "user_id": userId,
      "target_type": "user",
      "target_id": _host.id,
      "rating": state.reviewRating,
      "comment": comment,
      "created_at": DateTime.now().millisecondsSinceEpoch,
    };
    await _reviewRepository.createReview(data);
  }
}

