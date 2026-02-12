import 'dart:io';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/place/place.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../data/models/realm_models/posting/posting_extensions.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/posting_repository.dart';

class UpdatePostingViewModel extends ChangeNotifier {

  // Init
  UpdatePostingViewModel({
    required PostingRepository postingRepository,
    required MediaRepository mediaRepository,
    required AuthRepository authRepository,
    required Posting? posting,
  })  : _postingRepository = postingRepository,
        _mediaRepository = mediaRepository,
        _authRepository = authRepository,
        _posting = posting {
    _setUpInitialValues();
  }

  // ========== Private Properties ==========
  final PostingRepository _postingRepository;
  final MediaRepository _mediaRepository;
  final AuthRepository _authRepository;
  final Posting? _posting;
  bool _isLoading = false;
  String _name = "";
  String _price = "";
  String _description = "";
  String _address = "";
  String _city = "";
  String _country = "";
  double lat = 0.0;
  double lon = 0.0;
  String _amenities = "";
  final List<String> _propertyTypes = [
    'Detached House',
    'Villa',
    'Apartment',
    'Condo',
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
  String get name => _name;
  String get price => _price;
  String get description => _description;
  String get address => _address;
  String get city => _city;
  String get country => _country;
  String get amenities => _amenities;
  Map<String, int>? get beds => _beds;
  Map<String, int>? get bathrooms => _bathrooms;
  List<BaseItemModel> get imageItems => _imageItems;
  String? get propertyTypeChosen => _propertyTypeChosen;
  List<String> get propertyTypes => _propertyTypes;
  bool get isLoading => _isLoading;
  Posting? get posting => _posting;

  // ========== Private Methods ==========
  void _setUpInitialValues() {
    if (_posting != null) {
      _name = _posting.name ?? "";
      _price = _posting.price.toString();
      _description = _posting.description ?? "";
      _address = _posting.address ?? "";
      _city = _posting.city ?? "";
      _country = _posting.country ?? "";
      _propertyTypeChosen = _posting.type;
      _beds = Map<String, int>.from(_posting.beds);
      _bathrooms = Map<String, int>.from(_posting.bathrooms);
      _amenities = _posting.amenities.join(", ");
      _imageItems = _posting.images.map((imageUrl) {
        return BaseItemModel(Uuid().v4(), tag: "remote_image", imageUrl: imageUrl);
      }).toList();
    }

    final plusItem = BaseItemModel("plus_item", tag: "plus_item");
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
    _address = place.address ?? "";
    _city = place.city ?? "";
    _country = place.country ?? "";
    lat = place.lat ?? 0.0;
    lon = place.lon ?? 0.0;
    notifyListeners();
  }

  void updateName(String value) {
    _name = value;
  }

  void updatePrice(String value) {
    _price = value;
  }

  void updateDescription(String value) {
    _description = value;
  }

  void updateCity(String value) {
    _city = value;
  }

  void updateCountry(String value) {
    _country = value;
  }

  void updateAmenities(String value) {
    _amenities = value;
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
      final imageItem = BaseItemModel(Uuid().v4(), tag: "local_image", imageUrl: image.path, object: image);
      if (item.tag == "plus_item") {
        _imageItems.insert(_imageItems.length - 1, imageItem);
      } else {
        final index = _imageItems.indexOf(item);
        if (index != -1) {
          _imageItems[index] = imageItem;
        } else {
          _imageItems.add(imageItem);
        }
      }
    } finally {
      notifyListeners();
    }
  }

  Future<bool> createPosting(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() == false) {
      return false;
    }

    _isLoading = true;
    notifyListeners();
    try {
      List<String> imageUrls = [];
      for (var item in _imageItems) {
        switch (item.tag) {
          case "plus_item":
            continue;
          case "remote_image":
            imageUrls.add(item.imageUrl);
            break;
          case "local_image":
            final image = item.object as File;
            final publicId = "posting_image_${Uuid().v4()}";
            final imageUrl = await _mediaRepository.uploadImage(image, publicId);
            if (imageUrl != null) {
              imageUrls.add(imageUrl);
            }
            break;
        }
      }

      final Posting posting = Posting(
        "",
        name: _name,
        type: _propertyTypeChosen,
        price: double.tryParse(_price),
        description: _description,
        address: _address,
        city: _city,
        country: _country,
        rating: 2.5,
        hostId: await _authRepository.userId ?? "",
        images: imageUrls,
        amenities: _amenities.toLowerCase().split(","),
        beds: _beds ?? {},
        bathrooms: _bathrooms ?? {},
        lat: lat,
        lon: lon,
      );
      if (_posting != null) {
        if (_posting.isValid) {
          await _postingRepository.updatePosting(_posting.id, posting.toFirestore());
          return true;
        } else {
          return false;
        }
      } else {
        await _postingRepository.createPosting(posting.toFirestore());
        return true;
      }
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}