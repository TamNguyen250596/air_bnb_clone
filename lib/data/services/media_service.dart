import 'dart:convert';
import 'dart:io';
import 'package:air_bnb_clone/commons/constants/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MediaService {

  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      return null;
    }
  }

  Future<XFile?> takePhoto() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
      return photo;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadImage(File file, String publicId) async {
    final cloudName = dotenv.env[AppConstants.cloudinaryAppName]!;
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');

    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = AppConstants.cloudinaryUploadPreset;
    request.fields['public_id'] = publicId;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseBody);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['url'];
    } else {
      return null;
    }
  }
}
