import 'package:air_bnb_clone/data/models/realm_models/user/user.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';

import 'review.dart';

extension ReviewFirestoreExtension on Review {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (userId != null) 'user_id': userId,
      if (targetType != null) 'target_type': targetType,
      if (targetId != null) 'target_id': targetId,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
    };
  }
}

extension ReviewRelationshipExtension on Review {
  static List<RealmRelationship> get realmOutgoingRelationships => [
        RealmRelationship<User>('user_id', 'user'),
      ];

  static List<RealmRelationship> get realmIncomingRelationships => const [];
}

class ReviewFirestoreHelper {
  static Review fromFirestore(Map<String, dynamic> data) {
    return Review(
      data['id'] ?? "",
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'],
      userId: data['user_id'],
      user: data['user'] as User?,
      targetType: data['target_type'],
      targetId: data['target_id'],
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
