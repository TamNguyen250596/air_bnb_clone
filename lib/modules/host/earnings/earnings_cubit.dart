import 'package:bloc/bloc.dart';

class EarningsState {
  const EarningsState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;
}

class EarningsCubit extends Cubit<EarningsState> {
  EarningsCubit() : super(const EarningsState());
}
