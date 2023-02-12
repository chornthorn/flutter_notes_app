import 'package:flutter_notes_app/data/local_database.dart';
import 'package:flutter_notes_app/modules/auth/models/user_model.dart';

class AuthService {
  final LocalDatabase _localDatabase;

  AuthService(this._localDatabase);

  Future<UserModel> login(String email, String password) async {
    var user = await _localDatabase.queryOneBy(
      UserModel.TABLE_NAME,
      UserModel.EMAIL,
      email,
    );

    if (user.isEmpty) throw Exception('User not found');

    final UserModel userModel = UserModel.fromMap(user);

    if (userModel.password != password) throw Exception('Wrong password');

    return userModel;
  }

  Future<UserModel> register(UserModel userReqModel) async {
    try {
      // check if user already exists
      var user = await _localDatabase.queryOneBy(
        UserModel.TABLE_NAME, // table name
        UserModel.EMAIL, // column name
        userReqModel.email, // value
      );

      print(user);

      if (user.isNotEmpty) throw Exception('User already exists');

      // insert user
      var id = await _localDatabase.insert(
        table: UserModel.TABLE_NAME,
        data: userReqModel.toMap(),
      );

      if (id == 0) {
        throw Exception('Failed to register');
      }

      userReqModel.id = id;
      return userReqModel;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to register');
    }
  }

  // change password
  Future<bool> changePassword(
      int userId, String oldPassword, String newPassword) async {
    try {
      // check if user already exists
      var user = await _localDatabase.queryOneBy(
        UserModel.TABLE_NAME, // table name
        UserModel.ID, // column name
        userId, // value
      );

      print(user);

      if (user.isEmpty) throw Exception('User not found');

      final UserModel userModel = UserModel.fromMap(user);

      if (userModel.password != oldPassword) throw Exception('Wrong password');

      // update password
      var result = await _localDatabase.update(
        table: UserModel.TABLE_NAME,
        data: {
          UserModel.PASSWORD: newPassword, // { column: value }
        },
        id: userId,
      );

      if (result == 0) {
        throw Exception('Failed to change password');
      }

      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to change password');
    }
  }
}
