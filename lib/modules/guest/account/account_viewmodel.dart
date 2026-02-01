import 'dart:async';
import 'package:air_bnb_clone/commons/base/base_change_notifier.dart';
import 'package:air_bnb_clone/commons/extensions/stream_extension.dart';
import 'package:air_bnb_clone/data/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/models/realm_models/user/user.dart';
import '../../../routing/route_id.dart';
import '../../../data/repositories/auth_repository.dart';

// ========== Account ViewModel ==========
class AccountViewModel extends BaseChangeNotifier {

  // ========== Life cycle ==========
  AccountViewModel({
    required UserRepository userRepository,
    required AuthRepository authRepository,
    bool isInHostModel = false
  }) : _userRepository = userRepository,
        _authRepository = authRepository,
        _isInHostMode = isInHostModel {
    _observeData();
  }

  // ========== Private Properties ==========
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  User? _user;
  String _avatarUrl = "";
  String _fullName = "";
  String _email = "";
  bool _isLoading = false;
  String _errorMessage = "";
  String? _routeId;
  String _businessButtonTitle = "";
  final bool _isInHostMode;

  // ========== Public Getters ==========
  String get avatarUrl => _avatarUrl;
  String get fullName => _fullName;
  String get email => _email;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get routeId => _routeId;
  String get businessButtonTitle => _businessButtonTitle;

  // ========== Public Methods ==========
  Future<void> changeHost() async {
    _errorMessage = "";
    _setLoading(true);
    
    try {
      if (_user == null) {
        _errorMessage = "User information not available. Please try again.";
        return;
      }

      // Get a fresh, mutable user from Realm instead of using the frozen one
      final user = _user!;
      if (!user.isValid) {
        _errorMessage = "User data is invalid. Please try again.";
        return;
      }
      
      if (user.isHost == true && !_isInHostMode) {
         _routeId = RouteConstant.bookingsPath;
         return;
      }
      
      final userId = _user!.id;
      bool isHost = (user.isHost == null || user.isHost == false) ? true : false;
      
      try {
        await _userRepository.updateUser(userId, {"is_host": isHost});
        _routeId = isHost ? RouteConstant.bookingsPath : RouteConstant.explorePath;
        _errorMessage = ""; // Clear error on success
      } catch (e) {
        _errorMessage = "Failed to update host status. Please try again.";
      }

    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _errorMessage = "";
    _setLoading(true);
    
    try {
      await _authRepository.signOut();
      _errorMessage = ""; // Clear error on success
    } catch (e) {
      _errorMessage = "Failed to sign out. Please try again.";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // ========== Private Methods ==========
  Future<void> _observeData() async {
    String? userId = await _authRepository.userId;

    if (userId == null) {
      return;
    }

    _userRepository
        .observeUser(userId)
        .firstThenDebounce(const Duration(milliseconds: 500))
        .listen((user) {
      if (user.isValid) {
        _avatarUrl = user.imageUrl ?? "";
        _fullName = user.fullName ?? "";
        _email = user.email ?? "";
        _user = user.freeze();
        if (_user != null) {
          _businessButtonTitle = _getBusinessButtonTitle(_user!);
        }
        notifyListeners();
      }
    }).addTo(subscriptions);
  }

  String _getBusinessButtonTitle(User user) {
    if (user.isHost == null) {
      return "Become a Host";
    } else if (user.isHost == true && _isInHostMode) {
      return "Show my Guest Dashboard";
    } else {
      return "Show my Host Dashboard";
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
