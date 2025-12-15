import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/media_service.dart';

abstract class MediaRepository {
  Future<XFile?> pickImageFromGallery();
  Future<XFile?> takePhoto();
  Future<String?> uploadImage(File file, String publicId);
}

class MediaRepositoryLocal implements MediaRepository {

  // Init
  MediaRepositoryLocal({required MediaService mediaService})
    : _mediaService = mediaService;

  // Properties
  final MediaService _mediaService;

  // Functions
  @override
  Future<XFile?> pickImageFromGallery() {
    return _mediaService.pickImageFromGallery();
  }

  @override
  Future<XFile?> takePhoto() {
    return _mediaService.takePhoto();
  }

  @override
  Future<String?> uploadImage(File file, String publicId) {
    return _mediaService.uploadImage(file, publicId);
  }
}
