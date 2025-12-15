import 'dart:io';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String _errorMessage = "";
  bool _isSignUpSuccess = false;

  // ========== Public Getters ==========
  bool get isUploading => _isUploading;
  GlobalKey<FormState> get formKey => _formKey;
  File? get imageFile => _imageFile;
  String get errorMessage => _errorMessage;
  bool get isSignUpSuccess => _isSignUpSuccess;

  // ========== Public Methods ==========
  Future<void> chooseImage() async {
    try {
      final image = await _mediaRepository.pickImageFromGallery();
      if (image != null) {
        File originalFile = File(image.path);
        final tempDir = await getTemporaryDirectory();
        final targetPath = path.join(
          tempDir.path,
          "compressed_${DateTime.now().microsecondsSinceEpoch}.jpg",
        );
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          originalFile.path,
          quality: 50,
        );
        if (compressedBytes != null) {
          final compressedFile = File(targetPath);
          await compressedFile.writeAsBytes(compressedBytes);
          _imageFile = compressedFile;
        }
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> createAccount(
    String email,
    String password,
    String firstName,
    String lastName,
    String city,
    String country,
    String bio
  ) async {
    if (_formKey.currentState?.validate() == false || _imageFile == null) {
      _errorMessage = "Please fill all fields and choose a profile picture.";
      notifyListeners();
      return;
    }

    _isUploading = true;
    notifyListeners();

    try {
      final result = await _authResultRepository.createUser(email, password, firstName, lastName, city, country, bio, _imageFile);
      if (result.user != null) {
        _formKey.currentState!.reset();
        _isSignUpSuccess = true;
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
