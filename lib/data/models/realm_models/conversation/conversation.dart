import 'package:realm/realm.dart';
part 'conversation.realm.dart';

@RealmModel()
class _Conversation {

  @PrimaryKey()
  late String id;

  late Set<String> members;
  String? lastMessage;
  DateTime? createdAt;
}