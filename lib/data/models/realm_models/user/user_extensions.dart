import 'package:air_bnb_clone/data/services/realm/realm_relationship.dart';
import '../booking/booking.dart';
import '../favourite_posting/favourite_posting.dart';
import '../message/message.dart';
import '../posting/posting.dart';
import '../review/review.dart';
import 'user.dart';

/// Extension methods for User model to handle Firestore conversions
/// These methods are preserved even after running realm generate
extension UserFirestoreExtension on User {
  /// Convert User to Firestore map format
  Map<String, dynamic> toFirestore() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (email != null) 'email': email,
      if (bio != null) 'bio': bio,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (fullName != null) 'full_name': fullName,
      if (imageUrl != null) 'image_url': imageUrl,
      if (earning != null) 'earning': earning,
      'is_host': isHost,
      'is_currently_hosting': isCurrentlyHosting,
    };
  }
}

/// Realm foreign-key metadata for [RealmRelationshipRegistry] (same file as Firestore extension).
extension UserRelationshipExtension on User {
  static List<RealmRelationship> get realmOutgoingRelationships => const [];

  static List<RealmRelationship> get realmIncomingRelationships => [
        RealmRelationship<Posting>('hostId', 'host'),
        RealmRelationship<Booking>('userId', 'user'),
        RealmRelationship<FavouritePosting>('userId', 'user'),
        RealmRelationship<Review>('userId', 'user'),
        RealmRelationship<Message>('senderId', 'sender'),
      ];
}

/// Helper class for User Firestore operations
/// Since extension methods can't add factory constructors,
/// we use a static method here
///
/// Usage: UserFirestoreHelper.fromFirestore(data)
/// Or import this file and use: User.fromFirestore(data) via the helper
class UserFirestoreHelper {
  /// Create User from Firestore document data
  /// This maintains the same API as the previous factory constructor
  static User fromFirestore(Map<String, dynamic> data) {
    return User(
      data['id'] ?? "",
      email: data['email'],
      bio: data['bio'],
      city: data['city'],
      country: data['country'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      fullName: data['full_name'],
      imageUrl: data['image_url'],
      isHost: data['is_host'],
      isCurrentlyHosting: data['is_currently_hosting'] ?? false,
      earning: data['earning'],
    );
  }
}
