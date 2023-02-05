import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized; // getter

  Future<void> init() async {
    // TODO: Initialize your app here
    await Future.delayed(Duration(seconds: 3));
    _isInitialized = true;
    notifyListeners();
  }
}
