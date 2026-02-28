import 'package:bloc/bloc.dart';

class BookPostingState {
  BookPostingState({
    this.name = "",
    this.currentTag = "check_in",
    this.dates = const {},
    DateTime? firstDate,
    DateTime? lastDate,
  })  : firstDate = firstDate ?? DateTime.now(),
        lastDate = lastDate ?? DateTime.now().add(const Duration(days: 210));

  final String name;
  final String currentTag;
  final Map<String, DateTime> dates;
  final DateTime firstDate;
  final DateTime lastDate;

  bool get canBook {
    final checkIn = dates["check_in"];
    final checkOut = dates["check_out"];
    if (checkIn == null || checkOut == null) return false;
    final inDate = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final outDate = DateTime(checkOut.year, checkOut.month, checkOut.day);
    return outDate.isAfter(inDate);
  }

  DateTime getInitialDate() => dates[currentTag] ?? DateTime.now();

  String getInitialDateStr(String tag) {
    DateTime? date = dates[tag];
    if (date == null && tag == "check_in") date = DateTime.now();
    if (date != null) return "${date.day}/${date.month}/${date.year}";
    return "";
  }

  BookPostingState copyWith({
    String? name,
    String? currentTag,
    Map<String, DateTime>? dates,
  }) {
    return BookPostingState(
      name: name ?? this.name,
      currentTag: currentTag ?? this.currentTag,
      dates: dates ?? this.dates,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}

class BookPostingCubit extends Cubit<BookPostingState> {
  BookPostingCubit({required Map<String, dynamic> parameters})
      : super(BookPostingState()) {
    _setupInitialValues(parameters);
  }

  void _setupInitialValues(Map<String, dynamic> parameters) {
    final name = parameters["name"] as String? ?? "";
    final Map<String, DateTime>? datesParam = parameters["dates"] as Map<String, DateTime>?;
    final dates = (datesParam != null && datesParam.isNotEmpty)
        ? datesParam
        : {"check_in": DateTime.now()};
    emit(BookPostingState(
      name: name,
      dates: dates,
      firstDate: state.firstDate,
      lastDate: state.lastDate,
    ));
  }

  void setCurrentTag(String tag) {
    emit(state.copyWith(currentTag: tag));
  }

  void updateSelectedDate(DateTime date) {
    final newDates = Map<String, DateTime>.from(state.dates);
    newDates[state.currentTag] = date;
    emit(state.copyWith(dates: newDates));
  }
}
