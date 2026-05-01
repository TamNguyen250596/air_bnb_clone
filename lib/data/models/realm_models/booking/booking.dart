import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:realm/realm.dart';
import '../user/user.dart';
part 'booking.realm.dart';

@RealmModel()
class _Booking {

  @PrimaryKey()
  late String id;

  @MapTo('posting_id')
  String? postingId;
  $Posting? posting;
  @MapTo('user_id')
  String? userId;
  $User? user;
  @MapTo('check_in')
  DateTime? checkIn;
  @MapTo('check_out')
  DateTime? checkOut;
  @MapTo('payment_amount')
  double? paymentAmount;
}