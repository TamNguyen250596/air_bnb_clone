import 'package:air_bnb_clone/data/models/realm_models/conversation/conversation.dart';

extension ConversationFirestoreExtension on Conversation {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (members.isNotEmpty) 'members': members.toList(),
      if (lastMessage != null) 'last_message': lastMessage,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
    };
  }
}

class ConversationFirestoreHelper {
  static Conversation fromFirestore(Map<String, dynamic> data) {
    return Conversation(
      data['id'] ?? "",
      members: Set<String>.from(data['members'] ?? []),
      lastMessage: data['last_message'],
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
