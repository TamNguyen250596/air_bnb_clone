import 'dart:async';

import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realm/realm.dart';
import 'firestore_mapper.dart';

class FireStoreService {

  // Init
  FireStoreService({
    required RealmService realmManager,
  }) : _realmManager = realmManager;

  // Properties
  final RealmService _realmManager;
  final Map<DocumentReference, StreamSubscription<DocumentSnapshot>> _observedDocuments = {};

  Future<void> createDoc<T extends RealmObject>(String collection, String id, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.doc("$collection/$id").set(data);
      final realmObject = FirestoreMapper.fromMap<T>(data);
      _realmManager.createFromEntity(realmObject, update: true);
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  Future<DocumentSnapshot> getDoc<T extends RealmObject>(String collection, String id) async {
    final snapshot = await FirebaseFirestore.instance.doc("$collection/$id").get();
    if (snapshot.exists) {
      final realmObject = FirestoreMapper.fromDocumentSnapshot<T>(snapshot);
      _realmManager.createFromEntity(realmObject, update: true);
    }
    return snapshot;
  }

  void observeDoc<T extends RealmObject>(String collection, String id) {
    final doc = FirebaseFirestore.instance.doc("$collection/$id");
    if (_observedDocuments[doc] != null) return;
    final stream = doc.snapshots();

    _observedDocuments[doc] = stream.listen((event) {
      if (event.exists) {
        final realmObject = FirestoreMapper.fromDocumentSnapshot<T>(event);
        _realmManager.createFromEntity(realmObject, update: true);
      } else {
        _realmManager.deleteEntity(id);
      }
    });
  }

  Future<void> updateDoc<T extends RealmObject>(String collection, String id, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.doc("$collection/$id").update(data);
      final realmObject = FirestoreMapper.fromMap<T>(data);
      _realmManager.createFromEntity(realmObject, update: true);
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  void removeDocListener(String collection, String id) {
    final doc = FirebaseFirestore.instance.doc("$collection/$id");

    _observedDocuments[doc]?.cancel();
    _observedDocuments.remove(doc);
  }
}