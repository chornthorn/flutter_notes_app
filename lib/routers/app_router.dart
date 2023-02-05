import 'package:flutter/material.dart';
import 'package:flutter_notes_app/modules/auth/view/sign_in_view.dart';
import 'package:flutter_notes_app/modules/auth/view/sign_up_view.dart';
import 'package:flutter_notes_app/modules/home/view/home_view.dart';
import 'package:flutter_notes_app/modules/main/view/main_view.dart';
import 'package:flutter_notes_app/modules/notes/view/add_note_view.dart';
import 'package:flutter_notes_app/modules/notes/view/notes_view.dart';
import 'package:flutter_notes_app/modules/splash/views/splash_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashView());
      case '/main':
        return MaterialPageRoute(builder: (_) => MainView());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/notes/list':
        return MaterialPageRoute(builder: (_) => NotesView());
      case '/notes/add':
        return MaterialPageRoute(builder: (_) => AddNoteView());
      case '/notes/update':
        return MaterialPageRoute(builder: (_) => AddNoteView());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignInView());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => SignUpView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
