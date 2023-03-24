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

  Future<void> login(String email, String password) async {
    try {
      final apiService = ApiService();
      final response = await apiService.login(email, password);
      if (response.containsKey('token')) {
        _token = response['token'];
        notifyListeners();
      }
    } catch (error) {
      throw error;
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
