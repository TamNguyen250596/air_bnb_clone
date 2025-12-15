import '../model/user.dart';
import '../services/firestore_service.dart';

abstract class UserRepository {
  void createUser(User user);
  Future<User> getUser(String id);
}

class UserRepositoryRemote implements UserRepository {

  // Init
  UserRepositoryRemote({required FireStoreService fireStoreService}):
        _fireStoreService = fireStoreService;

  // Properties
  final FireStoreService _fireStoreService;

  // Functions
  @override
  void createUser(User user) {
    Map<String, dynamic> data = {
      "id": user.id,
      "email": user.email,
      "bio": user.bio,
      "city": user.city,
      "country": user.country,
      "is_host": user.isHost,
      "is_currently_hosting": user.isCurrentlyHosting,
      "first_name": user.firstName,
      "last_name": user.lastName,
      "full_name": user.fullName,
      "image_url": user.imageUrl
    };
    _fireStoreService.createDoc("users", user.id, data);
  }

  @override
  Future<User> getUser(String id) {
    final snapshot = _fireStoreService.getDoc("users", id);
    return snapshot.then((doc) {
      User user = User(
        id: doc["id"],
        email: doc["email"],
        bio: doc["bio"],
        city: doc["city"],
        country: doc["country"],
        firstName: doc["first_name"],
        lastName: doc["last_name"],
        fullName: doc["full_name"],
        imageUrl: doc["image_url"],
        isCurrentlyHosting: doc["is_currently_hosting"],
        isHost: doc["is_host"]
      );
      return user;
    });
  }
}