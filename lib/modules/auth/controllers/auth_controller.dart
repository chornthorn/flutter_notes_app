import 'package:flutter/material.dart';
import 'package:flutter_notes_app/data/local_database.dart';
import 'package:flutter_notes_app/modules/auth/models/user_model.dart';
import 'package:flutter_notes_app/modules/auth/services/auth_service.dart';
import 'package:flutter_notes_app/shared/constants.dart';
import 'package:flutter_notes_app/shared/share_prefs.dart';

class AuthController extends ChangeNotifier {
  final _authService = AuthService(LocalDatabase());

  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;

  bool get isLoading => _isLoading;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  UserModel? _user;

  UserModel? get user => _user;

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  // check if user is authenticated
  Future<void> checkAuth() async {
    final isAuthenticated = await SharedPrefs.getBool(kIsAuthenticatedKey);
    if (isAuthenticated != null) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
      checkUserInfo();
    } else {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  // sign up
  Future<void> signUp({
    String? name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userReqModel = UserModel(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      final user = await _authService.register(userReqModel);
      // save user to shared prefs
      final userInfo = user.toMap();
      final userStringJson = SharedPrefs.encodeMapToString(userInfo);
      final saveSuccess = await SharedPrefs.setString(kUserInfoKey, userStringJson);

      if (!saveSuccess) {
        _errorMessage = 'Failed to save user info';
      }

      _isAuthenticated = true;
      await SharedPrefs.setBool(kIsAuthenticatedKey, true);
      notifyListeners();

      checkUserInfo();
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // sign in
  Future<void> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authService.login(email, password);
      final userInfo = user.toMap();
      // save user to shared prefs
      final userStringJson = SharedPrefs.encodeMapToString(userInfo);
      final saveSuccess =
          await SharedPrefs.setString(kUserInfoKey, userStringJson);

      if (!saveSuccess) {
        _errorMessage = 'Failed to save user info';
      }

      _isAuthenticated = true;
      await SharedPrefs.setBool(kIsAuthenticatedKey, true);
      notifyListeners();

      checkUserInfo();
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // check user info
  Future<void> checkUserInfo() async {
    final userInfoString = await SharedPrefs.getString(kUserInfoKey);
    if (userInfoString != null) {
      final userInfoMap = SharedPrefs.decodeStringToMap(userInfoString);
      // convert string to map
      final userInfo = UserModel.fromMap(userInfoMap);
      _user = userInfo;
      notifyListeners();
    }
  }

  // sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    _isAuthenticated = false;
    await Future.delayed(Duration(seconds: 1));
    await SharedPrefs.clear();
    _isLoading = false;
    notifyListeners();
  }
}
