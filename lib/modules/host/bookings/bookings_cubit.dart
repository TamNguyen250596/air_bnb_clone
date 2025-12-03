import 'package:bloc/bloc.dart';

class BookingsState {
  const BookingsState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;
}

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit() : super(const BookingsState());
}
