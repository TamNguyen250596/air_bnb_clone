import 'dart:async';

import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/item/base_item_model.dart';

class ViewPostingViewModel extends BaseChangeNotifier {

  // Constructor
  ViewPostingViewModel({
    required AuthRepository authRepository,
    required Posting posting,
  })  : _authRepository = authRepository,
        _posting = posting {
    _setupInitialValues();
  }

  // Private Properties
  final AuthRepository _authRepository;
  final Posting _posting;
  List<String> _displayImages = [];
  String _title = "";
  String _description = "";
  List<BaseItemModel> _postingInfoTiles = [];
  List<String> _amenities = [];
  String _address = "";
  String _hostImage = "";
  String _hostName = "";
  LatLng _propertyLatLong = LatLng(37.42796133580664, -122.085749655962);
  String _displayAddress = "";
  Timer? _displayAddressTimer;
  double _reviewRating = 0.0;
  bool _isHost = false;
  String _price = "";
  String _name = "";
  Map<String, DateTime> _bookingTimeMap = {};

  // Public Properties
  Posting get posting => _posting;
  List<String> get displayImages => _displayImages;
  String get title => _title;
  String get description => _description;
  List<BaseItemModel> get postingInfoTiles => _postingInfoTiles;
  List<String> get amenities => _amenities;
  String get address => _address;
  String get hostImage => _hostImage;
  String get hostName => _hostName;
  LatLng get propertyLatLong => _propertyLatLong;
  String get displayAddress => _displayAddress;
  double get reviewRating => _reviewRating;
  bool get isHost => _isHost;
  String get price => _price;
  String get name => _name;
  Map<String, DateTime> get bookingTimeMap => _bookingTimeMap;

  // Life cycle
  @override
  void dispose() {
    _displayAddressTimer?.cancel();
    super.dispose();
  }

  // Public Functions
  void setReviewRating(double value) {
    _reviewRating = value;
    notifyListeners();
  }

  void selectedMarker() {
    if (!_posting.isValid) {
      return;
    }
    _displayAddressTimer?.cancel();
    _displayAddress = _posting.address ?? "";
    notifyListeners();
    _displayAddressTimer = Timer(const Duration(seconds: 5), () {
      _displayAddress = "";
      notifyListeners();
    });
  }

  void updateBookingTimeMap(Map<String, DateTime> map) {
    _bookingTimeMap = map;
  }

  // Private Functions
  bool _isPostingValid() =>
      _posting.images.isNotEmpty &&
      _posting.name != null &&
      _posting.name!.isNotEmpty &&
      _posting.description != null;

  int _getNumGuests() {
    final small = _posting.beds['small'] ?? 0;
    final medium = _posting.beds['medium'] ?? 0;
    final large = _posting.beds['large'] ?? 0;
    return small + (medium * 2) + (large * 2);
  }

  String _getBedroomText() {
    final parts = <String>[];
    final small = _posting.beds['small'] ?? 0;
    final medium = _posting.beds['medium'] ?? 0;
    final large = _posting.beds['large'] ?? 0;
    if (small != 0) parts.add('$small single/twin ');
    if (medium != 0) parts.add('$medium double ');
    if (large != 0) parts.add('$large queen/king ');
    return parts.join('').trim();
  }

  String _getBathroomText() {
    final parts = <String>[];
    final full = _posting.bathrooms['full'] ?? 0;
    final half = _posting.bathrooms['half'] ?? 0;
    if (full != 0) parts.add('$full full ');
    if (half != 0) parts.add('$half half ');
    return parts.join('').trim();
  }

  String _getFullAddress() {
    final parts = [_posting.address, _posting.city, _posting.country]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    return parts.join(', ');
  }

  void _setupInitialValues() {
    if (!_isPostingValid()) {
      return;
    }

    _authRepository.userId.then((userId) {
      _isHost = userId == _posting.hostId;
      notifyListeners();
    });

    _price = _posting.price != null ? "\$${_posting.price!.toStringAsFixed(0)}" : "";
    _name = _posting.name ?? "";
    _displayImages = _posting.images;
    _title = _posting.name ?? "";
    _description = _posting.description ?? "";
    _amenities = _posting.amenities.toList();
    _address = _getFullAddress();
    _propertyLatLong = LatLng(_posting.lat, _posting.lon);
    _hostImage = _posting.host?.imageUrl ?? "";
    _hostName = _posting.host?.fullName ??
        '${_posting.host?.firstName ?? ""} ${_posting.host?.lastName ?? ""}'
            .trim();

    final bedroomText = _getBedroomText();
    final bathroomText = _getBathroomText();

    _postingInfoTiles = [
      BaseItemModel(
        "guests",
        imageData: Icons.home,
        title: _posting.type ?? "Property",
        des: '${_getNumGuests()} guests',
      ),
      BaseItemModel(
        "beds",
        imageData: Icons.hotel,
        title: "Beds",
        des: bedroomText.isNotEmpty ? bedroomText : "—",
      ),
      BaseItemModel(
        "bathrooms",
        imageData: Icons.wc,
        title: "Bathrooms",
        des: bathroomText.isNotEmpty ? bathroomText : "—",
      ),
    ];
  }
}
