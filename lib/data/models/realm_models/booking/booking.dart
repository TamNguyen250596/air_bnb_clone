import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:realm/realm.dart';
import '../user/user.dart';
part 'booking.realm.dart';

@RealmModel()
class _Booking {

  @PrimaryKey()
  late String id;

  String? postingId;
  $Posting? posting;
  String? userId;
  $User? user;
  DateTime? checkIn;
  DateTime? checkOut;
  double? paymentAmount;
}