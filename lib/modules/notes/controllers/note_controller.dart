import 'package:flutter/material.dart';
import 'package:flutter_notes_app/data/local_database.dart';
import 'package:flutter_notes_app/modules/notes/models/note_enum.dart';

import '../models/note_model.dart';
import '../services/note_service.dart';

enum CreateNoteStatus { initial,  loading, success  }

class NoteController with ChangeNotifier {
  final _noteService = NoteService(LocalDatabase());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessages = '';

  String get errorMessages => _errorMessages;

  final _notes = <NoteModel>[];

  List<NoteModel> get notes => _notes;

  // read
  Future<void> getAll() async {

    _isLoading = true;
    notifyListeners();

    try {

      _notes.clear(); // clear previous data

      final notes = await _noteService.getAll();
      _notes.addAll(notes);
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _errorMessages = e.toString();
      notifyListeners();

      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  CreateNoteStatus _createNoteStatus = CreateNoteStatus.initial;
  CreateNoteStatus get createNoteStatus => _createNoteStatus;

  // create
  Future<void> create(NoteModel noteModel) async {
    _isLoading = true;
    notifyListeners();

    try {

      // format date
      final currentDate = DateTime.now();
      noteModel.createdAt = currentDate.toString();
      noteModel.updatedAt = currentDate.toString();

      final note = await _noteService.create(noteModel);
      _notes.add(note);
      _isLoading = false;
      _createNoteStatus = CreateNoteStatus.success;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _errorMessages = e.toString();
      notifyListeners();

      print(e.toString());
    } finally {
      _createNoteStatus = CreateNoteStatus.initial;
      notifyListeners();
    }
  }

  // update
  Future<void> update(NoteModel noteModel) async {
    _isLoading = true;
    notifyListeners();

    try {
      final note = await _noteService.update(noteModel);
      final index = _notes.indexWhere((element) => element.id == note.id);
      _notes[index] = note;
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _errorMessages = e.toString();
      notifyListeners();

      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // delete
  Future<void> delete(int noteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _noteService.delete(noteId);
      _notes.removeWhere((element) => element.id == noteId);
      notifyListeners();

    } catch (e) {
      _isLoading = false;
      _errorMessages = e.toString();
      notifyListeners();

      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  NoteStatus _noteStatus = NoteStatus.draft;
  NoteStatus get noteStatus => _noteStatus;
  set noteStatus(NoteStatus noteStatus) {
    _noteStatus = noteStatus;
    notifyListeners();
  }

}
