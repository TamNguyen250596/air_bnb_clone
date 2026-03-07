import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/booking/booking.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';

/// Abstract contract for bookings. Use [BookingRepositoryImpl] in app and a fake in unit tests.
abstract class BookingRepository {
  Future<Booking> createBooking(Map<String, dynamic> data);
  Future<RealmResults<Booking>> getBookingsByPostingId(String postingId);
  Stream<RealmResultsChanges<Booking>> observeBookingsWithCheckOutFrom(int dateMillis);
  Stream<RealmResultsChanges<Booking>> observeBookingsWithCheckOutBefore(int dateMillis);
}

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  })  : _firestoreService = firestoreService,
        _realmManager = realmManager;

  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  @override
  Future<Booking> createBooking(Map<String, dynamic> data) async {
    try {
      final id = await _firestoreService.createDoc<Booking>(
        FirestoreCollection.booking,
        null,
        data,
      );
      final createdBooking = await _realmManager.getEntity<Booking>(id);
      if (createdBooking == null) {
        throw Exception("Failed to create booking in local storage");
      }
      return createdBooking;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<RealmResults<Booking>> getBookingsByPostingId(String postingId) async {
    try {
      final query = FirestoreQueryBuilder(FirestoreCollection.booking)
          .equalTo('posting_id', postingId);
      await _firestoreService.getCollection<Booking>(query);
      final realmQuery = RealmQueryBuilder().equal('postingId', postingId);
      return await _realmManager.getEntities<Booking>(realmQuery);
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Stream<RealmResultsChanges<Booking>> observeBookingsWithCheckOutFrom(int dateMillis) {
    try {
      final firestoreQuery = FirestoreQueryBuilder(FirestoreCollection.booking)
          .filter(Filter('check_out', isGreaterThanOrEqualTo: dateMillis));
      _firestoreService.observeCollection<Booking>(firestoreQuery);
      final realmQuery = RealmQueryBuilder().greaterThanOrEqualTo(
        'checkOut',
        DateTime.fromMillisecondsSinceEpoch(dateMillis),
      );
      final stream = _realmManager.observeEntities<Booking>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Stream<RealmResultsChanges<Booking>> observeBookingsWithCheckOutBefore(int dateMillis) {
    try {
      final firestoreQuery = FirestoreQueryBuilder(FirestoreCollection.booking)
          .filter(Filter('check_out', isLessThan: dateMillis));
      _firestoreService.observeCollection<Booking>(firestoreQuery);
      final realmQuery = RealmQueryBuilder().lessThan(
        'checkOut',
        DateTime.fromMillisecondsSinceEpoch(dateMillis),
      );
      final stream = _realmManager.observeEntities<Booking>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}
