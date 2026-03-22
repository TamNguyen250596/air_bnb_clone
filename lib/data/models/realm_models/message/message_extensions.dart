import 'package:air_bnb_clone/data/models/realm_models/message/message.dart';
import 'package:air_bnb_clone/data/models/realm_models/user/user.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';

extension MessageFirestoreExtension on Message {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (text != null) 'text': text,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
    };
  }
}

extension MessageRelationshipExtension on Message {
  static List<RealmRelationship> get realmOutgoingRelationships => [
        RealmRelationship<User>('senderId', 'sender'),
      ];

  static List<RealmRelationship> get realmIncomingRelationships => const [];
}

class MessageFirestoreHelper {
  static Message fromFirestore(Map<String, dynamic> data) {
    var entity = Message(
      data['id'] ?? "",
      senderId: data['sender_id'],
      conversationId: data['conversation_id'],
      text: data['text'],
      createdAt: _parseDateTime(data['created_at']),
    );
    final sender = _getUser(data);
    if (sender != null) {
      entity.sender = sender;
    }
    return entity;
  }

  static User? _getUser(Map<String, dynamic> data) {
    return data['sender'] as User?;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
