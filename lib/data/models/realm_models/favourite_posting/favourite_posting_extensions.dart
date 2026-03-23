import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/models/realm_models/user/user.dart';
import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';
import 'favourite_posting.dart';

extension FavouritePostingFirestoreExtension on FavouritePosting {
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (postingId != null) 'posting_id': postingId,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt!.millisecondsSinceEpoch,
    };
  }
}

extension FavouritePostingRelationshipExtension on FavouritePosting {
  static List<RealmRelationship> get realmOutgoingRelationships => [
        RealmRelationship<Posting>('postingId', 'posting'),
        RealmRelationship<User>('userId', 'user'),
      ];

  static List<RealmRelationship> get realmIncomingRelationships => const [];
}

class FavouritePostingFirestoreHelper {
  static FavouritePosting fromFirestore(Map<String, dynamic> data) {
    return FavouritePosting(
      data['id'] ?? "",
      postingId: data['posting_id'],
      posting: data['posting'] as Posting?,
      userId: data['user_id'],
      user: data['user'] as User?,
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
