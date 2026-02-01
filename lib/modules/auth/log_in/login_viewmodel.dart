import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/repositories/auth_repository.dart';

// ========== Login ViewModel ==========
class LoginViewModel extends ChangeNotifier {
  // ========== Constructor ==========
  LoginViewModel({
    required AuthRepository authResultRepository
  }) : _authResultRepository = authResultRepository;

  // ========== Private Properties ==========
  final AuthRepository _authResultRepository;
  bool _isLoading = false;
  String _errorMessage = "";

  // ========== Public Getters ==========
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // ========== Public Methods ==========
  Future<void> signIn( GlobalKey<FormState> formKey, String email, String password) async {
    _errorMessage = "";
    if (formKey.currentState?.validate() == false) {
      _errorMessage = "Please fill all fields.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final firebaseUser = await _authResultRepository.signIn(email, password);

      if (firebaseUser.user != null) {
        formKey.currentState!.reset();
      }
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "email-already-in-use":
          _errorMessage = "This email is already registered.";
          break;
        case "invalid-email":
          _errorMessage = "Please enter a valid email address.";
          break;
        case "weak-password":
          _errorMessage = "Password is too weak. Please use a stronger one. Use at-least 6 characters";
          break;
        default:
          _errorMessage = "Sign in failed. Please try again later.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}