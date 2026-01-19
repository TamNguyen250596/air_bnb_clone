import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/place/place.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/posting_repository.dart';

class UpdatePostingViewmodel extends ChangeNotifier {

  // Init
  UpdatePostingViewmodel({
    required PostingRepository postingRepository,
    required MediaRepository mediaRepository,
  })  : _postingRepository = postingRepository,
        _mediaRepository = mediaRepository {
    _setUpInitialValues();
  }

  // ========== Private Properties ==========
  final PostingRepository _postingRepository;
  final MediaRepository _mediaRepository;
  Posting? _posting;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _amenitiesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> _propertyTypes = [
    'Detached House',
    'Villa',
    'Apartment',
    'condo',
    'Flat',
    'Town House',
    'Studio',
    'Room',
  ];
  String? _propertyTypeChosen;
  Map<String, int>? _beds;
  Map<String, int>? _bathrooms;
  List<BaseItemModel> _imageItems = [];

  // ========== Public Getters ==========
  TextEditingController get nameController => _nameController;
  TextEditingController get priceController => _priceController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get addressController => _addressController;
  TextEditingController get cityController => _cityController;
  TextEditingController get countryController => _countryController;
  TextEditingController get amenitiesController => _amenitiesController;
  GlobalKey<FormState> get formKey => _formKey;
  List<String> get propertyTypes => _propertyTypes;
  bool get isLoading => _isLoading;
  Posting? get posting => _posting;
  String? get propertyTypeChosen => _propertyTypeChosen;
  Map<String, int>? get beds => _beds;
  Map<String, int>? get bathrooms => _bathrooms;
  List<BaseItemModel> get imageItems => _imageItems;

  // ========== Private Methods ==========
  void _setUpInitialValues() {
    final plusItem = BaseItemModel("plus_item");
    _imageItems.add(plusItem);
  }

  // ========== Public Methods ==========
  String? validatePostingNameField(String? text) {
    if (text!.isEmpty) {
      return "Please enter a valid name";
    }
    return null;
  }

  String? validatePriceNameField(String? text) {
    if (text!.isEmpty) {
      return "Please enter a valid price";
    }
    return null;
  }

  String? validateDescriptionField(String? text) {
    if (text!.isEmpty) {
      return "Please enter a valid description";
    }
    return null;
  }

  void updatePropertyTypeChosen(String? value) {
    _propertyTypeChosen = value;
    notifyListeners();
  }

  void updatePlace(Place? place) {
    if (place == null) {
      return;
    }
    _addressController.text = place.address ?? "";
    _cityController.text = place.city ?? "";
    _countryController.text = place.country ?? "";
    notifyListeners();
  }

  int geBedNo(String kind) {
    if (_beds == null) {
      return 0;
    }
    return _beds![kind] ?? 0;
  }

  void updateBedNo(String kind, int value) {
    if (_beds == null) {
      _beds = {kind: value};
    } else {
      _beds![kind] = value;
    }
  }

  int geBathroomNo(String kind) {
    if (_bathrooms == null) {
      return 0;
    }
    return _bathrooms![kind] ?? 0;
  }

  void updateBathroomNo(String kind, int value) {
    if (_bathrooms == null) {
      _bathrooms = {kind: value};
    } else {
      _bathrooms![kind] = value;
    }
  }

  String? validateAmenitiesField(String? text) {
    if (text!.isEmpty) {
      return "Please enter valid amenities";
    }
    return null;
  }

  void selectImage(BaseItemModel item) async {
    try {
      final image = await _mediaRepository.pickImageFromGallery(15);
      if (image == null) {
        return;
      }
      final imageItem = BaseItemModel(Uuid().v4(), imageUrl: image.path);
      if (item.id == "plus_item") {
        _imageItems.insert(_imageItems.length - 1, imageItem);
      } else {
        _imageItems.add(imageItem);
      }
    } finally {
      notifyListeners();
    }
  }
}