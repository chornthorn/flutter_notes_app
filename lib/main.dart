import 'package:flutter/material.dart';
import 'package:flutter_notes_app/modules/auth/controllers/auth_controller.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'modules/splash/controllers/splash_controller.dart';
import 'routers/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => SplashController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          return GlobalLoaderOverlay(
            overlayColor: Colors.black.withOpacity(0.5),
            child: child!,
          );
        },
      ),
    );
  }
}
