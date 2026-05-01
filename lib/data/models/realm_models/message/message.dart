import 'package:realm/realm.dart';
import '../user/user.dart';
part 'message.realm.dart';

@RealmModel()
class $Message {

  @PrimaryKey()
  late String id;

  @MapTo('sender_id')
  String? senderId;
  $User? sender;
  @MapTo('conversation_id')
  String? conversationId;
  String? text;
  @MapTo('created_at')
  DateTime? createdAt;
}