import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';

class BookPostingViewModel extends BaseChangeNotifier {

  // Constructor
  BookPostingViewModel({
    required Map<String, dynamic> parameters,
  }) {
    _setupInitialValues(parameters);
  }

  // Private Properties
  String _name = "";
  String _currentTag = "check_in";
  Map<String, DateTime> _dates = {};
  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 210));

  // Public Getters
  String get name => _name;
  String get currentTag => _currentTag;
  Map<String, DateTime> get dates => _dates;
  DateTime get firstDate => _firstDate;
  DateTime get lastDate => _lastDate;

  /// True when both check-in and check-out are set and check-out is after check-in.
  bool get canBook {
    final checkIn = _dates["check_in"];
    final checkOut = _dates["check_out"];
    if (checkIn == null || checkOut == null) return false;
    final inDate = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final outDate = DateTime(checkOut.year, checkOut.month, checkOut.day);
    return outDate.isAfter(inDate);
  }

  // Public Methods
  void setCurrentTag(String tag) {
    _currentTag = tag;
    notifyListeners();
  }

  DateTime getInitialDate() {
    return _dates[_currentTag] ?? DateTime.now();
  }

  String getInitialDateStr(String tag) {
    DateTime? date = _dates[tag];

    if (date == null && tag == "check_in") {
      date = DateTime.now();
    }
    if (date != null) {
      return "${date.day}/${date.month}/${date.year}";
    } else {
      return "";
    }
  }

  void updateSelectedDate(DateTime date) {
    _dates[_currentTag] = date;
    notifyListeners();
  }

  // Private Methods
  void _setupInitialValues(Map<String, dynamic> parameters) {
    _name = parameters["name"] as String? ?? "";
    final Map<String, DateTime>? dates = parameters["dates"] as Map<String, DateTime>?;
    if (dates != null && dates.isNotEmpty) {
      _dates = dates;
    } else {
      _dates = {"check_in": DateTime.now()};
    }
  }
}