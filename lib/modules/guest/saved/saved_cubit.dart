import 'package:bloc/bloc.dart';

class SavedState {
  const SavedState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;
}

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(const SavedState());
}
