import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/shared/dark_theme/dark_theme_styles.dart';
import 'application_layer/wrapper.dart';
import 'package:flutter/foundation.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    print(themeChangeProvider.darkTheme);
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            //darkTheme: themeModel.themeData(platformDarkMode: true),
            // ThemeData(
            //     textTheme:
            //         TextTheme().copyWith(bodyText2: TextStyle(color: Colors.black)),
            //     appBarTheme:
            //         AppBarTheme(centerTitle: true, color: Color(0xff1f2224))),
            debugShowCheckedModeBanner: false,
            home: FirebaseCheck(),
          );
        },
      ),
    );
  }
}

class FirebaseCheck extends StatelessWidget {
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
          return Container(
              color: Colors.redAccent,
              child: Center(
                child: Text(
                  "Error",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
              ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: FirebaseAuth.instance.authStateChanges(),
            child: Wrapper());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );
  }
}
