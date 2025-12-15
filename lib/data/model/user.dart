// ========== User Model ==========
class User {
  // ========== Constructor ==========
  User({
    required this.id,
    this.email,
    this.bio,
    this.city,
    this.country,
    this.firstName,
    this.lastName,
    this.fullName,
    this.imageUrl,
    this.isHost,
    this.isCurrentlyHosting
  });

  // ========== Properties ==========
  String id;
  String? email;
  String? bio;
  String? city;
  String? country;
  String? firstName;
  String? lastName;
  String? fullName;
  String? imageUrl;
  bool? isHost;
  bool? isCurrentlyHosting;
}