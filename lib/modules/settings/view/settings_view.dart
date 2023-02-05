import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../auth/controllers/auth_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = context.read<AuthController>();
    _authController.addListener(_onAuthenticationChanged);
  }

  // _onAuthenticationChanged
  void _onAuthenticationChanged() {
    if (!_authController.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/sign_in');
    }
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthenticationChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Warning'),
                    content: Text('Do you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Provider.of<AuthController>(context, listen: false)
                              .signOut();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, AuthController authController, child) {
          if (authController.isLoading) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Account profile section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 40),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'thorn@gmail.com',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Account settings section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
                // App settings section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Settings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Language'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                      ListTile(
                        leading: Icon(Icons.brightness_6),
                        title: Text('Theme'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
                // About section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('App Info'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('App Info'),
                                content: Text('Flutter Notes App v1.0.0'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // app license
                      ListTile(
                        leading: Icon(Icons.article),
                        title: Text('License Agreement'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'Flutter Notes App',
                            applicationVersion: '1.0.0',
                            applicationIcon: Image.asset(
                              'assets/images/logo.png',
                              width: 50,
                              height: 50,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
