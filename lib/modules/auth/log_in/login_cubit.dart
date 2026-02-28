import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  final LoginStatus status;
  final String? errorMessage;

  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> signIn(GlobalKey<FormState> formKey, String email, String password) async {
    if (formKey.currentState?.validate() == false) {
      emit(LoginState(status: LoginStatus.failure, errorMessage: "Please fill all fields."));
      return;
    }

    emit(const LoginState(status: LoginStatus.loading));

    try {
      final firebaseUser = await _authRepository.signIn(email, password);
      if (firebaseUser.user != null) {
        formKey.currentState?.reset();
        emit(const LoginState(status: LoginStatus.success));
      } else {
        emit(const LoginState(status: LoginStatus.failure, errorMessage: "Sign in failed. Please try again later."));
      }
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthError(e);
      emit(LoginState(status: LoginStatus.failure, errorMessage: message));
    } catch (e) {
      emit(LoginState(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case "email-already-in-use":
        return "This email is already registered.";
      case "invalid-email":
        return "Please enter a valid email address.";
      case "weak-password":
        return "Password is too weak. Please use a stronger one. Use at-least 6 characters";
      default:
        return "Sign in failed. Please try again later.";
    }
  }
}
