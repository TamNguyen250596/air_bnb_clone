import 'dart:developer' as developer;
import 'package:air_bnb_clone/data/models/realm_models/message/message.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';

/// Abstract contract for messages. Use [MessageRepositoryImpl] in app and a fake in unit tests.
abstract class MessageRepository {
  Future<Message> createMessage(Map<String, dynamic> data);
  Stream<RealmResultsChanges<Message>> observeMessagesByConversationId(String conversationId);
}

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  })  : _firestoreService = firestoreService,
        _realmManager = realmManager;

  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  @override
  Future<Message> createMessage(Map<String, dynamic> data) async {
    try {
      final id = await _firestoreService.createDoc<Message>(
        FirestoreCollection.message,
        null,
        data,
      );
      final createdMessage = await _realmManager.getEntity<Message>(id);
      if (createdMessage == null) {
        throw Exception("Failed to create message in local storage");
      }
      return createdMessage;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Stream<RealmResultsChanges<Message>> observeMessagesByConversationId(String conversationId) {
    try {
      final firestoreQuery = FirestoreQueryBuilder(FirestoreCollection.message)
          .equalTo('conversation_id', conversationId);
      _firestoreService.observeCollection<Message>(firestoreQuery);
      final realmQuery = RealmQueryBuilder()
          .equal('conversationId', conversationId)
          .sortAscending('createdAt');
      final stream = _realmManager.observeEntities<Message>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}
