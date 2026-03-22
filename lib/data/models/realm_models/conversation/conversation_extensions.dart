import 'package:air_bnb_clone/data/models/realm_models/conversation/conversation.dart';

extension ConversationFirestoreExtension on Conversation {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (members.isNotEmpty) 'members': members.toList(),
      if (avatar != null) 'avatar': avatar,
      if (name != null) 'name': name,
      if (lastMessage != null) 'last_message': lastMessage,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt!.millisecondsSinceEpoch,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
    };
  }
}

class ConversationFirestoreHelper {
  static Conversation fromFirestore(Map<String, dynamic> data) {
    return Conversation(
      data['id'] ?? "",
      members: Set<String>.from(data['members'] ?? []),
      avatar: data['avatar'],
      name: data['name'],
      lastMessage: data['last_message'],
      lastMessageAt: _parseDateTime(data['last_message_at']),
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
