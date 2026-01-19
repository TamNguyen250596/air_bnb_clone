import 'package:realm/realm.dart';
import '../user/user.dart';
part 'posting.realm.dart';

@RealmModel()
class _Posting {
  // ========== Properties ==========
  @PrimaryKey()
  late String id;

  String? name;
  String? type;
  double? price;
  String? description;
  String? address;
  String? city;
  String? country;
  double? rating;
  String? hostId;
  $User? host;
  late List<String> images;
  late List<String> amenities;
  late Map<String, int> beds;
  late Map<String, int> bathrooms;
}