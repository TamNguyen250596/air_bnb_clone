import 'dart:async';
import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import '../../../data/models/realm_models/user/user.dart';
import '../../../routing/route_id.dart';

class AccountState {
  const AccountState({
    this.avatarUrl = "",
    this.fullName = "",
    this.email = "",
    this.isLoading = false,
    this.errorMessage,
    this.routeId,
    this.businessButtonTitle = "",
  });

  final String avatarUrl;
  final String fullName;
  final String email;
  final bool isLoading;
  final String? errorMessage;
  final String? routeId;
  final String businessButtonTitle;
}

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required UserRepository userRepository,
    required AuthRepository authRepository,
    bool isInHostMode = false,
  })  : _userRepository = userRepository,
        _authRepository = authRepository,
        _isInHostMode = isInHostMode,
        super(const AccountState()) {
    _observeData();
  }

  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final bool _isInHostMode;
  User? _user;
  StreamSubscription? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Future<void> changeHost() async {
    emit(state.copyWith(errorMessage: null, routeId: null));
    emit(state.copyWith(isLoading: true));

    if (_user == null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "User information not available. Please try again.",
      ));
      return;
    }

    final user = _user!;
    if (!user.isValid) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "User data is invalid. Please try again.",
      ));
      return;
    }

    if (user.isHost == true && !_isInHostMode) {
      emit(state.copyWith(isLoading: false, routeId: RouteConstant.bookingsPath));
      return;
    }

    final userId = user.id;
    final isHost = (user.isHost == null || user.isHost == false);

    try {
      await _userRepository.updateUser(userId, {"is_host": isHost});
      emit(state.copyWith(
        isLoading: false,
        routeId: isHost ? RouteConstant.bookingsPath : RouteConstant.explorePath,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Failed to update host status. Please try again.",
      ));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(errorMessage: null, isLoading: true));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(isLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Failed to sign out. Please try again.",
      ));
    }
  }

  void _observeData() async {
    final userId = await _authRepository.userId;
    if (userId == null) return;

    _userSubscription = _userRepository
        .observeUser(userId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((user) {
      if (user.isValid) {
        _user = user.freeze();
        final title = _getBusinessButtonTitle(_user!);
        emit(state.copyWith(
          avatarUrl: user.imageUrl ?? "",
          fullName: user.fullName ?? "",
          email: user.email ?? "",
          businessButtonTitle: title,
        ));
      }
    });
  }

  String _getBusinessButtonTitle(User user) {
    if (user.isHost == null) return "Become a Host";
    if (user.isHost == true && _isInHostMode) return "Show my Guest Dashboard";
    return "Show my Host Dashboard";
  }
}

extension _AccountStateCopy on AccountState {
  AccountState copyWith({
    String? avatarUrl,
    String? fullName,
    String? email,
    bool? isLoading,
    String? errorMessage,
    String? routeId,
    String? businessButtonTitle,
  }) {
    return AccountState(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      routeId: routeId ?? this.routeId,
      businessButtonTitle: businessButtonTitle ?? this.businessButtonTitle,
    );
  }
}
