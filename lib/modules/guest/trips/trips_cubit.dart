import 'dart:async';
import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/models/item/trip_grid_item_model.dart';
import 'package:air_bnb_clone/data/models/realm_models/booking/booking.dart';
import 'package:air_bnb_clone/data/repositories/booking_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';
import '../../../data/models/realm_models/posting/posting.dart';

class TripsState {
  const TripsState({
    this.isLoading = false,
    this.errorMessage,
    this.upcomingTrips = const [],
    this.previousTrips = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<TripGridItemModel> upcomingTrips;
  final List<TripGridItemModel> previousTrips;

  TripsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<TripGridItemModel>? upcomingTrips,
    List<TripGridItemModel>? previousTrips,
  }) {
    return TripsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      upcomingTrips: upcomingTrips ?? this.upcomingTrips,
      previousTrips: previousTrips ?? this.previousTrips,
    );
  }
}

class TripsCubit extends Cubit<TripsState> {

  TripsCubit({
    required BookingRepository bookingRepository,
  })  : _bookingRepository = bookingRepository,
        super(const TripsState()) {
    _observeBookings();
  }

  // Properties
  final BookingRepository _bookingRepository;
  StreamSubscription<RealmResultsChanges<Booking>>? _upcomingSubscription;
  StreamSubscription<RealmResultsChanges<Booking>>? _previousSubscription;

  // Private Methods
  void _observeBookings() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    _upcomingSubscription = _bookingRepository
        .observeBookingsWithCheckOutFrom(nowMs)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen(_onUpcomingBookingsChanged);
    _previousSubscription = _bookingRepository
        .observeBookingsWithCheckOutBefore(nowMs)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen(_onPreviousBookingsChanged);
  }

  void _onUpcomingBookingsChanged(RealmResultsChanges<Booking> change) {
    emit(state.copyWith(upcomingTrips: _bookingsToTripModels(change.results)));
  }

  void _onPreviousBookingsChanged(RealmResultsChanges<Booking> change) {
    emit(state.copyWith(previousTrips: _bookingsToTripModels(change.results)));
  }

  List<TripGridItemModel> _bookingsToTripModels(RealmResults<Booking> results) {
    return results.map(_bookingToTripModel).toList();
  }

  TripGridItemModel _bookingToTripModel(Booking booking) {
    final posting = booking.posting;
    final checkIn = booking.checkIn;
    final checkOut = booking.checkOut;
    final imageUrl = (posting?.images.isNotEmpty ?? false)
        ? posting!.images.first
        : "";
    final bookedDatesDes = (checkIn != null && checkOut != null)
        ? "${_formatDate(checkIn)} - ${_formatDate(checkOut)}"
        : "";
    final price = booking.paymentAmount != null
        ? "\$${booking.paymentAmount!.toStringAsFixed(0)}"
        : "";
    return TripGridItemModel(
      booking.id,
      title: posting?.name ?? "",
      des: posting?.address ?? "",
      imageUrl: imageUrl,
      price: price,
      bookedDatesDes: bookedDatesDes,
      object: posting,
    );
  }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  @override
  Future<void> close() {
    _upcomingSubscription?.cancel();
    _previousSubscription?.cancel();
    return super.close();
  }

  // Public Methods
  Posting? getPostingEntity(TripGridItemModel item) {
    if (item.object is Posting) {
      return item.object as Posting;
    }
    return null;
  }
}
