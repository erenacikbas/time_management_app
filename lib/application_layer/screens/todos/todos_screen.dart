import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:time_management_app/application_layer/components/tracker_adder.dart';
import 'package:time_management_app/application_layer/models/todos.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController textEditingController;
  String todo = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Future<String> _userID;
  // String userID;
  // void _getUserID() async {
  //   User user = await FirebaseAuth.instance.currentUser;
  //   userID = user.uid;
  // }

  @override
  void initState() {
    super.initState();
    // _userID = _prefs.then((SharedPreferences preferences) {
    //   return (preferences.getString("userID") ?? "");
    // });
    //_getUserID();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder<List<TodoItems>>(
      stream: DatabaseService().todosFromFilteredData(user.uid),
      builder: (BuildContext context, AsyncSnapshot todos) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: false,
                title: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text("Todos"),
                ),
                actions: [
                  CupertinoButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 10,
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0, top: 5),
                                              child: Icon(
                                                Icons.radio_button_off_outlined,
                                                color: themeChange.darkTheme
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(20),
                                            title: TextFormField(
                                              style: TextStyle(
                                                  color: themeChange.darkTheme
                                                      ? Colors.white
                                                      : Colors.black),
                                              controller: textEditingController,
                                              decoration:
                                                  kAddingTodoInputDecoration
                                                      .copyWith(
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
                                                              "Add a Task"),
                                              onChanged: (_) {
                                                setState(() {
                                                  todo = _;
                                                  print(todo);
                                                });
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) {
                                                setState(() {
                                                  todo = value;
                                                  DatabaseService().updateTODO(
                                                      Timestamp.now(),
                                                      uuid.v1(),
                                                      false,
                                                      todo,
                                                      user.uid);
                                                  print(todo);
                                                  //textEditingController.clear();
                                                  Navigator.pop(context);
                                                });
                                              },
                                            )),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: themeChange.darkTheme
                                            ? Color(0xff1a1c22)
                                            : Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30))),
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width: double.infinity,
                                  );
                                },
                              ));
                    },
                    child: Icon(
                      Icons.add,
                    ),
                  )
                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("todos")
                    .doc(user.uid)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final userDocument = snapshot.data;

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 30.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    )),
                                height: height / 12,
                                margin:
                                    EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: kRedGradient,
                                  //color: Color(0xff979ca0)
                                ),
                              ),
                            ),
                            DismissibleTodoCard(
                              height: height,
                              todos: todos,
                              index: index,
                            ),
                          ],
                        );
                      }, childCount: todos.data.length),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: Colors.white70),
                              child: Container(
                                height: 85,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // SkeletonAnimation(
                                    //   child: Container(
                                    //     width: 70.0,
                                    //     height: 70.0,
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.grey[300],
                                    //     ),
                                    //   ),
                                    // ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, bottom: 5.0),
                                          child: SkeletonAnimation(
                                            child: Container(
                                              height: 15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.grey[300]),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: SkeletonAnimation(
                                              child: Container(
                                                width: 60,
                                                height: 13,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.grey[300]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 5,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DismissibleTodoCard extends StatefulWidget {
  const DismissibleTodoCard({
    Key key,
    @required this.height,
    @required this.todos,
    @required this.index,
  }) : super(key: key);

  final double height;
  final AsyncSnapshot todos;
  final int index;

  @override
  _DismissibleTodoCardState createState() => _DismissibleTodoCardState();
}

class _DismissibleTodoCardState extends State<DismissibleTodoCard> {
  @override
  Widget build(BuildContext context) {
    //print("EVENT ID = " + widget.todos.data[widget.index].eventID);
    return Dismissible(
      key: Key(widget.todos.data[widget.index].eventID),
      direction: DismissDirection.endToStart,
      onResize: () {
        setState(() {
          DatabaseService()
              .deleteTodoByEventID(widget.todos.data[widget.index].eventID);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.indigoAccent),
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Center(
                  child: Text(
                    "${widget.todos.data[widget.index].todo} dismissed",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      },

      //resizeDuration: Duration(seconds: 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          // ** for red bottom effect set height height/12
          height: widget.height / 12,
          margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), gradient: greyGradient
              //color: Color(0xff979ca0)
              ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                checkColor: Colors.white,
                tileColor: Colors.transparent,
                activeColor: Colors.indigo,
                selectedTileColor: Colors.black,
                value: widget.todos.data[widget.index].isDone,
                onChanged: (value) {
                  if (value == false) {
                    DatabaseService().setIsDoneFalse(
                        widget.todos.data[widget.index].eventID);
                  } else {
                    DatabaseService()
                        .setIsDoneTrue(widget.todos.data[widget.index].eventID);
                  }
                },
                title: Text(
                  "${widget.todos.data[widget.index].todo}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TodoSkeletonCard extends StatefulWidget {
  @override
  _TodoSkeletonCardState createState() => _TodoSkeletonCardState();
}

class _TodoSkeletonCardState extends State<TodoSkeletonCard> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height / 12,
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: greyGradient
                  //color: Color(0xff979ca0)
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
