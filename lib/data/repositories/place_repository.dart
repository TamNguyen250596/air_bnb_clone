import 'dart:convert';
import 'package:air_bnb_clone/commons/constants/api_credential.dart';
import 'package:air_bnb_clone/data/models/place/place.dart';
import 'package:http/http.dart' as http;
import '../../commons/constants/app_constants.dart';

class PlaceRepository {

  Future<List<Place>> getPlaces(String searchTxt) async {
    final uri = Uri.https(
        AppConstants.geoAPIfyDomain,
        AppConstants.geoAPIfyPath,
        {'text': searchTxt, 'apiKey': ApiCredential.geoAPIfyApiKey}
    );
    http.Response response = await http.get(uri);

    try {
      if (response.statusCode == 200) {
        final data = response.body;
        final json = jsonDecode(data);
        final features = json['features'] as List;
        final places = features.map((feature) => Place.fromJson(feature)).toList();
        return places;

      } else {
        throw Exception("Something went wrong");
      }
    } catch (_) {
      rethrow;
    }
  }
}