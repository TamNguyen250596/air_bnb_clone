import 'dart:async';

import 'package:air_bnb_clone/data/models/realm_models/notification/notification.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/remote_notification_repository.dart';

class CurrentUserState {
  const CurrentUserState({
    this.isLoading = true,
    this.errorMessage,
    this.pendingAdvertisementNotification,
  });

  final bool isLoading;
  final String? errorMessage;
  final Notification? pendingAdvertisementNotification;

  CurrentUserState copyWith({
    bool? isLoading,
    String? errorMessage,
    Notification? pendingAdvertisementNotification,
    bool clearPendingAdvertisementNotification = false,
  }) {
    return CurrentUserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingAdvertisementNotification: clearPendingAdvertisementNotification
          ? null
          : (pendingAdvertisementNotification ?? this.pendingAdvertisementNotification),
    );
  }
}

class CurrentUserCubit extends Cubit<CurrentUserState> {

  CurrentUserCubit({
    required RemoteNotificationPermissionRepository pushNotificationRepository,
    required NotificationRepository notificationRepository,
  }) : _pushNotificationRepository = pushNotificationRepository,
       _notificationRepository = notificationRepository,
       super(const CurrentUserState()) {
    _initPushNotifications();
  }

  final RemoteNotificationPermissionRepository _pushNotificationRepository;
  final NotificationRepository _notificationRepository;
  StreamSubscription<RemoteMessage>? _foregroundPushSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;
  StreamSubscription<RealmResultsChanges<Notification>>?
      _advertisementNotificationSubscription;
  final Set<String> _hiddenAdvertisementIds = <String>{};

  @override
  Future<void> close() {
    _foregroundPushSubscription?.cancel();
    _messageOpenedAppSubscription?.cancel();
    _advertisementNotificationSubscription?.cancel();
    return super.close();
  }

  Future<void> _initPushNotifications() async {
    try {
      await _pushNotificationRepository.requestPermission();
      final token = await _pushNotificationRepository.getToken();
      if (kDebugMode) {
        print("Remote Notification Log: $token");
      }
      await _pushNotificationRepository.persistInitialMessageIfAny();
      _messageOpenedAppSubscription =
          _pushNotificationRepository.listenPersistOnMessageOpenedApp();
      _foregroundPushSubscription =
          _pushNotificationRepository.listenPersistForegroundNotifications();
      _advertisementNotificationSubscription = _notificationRepository
          .observeNotificationsByType('advertisement')
          .listen(_handleAdvertisementNotifications);
      emit(const CurrentUserState(isLoading: false));
    } catch (e) {
      emit(CurrentUserState(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> onAdvertisementDialogClosed(Notification notification) async {
    _hiddenAdvertisementIds.add(notification.id);
    emit(state.copyWith(clearPendingAdvertisementNotification: true));
    await _notificationRepository.markNotificationAsRead(notification.id);
  }

  void _handleAdvertisementNotifications(
    RealmResultsChanges<Notification> changes,
  ) {
    Notification? unread;
    for (final n in changes.results) {
      if (!n.isRead && !_hiddenAdvertisementIds.contains(n.id)) {
        unread = n;
        break;
      }
    }
    if (unread == null) {
      if (state.pendingAdvertisementNotification != null) {
        emit(state.copyWith(clearPendingAdvertisementNotification: true));
      }
      return;
    }
    if (state.pendingAdvertisementNotification?.id == unread.id) return;
    final frozenUnread = unread.freeze();
    emit(state.copyWith(pendingAdvertisementNotification: frozenUnread));
  }
}