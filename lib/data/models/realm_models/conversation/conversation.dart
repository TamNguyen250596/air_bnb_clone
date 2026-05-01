import 'package:realm/realm.dart';
part 'conversation.realm.dart';

@RealmModel()
class _Conversation {

  @PrimaryKey()
  late String id;

  late Set<String> members;
  String? avatar;
  String? name;
  @MapTo('last_message')
  String? lastMessage;
  @MapTo('last_message_at')
  DateTime? lastMessageAt;
  @MapTo('created_at')
  DateTime? createdAt;
}