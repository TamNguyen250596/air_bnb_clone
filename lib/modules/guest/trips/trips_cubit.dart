import 'package:bloc/bloc.dart';

class TripsState {
  const TripsState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;
}

class TripsCubit extends Cubit<TripsState> {
  TripsCubit() : super(const TripsState());
}
