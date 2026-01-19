import 'dart:io';
import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:air_bnb_clone/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import '../../commons/constants/app_constants.dart';
import '../models/realm_models/user/user.dart';
import '../models/realm_models/user/user_extensions.dart';
import '../services/realm/realm_service.dart';
import '../services/shared_preferences_service.dart';
import 'media_repository.dart';

// ========== Auth Result Repository Implementation ==========
class AuthRepository extends ChangeNotifier {
  // ========== Constructor ==========
  AuthRepository({
    required AuthService authService,
    required SharedPreferencesService sharedPreferencesService,
    required UserRepository userRepository,
    required MediaRepository mediaRepository,
    required RealmService realmManager,
  }):
        _authService = authService,
        _sharedPreferencesService = sharedPreferencesService,
        _userRepository = userRepository,
        _mediaRepository = mediaRepository,
        _realmManager = realmManager
  ;

  // ========== Properties ==========
  final AuthService _authService;
  final SharedPreferencesService _sharedPreferencesService;
  final UserRepository _userRepository;
  final MediaRepository _mediaRepository;
  final RealmService _realmManager;

  bool? _isAuthenticated;
  String? _userId;

  // ========== Public Methods ==========
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  Future<String?> get userId async {
    // Status is cached
    if (_userId != null) {
      return _userId;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _userId;
  }

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
        id,
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

      await _userRepository.createUser(id, user.toFirestore());
      _sharedPreferencesService.saveToken(id);
      _isAuthenticated = true;
      _userId = id;
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
    return firebaseUser;
  }

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

  Future<void> signOut() async {
    await _sharedPreferencesService.removeToken();
    await _authService.signOut();
    _realmManager.deleteAll;
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}