import 'package:realm/realm.dart';
part 'notification.realm.dart';

@RealmModel()
class _Notification {

  @PrimaryKey()
  late String id;

  String? title;
  String? body;
  @MapTo('image_url')
  String? imageUrl;
  String? type;
  @MapTo('is_read')
  bool isRead = false;
  @MapTo('created_at')
  DateTime? createdAt;
}