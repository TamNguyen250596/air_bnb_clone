import 'dart:io';
import 'package:air_bnb_clone/commons/constants/app_constants.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/user_repository.dart';

class EditProfileState {
  const EditProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.imageUrl,
    this.imageFile,
    this.email = '',
    this.firstName,
    this.lastName,
    this.city,
    this.country,
    this.bio,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? imageUrl;
  final File? imageFile;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? country;
  final String? bio;

  EditProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? imageUrl,
    File? imageFile,
    String? email,
    String? firstName,
    String? lastName,
    String? city,
    String? country,
    String? bio,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      country: country ?? this.country,
      bio: bio ?? this.bio,
    );
  }
}

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required MediaRepository mediaRepository,
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _mediaRepository = mediaRepository,
        _userRepository = userRepository,
        super(const EditProfileState()) {
    loadInitialProfile();
  }

  final MediaRepository _mediaRepository;
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Future<void> loadInitialProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final id = await _authRepository.userId;
      if (id == null) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Not signed in.'));
        return;
      }
      final user = await _userRepository.getUser(id);
      if (!user.isValid) {
        emit(state.copyWith(isLoading: false, errorMessage: 'User not found.'));
        return;
      }
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: null,
          email: user.email ?? '',
          firstName: user.firstName,
          lastName: user.lastName,
          city: user.city,
          country: user.country,
          bio: user.bio,
          imageUrl: user.imageUrl,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> chooseImage() async {
    final file = await _mediaRepository.pickImageFromGallery(50);
    emit(state.copyWith(imageFile: file));
  }

  Future<void> submitProfile({
    required GlobalKey<FormState> formKey,
    required String firstName,
    required String lastName,
    required String city,
    required String country,
    required String bio,
  }) async {
    if (formKey.currentState?.validate() != true) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final id = await _authRepository.userId;
      if (id == null) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Not signed in.'));
        return;
      }

      final data = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'full_name': '$firstName $lastName'.trim(),
        'city': city,
        'country': country,
        'bio': bio,
      };

      if (state.imageFile != null) {
        final publicId = '${AppConstants.userAvatar}_${id}_${DateTime.now().microsecondsSinceEpoch}';
        final url = await _mediaRepository.uploadImage(state.imageFile!, publicId);
        if (url != null) {
          data['image_url'] = url;
        }
      } else if (state.imageUrl != null) {
        data['image_url'] = state.imageUrl;
      }

      final updated = await _userRepository.updateUser(id, data);
      if (!updated.isValid) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Update failed.'));
        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: null,
          imageFile: null,
          imageUrl: updated.imageUrl ?? state.imageUrl,
          firstName: updated.firstName,
          lastName: updated.lastName,
          city: updated.city,
          country: updated.country,
          bio: updated.bio,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
