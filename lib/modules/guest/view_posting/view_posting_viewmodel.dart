import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';
import 'package:air_bnb_clone/data/models/realm_models/posting/posting.dart';
import 'package:flutter/material.dart';

import '../../../data/models/item/base_item_model.dart';

class ViewPostingViewModel extends BaseChangeNotifier {

  // Constructor
  ViewPostingViewModel(Posting posting) : _posting = posting {
    _setupInitialValues();
  }

  // Private Properties
  final Posting _posting;
  String _imageUrl = "";
  String _title = "";
  String _description = "";
  List<BaseItemModel> _postingInfoTiles = [];
  List<String> _amenities = [];
  String _address = "";
  String _hostImage = "";
  String _hostName = "";

  // Public Properties
  Posting get posting => _posting;
  String get imageUrl => _imageUrl;
  String get title => _title;
  String get description => _description;
  List<BaseItemModel> get postingInfoTiles => _postingInfoTiles;
  List<String> get amenities => _amenities;
  String get address => _address;
  String get hostImage => _hostImage;
  String get hostName => _hostName;

  // Public Functions

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

    _imageUrl = _posting.images.isNotEmpty ? _posting.images[0] : "";
    _title = _posting.name ?? "";
    _description = _posting.description ?? "";
    _amenities = _posting.amenities.toList();
    _address = _getFullAddress();
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
