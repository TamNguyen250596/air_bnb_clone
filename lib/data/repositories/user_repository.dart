import 'dart:developer' as developer;
import 'package:rxdart/rxdart.dart';
import '../models/realm_models/user/user.dart';
import '../services/firestore/firestore_service.dart';
import '../services/firestore/firestore_constant.dart';
import '../services/realm/realm_service.dart';
import '../services/realm/realm_query_builder.dart';

/// Abstract contract for user data. Use [UserRepositoryImpl] in app and a fake in unit tests.
abstract class UserRepository {
  Future<User> createUser(String id, Map<String, dynamic> data);
  Future<User> getUser(String id);
  Stream<User> observeUser(String id);
  Future<User> updateUser(String id, Map<String, dynamic> data);
}

class UserRepositoryImpl implements UserRepository {
  // Init
  UserRepositoryImpl({
    required FireStoreService fireStoreService,
    required RealmService realmManager,
  }) : _fireStoreService = fireStoreService,
       _realmManager = realmManager;

  // Properties
  final FireStoreService _fireStoreService;
  final RealmService _realmManager;

  // Functions
  @override
  Future<User> createUser(String id, Map<String, dynamic> data) async {
    try {
      await _fireStoreService.createDoc<User>(FirestoreCollection.user, id, data);
      final createdUser = await _realmManager.getEntity<User>(id);
      if (createdUser == null) {
        throw Exception("Failed to create user in local storage");
      }
      return createdUser;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<User> getUser(String id) async {
    try {
      final doc = await _fireStoreService.getDoc<User>(FirestoreCollection.user, id);
      if (!doc.exists) {
        throw Exception("User not found");
      }
      final user = await _realmManager.getEntity<User>(id);
      if (user == null) {
        throw Exception("Failed to retrieve user from local storage");
      }
      return user;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Stream<User> observeUser(String id) {
    try {
      // Set up Firestore listener (updates Realm automatically)
      _fireStoreService.observeDoc<User>(FirestoreCollection.user, id);

      // Return Realm stream that will be updated by Firestore listener
      final localUserStream = _realmManager
          .observeEntities<User>(RealmQueryBuilder().equal("id", id))
          .where((event) => event.results.isNotEmpty)
          .map((event) => event.results.first);

      localUserStream.doOnCancel(() {
        _fireStoreService.removeDocListener(FirestoreCollection.user, id);
      });

      return localUserStream;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _fireStoreService.updateDoc<User>(FirestoreCollection.user, id, data);
      final updatedUser = await _realmManager.getEntity<User>(id);
      if (updatedUser == null) {
        throw Exception("Failed to retrieve updated user from local storage");
      }
      return updatedUser;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}