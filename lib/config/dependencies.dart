import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/services/auth_service.dart';
import 'package:air_bnb_clone/data/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/repositories/media_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/services/media_service.dart';
import '../data/services/shared_preferences_service.dart';

// ========== Dependency Injection Providers ==========
List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => MediaService()),
    Provider(create: (context) => AuthService()),
    Provider(create: (context) => FireStoreService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(
      create: (context) =>
      MediaRepositoryLocal(mediaService: context.read())
      as MediaRepository,
    ),
    Provider(
      create: (context) =>
      UserRepositoryRemote(fireStoreService: context.read())
      as UserRepository,
    ),
    ChangeNotifierProvider(
      create: (context) =>
      AuthRepositoryRemote(
          authService: context.read(),
          sharedPreferencesService: context.read(),
          userRepository: context.read(),
          mediaRepository: context.read()
      )
      as AuthRepository,
    ),
  ];
}
