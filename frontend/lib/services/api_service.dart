import 'dart:convert';
import 'dart:developer';
import 'package:frontend/models/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'localhost:5000/api';

  static Future<void> addNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes');
    var response = await http.post(requestUrl, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/${note.id}');
    var response = await http.delete(requestUrl);
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async {
    Uri requestUrl = Uri.parse('$_baseUrl/notes/$userid');
    var response = await http.get(requestUrl);
    var decoded = jsonDecode(response.body);

    List<Note> notes = [];
    for (var noteMap in decoded) {
      Note newNote = Note.fromMap(noteMap);
      notes.add(newNote);
    }

    return notes;
  }
}
