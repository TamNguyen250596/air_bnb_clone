import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/models/stripe/payment_intent.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/stripe_payment_intent_repository.dart';
import 'package:bloc/bloc.dart';

class BookPostingState {
  BookPostingState({
    this.name = "",
    this.currentTag = "check_in",
    this.dates = const {},
    DateTime? firstDate,
    DateTime? lastDate,
    this.errorMessage,
    this.paymentIntent,
  })  : firstDate = firstDate ?? DateTime.now(),
        lastDate = lastDate ?? DateTime.now().add(const Duration(days: 210));

  final String name;
  final String currentTag;
  final Map<String, DateTime> dates;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? errorMessage;
  final PaymentIntent? paymentIntent;

  bool get canBook {
    final checkIn = dates["check_in"];
    final checkOut = dates["check_out"];
    if (checkIn == null || checkOut == null) return false;
    final inDate = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final outDate = DateTime(checkOut.year, checkOut.month, checkOut.day);
    return outDate.isAfter(inDate);
  }

  int get bookDates {
    final checkIn = dates["check_in"];
    final checkOut = dates["check_out"];
    if (checkIn == null || checkOut == null) return 0;
    final inDate = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final outDate = DateTime(checkOut.year, checkOut.month, checkOut.day);
    return outDate.difference(inDate).inDays;
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
    String? errorMessage,
    PaymentIntent? paymentIntent,
  }) {
    return BookPostingState(
      name: name ?? this.name,
      currentTag: currentTag ?? this.currentTag,
      dates: dates ?? this.dates,
      firstDate: firstDate,
      lastDate: lastDate,
      errorMessage: errorMessage,
      paymentIntent: paymentIntent,
    );
  }
}

class BookPostingCubit extends Cubit<BookPostingState> {
  BookPostingCubit({
    required Map<String, dynamic> parameters,
    required AuthRepository authRepository,
    required StripePaymentIntentRepository stripePaymentIntentRepository})
      : _posting = parameters["posting"] as Posting?,
        _authRepository = authRepository,
        _stripePaymentIntentRepository = stripePaymentIntentRepository,
        super(BookPostingState()) {
    _setupInitialValues(parameters);
  }

  final Posting? _posting;
  final AuthRepository _authRepository;
  final StripePaymentIntentRepository _stripePaymentIntentRepository;

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
      lastDate: state.lastDate
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

  Future<void> book() async {
    if (_posting == null) return;
    if (!_posting.isValid) return;

    final bookDates = state.bookDates;
    if (bookDates > 0) {
      try {
        final price = _posting.price;
        if (price == null) return;

        int totalAmount = (price * bookDates).round();
        final userId = await _authRepository.userId;
        if (userId == null) return;

        final paymentIntent = await _stripePaymentIntentRepository.createPaymentIntent(
            name: userId,
            address: _posting.address ?? '',
            amount: totalAmount.toString()
        );

        emit(state.copyWith(paymentIntent: paymentIntent));
      } catch (e) {
        emit(state.copyWith(errorMessage: "Payment setup failed: $e"));
      }
    } else {
      emit(state.copyWith(errorMessage: "Please select check-in and check-out dates."));
    }
  }
}
