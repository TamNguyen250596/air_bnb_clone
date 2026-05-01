import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class RemoteNotificationService {

  Future<AuthorizationStatus> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
    return settings.authorizationStatus;
  }

  Future<String?> getToken() async {
    final messaging = FirebaseMessaging.instance;
    return messaging.getToken();
  }

  /// Function A:
  /// Observes push notifications while app is in foreground.
  /// Also enables iOS foreground presentation options, as recommended by FlutterFire docs.
  Stream<RemoteMessage> observeForegroundNotifications() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    return FirebaseMessaging.onMessage;
  }
}