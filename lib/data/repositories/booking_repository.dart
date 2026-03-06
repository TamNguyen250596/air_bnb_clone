import 'package:air_bnb_clone/data/models/realm_models/booking/booking.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';

/// Abstract contract for bookings. Use [BookingRepositoryImpl] in app and a fake in unit tests.
abstract class BookingRepository {
  Future<Booking> createBooking(Map<String, dynamic> data);
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
      print(e);
      rethrow;
    }
  }
}
