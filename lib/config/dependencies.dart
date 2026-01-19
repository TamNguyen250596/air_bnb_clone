import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/place_repository.dart';
import 'package:air_bnb_clone/data/services/auth_service.dart';
import 'package:air_bnb_clone/data/services/firestore/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/repositories/media_repository.dart';
import '../data/repositories/posting_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/services/media_service.dart';
import '../data/services/realm/realm_service.dart';
import '../data/services/shared_preferences_service.dart';

// ========== Dependency Injection Providers ==========
List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => MediaService()),
    Provider(create: (context) => AuthService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => RealmService()),
    Provider(create: (context) => FireStoreService(
      realmManager: context.read(),
    )),
    Provider(
      create: (context) =>
      MediaRepository(mediaService: context.read()),
    ),
    Provider(
      create: (context) =>
      UserRepository(
          fireStoreService: context.read(),
          realmManager: context.read()
      ),
    ),
    Provider(
      create: (context) =>
      PostingRepository(
          firestoreService: context.read(),
          realmManager: context.read()
      ),
    ),
    Provider(create: (context) => PlaceRepository()),
    ChangeNotifierProvider(
      create: (context) =>
      AuthRepository(
          authService: context.read(),
          sharedPreferencesService: context.read(),
          userRepository: context.read(),
          mediaRepository: context.read(),
          realmManager: context.read()
      ),
    ),
  ];
}
