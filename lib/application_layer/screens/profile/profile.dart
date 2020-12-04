import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/application_layer/screens/profile/friends.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/service_layer/database.dart';
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
  final AuthService _auth = AuthService();

  int result = 0;
  TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    //_auth.signOut();
    super.build(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final width = MediaQuery.of(context).size.height;
    final height = MediaQuery.of(context).size.height;
    //final _users = Provider.of<List<Users>>(context) ?? [];
    //final user = _users[0];
    final user = Provider.of<User>(context);

    var iconColor =
        Styles.themeData(themeChange.darkTheme, context).iconTheme.color;

    return StreamBuilder(
      stream: DatabaseService().userData(user.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return LoadingScreen();
        } else {
          return CupertinoPageScaffold(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: true,
                title: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    "Profile",
                  ),
                ),
                actions: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Icon(Icons.add),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 10,
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  final user = Provider.of<User>(context);
                                  @override
                                  void dispose() {
                                    // Clean up the controller when the Widget is removed from the Widget tree
                                    _textEditingController.clear();
                                    super.dispose();
                                  }

                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20),
                                                  child: Text(
                                                    "Add a friend",
                                                    style: TextStyle(
                                                        color: themeChange
                                                                .darkTheme
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                ListTile(
                                                    contentPadding:
                                                        EdgeInsets.all(20),
                                                    title: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[0-9]')),
                                                      ],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: themeChange
                                                                  .darkTheme
                                                              ? Colors.white
                                                              : Colors.black),
                                                      controller:
                                                          _textEditingController,
                                                      decoration: kAddingTodoInputDecoration.copyWith(
                                                          hintStyle: TextStyle(
                                                              color: themeChange
                                                                      .darkTheme
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          hintText:
                                                              "Search by user code"),
                                                      onChanged: (_) {
                                                        setState(() {
                                                          setState(() {
                                                            result =
                                                                int.parse(_);
                                                          });
                                                        });
                                                      },
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      onFieldSubmitted:
                                                          (value) {
                                                        setState(() {
                                                          result =
                                                              int.parse(value);
                                                          _textEditingController
                                                              .clear();
                                                        });
                                                      },
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: StreamBuilder(
                                              stream: DatabaseService()
                                                  .findMatchedUser(result),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Card(
                                                          elevation: 10,
                                                          child: ListTile(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            10,
                                                                        horizontal:
                                                                            20),
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 24,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        "${snapshot.data[0].profilePicture == "" ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLuECLXQrCdU1e1npz8Y0NAHi7xqilHSa2DVrpWVDDmGWSz3W_5ApcsAjRPeW37__YUvcGQlxYca1jBhcWgAV0CLHtWbv09qU&usqp=CAU&ec=45730948" : snapshot.data[0].profilePicture}"),
                                                              ),
                                                            ),
                                                            title: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .name,
                                                            ),
                                                            trailing:
                                                                Icon(Icons.add),
                                                            onTap: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(user.uid)
                                                                  .update({
                                                                "friends":
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  result
                                                                ])
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      itemCount:
                                                          snapshot.data.length);
                                                } else {
                                                  print(
                                                      "No match has been found");
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: themeChange.darkTheme
                                            ? Color(0xff1a1c22)
                                            : Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30))),
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: double.infinity,
                                  );
                                },
                              ));
                    },
                  )
                ],
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
                        backgroundImage: NetworkImage(
                            "${snapshot.data[0].profilePicture == "" ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLuECLXQrCdU1e1npz8Y0NAHi7xqilHSa2DVrpWVDDmGWSz3W_5ApcsAjRPeW37__YUvcGQlxYca1jBhcWgAV0CLHtWbv09qU&usqp=CAU&ec=45730948" : snapshot.data[0].profilePicture}"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "${snapshot.data[0].name}",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        "${snapshot.data[0].userCode}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          ListTileTheme(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
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
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Icons.brightness_5
                                          : Icons.brightness_2,
                                      color: iconColor,
                                    ),
                                  ),
                                  trailing: CupertinoSwitch(
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      value: themeChange.darkTheme,
                                      onChanged: (bool value) {
                                        setState(() {
                                          themeChange.darkTheme = value;
                                        });
                                      }),
                                ),
                                ListTile(
                                  title: Text("Friends"),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Friends()));
                                  },
                                  leading: Icon(
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Icons.person
                                        : Icons.person,
                                    color: iconColor,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CupertinoButton(
                                    child: Container(
                                        width: width / 5,
                                        height: height / 18,
                                        margin: EdgeInsets.only(top: 25),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
      },
    );
  }
}
