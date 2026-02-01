import 'dart:io';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import '../../../data/repositories/media_repository.dart';

// ========== Signup ViewModel ==========
class SignupViewModel extends ChangeNotifier {
  // ========== Constructor ==========
  SignupViewModel({
    required MediaRepository mediaRepository,
    required AuthRepository authResultRepository
  }) : _mediaRepository = mediaRepository,
       _authResultRepository = authResultRepository;

  // ========== Private Properties ==========
  final MediaRepository _mediaRepository;
  final AuthRepository _authResultRepository;
  bool _isUploading = false;
  String _errorMessage = "";
  File? _imageFile;

  // ========== Public Getters ==========
  bool get isUploading => _isUploading;
  String get errorMessage => _errorMessage;
  File? get imageFile => _imageFile;

  // ========== Public Methods ==========
  Future<void> chooseImage() async {
    _imageFile = await _mediaRepository.pickImageFromGallery(50);
    notifyListeners();
  }

  Future<void> createAccount({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String city,
    required String country,
    required String bio,
  }) async {
    if (formKey.currentState?.validate() == false || _imageFile == null) {
      _errorMessage = "Please fill all fields and choose a profile picture.";
      notifyListeners();
      return;
    }

    _isUploading = true;
    notifyListeners();

    try {
      final result = await _authResultRepository.createUser(
          email, password, firstName, lastName, city, country, bio, _imageFile);
      if (result.user != null) {
        formKey.currentState!.reset();
        _imageFile = null;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          _errorMessage = "This email is already registered.";
          break;
        case "invalid-email":
          _errorMessage = "Please enter a valid email address.";
          break;
        case "weak-password":
          _errorMessage =
              "Password is too weak. Please use a stronger one. Use at-least 6 characters";
          break;
        default:
          _errorMessage = "Sign up failed. Please try again later.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
