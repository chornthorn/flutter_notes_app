import 'package:flutter/material.dart';
import 'package:flutter_notes_app/modules/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  late SplashController _splashController; // declare variable
  late AuthController _authController; // declare variable

  @override
  void initState() {
    super.initState();
    _authController = context.read<AuthController>(); // get controller instance with locator
    _splashController = context.read<SplashController>(); // get controller instance
    _splashController.init(); // call init method
    _authController.addListener(_onChanged);
    _splashController.addListener(_onInitializedChanged);
  }

  //_onInitializedChanged
  void _onInitializedChanged() {
    if (_splashController.isInitialized) {
      _authController.checkAuth();
    }
  }

  // onChanged
  void _onChanged() {
    if (_authController.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      Navigator.of(context).pushReplacementNamed('/sign_in');
    }
  }

  @override
  void dispose() {
    _splashController.removeListener(_onInitializedChanged);
    _authController.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SplashController>(
        builder: (context, controller, child) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}