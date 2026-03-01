import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../services/media_service.dart';

/// Abstract contract for media (pick, upload). Use [MediaRepositoryImpl] in app and a fake in unit tests.
abstract class MediaRepository {
  Future<File?> pickImageFromGallery(int? compressQuality);
  Future<File?> takePhoto(int? compressQuality);
  Future<String?> uploadImage(File file, String publicId);
}

class MediaRepositoryImpl implements MediaRepository {
  // Init
  MediaRepositoryImpl({required MediaService mediaService})
    : _mediaService = mediaService;

  // Properties
  final MediaService _mediaService;

  // Functions
  @override
  Future<File?> pickImageFromGallery(int? compressQuality) async {
    final xFile = await _mediaService.pickImageFromGallery();
    if (xFile == null) {
      return null;
    }
    return _processImageFile(xFile, compressQuality);
  }

  @override
  Future<File?> takePhoto(int? compressQuality) async {
    final xFile = await _mediaService.takePhoto();
    if (xFile == null) {
      return null;
    }
    return _processImageFile(xFile, compressQuality);
  }

  Future<File> _processImageFile(XFile xFile, int? compressQuality) async {
    if (compressQuality != null) {
      File originalFile = File(xFile.path);
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        "compressed_${DateTime.now().microsecondsSinceEpoch}.jpg",
      );
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalFile.path,
        quality: compressQuality,
      );
      if (compressedBytes != null) {
        final compressedFile = File(targetPath);
        await compressedFile.writeAsBytes(compressedBytes);
        return compressedFile;
      }
      return originalFile;
    } else {
      return File(xFile.path);
    }
  }

  @override
  Future<String?> uploadImage(File file, String publicId) {
    return _mediaService.uploadImage(file, publicId);
  }
}
