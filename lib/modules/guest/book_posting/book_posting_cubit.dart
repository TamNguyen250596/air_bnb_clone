import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/models/stripe/payment_intent.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/conversation_repository.dart';
import 'package:air_bnb_clone/data/repositories/stripe_payment_intent_repository.dart';
import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/message_repository.dart';

class BookPostingState {
  BookPostingState({
    this.name = "",
    this.currentTag = "check_in",
    this.dates = const {},
    DateTime? firstDate,
    DateTime? lastDate,
    this.errorMessage,
    this.paymentIntent,
    this.isSaving = false,
  })  : firstDate = firstDate ?? DateTime.now(),
        lastDate = lastDate ?? DateTime.now().add(const Duration(days: 210));

  final String name;
  final String currentTag;
  final Map<String, DateTime> dates;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? errorMessage;
  final PaymentIntent? paymentIntent;
  final bool isSaving;

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
    bool? isSaving,
  }) {
    return BookPostingState(
      name: name ?? this.name,
      currentTag: currentTag ?? this.currentTag,
      dates: dates ?? this.dates,
      firstDate: firstDate,
      lastDate: lastDate,
      errorMessage: errorMessage,
      paymentIntent: paymentIntent,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class BookPostingCubit extends Cubit<BookPostingState> {
  BookPostingCubit({
    required Map<String, dynamic> parameters,
    required AuthRepository authRepository,
    required StripePaymentIntentRepository stripePaymentIntentRepository,
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
    required ConversationRepository conversationRepository,
    required MessageRepository messageRepository,
  })
      : _posting = parameters["posting"] as Posting?,
        _authRepository = authRepository,
        _stripePaymentIntentRepository = stripePaymentIntentRepository,
        _bookingRepository = bookingRepository,
        _userRepository = userRepository,
        _conversationRepository = conversationRepository,
        _messageRepository = messageRepository,
        super(BookPostingState()) {
    _setupInitialValues(parameters);
  }

  final Posting? _posting;
  final AuthRepository _authRepository;
  final StripePaymentIntentRepository _stripePaymentIntentRepository;
  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;
  final ConversationRepository _conversationRepository;
  final MessageRepository _messageRepository;

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

  Future<void> getPaymentIntent() async {
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

  Future<void> saveBooking() async {
    final posting = _posting;
    if (posting == null || !posting.isValid) return;
    final hostId = posting.hostId;
    final price = posting.price;
    if (hostId == null || price == null) return;

    final userId = await _authRepository.userId;
    if (userId == null) return;

    final checkIn = state.dates["check_in"];
    final checkOut = state.dates["check_out"];
    if (checkIn == null || checkOut == null) return;

    final inDate = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final outDate = DateTime(checkOut.year, checkOut.month, checkOut.day);
    final paymentAmount = state.bookDates * price;

    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      await _createBookingAndUpdateHostEarning(
        postingId: posting.id,
        userId: userId,
        hostId: hostId,
        inDate: inDate,
        outDate: outDate,
        paymentAmount: paymentAmount,
      );
      await _ensureConversationAndSendMessage(
        userId: userId,
        hostId: hostId,
        postingName: posting.name ?? "",
        inDate: inDate,
        outDate: outDate,
      );
      emit(state.copyWith(isSaving: false));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        isSaving: false,
        errorMessage: "Booking failed. Please try again.",
      ));
    }
  }

  Future<void> _createBookingAndUpdateHostEarning({
    required String postingId,
    required String userId,
    required String hostId,
    required DateTime inDate,
    required DateTime outDate,
    required double paymentAmount,
  }) async {
    final bookingData = {
      "posting_id": postingId,
      "user_id": userId,
      "check_in": inDate.millisecondsSinceEpoch,
      "check_out": outDate.millisecondsSinceEpoch,
      "payment_amount": paymentAmount,
    };
    await _bookingRepository.createBooking(bookingData);

    final user = await _userRepository.getUser(userId);
    if (!user.isValid) return;

    final newEarning = (user.earning ?? 0) + paymentAmount;
    await _userRepository.updateUser(hostId, {"earning": newEarning});
  }

  static String _conversationId(String userId, String hostId) =>
      userId.compareTo(hostId) < 0 ? "$userId-$hostId" : "$hostId-$userId";

  Future<void> _ensureConversationAndSendMessage({
    required String userId,
    required String hostId,
    required String postingName,
    required DateTime inDate,
    required DateTime outDate,
  }) async {
    final conversationId = _conversationId(userId, hostId);
    final text =
        "Hello, I want to book $postingName from ${inDate.day}/${inDate.month}/${inDate.year} to ${outDate.day}/${outDate.month}/${outDate.year}";

    final existing = await _conversationRepository.getConversation(conversationId);
    if (existing != null) {
      await _conversationRepository.updateConversation(
        conversationId,
        {"last_message": text},
      );
    } else {
      await _conversationRepository.createConversation(
        {
          "members": [userId, hostId],
          "created_at": DateTime.now().millisecondsSinceEpoch,
          "last_message": text,
        },
        conversationId,
      );
    }

    await _messageRepository.createMessage({
      "conversation_id": conversationId,
      "sender_id": userId,
      "text": text,
      "created_at": DateTime.now().millisecondsSinceEpoch,
    });
  }
}
