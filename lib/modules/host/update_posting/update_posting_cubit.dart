import 'dart:io';
import 'package:air_bnb_clone/data/models/item/base_item_model.dart';
import 'package:flutter/material.dart';
import 'package:air_bnb_clone/data/repositories/auth_repository.dart';
import 'package:air_bnb_clone/data/repositories/media_repository.dart';
import 'package:air_bnb_clone/data/repositories/posting_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/place/place.dart';
import '../../../data/models/realm_models/posting/posting.dart';
import '../../../data/models/realm_models/posting/posting_extensions.dart';

class UpdatePostingState {
  const UpdatePostingState({
    this.name = "",
    this.price = "",
    this.description = "",
    this.address = "",
    this.city = "",
    this.country = "",
    this.lat = 0.0,
    this.lon = 0.0,
    this.amenities = "",
    this.propertyTypeChosen,
    this.beds,
    this.bathrooms,
    this.imageItems = const [],
    this.propertyTypes = const [
      'Detached House', 'Villa', 'Apartment', 'Condo', 'Flat',
      'Town House', 'Studio', 'Room',
    ],
    this.isLoading = false,
    this.posting,
  });

  final String name;
  final String price;
  final String description;
  final String address;
  final String city;
  final String country;
  final double lat;
  final double lon;
  final String amenities;
  final String? propertyTypeChosen;
  final Map<String, int>? beds;
  final Map<String, int>? bathrooms;
  final List<BaseItemModel> imageItems;
  final List<String> propertyTypes;
  final bool isLoading;
  final Posting? posting;

  UpdatePostingState copyWith({
    String? name,
    String? price,
    String? description,
    String? address,
    String? city,
    String? country,
    double? lat,
    double? lon,
    String? amenities,
    String? propertyTypeChosen,
    Map<String, int>? beds,
    Map<String, int>? bathrooms,
    List<BaseItemModel>? imageItems,
    bool? isLoading,
  }) {
    return UpdatePostingState(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      amenities: amenities ?? this.amenities,
      propertyTypeChosen: propertyTypeChosen ?? this.propertyTypeChosen,
      beds: beds ?? this.beds,
      bathrooms: bathrooms ?? this.bathrooms,
      imageItems: imageItems ?? this.imageItems,
      propertyTypes: propertyTypes,
      isLoading: isLoading ?? this.isLoading,
      posting: posting,
    );
  }
}

class UpdatePostingCubit extends Cubit<UpdatePostingState> {
  UpdatePostingCubit({
    required PostingRepository postingRepository,
    required MediaRepository mediaRepository,
    required AuthRepository authRepository,
    required Posting? posting,
  })  : _postingRepository = postingRepository,
        _mediaRepository = mediaRepository,
        _authRepository = authRepository,
        super(UpdatePostingState(posting: posting)) {
    _setUpInitialValues();
  }

  final PostingRepository _postingRepository;
  final MediaRepository _mediaRepository;
  final AuthRepository _authRepository;

  void _setUpInitialValues() {
    final p = state.posting;
    List<BaseItemModel> imageItems = [];
    if (p != null) {
      imageItems = p.images
          .map((url) => BaseItemModel(Uuid().v4(), tag: "remote_image", imageUrl: url))
          .toList();
    }
    imageItems.add(BaseItemModel("plus_item", tag: "plus_item"));

    emit(UpdatePostingState(
      name: p?.name ?? "",
      price: p?.price.toString() ?? "",
      description: p?.description ?? "",
      address: p?.address ?? "",
      city: p?.city ?? "",
      country: p?.country ?? "",
      lat: p?.lat ?? 0.0,
      lon: p?.lon ?? 0.0,
      amenities: p?.amenities.join(", ") ?? "",
      propertyTypeChosen: p?.type,
      beds: p != null ? Map<String, int>.from(p.beds) : null,
      bathrooms: p != null ? Map<String, int>.from(p.bathrooms) : null,
      imageItems: imageItems,
      propertyTypes: const [
        'Detached House', 'Villa', 'Apartment', 'Condo', 'Flat',
        'Town House', 'Studio', 'Room',
      ],
      posting: state.posting,
    ));
  }

