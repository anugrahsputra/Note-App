import 'package:flutter/material.dart';
import 'package:notestaking_app/model/note.dart';

import '../database/notes_database.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future fetchNotes() async {
    _notes = await NotesDatabase.instance.readAllNotes();
    notifyListeners();
  }

  Future createNote(Note note) async {
    _notes.insert(0, note);
    notifyListeners();
    await NotesDatabase.instance.create(note);
  }

  Future updateNote(Note note) async {
    final index = _notes.indexWhere((e) => e.id == note.id);

    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
      await NotesDatabase.instance.update(note);
    }
  }

  Future deleteNote(int id) async {
    _notes.removeWhere((e) => e.id == id);
    notifyListeners();
    await NotesDatabase.instance.delete(id);
  }
}
