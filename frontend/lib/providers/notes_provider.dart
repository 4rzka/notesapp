import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/services/api_service.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = true;

  NotesProvider() {
    fetchNotes();
  }

  Future<Note> addNote(Note note) async {
    notes.add(note);
    sortNotes();
    notifyListeners();
    final response = await ApiService.addNote(note);
    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add note');
    }
  }

  void updateNote(Note note) {
    int noteIndex =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[noteIndex] = note;
    sortNotes();
    notifyListeners();
    ApiService.updateNote(note);
  }

  void deleteNote(Note note) {
    int noteIndex =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(noteIndex);
    sortNotes();
    notifyListeners();
    ApiService.deleteNote(note.id);
  }

  void fetchNotes() async {
    notes = await ApiService.fetchNotes();
    sortNotes();
    isLoading = false;
    notifyListeners();
  }

  void sortNotes() {
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }
}
