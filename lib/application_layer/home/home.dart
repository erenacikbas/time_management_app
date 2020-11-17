import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/service_layer/auth.dart';

import '../wrapper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        elevation: 0.0,
        title: Text("Great Tracker"),
        actions: <Widget>[
          RawMaterialButton(
            child: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
              LoadingScreen();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Wrapper()));
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
