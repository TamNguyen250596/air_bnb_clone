import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/place_repository.dart';
import 'package:air_bnb_clone/data/repositories/remote_notification_repository.dart';
import 'package:air_bnb_clone/data/services/auth_service.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:air_bnb_clone/data/services/remote_notification_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/favourite_posting_repository.dart';
import '../data/repositories/conversation_repository.dart';
import '../data/repositories/media_repository.dart';
import '../data/repositories/message_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/posting_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/stripe_payment_intent_repository.dart';
import '../data/services/media_service.dart';
import '../data/services/realm/realm_service.dart';
import '../data/services/shared_preferences_service.dart';
import '../data/services/stripe_service.dart';

// ========== Dependency Injection Providers ==========
List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => MediaService()),
    Provider(create: (context) => StripeService()),
    Provider(create: (context) => AuthService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => RealmService()),
    Provider(create: (context) => FireStoreService(
      realmManager: context.read(),
    )),
    Provider<MediaRepository>(
      create: (context) =>
      MediaRepositoryImpl(mediaService: context.read()),
    ),
    Provider<UserRepository>(
      create: (context) =>
      UserRepositoryImpl(
          fireStoreService: context.read(),
          realmManager: context.read()
      ),
    ),
    Provider<PostingRepository>(
      create: (context) =>
      PostingRepositoryImpl(
          firestoreService: context.read(),
          realmManager: context.read()
      ),
    ),
    Provider<BookingRepository>(
      create: (context) =>
      BookingRepositoryImpl(
        firestoreService: context.read(),
        realmManager: context.read(),
      ),
    ),
    Provider<FavouritePostingRepository>(
      create: (context) => FavouritePostingRepositoryImpl(
        firestoreService: context.read(),
        realmManager: context.read(),
      ),
    ),
    Provider<ReviewRepository>(
      create: (context) => ReviewRepositoryImpl(
        firestoreService: context.read(),
        realmManager: context.read(),
      ),
    ),
    Provider<ConversationRepository>(
      create: (context) =>
      ConversationRepositoryImpl(
        firestoreService: context.read(),
        realmManager: context.read(),
      ),
    ),
    Provider<MessageRepository>(
      create: (context) =>
      MessageRepositoryImpl(
          firestoreService: context.read(),
          realmManager: context.read(),
      ),
    ),
    Provider<NotificationRepository>(
      create: (context) => NotificationRepositoryImpl(
        firestoreService: context.read(),
        realmManager: context.read(),
      ),
    ),
    Provider<PlaceRepository>(create: (context) => PlaceRepositoryImpl()),
    Provider<StripePaymentIntentRepository>(
      create: (context) => StripePaymentIntentRepositoryImpl(
        stripeService: context.read(),
      ),
    ),
    Provider(create: (context) => RemoteNotificationService()),
    Provider<RemoteNotificationPermissionRepository>(
      create: (context) => RemoteNotificationRepositoryImpl(
        context.read(),
        context.read(),
      ),
    ),
    ChangeNotifierProvider<AuthRepository>(
      create: (context) =>
      AuthRepositoryImpl(
          authService: context.read(),
          sharedPreferencesService: context.read(),
          userRepository: context.read(),
          mediaRepository: context.read(),
          realmManager: context.read(),
          firestoreService: context.read(),
      ),
    ),
  ];
}
