import 'package:flutter_notes_app/modules/auth/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

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

  _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(' CREATE TABLE IF NOT EXISTS ${UserModel.TABLE_NAME} ( '
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${UserModel.NAME} TEXT NULL, '
        '${UserModel.EMAIL} TEXT NULL, '
        '${UserModel.PASSWORD} TEXT NULL, '
        '${UserModel.PHONE} TEXT NULL '
        ' ); '
        ' CREATE TABLE IF NOT EXISTS notes ( '
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ')'
    );
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database? db = await database;
    print(db);
    return await db!.insert(table, row);
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
      String table, String columnName, String value) async {
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

  Future<int> update(String table, Map<String, dynamic> row) async {
    Database? db = await database;
    int id = row['id'];
    return await db!.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    Database? db = await database;
    return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
