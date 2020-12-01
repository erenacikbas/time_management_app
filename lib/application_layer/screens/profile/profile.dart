import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/shared/constants.dart';
import 'package:time_management_app/shared/dark_theme/dark_theme_styles.dart';
import 'dart:math';
import '../../wrapper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Future<String> _userID;
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
    print(_userID);
  }

  @override
  Widget build(BuildContext context) {
    //_auth.signOut();
    super.build(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final width = MediaQuery.of(context).size.height;
    final height = MediaQuery.of(context).size.height;
    final _users = Provider.of<List<Users>>(context) ?? [];
    final user = _users[0];
    print(user);
    var iconColor = Styles.themeData(themeChange.darkTheme, context).iconTheme.color;
    return CupertinoPageScaffold(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "Profile",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                radius: 85,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage("${user.profilePicture.isEmpty ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLuECLXQrCdU1e1npz8Y0NAHi7xqilHSa2DVrpWVDDmGWSz3W_5ApcsAjRPeW37__YUvcGQlxYca1jBhcWgAV0CLHtWbv09qU&usqp=CAU&ec=45730948" : user.profilePicture}"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "${user.name}",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    ListTileTheme(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SliverList(
                        delegate: SliverChildListDelegate([
                          ListTile(
                            title: Text("Dark Mode"),
                            onTap: () {
                              print(Theme.of(context).brightness);
                              //switchDarkMode(context);
                              print(Theme.of(context).brightness);
                            },
                            leading: Transform.rotate(
                              angle: -pi,
                              child: Icon(
                                Theme.of(context).brightness == Brightness.light
                                    ? Icons.brightness_5
                                    : Icons.brightness_2,
                                color: iconColor,
                              ),
                            ),
                            trailing: CupertinoSwitch(
                                activeColor: Theme.of(context).accentColor,
                                value: themeChange.darkTheme,
                                onChanged: (bool value) {
                                  setState(() {
                                    themeChange.darkTheme = value;
                                  });
                                }),
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
                                      color: kAppIndigo),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                        builder: (BuildContext context) =>
                                            Wrapper()));
                              },
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

