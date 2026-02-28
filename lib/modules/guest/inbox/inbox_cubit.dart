import 'package:bloc/bloc.dart';

class InboxState {
  const InboxState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;
}

class InboxCubit extends Cubit<InboxState> {
  InboxCubit() : super(const InboxState());
}
