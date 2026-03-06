import 'package:air_bnb_clone/data/models/realm_models/message/message.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';

/// Abstract contract for messages. Use [MessageRepositoryImpl] in app and a fake in unit tests.
abstract class MessageRepository {
  Future<Message> createMessage(Map<String, dynamic> data);
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
      print(e);
      rethrow;
    }
  }
}
