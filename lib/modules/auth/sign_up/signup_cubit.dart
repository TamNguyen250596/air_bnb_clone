import 'dart:io';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/media_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState {
  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.imageFile,
  });

  final SignupStatus status;
  final String? errorMessage;
  final File? imageFile;

  bool get isLoading => status == SignupStatus.loading;
  bool get isSuccess => status == SignupStatus.success;
  bool get isFailure => status == SignupStatus.failure;
}

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required MediaRepository mediaRepository,
    required AuthRepository authRepository,
  })  : _mediaRepository = mediaRepository,
        _authRepository = authRepository,
        super(const SignupState());

  final MediaRepository _mediaRepository;
  final AuthRepository _authRepository;

  Future<void> chooseImage() async {
    final file = await _mediaRepository.pickImageFromGallery(50);
    emit(SignupState(
      status: state.status,
      errorMessage: state.errorMessage,
      imageFile: file,
    ));
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
    if (formKey.currentState?.validate() == false || state.imageFile == null) {
      emit(SignupState(
        status: SignupStatus.failure,
        errorMessage: "Please fill all fields and choose a profile picture.",
        imageFile: state.imageFile,
      ));
      return;
    }

    emit(SignupState(status: SignupStatus.loading, imageFile: state.imageFile));

    try {
      final result = await _authRepository.createUser(
        email, password, firstName, lastName, city, country, bio, state.imageFile,
      );
      if (result.user != null) {
        formKey.currentState?.reset();
        emit(const SignupState(status: SignupStatus.success));
      } else {
        emit(SignupState(
          status: SignupStatus.failure,
          errorMessage: "Sign up failed. Please try again later.",
        ));
      }
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthError(e);
      emit(SignupState(status: SignupStatus.failure, errorMessage: message));
    } catch (e) {
      emit(SignupState(status: SignupStatus.failure, errorMessage: e.toString()));
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
        return "Sign up failed. Please try again later.";
    }
  }
}
