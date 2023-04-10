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
    var response =
        await http.post(requestUrl, body: jsonEncode(note.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
  }

  static Future<void> deleteNote(noteId) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/$noteId');
    var response = await http.delete(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
  }

  static Future<void> updateNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/${note.id}');
    var response =
        await http.put(requestUrl, body: json.encode(note.toJson()), headers: {
      'Authorization': 'Bearer ${ApiService.token}',
      'Content-Type': 'application/json',
    });
  }

  static Future<List<Note>> fetchNotes() async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes');
    var response = await http.get(requestUrl, headers: {
      'Authorization': 'Bearer ${ApiService.token}',
    });
    var decoded = jsonDecode(response.body);
    List<Note> notes = [];

    if (decoded is List) {
      for (var noteMap in decoded) {
        Note newNote = Note.fromJson(noteMap.cast<String, dynamic>());
        notes.add(newNote);
      }
    } else if (decoded is Map) {
      Note newNote = Note.fromJson(decoded.cast<String, dynamic>());
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
      token = responseData['token'];
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
