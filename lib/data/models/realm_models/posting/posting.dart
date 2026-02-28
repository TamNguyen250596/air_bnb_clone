import 'package:realm/realm.dart';
import '../user/user.dart';
part 'posting.realm.dart';

@RealmModel()
class _Posting {
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
  double lat = 0.0;
  double lon = 0.0;
  late List<String> images;
  late List<String> amenities;
  late Map<String, int> beds;
  late Map<String, int> bathrooms;
}