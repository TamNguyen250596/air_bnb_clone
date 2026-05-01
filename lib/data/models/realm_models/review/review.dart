import 'package:realm/realm.dart';
import '../user/user.dart';
part 'review.realm.dart';

@RealmModel()
class _Review {

  @PrimaryKey()
  late String id;

  double rating = 0.0;
  String? comment;
  @MapTo('user_id')
  String? userId;
  $User? user;
  @MapTo('target_type')
  String? targetType;
  @MapTo('target_id')
  String? targetId;
  @MapTo('created_at')
  DateTime? createdAt;
}