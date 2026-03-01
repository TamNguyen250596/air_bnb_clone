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
  CurrentUserCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const CurrentUserState()) {
    _observeCurrentUser();
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<User>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Future<void> _observeCurrentUser() async {
    final userId = await _authRepository.userId;
    if (userId == null) {
      emit(const CurrentUserState(isLoading: false));
      return;
    }

    try {
      _userSubscription = _userRepository.observeUser(userId).listen(
        (user) {
          emit(CurrentUserState(
            user: user,
            isLoading: false,
            errorMessage: null,
          ));
        },
        onError: (Object error, StackTrace stackTrace) {
          emit(CurrentUserState(
            isLoading: false,
            errorMessage: error.toString(),
          ));
        },
      );
    } catch (e) {
      emit(CurrentUserState(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
