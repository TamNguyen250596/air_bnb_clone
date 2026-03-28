import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import '../../../data/repositories/auth_repository.dart';

class EarningsState {
  const EarningsState({this.isLoading = false, this.totalMoney = ""});

  final bool isLoading;
  final String totalMoney;

  EarningsState copyWith({
    bool? isLoading,
    String? totalMoney
  }) {
    return EarningsState(
      isLoading: isLoading ?? this.isLoading,
      totalMoney: totalMoney ?? this.totalMoney
    );
  }
}

class EarningsCubit extends Cubit<EarningsState> {

  EarningsCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository
  }) : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const EarningsState()) {
    _getTotalEarning();
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  Future<void> _getTotalEarning() async {
    final id = await _authRepository.userId;
    if (id == null) {
      return;
    }
    final user = await _userRepository.getUser(id);
    if (!user.isValid) {
      return;
    }
    final earning = user.earning ?? 0.0;
    final earnStr =  "💲${earning.toStringAsFixed(2)}";
    emit(state.copyWith(totalMoney: earnStr));
  }
}
