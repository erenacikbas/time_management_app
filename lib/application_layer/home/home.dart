import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/components/tracker_adder.dart';
import 'package:time_management_app/application_layer/components/tracker_list.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/service_layer/database.dart';

import '../wrapper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _userID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userID = _prefs.then((SharedPreferences preferences) {
      return (preferences.getString("userID") ?? "");
    });
    //DatabaseService().sortUserData();
  }

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
      body: FutureBuilder(
        future: _userID,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return StreamProvider<List<Trackers>>.value(
            value: DatabaseService().trackersFromFilteredData(snapshot.data),
            child: Column(
                    children: [
                      TrackerAdder(
                        userID: snapshot.data,
                      ),
                      Flexible(child: TrackerList()),
                    ],
                  ),
            );
        },
      ),
    );
  }
}
