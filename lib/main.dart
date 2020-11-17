import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:time_management_app/application_layer/auth/login/login_screen.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //TODO: Design Widget for error
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // TODO: Add Wrapper Widget when finished
          return LoginScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // TODO: Design Loading Screen
        return LoadingScreen();
      },
    );
  }
}

