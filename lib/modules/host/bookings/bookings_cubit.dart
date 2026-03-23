import 'dart:async';
import 'package:air_bnb_clone/data/repositories/posting_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:realm/realm.dart';
import '../../../commons/extensions/stream_extension.dart';
import '../../../data/models/item/base_item_model.dart';
import '../../../data/models/realm_models/booking/booking.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';

class BookingsState {

  BookingsState({
    this.isLoading = false,
    this.errorMessage,
    this.postings = const [],
    this.selectedPosting,
    DateTime? firstDate,
    DateTime? lastDate,
    this.selectableDates = const <DateTime>{},
  }) : firstDate = firstDate ?? DateTime.now(),
        lastDate = lastDate ?? DateTime.now().add(const Duration(days: 210));

  final bool isLoading;
  final String? errorMessage;
  final List<BaseItemModel> postings;
  final BaseItemModel? selectedPosting;
  final DateTime firstDate;
  final DateTime lastDate;
  final Set<DateTime> selectableDates;

  bool isDaySelectable(DateTime day) {
    return selectableDates.contains(day);
  }

  BookingsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BaseItemModel>? postings,
    BaseItemModel? selectedPosting,
    DateTime? firstDate,
    DateTime? lastDate,
    Set<DateTime>? selectableDates,
  }) {
    return BookingsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      postings: postings ?? this.postings,
      selectedPosting: selectedPosting ?? this.selectedPosting,
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      selectableDates: selectableDates ?? this.selectableDates,
    );
  }
}

class BookingsCubit extends Cubit<BookingsState> {

  // Constructor
  BookingsCubit({
    required PostingRepository postingRepository,
    required BookingRepository bookingRepository,
    required AuthRepository authRepository,
  }) : _postingRepository = postingRepository,
        _bookingRepository = bookingRepository,
        _authRepository = authRepository,
        super(BookingsState()) {
    _observeData();
  }

  // Properties
  final PostingRepository _postingRepository;
  final BookingRepository _bookingRepository;
  final AuthRepository _authRepository;
  StreamSubscription? _postingsSubscription;

  // Life cycle
  @override
  Future<void> close() {
    _postingsSubscription?.cancel();
    return super.close();
  }

  // Public Method
  void selectPosting(BaseItemModel posting) async {
    final entity = posting.object as Posting;
    if (!entity.isValid) return;
    final bookings = await _bookingRepository.getBookingsForPosting(entity.id);
    final selectableDates = _getSelectableDates(bookings);
    final DateTime? firstDate;
    if (selectableDates.isNotEmpty) {
      firstDate = selectableDates.first;
    } else {
      firstDate = DateTime.now();
    }

    emit(state.copyWith(
      selectedPosting: posting,
      firstDate: firstDate,
      selectableDates: selectableDates,
    ));
  }

  bool isPostingSelected(BaseItemModel posting) {
    return state.selectedPosting == posting;
  }

  // Private Method
  Future<void> _observeData() async {
    final hostId = await _authRepository.userId;
    if (hostId == null) return;

    _postingsSubscription = _postingRepository
        .observePostings(hostId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((postings) {

      final list = _createPostings(postings.results);
      emit(BookingsState(postings: list));
    });
  }

  List<BaseItemModel> _createPostings(RealmResults<Posting> entities) {
    final list = entities
        .where((entity) => entity.isValid)
        .map((entity) => BaseItemModel(
      entity.id,
      imageUrl: entity.images.first,
      title: entity.name ?? "NA",
      tag: "posting",
      object: entity,
    )).toList();
    return list;
  }

  Set<DateTime> _getSelectableDates(RealmResults<Booking> bookings) {
    if (bookings.isEmpty) return <DateTime>{};

    Set<DateTime> bookedDates = <DateTime>{};

    for (var booking in bookings) {
      if (!booking.isValid) continue;
      final checkIn = booking.checkIn;
      if (checkIn == null) continue;
      final checkOut = booking.checkOut;
      if (checkOut == null) continue;

      final dates = _getDaysInBetween(checkIn, checkOut);
      bookedDates.addAll(dates);
    }

    return bookedDates;
  }

  List<DateTime> _getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
        DateTime(
          startDate.year,
          startDate.month,
          startDate.day + i,
        ),
      );
    }
    return days;
  }
}
