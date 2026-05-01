import 'package:realm/realm.dart';
part 'user.realm.dart';

@RealmModel()
class $User {
  @PrimaryKey()
  late String id;

  String? email;
  String? bio;
  String? city;
  String? country;
  @MapTo('first_name')
  String? firstName;
  @MapTo('last_name')
  String? lastName;
  @MapTo('full_name')
  String? fullName;
  @MapTo('image_url')
  String? imageUrl;
  @MapTo('is_host')
  bool? isHost;
  @MapTo('is_currently_hosting')
  bool isCurrentlyHosting = false;
  double? earning;
}