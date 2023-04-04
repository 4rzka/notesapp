import 'dart:convert';
import 'dart:developer';
import 'package:frontend/models/note.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class ApiService {
  static const String _baseUrl = 'http://192.168.38.183:5000/api';
  static const String _loginUrl = '$_baseUrl/users/login';
  static const String _registerUrl = '$_baseUrl/users/';
  static String? token;
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<void> addNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes');
    var response = await http.post(requestUrl, body: note.toJson());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/${note.id}');
    var response = await http.delete(requestUrl);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<List<Note>> fetchNotes() async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes');
    var response = await http.get(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    var decoded = jsonDecode(response.body);

    List<Note> notes = [];
    for (var noteMap in decoded) {
      Note newNote = Note.fromJson(noteMap);
      notes.add(newNote);
    }

    return notes;
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    }
    if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception('Failed to log in');
    }
  }

  static void setToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  static Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    final response = await http.post(Uri.parse(_registerUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'name': name,
        }));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}
