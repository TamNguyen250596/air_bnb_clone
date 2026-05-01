import 'dart:developer' as developer;

import 'package:air_bnb_clone/data/models/realm_models/notification/notification.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_constant.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_query_builder.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_query_builder.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:realm/realm.dart';
import 'package:rxdart/rxdart.dart';

import '../models/realm_models/notification/notification_extensions.dart';

abstract class NotificationRepository {
  Future<Notification> createNotification(Map<String, dynamic> data);
  Future<Notification> createNotificationOnRemote(RemoteMessage message);
  Future<void> markNotificationAsRead(String id);
  Stream<RealmResultsChanges<Notification>> observeNotificationsByType(String type, {int? limit,});
}

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required FireStoreService firestoreService,
    required RealmService realmManager,
  })  : _firestoreService = firestoreService,
        _realmManager = realmManager;

  final FireStoreService _firestoreService;
  final RealmService _realmManager;

  @override
  Future<Notification> createNotification(Map<String, dynamic> data) async {
    try {
      final id = await _firestoreService.createDoc<Notification>(
        FirestoreCollection.notification,
        null,
        data,
      );
      final created = await _realmManager.getEntity<Notification>(id);
      if (created == null) {
        throw Exception("Failed to create notification in local storage");
      }
      return created;
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<Notification> createNotificationOnRemote(RemoteMessage message) {
    try {
      final data = Map<String, dynamic>.from(message.data);
      final createdAt =
          _toMillisecondsSinceEpoch(data['created_at']) ??
              DateTime.now().millisecondsSinceEpoch;
      final map = {
        'id': (data['id'] ?? message.messageId ?? createdAt.toString()).toString(),
        'title': data['title'] ?? message.notification?.title,
        'body': data['body'] ?? message.notification?.body,
        'image_url': data['image_url'],
        'type': data['type'] ?? 'general',
        'is_read': false,
        'created_at': createdAt,
      };
      final realmObject = NotificationFirestoreHelper.fromFirestore(map);
      return _realmManager.createFromEntity(realmObject, update: true);
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    try {
      final existing = await _realmManager.getEntity<Notification>(id);
      if (existing == null) return;
      if (!existing.isValid) return;

      await _realmManager.updateEntity<Notification>(existing.id, {"is_read": true});
      final updated = existing.toFirestore();
      updated['is_read'] = true;
      await _firestoreService.updateDoc<Notification>(
        FirestoreCollection.notification,
        id,
        updated,
      );
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }

  int? _toMillisecondsSinceEpoch(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is DateTime) return value.millisecondsSinceEpoch;
    if (value is String) {
      final asInt = int.tryParse(value);
      if (asInt != null) return asInt;
      final asDateTime = DateTime.tryParse(value);
      return asDateTime?.millisecondsSinceEpoch;
    }
    return null;
  }

  @override
  Stream<RealmResultsChanges<Notification>> observeNotificationsByType(
    String type, {
    int? limit,
  }) {
    try {
      var firestoreQuery = FirestoreQueryBuilder(FirestoreCollection.notification)
          .equalTo('type', type)
          .orderBy('created_at', descending: true);
      final lim = limit;
      if (lim != null && lim > 0) {
        firestoreQuery = firestoreQuery.limit(lim);
      }
      _firestoreService.observeCollection<Notification>(firestoreQuery);

      var realmQuery = RealmQueryBuilder()
          .equal('type', type)
          .sortDescending('createdAt');
      if (lim != null && lim > 0) {
        realmQuery = realmQuery.limit(lim);
      }
      final stream = _realmManager.observeEntities<Notification>(realmQuery);
      return stream.doOnCancel(() {
        _firestoreService.removeCollectionListener(firestoreQuery);
      });
    } catch (e) {
      developer.log('', error: e);
      rethrow;
    }
  }
}
