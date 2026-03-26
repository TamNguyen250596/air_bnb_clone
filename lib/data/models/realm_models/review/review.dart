import 'package:realm/realm.dart';
import '../user/user.dart';
part 'review.realm.dart';

@RealmModel()
class _Review {

  @PrimaryKey()
  late String id;

  double rating = 0.0;
  String? comment;
  String? userId;
  $User? user;
  String? targetType;
  String? targetId;
  DateTime? createdAt;
}