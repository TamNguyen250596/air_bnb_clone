import 'dart:convert';
import 'package:air_bnb_clone/commons/constants/app_constants.dart';
import 'package:air_bnb_clone/data/models/place/place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Abstract contract for place search. Implement this interface for production
/// and use a [FakePlaceRepository] (or mock) in unit tests.
abstract class PlaceRepository {
  Future<List<Place>> getPlaces(String searchTxt);
}

class PlaceRepositoryImpl implements PlaceRepository {
  @override
  Future<List<Place>> getPlaces(String searchTxt) async {
    final uri = Uri.https(
        AppConstants.geoAPIfyDomain,
        AppConstants.geoAPIfyPath,
        {'text': searchTxt, 'apiKey': dotenv.env[AppConstants.geoAPIfyApiKey]!}
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