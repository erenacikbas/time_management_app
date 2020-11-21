import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/service_layer/auth.dart';

import '../../wrapper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.height;
    final height = MediaQuery.of(context).size.height;
    final _users = Provider.of<List<Users>>(context) ?? [];
    final user = _users[0];
    return CupertinoPageScaffold(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Profile"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  radius: 88,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage("${user.profilePicture}"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${user.name}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    child: Container(
                        width: width / 5,
                        height: height / 18,
                        margin: EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.indigoAccent),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Sign out',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ))),
                    onPressed: () async {
                      await _auth.signOut();
                      await AuthService().googleSignOut();
                      LoadingScreen();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Wrapper()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
