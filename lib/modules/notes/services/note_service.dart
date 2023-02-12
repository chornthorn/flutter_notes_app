import 'package:flutter_notes_app/data/local_database.dart';
import 'package:flutter_notes_app/modules/notes/models/note_model.dart';


class NoteService {
  final LocalDatabase _localDatabase;

  NoteService(this._localDatabase);

  // create
  Future<NoteModel> create(NoteModel noteModel) async {
    try {
      var id = await _localDatabase.insert(
        table: NoteModel.TABLE_NAME,
        data: noteModel.toMap(),
      );

      if (id == 0) {
        throw Exception('Failed to create note');
      }

      noteModel.id = id;
      return noteModel;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to create note');
    }
  }

  // read
  Future<List<NoteModel>> getAll() async {
    try {
      var notes = await _localDatabase.query(NoteModel.TABLE_NAME);

      if (notes.isEmpty) {
        throw Exception('No notes found');
      }

      return notes.map((e) => NoteModel.fromMap(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to get notes');
    }
  }

  // update
  Future<NoteModel> update(NoteModel noteModel) async {
    try {

      if (noteModel.id == null) {
        throw Exception('Note id is null');
      }

      var id = await _localDatabase.update(
        table: NoteModel.TABLE_NAME,
        id: noteModel.id!,
        data: noteModel.toMap(),
      );

      if (id == 0) {
        throw Exception('Failed to update note');
      }

      return noteModel;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to update note');
    }
  }

  // delete
  Future<bool> delete(int id) async {
    try {
      var result = await _localDatabase.delete(
        table: NoteModel.TABLE_NAME,
        id: id,
      );

      if (result == 0) {
        throw Exception('Failed to delete note');
      }

      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to delete note');
    }
  }
}
