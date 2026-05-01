import 'dart:developer' as developer;

import 'package:air_bnb_clone/data/repositories/notification_repository.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/realm/realm_service.dart';
import 'package:air_bnb_clone/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

/// Persists FCM payloads into Realm when a message is handled in a background isolate.
///
/// Register with [FirebaseMessaging.onBackgroundMessage] in `main()` after
/// [Firebase.initializeApp] (see [FlutterFire background messaging](https://firebase.flutter.dev/docs/messaging/usage#background-messages)).
///
/// **Android note:** Messages that contain only a `notification` payload are often
/// displayed by the system while the app is backgrounded and may not invoke this
/// handler. Include a `data` payload (and/or handle [FirebaseMessaging.onMessageOpenedApp]
/// / [FirebaseMessaging.instance.getInitialMessage]) so the app can persist fields
/// reliably. See [Notifications via REST](https://firebase.flutter.dev/docs/messaging/notifications/#via-rest).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    final realmService = RealmService();
    final fireStoreService = FireStoreService(realmManager: realmService);
    final notificationRepository = NotificationRepositoryImpl(
      firestoreService: fireStoreService,
      realmManager: realmService,
    );
    await notificationRepository.createNotificationOnRemote(message);
  } catch (e, st) {
    developer.log('FCM background persist failed', error: e, stackTrace: st);
  }
}
