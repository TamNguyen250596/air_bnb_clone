import 'dart:async';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import '../../../data/models/realm_models/user/user.dart';

class CurrentUserState {
  const CurrentUserState({
    this.user,
    this.isLoading = true,
    this.errorMessage,
  });

  final User? user;
  final bool isLoading;
  final String? errorMessage;
}

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(const CurrentUserState());
}
