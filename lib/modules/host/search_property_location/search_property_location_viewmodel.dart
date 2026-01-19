import 'dart:async';
import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/models/place/place.dart';
import '../../../data/repositories/place_repository.dart';

class SearchPropertyLocationViewModel extends BaseChangeNotifier {

  // Init
  SearchPropertyLocationViewModel({
    required PlaceRepository placeRepository,
  }) : _placeRepository = placeRepository {
    _observeSearchTxt();
  }

  // Private Properties
  final PlaceRepository _placeRepository;
  final _searchTxtController = BehaviorSubject<String>();
  List<Place> _places = [];

  // Public Properties
  List<Place> get places => _places;

  // Public Functions
  void setSearchTxt(String searchTxt) {
    _searchTxtController.add(searchTxt);
  }

  // Private Functions
  void _observeSearchTxt() {
    _searchTxtController
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen((searchTxt) {
      _searchPlace(searchTxt);
    }).addTo(subscriptions);
  }

  Future<void> _searchPlace(String searchTxt) async {
    try {
      if (searchTxt.isEmpty) {
        _places = [];
      } else {
        _places = await _placeRepository.getPlaces(searchTxt);
      }
    } finally {
      notifyListeners();
    }
  }
}