import 'package:flutter/foundation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late User _user;
  final ApiService apiService;
  String? _token;
  String? get token => _token;

  AuthProvider({required this.apiService});

  User get user => _user;

  bool get isAuthenticated => _token != null;

  Future<String> login(String email, String password) async {
    try {
      final response = await ApiService.login(email, password);
      if (response.containsKey('token')) {
        final token = response['token'];
        _storeToken(token); // Store the token in SharedPreferences
        ApiService.setToken(token); // Set the token in the ApiService
        notifyListeners();
        return token;
      } else {
        throw Exception('Token not found in response');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final response = await ApiService.register(email, password, name);
      if (response.containsKey('_id') && response.containsKey('token')) {
        _user = User(
          id: response['_id'],
          email: email,
          name: name,
          password: password,
        );
        _token = response['token'];
        _storeToken(_token!); // Store the token in SharedPreferences
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Initialize the AuthProvider from SharedPreferences and retvieve the token
  Future<void> initAuthProvider() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (token != null) {
      ApiService.setToken(_token!);
      _token = token;
      notifyListeners();
    }
  }
}
