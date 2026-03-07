import 'package:air_bnb_clone/data/models/realm_models/message/message.dart';
import 'package:air_bnb_clone/data/models/realm_models/user/user.dart';

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

class MessageFirestoreHelper {
  static Message fromFirestore(Map<String, dynamic> data) {
    return Message(
      data['id'] ?? "",
      senderId: data['sender_id'],
      sender: data['sender'] as User?,
      conversationId: data['conversation_id'],
      text: data['text'],
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
}
