import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/remote_notification_service.dart';
import 'notification_repository.dart';

abstract class RemoteNotificationPermissionRepository {
  Future<void> requestPermission();
  Future<String?> getToken();
  Future<void> persistInitialMessageIfAny();
  StreamSubscription<RemoteMessage> listenPersistOnMessageOpenedApp();
  StreamSubscription<RemoteMessage> listenPersistForegroundNotifications();
}

class RemoteNotificationRepositoryImpl extends RemoteNotificationPermissionRepository {

  RemoteNotificationRepositoryImpl(
    this._service,
    this._notificationRepository,
  );

  final RemoteNotificationService _service;
  final NotificationRepository _notificationRepository;

  @override
  Future<void> requestPermission() async {
    await _service.requestPermission();
  }

  @override
  Future<String?> getToken() async {
    return _service.getToken();
  }

  @override
  Future<void> persistInitialMessageIfAny() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial == null) return;
    try {
      await _notificationRepository.createNotificationOnRemote(initial);
    } catch (e, st) {
      developer.log('FCM getInitialMessage persist failed', error: e, stackTrace: st);
    }
  }

  @override
  StreamSubscription<RemoteMessage> listenPersistOnMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      try {
        await _notificationRepository.createNotificationOnRemote(message);
      } catch (e, st) {
        developer.log('FCM onMessageOpenedApp persist failed', error: e, stackTrace: st);
      }
    });
  }

  @override
  StreamSubscription<RemoteMessage> listenPersistForegroundNotifications() {
    return _service.observeForegroundNotifications().listen((message) async {
      try {
        await _notificationRepository.createNotificationOnRemote(message);
      } catch (e, st) {
        developer.log('FCM foreground persist failed', error: e, stackTrace: st);
      }
    });
  }
}