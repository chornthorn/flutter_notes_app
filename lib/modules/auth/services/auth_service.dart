import 'package:flutter_notes_app/data/local_database.dart';

class AuthService {
  final LocalDatabase _localDatabase;

  AuthService(this._localDatabase);

  Future<bool> login(String username, String password) async {
    var users = await _localDatabase.query('user');
    var user = users.firstWhere(
      (user) => user['username'] == username && user['password'] == password,
      orElse: () => {},
    );
    return user.isNotEmpty;
  }

  Future<bool> register(
      String name, String email, String username, String password) async {
    var users = await _localDatabase.query('user');
    var user = users.firstWhere(
      (user) => user['username'] == username,
      orElse: () => {},
    );
    if (user.isNotEmpty) return false;
    await _localDatabase.insert('user', {
      'name': name,
      'email': email,
      'username': username,
      'password': password,
    });
    return true;
  }
}
