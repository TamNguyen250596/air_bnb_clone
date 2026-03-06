import 'dart:async';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realm/realm.dart';
import 'firestore_mapper.dart';
import 'firestore_query_builder.dart';

class FireStoreService {

  // Init
  FireStoreService({
    required RealmService realmManager,
  }) : _realmManager = realmManager;

  // Properties
  final RealmService _realmManager;
  final Map<DocumentReference, StreamSubscription<DocumentSnapshot>> _observedDocuments = {};
  final Map<Query<Map<String, dynamic>>, StreamSubscription<QuerySnapshot>> _observedCollections = {};

  // Create
  Future<String> createDoc<T extends RealmObject>(String collection, String? id, Map<String, dynamic> data) async {
    try {
      if (id == null || id.isEmpty) {
        final docRef = await FirebaseFirestore.instance.collection(collection).doc();
        data["id"] = docRef.id;
        id = docRef.id;
        await docRef.set(data);
      } else {
        if (data["id"] == null || data["id"] == "") {
          data["id"] = id;
        }
        await FirebaseFirestore.instance.doc("$collection/$id").set(data);
      }
      final realmObject = FirestoreMapper.fromMap<T>(data);
      _realmManager.createFromEntity(realmObject, update: true);
      return id;
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  // Read
  Future<DocumentSnapshot> getDoc<T extends RealmObject>(String collection, String id) async {
    final snapshot = await FirebaseFirestore.instance.doc("$collection/$id").get();
    if (snapshot.exists) {
      final realmObject = FirestoreMapper.fromDocumentSnapshot<T>(snapshot);
      _realmManager.createFromEntity(realmObject, update: true);
    }
    return snapshot;
  }

  Future<List<QueryDocumentSnapshot<Object>>> getCollection<T extends RealmObject>(FirestoreQueryBuilder builder) async {
    final snapshot = await builder.build(FirebaseFirestore.instance).get();
    return snapshot.docs.map((doc) {
      final realmObject = FirestoreMapper.fromDocumentSnapshot<T>(doc);
      _realmManager.createFromEntity(realmObject, update: true);
      return doc;
    }).toList();
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

  void observeCollection<T extends RealmObject>(FirestoreQueryBuilder builder) {
    final stream = builder.build(FirebaseFirestore.instance);
    if (_observedCollections[stream] != null) return;
    final subscription = stream.snapshots();

    _observedCollections[stream] = subscription.listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
          case DocumentChangeType.modified:
            if (change.doc.exists && change.doc.data() != null) {
              final realmObject = FirestoreMapper.fromMap<T>(change.doc.data()!);
              _realmManager.createFromEntity(
                realmObject,
                update: true,
              );
            }
            break;

          case DocumentChangeType.removed:
            _realmManager.deleteEntity<T>(change.doc.id);
            break;
        }
      }
    });
  }

  // Update
  Future<void> updateDoc<T extends RealmObject>(String collection, String id, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.doc("$collection/$id").update(data);
      if (data["id"] == null || data["id"] == "") {
        data["id"] = id;
      }
      final realmObject = FirestoreMapper.fromMap<T>(data);
      _realmManager.createFromEntity(realmObject, update: true);
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  // Functions
  void removeDocListener(String collection, String id) {
    final doc = FirebaseFirestore.instance.doc("$collection/$id");

    _observedDocuments[doc]?.cancel();
    _observedDocuments.remove(doc);
  }

  void removeCollectionListener(FirestoreQueryBuilder builder) {
    final stream = builder.build(FirebaseFirestore.instance);

    _observedCollections[stream]?.cancel();
    _observedCollections.remove(stream);
  }

  void removeAllListeners() {
    _observedDocuments.forEach((key, value) => value.cancel());
    _observedDocuments.clear();
    _observedCollections.forEach((key, value) => value.cancel());
    _observedCollections.clear();
  }
}