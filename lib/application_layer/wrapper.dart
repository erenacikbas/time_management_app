import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/components/CupertinoBottomBar/CupertinoBottomBar.dart';
import 'package:time_management_app/application_layer/components/CupertinoBottomBar/CupertinoTabManager.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/application_layer/screens/home/home.dart';
import 'package:time_management_app/service_layer/database.dart';

import 'auth/auth_management/authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _userID;
  @override
  void initState() {
    super.initState();
    _userID = _prefs.then((SharedPreferences preferences) {
      return (preferences.getString("userID") ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    TabItemEnum currentTab = TabItemEnum.Trackers;
    //final authStatus = Provider.of<FirebaseAuth>(context).currentUser();
    //print(user);

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (ModalRoute.of(context).isCurrent == true) {
            print("snapshot is ==========> ${snapshot.data}");
            if (snapshot.data == null) {
              return Authenticate();
            } else {
              return FutureBuilder(
                  future: _userID,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return StreamProvider<List<Users>>.value(
                      //input userID
                      value: DatabaseService().userData(snapshot.data),
                      child: WillPopScope(
                        onWillPop: () async => !await TabItem
                            .navigatorKeys[currentTab].currentState
                            .maybePop(),
                        child: CupertinoTabManager(
                            currentTab: currentTab,
                            selectedTabItem: TabItem.getSelectedPage(),
                            navigatorKeys: TabItem.navigatorKeys),
                      ),
                    );
                  });
            }
          } else {
            return LoadingScreen();
          }
        });

    // if (true == null) {
    //       return Authenticate();
    //     } else {R
    //       return Home();
    //     }
  }
}
