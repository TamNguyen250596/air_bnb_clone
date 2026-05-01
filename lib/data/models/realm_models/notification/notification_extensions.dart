import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';

import 'notification.dart';

extension NotificationFirestoreExtension on Notification {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (imageUrl != null) 'image_url': imageUrl,
      if (type != null) 'type': type,
      'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
    };
  }
}

extension NotificationRelationshipExtension on Notification {
  static List<RealmRelationship> get realmOutgoingRelationships => const [];

  static List<RealmRelationship> get realmIncomingRelationships => const [];
}

class NotificationFirestoreHelper {
  static Notification fromFirestore(Map<String, dynamic> data) {
    return Notification(
      data['id'] ?? "",
      title: data['title'],
      body: data['body'],
      imageUrl: data['image_url'],
      type: data['type'],
      isRead: _parseBool(data['is_read']) ?? false,
      createdAt: _parseDateTime(data['created_at']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final v = value.toLowerCase();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0') return false;
    }
    return null;
  }
}
