import 'dart:async';

import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:air_bnb_clone/data/models/item/review_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/review/review.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/favourite_posting_repository.dart';
import 'package:air_bnb_clone/data/repositories/review_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:realm/realm.dart';

import '../../../data/models/realm_models/posting/posting.dart';
import '../../../data/repositories/booking_repository.dart';

class ViewPostingState {
  const ViewPostingState({
    this.isFavorite = false,
    this.displayImages = const [],
    this.title = "",
    this.description = "",
    this.postingInfoTiles = const [],
    this.amenities = const [],
    this.address = "",
    this.hostImage = "",
    this.hostName = "",
    LatLng? propertyLatLong,
    this.displayAddress = "",
    this.reviewRating = 0.0,
    this.isHost = false,
    this.price = "",
    this.name = "",
    this.bookingTimeMap = const {},
    this.canReview = false,
    this.recentReviews = const [],
  }) : propertyLatLong = propertyLatLong ?? const LatLng(37.42796133580664, -122.085749655962);

  final bool isFavorite;
  final List<String> displayImages;
  final String title;
  final String description;
  final List<BaseItemModel> postingInfoTiles;
  final List<String> amenities;
  final String address;
  final String hostImage;
  final String hostName;
  final LatLng propertyLatLong;
  final String displayAddress;
  final double reviewRating;
  final bool isHost;
  final String price;
  final String name;
  final Map<String, DateTime> bookingTimeMap;
  final bool canReview;
  final List<ReviewItemModel> recentReviews;

  ViewPostingState copyWith({
    bool isFavorite = false,
    List<String>? displayImages,
    String? title,
    String? description,
    List<BaseItemModel>? postingInfoTiles,
    List<String>? amenities,
    String? address,
    String? hostImage,
    String? hostName,
    LatLng? propertyLatLong,
    String? displayAddress,
    double? reviewRating,
    bool? isHost,
    String? price,
    String? name,
    Map<String, DateTime>? bookingTimeMap,
    bool? canReview,
    List<ReviewItemModel>? recentReviews,
  }) {
    return ViewPostingState(
      isFavorite: isFavorite,
      displayImages: displayImages ?? this.displayImages,
      title: title ?? this.title,
      description: description ?? this.description,
      postingInfoTiles: postingInfoTiles ?? this.postingInfoTiles,
      amenities: amenities ?? this.amenities,
      address: address ?? this.address,
      hostImage: hostImage ?? this.hostImage,
      hostName: hostName ?? this.hostName,
      propertyLatLong: propertyLatLong ?? this.propertyLatLong,
      displayAddress: displayAddress ?? this.displayAddress,
      reviewRating: reviewRating ?? this.reviewRating,
      isHost: isHost ?? this.isHost,
      price: price ?? this.price,
      name: name ?? this.name,
      bookingTimeMap: bookingTimeMap ?? this.bookingTimeMap,
      canReview: canReview ?? this.canReview,
      recentReviews: recentReviews ?? this.recentReviews,
    );
  }
}

class ViewPostingCubit extends Cubit<ViewPostingState> {
  ViewPostingCubit({
    required AuthRepository authRepository,
    required FavouritePostingRepository favouritePostingRepository,
    required BookingRepository bookingRepository,
    required ReviewRepository reviewRepository,
    required Posting posting,
  })  : _authRepository = authRepository,
        _favouritePostingRepository = favouritePostingRepository,
        _bookingRepository = bookingRepository,
        _reviewRepository = reviewRepository,
        _posting = posting,
        super(const ViewPostingState()) {
    _setupInitialValues();
  }

  final AuthRepository _authRepository;
  final FavouritePostingRepository _favouritePostingRepository;
  final BookingRepository _bookingRepository;
  final ReviewRepository _reviewRepository;
  final Posting _posting;
  Timer? _displayAddressTimer;
  StreamSubscription<RealmResultsChanges<Review>>? _recentReviewsSubscription;
  Posting get posting => _posting;

  @override
  Future<void> close() async {
    _displayAddressTimer?.cancel();
    await _recentReviewsSubscription?.cancel();
    return super.close();
  }

  void setReviewRating(double value) {
    emit(state.copyWith(reviewRating: value));
  }

  void selectedMarker() {
    if (!_posting.isValid) return;
    _displayAddressTimer?.cancel();
    emit(state.copyWith(displayAddress: _posting.address ?? ""));
    _displayAddressTimer = Timer(const Duration(seconds: 5), () {
      emit(state.copyWith(displayAddress: ""));
    });
  }

  void updateBookingTimeMap(Map<String, DateTime> map) {
    emit(state.copyWith(bookingTimeMap: map));
  }

