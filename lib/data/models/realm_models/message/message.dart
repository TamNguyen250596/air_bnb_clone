import 'package:realm/realm.dart';
import '../user/user.dart';
part 'message.realm.dart';

@RealmModel()
class $Message {

  @PrimaryKey()
  late String id;

  String? senderId;
  $User? sender;
  String? conversationId;
  String? text;
  DateTime? createdAt;
}