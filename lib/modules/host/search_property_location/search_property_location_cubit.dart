import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/models/place/place.dart';
import '../../../data/repositories/place_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchPropertyLocationState {
  const SearchPropertyLocationState({this.places = const []});

  final List<Place> places;
}

class SearchPropertyLocationCubit extends Cubit<SearchPropertyLocationState> {
  SearchPropertyLocationCubit({required PlaceRepository placeRepository})
      : _placeRepository = placeRepository,
        super(const SearchPropertyLocationState()) {
    _observeSearchTxt();
  }

  final PlaceRepository _placeRepository;
  final _searchTxtController = BehaviorSubject<String>();
  StreamSubscription? _searchSubscription;

  @override
  Future<void> close() async {
    await _searchSubscription?.cancel();
    await _searchTxtController.close();
    await super.close();
  }

  void setSearchTxt(String searchTxt) {
    _searchTxtController.add(searchTxt);
  }

  void _observeSearchTxt() {
    _searchSubscription?.cancel();
    _searchSubscription = _searchTxtController
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen(_searchPlace);
  }

  Future<void> _searchPlace(String searchTxt) async {
    if (searchTxt.isEmpty) {
      emit(const SearchPropertyLocationState());
      return;
    }
    final places = await _placeRepository.getPlaces(searchTxt);
    emit(SearchPropertyLocationState(places: places));
  }
}
