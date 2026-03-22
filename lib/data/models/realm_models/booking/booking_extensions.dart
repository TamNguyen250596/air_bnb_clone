import 'package:air_bnb_clone/data/models/realm_models/booking/booking.dart';
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/models/realm_models/user/user.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';

extension BookingFirestoreExtension on Booking {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (postingId != null) 'posting_id': postingId,
      if (userId != null) 'user_id': userId,
      if (checkIn != null) 'check_in': checkIn!.millisecondsSinceEpoch,
      if (checkOut != null) 'check_out': checkOut!.millisecondsSinceEpoch,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
    };
  }
}

extension BookingRelationshipExtension on Booking {
  static List<RealmRelationship> get realmOutgoingRelationships => [
        RealmRelationship<Posting>('postingId', 'posting'),
        RealmRelationship<User>('userId', 'user'),
      ];

  static List<RealmRelationship> get realmIncomingRelationships => const [];
}

class BookingFirestoreHelper {
  static Booking fromFirestore(Map<String, dynamic> data) {
    return Booking(
      data['id'] ?? "",
      postingId: data['posting_id'],
      posting: data['posting'] as Posting?,
      userId: data['user_id'],
      user: data['user'] as User?,
      checkIn: _parseDateTime(data['check_in']),
      checkOut: _parseDateTime(data['check_out']),
      paymentAmount: data['payment_amount'],
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
