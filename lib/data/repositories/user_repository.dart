import 'package:rxdart/rxdart.dart';
import '../model/user.dart';
import '../services/firestore/firestore_service.dart';
import '../services/realm/realm_service.dart';
import '../services/realm/realm_query_builder.dart';

abstract class UserRepository {
  Future<User> createUser(User user);
  Future<User> getUser(String id);
  Stream<User> observeUser(String id);
  Future<User> updateUser(String id, Map<String, dynamic> data);
}

class UserRepositoryRemote implements UserRepository {
  // Init
  UserRepositoryRemote({
    required FireStoreService fireStoreService,
    required RealmService realmManager,
  }) : _fireStoreService = fireStoreService,
       _realmManager = realmManager;

  // Properties
  final FireStoreService _fireStoreService;
  final RealmService _realmManager;

  // Functions
  @override
  Future<User> createUser(User user) async {
    try {
      final data = user.toFirestore();
      await _fireStoreService.createDoc<User>("users", user.id, data);
      final createdUser = await _realmManager.getEntity<User>(user.id);
      if (createdUser == null) {
        throw Exception("Failed to create user in local storage");
      }
      return createdUser;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<User> getUser(String id) async {
    try {
      final doc = await _fireStoreService.getDoc<User>("users", id);
      if (!doc.exists) {
        throw Exception("User not found");
      }
      final user = await _realmManager.getEntity<User>(id);
      if (user == null) {
        throw Exception("Failed to retrieve user from local storage");
      }
      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Stream<User> observeUser(String id) {
    try {
      // Set up Firestore listener (updates Realm automatically)
      _fireStoreService.observeDoc<User>("users", id);

      // Return Realm stream that will be updated by Firestore listener
      final localUserStream = _realmManager
          .observeEntities<User>(RealmQueryBuilder().equal("id", id))
          .where((event) => event.results.isNotEmpty)
          .map((event) => event.results.first);

      localUserStream.doOnCancel(() {
        _fireStoreService.removeDocListener("users", id);
      });

      return localUserStream;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _fireStoreService.updateDoc<User>("users", id, data);
      final updatedUser = await _realmManager.getEntity<User>(id);
      if (updatedUser == null) {
        throw Exception("Failed to retrieve updated user from local storage");
      }
      return updatedUser;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}