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
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";
  bool _isLogInSuccess = false;

  // ========== Public Getters ==========
  bool get isLoading => _isLoading;
  GlobalKey<FormState> get formKey => _formKey;
  String get errorMessage => _errorMessage;
  bool get isLogInSuccess => _isLogInSuccess;

  // ========== Public Methods ==========
  Future<void> signIn(String email, String password) async {
    _reset();
    if (_formKey.currentState?.validate() == false) {
      _errorMessage = "Please fill all fields.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final firebaseUser = await _authResultRepository.signIn(email, password);

      if (firebaseUser.user != null) {
        _formKey.currentState!.reset();
        _isLogInSuccess = true;
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
          _errorMessage = "Sign up failed. Please try again later.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========== Private Methods ==========
  void _reset() {
    _errorMessage = "";
    _isLogInSuccess = false;
    _isLoading = false;
    _formKey.currentState!.reset();
  }
}