  String? validatePostingNameField(String? text) {
    if (text == null || text.isEmpty) return "Please enter a valid name";
    return null;
  }

  String? validatePriceNameField(String? text) {
    if (text == null || text.isEmpty) return "Please enter a valid price";
    return null;
  }

  String? validateDescriptionField(String? text) {
    if (text == null || text.isEmpty) return "Please enter a valid description";
    return null;
  }

  String? validateAmenitiesField(String? text) {
    if (text == null || text.isEmpty) return "Please enter valid amenities";
    return null;
  }

  void updatePropertyTypeChosen(String? value) {
    emit(state.copyWith(propertyTypeChosen: value));
  }

  void updatePlace(Place? place) {
    if (place == null) return;
    emit(state.copyWith(
      address: place.address ?? "",
      city: place.city ?? "",
      country: place.country ?? "",
      lat: place.lat ?? 0.0,
      lon: place.lon ?? 0.0,
    ));
  }

  void updateName(String value) => emit(state.copyWith(name: value));
  void updatePrice(String value) => emit(state.copyWith(price: value));
  void updateDescription(String value) => emit(state.copyWith(description: value));
  void updateCity(String value) => emit(state.copyWith(city: value));
  void updateCountry(String value) => emit(state.copyWith(country: value));
  void updateAmenities(String value) => emit(state.copyWith(amenities: value));

  int getBedNo(String kind) => state.beds?[kind] ?? 0;
  void updateBedNo(String kind, int value) {
    final beds = Map<String, int>.from(state.beds ?? {});
    beds[kind] = value;
    emit(state.copyWith(beds: beds));
  }

  int getBathroomNo(String kind) => state.bathrooms?[kind] ?? 0;
  void updateBathroomNo(String kind, int value) {
    final bathrooms = Map<String, int>.from(state.bathrooms ?? {});
    bathrooms[kind] = value;
    emit(state.copyWith(bathrooms: bathrooms));
  }

  Future<void> selectImage(BaseItemModel item) async {
    final image = await _mediaRepository.pickImageFromGallery(15);
    if (image == null) return;
    final imageItem = BaseItemModel(
      Uuid().v4(),
      tag: "local_image",
      imageUrl: image.path,
      object: image,
    );
    final items = List<BaseItemModel>.from(state.imageItems);
    if (item.tag == "plus_item") {
      items.insert(items.length - 1, imageItem);
    } else {
      final index = items.indexOf(item);
      if (index != -1) {
        items[index] = imageItem;
      } else {
        items.add(imageItem);
      }
    }
    emit(state.copyWith(imageItems: items));
  }

  Future<bool> createPosting(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() == false) return false;

    emit(state.copyWith(isLoading: true));
    try {
      List<String> imageUrls = [];
      for (var item in state.imageItems) {
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
            if (imageUrl != null) imageUrls.add(imageUrl);
            break;
        }
      }

      final posting = Posting(
        "",
        name: state.name,
        type: state.propertyTypeChosen,
        price: double.tryParse(state.price),
        description: state.description,
        address: state.address,
        city: state.city,
        country: state.country,
        rating: 2.5,
        hostId: await _authRepository.userId ?? "",
        images: imageUrls,
        amenities: state.amenities.toLowerCase().split(","),
        beds: state.beds ?? {},
        bathrooms: state.bathrooms ?? {},
        lat: state.lat,
        lon: state.lon,
      );

      final p = state.posting;
      if (p != null && p.isValid) {
        await _postingRepository.updatePosting(p.id, posting.toFirestore());
      } else {
        await _postingRepository.createPosting(posting.toFirestore());
      }
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      return false;
    }
  }
}
