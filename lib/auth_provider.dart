import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  bool _isAuthenticated = false;
  String? _userId;
  String? _userType;
  String? _accessToken;
  Map<String, dynamic>? _userData;

  AuthProvider(this._prefs) {
    _loadAuthData();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userType => _userType;
  String? get accessToken => _accessToken;
  Map<String, dynamic>? get userData => _userData;

  bool get isCustomer => _userType == AppConstants.userTypeCustomer;
  bool get isCourier => _userType == AppConstants.userTypeCourier;
  bool get isBusiness => _userType == AppConstants.userTypeBusiness;

  // Load auth data from SharedPreferences
  Future<void> _loadAuthData() async {
    _userId = _prefs.getString(AppConstants.keyUserId);
    _userType = _prefs.getString(AppConstants.keyUserType);
    _accessToken = _prefs.getString(AppConstants.keyAccessToken);
    
    if (_userId != null && _accessToken != null) {
      _isAuthenticated = true;
    }
    
    notifyListeners();
  }

  // Login
  Future<void> login({
    required String userId,
    required String userType,
    required String accessToken,
    String? refreshToken,
    Map<String, dynamic>? userData,
  }) async {
    _userId = userId;
    _userType = userType;
    _accessToken = accessToken;
    _userData = userData;
    _isAuthenticated = true;

    await _prefs.setString(AppConstants.keyUserId, userId);
    await _prefs.setString(AppConstants.keyUserType, userType);
    await _prefs.setString(AppConstants.keyAccessToken, accessToken);
    
    if (refreshToken != null) {
      await _prefs.setString(AppConstants.keyRefreshToken, refreshToken);
    }

    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _userId = null;
    _userType = null;
    _accessToken = null;
    _userData = null;
    _isAuthenticated = false;

    await _prefs.remove(AppConstants.keyUserId);
    await _prefs.remove(AppConstants.keyUserType);
    await _prefs.remove(AppConstants.keyAccessToken);
    await _prefs.remove(AppConstants.keyRefreshToken);
    await _prefs.remove(AppConstants.keySessionCookie);

    notifyListeners();
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    _userData = userData;
    notifyListeners();
  }

  // Update access token
  Future<void> updateAccessToken(String accessToken) async {
    _accessToken = accessToken;
    await _prefs.setString(AppConstants.keyAccessToken, accessToken);
    notifyListeners();
  }

  // Check if first launch
  Future<bool> isFirstLaunch() async {
    final isFirst = _prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;
    if (isFirst) {
      await _prefs.setBool(AppConstants.keyIsFirstLaunch, false);
    }
    return isFirst;
  }

  // Set user type (for registration flow)
  Future<void> setUserType(String userType) async {
    _userType = userType;
    await _prefs.setString(AppConstants.keyUserType, userType);
    notifyListeners();
  }
}
