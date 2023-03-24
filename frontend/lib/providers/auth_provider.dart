import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:frontend/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

  bool get isLoggedIn {
    return _token != null && _expiryDate != null && _userId != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final response = await ApiService.register(email, password, name);
      if (response.statusCode == 201) {
        final responseData = response.body;
        // TODO: process the response data and store the user credentials
        notifyListeners();
      } else {
        // TODO: handle error response
      }
    } catch (error) {
      // TODO: handle error
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.login(email, password);
      if (response.statusCode == 200) {
        final responseData = response.body;
        // TODO: process the response data and store the user credentials
        notifyListeners();
      } else {
        // TODO: handle error response
      }
    } catch (error) {
      // TODO: handle error
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> autoLogin() async {
    // TODO: check if there are saved user credentials and auto-login
    notifyListeners();
  }
}
