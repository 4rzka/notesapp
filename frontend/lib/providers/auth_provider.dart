import 'package:flutter/foundation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_service.dart';

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
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
