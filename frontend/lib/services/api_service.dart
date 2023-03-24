import 'dart:convert';
import 'dart:developer';
import 'package:frontend/models/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'localhost:5000/api';
  static const String _loginUrl = '$_baseUrl/users/login';
  static const String _registerUrl = '$_baseUrl/users/';

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
    var response = await http.get(requestUrl);
    var decoded = jsonDecode(response.body);

    List<Note> notes = [];
    for (var noteMap in decoded) {
      Note newNote = Note.fromJson(noteMap);
      notes.add(newNote);
    }

    return notes;
  }

  static Future<http.Response> login(String email, String password) async {
    Uri requestUrl = Uri.parse(_loginUrl);
    var response = await http.post(requestUrl, body: {
      'email': email,
      'password': password,
    });
    return response;
  }

  static Future<http.Response> register(
      String email, String password, String name) async {
    Uri requestUrl = Uri.parse(_registerUrl);
    var response = await http.post(requestUrl, body: {
      'email': email,
      'password': password,
      'name': name,
    });
    return response;
  }
}
