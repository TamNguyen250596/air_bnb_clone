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
  String? firstName;
  String? lastName;
  String? fullName;
  String? imageUrl;
  bool? isHost;
  bool isCurrentlyHosting = false;
}