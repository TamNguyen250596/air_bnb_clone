import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {

  static const _tokenKey = 'TOKEN';

  Future<String?> fetchToken() async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      return await sharedPreferences.getString(_tokenKey);
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> saveToken(String? token) async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      if (token == null) {
        sharedPreferences.remove(_tokenKey);
      } else {
        sharedPreferences.setString(_tokenKey, token);
      }
    } on Exception catch (_) {
      return;
    }
  }

  Future<void> removeToken() async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      sharedPreferences.remove(_tokenKey);
      } on Exception catch (_) {
      return;
    }
  }
}