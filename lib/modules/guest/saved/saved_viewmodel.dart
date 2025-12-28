import 'package:flutter/cupertino.dart';

// ========== Saved ViewModel ==========
class SavedViewModel extends ChangeNotifier {
  // ========== Constructor ==========
  SavedViewModel();

  // ========== Private Properties ==========
  bool _isLoading = false;
  String _errorMessage = "";

  // ========== Public Getters ==========
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // ========== Public Methods ==========
  void _reset() {
    _errorMessage = "";
    _isLoading = false;
  }

  // ========== Private Methods ==========
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}

