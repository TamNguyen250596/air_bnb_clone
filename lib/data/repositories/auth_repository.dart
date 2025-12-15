import 'dart:io';
import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:air_bnb_clone/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import '../../commons/constants/app_constants.dart';
import '../model/user.dart';
import '../services/shared_preferences_service.dart';
import 'media_repository.dart';

// ========== Auth Result Repository Interface ==========
abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<UserCredential> createUser(
      String email,
      String password,
      String firstName,
      String lastName,
      String city,
      String country,
      String bio,
      File? imageFile
      );
  Future<UserCredential> signIn(String email, String password);
}

// ========== Auth Result Repository Implementation ==========
class AuthRepositoryRemote extends AuthRepository {
  // ========== Constructor ==========
  AuthRepositoryRemote({
    required AuthService authService,
    required SharedPreferencesService sharedPreferencesService,
    required UserRepository userRepository,
    required MediaRepository mediaRepository
  }):
        _authService = authService,
        _sharedPreferencesService = sharedPreferencesService,
        _userRepository = userRepository,
        _mediaRepository = mediaRepository
  ;

  // ========== Properties ==========
  final AuthService _authService;
  final SharedPreferencesService _sharedPreferencesService;
  final UserRepository _userRepository;
  final MediaRepository _mediaRepository;

  bool? _isAuthenticated;
  String? _userId;

  // ========== Public Methods ==========
  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<UserCredential> createUser(
      String email,
      String password,
      String firstName,
      String lastName,
      String city,
      String country,
      String bio,
      File? imageFile) async {
    final firebaseUser = await _authService.createUser(email, password);

    if (firebaseUser.user != null) {
      final id = firebaseUser.user!.uid;
      final publicId = "${AppConstants.userAvatar}_$id";
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _mediaRepository.uploadImage(imageFile, publicId);
      }
      final User user = User(
        id: id,
        email: email,
        bio: bio,
        city: city,
        country: country,
        firstName: firstName,
        lastName: lastName,
        fullName: "$firstName $lastName",
        imageUrl: imageUrl,
        isCurrentlyHosting: false,
        isHost: false,
      );

      _userRepository.createUser(user);
      _sharedPreferencesService.saveToken(id);
      _isAuthenticated = true;
      _userId = id;
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
    return firebaseUser;
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    final firebaseUser = await _authService.signIn(email, password);

    if (firebaseUser.user != null) {
      final id = firebaseUser.user!.uid;

      _sharedPreferencesService.saveToken(id);
      await _userRepository.getUser(id);
      _isAuthenticated = true;
      _userId = id;
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
    return firebaseUser;
  }

// ========== Private Methods ==========
  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();

    _userId = result;
    _isAuthenticated = result != null;
  }
}