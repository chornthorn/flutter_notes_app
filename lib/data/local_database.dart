import 'package:flutter_notes_app/modules/auth/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

import '../modules/notes/models/note_model.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();

  factory LocalDatabase() => _instance;

  LocalDatabase._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  static const int _version = 4;

  _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(' CREATE TABLE IF NOT EXISTS ${UserModel.TABLE_NAME} ( '
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${UserModel.NAME} TEXT NULL, '
        '${UserModel.EMAIL} TEXT NULL, '
        '${UserModel.PASSWORD} TEXT NULL, '
        '${UserModel.PHONE} TEXT NULL '
        ' ); '
    );

    await db.execute(' CREATE TABLE IF NOT EXISTS ${NoteModel.TABLE_NAME} ( '
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${NoteModel.TITLE} TEXT NULL, '
        '${NoteModel.DESCRIPTION} TEXT NULL, '
        '${NoteModel.PRIORITY} TEXT NULL, '
        '${NoteModel.STATUS} TEXT NULL, '
        '${NoteModel.CREATED_AT} TEXT NULL, '
        '${NoteModel.UPDATED_AT} TEXT NULL '
        ' ); '
    );
  }

  // on upgrade database
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
     // user table doesn't delete on upgrade
      print('on upgrade database');
      await _onCreate(db, newVersion);
    }
  }

  Future<int> insert({required String table,required Map<String, dynamic> data}) async {
    Database? db = await database;
    print(db);
    return await db!.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    Database? db = await database;
    return await db!.query(table);
  }

  // query one record
  Future<Map<String, dynamic>> queryOne(String table, int id) async {
    Database? db = await database;
    final result = await db!.query(table, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  // query find one by column name
  Future<Map<String, dynamic>> queryOneBy(
      String table, String columnName, dynamic value) async {
    Database? db = await database;
    final result = await db!.query(
      table,
      where: '$columnName = ?',
      whereArgs: [value],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future<int> update(
      {required String table,
      required int id,
      required Map<String, dynamic> data}) async {
    Database? db = await database;
    int id = data['id'];
    return await db!.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  // update one by column name
  Future<int> updateOneBy(String table, String columnName, dynamic value,
      Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!
        .update(table, row, where: '$columnName = ?', whereArgs: [value]);
  }

  Future<int> delete({required String table,required int id}) async {
    Database? db = await database;
    return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // query all records with pagination (page,perPage)
  Future<List<Map<String, dynamic>>> queryAllWithPagination(
      String table, int page,
      {int perPage = 20}) async {
    Database? db = await database;
    int offset = (page - 1) * perPage;
    return await db!.query(table, limit: perPage, offset: offset);
  }
}
