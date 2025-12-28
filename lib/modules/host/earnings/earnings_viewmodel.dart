import 'package:flutter/cupertino.dart';

// ========== Earnings ViewModel ==========
class EarningsViewModel extends ChangeNotifier {
  // ========== Constructor ==========
  EarningsViewModel();

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

