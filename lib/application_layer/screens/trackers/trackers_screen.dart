import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/components/tracker_adder.dart';
import 'package:time_management_app/application_layer/components/tracker_list.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/application_layer/screens/profile/profile.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/service_layer/database.dart';

class TrackerScreen extends StatefulWidget {
  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final AuthService _auth = AuthService();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _userID;
  @override
  void initState() {
    super.initState();
    _userID = _prefs.then((SharedPreferences preferences) {
      return (preferences.getString("userID") ?? "");
    });
    //_auth.signOut();

    //DatabaseService().sortUserData();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    return FutureBuilder(
      future: _userID,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CupertinoPageScaffold(
          child: Scaffold(
            // old
            //backgroundColor: Color(0xff252a2d),
            appBar: AppBar(
              elevation: 0.0,
              title: Text("Great Tracker"),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CupertinoButton(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    // onLongPress: () async{
                    //   await _auth.signOut();
                    //   await AuthService().googleSignOut();
                    // },
                    onPressed: () async {
                      print(await _userID);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Profile()));
                    },
                  ),
                ),
              ],
            ),
            body: StreamProvider<List<Trackers>>.value(
              value: DatabaseService().trackersFromFilteredData(snapshot.data),
              child: CupertinoScrollbar(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TrackerAdder(
                      userID: snapshot.data,
                    ),
                    Flexible(child: TrackerList()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
