import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/conversation/conversation.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';

/// Abstract contract for conversations. Use [ConversationRepositoryImpl] in app and a fake in unit tests.
abstract class ConversationRepository {
  Future<Conversation> createConversation(Map<String, dynamic> data, String? id);
  Future<Conversation?> getConversation(String id);
  Future<Conversation> updateConversation(String id, Map<String, dynamic> data);
}

class ConversationRepositoryImpl implements ConversationRepository {
  ConversationRepositoryImpl({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  })  : _firestoreService = firestoreService,
        _realmManager = realmManager;

  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  @override
  Future<Conversation> createConversation(Map<String, dynamic> data, String? id) async {
    try {
      final docId = await _firestoreService.createDoc<Conversation>(
        FirestoreCollection.conversation,
        id,
        data,
      );
      final createdConversation =
          await _realmManager.getEntity<Conversation>(docId);
      if (createdConversation == null) {
        throw Exception("Failed to create conversation in local storage");
      }
      return createdConversation;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<Conversation?> getConversation(String id) async {
    try {
      await _firestoreService.getDoc<Conversation>(
        FirestoreCollection.conversation,
        id,
      );
      return await _realmManager.getEntity<Conversation>(id);
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<Conversation> updateConversation(
      String id, Map<String, dynamic> data) async {
    try {
      await _firestoreService.updateDoc<Conversation>(
        FirestoreCollection.conversation,
        id,
        data,
      );
      final updated =
          await _realmManager.getEntity<Conversation>(id);
      if (updated == null) {
        throw Exception(
            "Failed to retrieve updated conversation from local storage");
      }
      return updated;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}