  bool _isPostingValid() =>
      _posting.images.isNotEmpty &&
      _posting.name != null &&
      _posting.name!.isNotEmpty &&
      _posting.description != null;

  int _getNumGuests() {
    final small = _posting.beds['small'] ?? 0;
    final medium = _posting.beds['medium'] ?? 0;
    final large = _posting.beds['large'] ?? 0;
    return small + (medium * 2) + (large * 2);
  }

  String _getBedroomText() {
    final parts = <String>[];
    final small = _posting.beds['small'] ?? 0;
    final medium = _posting.beds['medium'] ?? 0;
    final large = _posting.beds['large'] ?? 0;
    if (small != 0) parts.add('$small single/twin ');
    if (medium != 0) parts.add('$medium double ');
    if (large != 0) parts.add('$large queen/king ');
    return parts.join('').trim();
  }

  String _getBathroomText() {
    final parts = <String>[];
    final full = _posting.bathrooms['full'] ?? 0;
    final half = _posting.bathrooms['half'] ?? 0;
    if (full != 0) parts.add('$full full ');
    if (half != 0) parts.add('$half half ');
    return parts.join('').trim();
  }

  String _getFullAddress() {
    final parts = [_posting.address, _posting.city, _posting.country]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    return parts.join(', ');
  }

  void _setupInitialValues() {
    if (!_isPostingValid()) return;

    _authRepository.userId.then((userId) {
      final isHost = userId == _posting.hostId;
      emit(state.copyWith(isHost: isHost));

      if (userId != null) {
        _favouritePostingRepository.getFavouritePosting(userId, _posting.id).then((favouritePosting) {
          emit(state.copyWith(isFavorite: favouritePosting != null));
        });
        _bookingRepository.getBookingsForPosting(_posting.id, userId: userId).then((bookings) {
          emit(state.copyWith(canReview: bookings.isNotEmpty));
        });
      }
    });

    final price = _posting.price != null ? "\$${_posting.price!.toStringAsFixed(0)}" : "";
    final name = _posting.name ?? "";
    final displayImages = _posting.images;
    final title = _posting.name ?? "";
    final description = _posting.description ?? "";
    final amenities = _posting.amenities.toList();
    final address = _getFullAddress();
    final propertyLatLong = LatLng(_posting.lat, _posting.lon);
    final hostImage = _posting.host?.imageUrl ?? "";
    final hostName = _posting.host?.fullName ??
        '${_posting.host?.firstName ?? ""} ${_posting.host?.lastName ?? ""}'.trim();
    final bedroomText = _getBedroomText();
    final bathroomText = _getBathroomText();
    final postingInfoTiles = [
      BaseItemModel("guests", imageData: Icons.home, title: _posting.type ?? "Property", des: '${_getNumGuests()} guests'),
      BaseItemModel("beds", imageData: Icons.hotel, title: "Beds", des: bedroomText.isNotEmpty ? bedroomText : "—"),
      BaseItemModel("bathrooms", imageData: Icons.wc, title: "Bathrooms", des: bathroomText.isNotEmpty ? bathroomText : "—"),
    ];

    emit(ViewPostingState(
      displayImages: displayImages,
      title: title,
      description: description,
      postingInfoTiles: postingInfoTiles,
      amenities: amenities,
      address: address,
      hostImage: hostImage,
      hostName: hostName,
      propertyLatLong: propertyLatLong,
      displayAddress: "",
      price: price,
      name: name,
    ));

    _observeRecentReviews();
  }

  void _observeRecentReviews() {
    _recentReviewsSubscription?.cancel();
    _recentReviewsSubscription = _reviewRepository
        .observeReviewsForTarget(
          targetType: 'posting',
          targetId: _posting.id,
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

  Future<void> toggleFavourite() async {
    if (state.isHost) return;
    if (state.isFavorite) return;
    final userId = await _authRepository.userId;
    if (userId == null) return;
    final data = {
      "user_id": userId,
      "posting_id": _posting.id,
      "created_at": DateTime.now().toIso8601String()
    };
    await _favouritePostingRepository.createFavouritePosting(data);
    emit(state.copyWith(isFavorite: true));
  }

  Future<void> submitReview(String? comment) async {
    if (comment == null) return;
    final userId = await _authRepository.userId;
    if (userId == null) return;
    if (!posting.isValid) return;
    final data = {
      "user_id": userId,
      "target_type": "posting",
      "target_id": posting.id,
      "rating": state.reviewRating,
      "comment": comment,
      "created_at": DateTime.now().millisecondsSinceEpoch,
    };
    await _reviewRepository.createReview(data);
  }
}
