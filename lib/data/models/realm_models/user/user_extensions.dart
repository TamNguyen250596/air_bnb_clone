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
      'is_host': isHost,
      'is_currently_hosting': isCurrentlyHosting,
    };
  }
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
    );
  }
}

