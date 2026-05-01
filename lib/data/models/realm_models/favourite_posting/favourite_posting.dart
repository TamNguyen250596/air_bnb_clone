import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:realm/realm.dart';
import '../user/user.dart';
part 'favourite_posting.realm.dart';

@RealmModel()
class _FavouritePosting {

  @PrimaryKey()
  late String id;

  @MapTo('posting_id')
  String? postingId;
  $Posting? posting;
  @MapTo('user_id')
  String? userId;
  $User? user;
  @MapTo('created_at')
  DateTime? createdAt;
}