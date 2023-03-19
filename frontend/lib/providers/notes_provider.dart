import 'package:flutter/cupertino.dart';
import 'package:frontend/models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];

  void addNote(Note note) {
    notes.add(note);
    notifyListeners();
  }

  void updateNote(Note note) {
    int noteIndex =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[noteIndex] = note;
    notifyListeners();
  }

  void deleteNote(String id) {
    // int noteIndex =
    //     notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    // notes.removeAt(noteIndex);
    // notifyListeners();
  }
}
