import 'package:flutter/material.dart';
import 'package:flutter_notes_app/shared/constants.dart';
import 'package:flutter_notes_app/shared/share_prefs.dart';

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // check if user is authenticated
  Future<void> checkAuth() async {
    final isAuthenticated = await SharedPrefs.getBool(kIsAuthenticatedKey);
    if (isAuthenticated != null) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
    } else {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  // sign in
  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));
    _isAuthenticated = true;
    await SharedPrefs.setBool(kIsAuthenticatedKey, true);
    _isLoading = false;
    notifyListeners();
  }

  // sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    _isAuthenticated = false;
    await Future.delayed(Duration(seconds: 2));
    await SharedPrefs.clear();
    _isLoading = false;
    notifyListeners();
  }
}
