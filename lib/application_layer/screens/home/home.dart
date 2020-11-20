import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/components/tracker_adder.dart';
import 'package:time_management_app/application_layer/components/tracker_list.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/application_layer/screens/profile/profile.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/service_layer/database.dart';

import '../../wrapper.dart';

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
    return FutureBuilder(
      future: _userID,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigoAccent,
            elevation: 0.0,
            title: Text("Great Tracker"),
            actions: <Widget>[
              RawMaterialButton(
                child: Icon(Icons.person),
                // onLongPress: () async{
                //   await _auth.signOut();
                //   await AuthService().googleSignOut();
                // },
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StreamProvider<List<Users>>.value(
                                value:
                                    DatabaseService().userData(snapshot.data),
                                child: Builder(builder: (context) {
                                  var snapshot =
                                      Provider.of<List<Users>>(context);
                                  if (snapshot == null) {
                                    return LoadingScreen();
                                  } else {
                                    return Profile(snapshot);
                                  }
                                }),
                              )));
                },
              ),
            ],
          ),
          body: StreamProvider<List<Trackers>>.value(
            value: DatabaseService().trackersFromFilteredData(snapshot.data),
            child: Column(
              children: [
                TrackerAdder(
                  userID: snapshot.data,
                ),
                Flexible(child: TrackerList()),
              ],
            ),
          ),
        );
      },
    );
  }
}
