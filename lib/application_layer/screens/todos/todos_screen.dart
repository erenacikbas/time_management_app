import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reorderables/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/components/tracker_adder.dart';
import 'package:time_management_app/application_layer/models/todoCurrentPage.dart';
import 'package:time_management_app/application_layer/models/todoPage.dart';
import 'package:time_management_app/application_layer/screens/todos/todo_skeleton_page.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

import 'dismissible_todo_card.dart';
import 'red_delete_box.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController textEditingController;
  String todo = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController =
        PrimaryScrollController.of(context) ?? ScrollController();
    final user = Provider.of<User>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;

    return StreamProvider<List<TodoPageSettings>>.value(
      value: DatabaseService().getTodoPageSettings(user.uid),
      child: StreamBuilder<List<TodoPage>>(
        stream: DatabaseService().todoPageName(user.uid),
        builder: (BuildContext context, AsyncSnapshot todoPages) {
          final pageSettings = Provider.of<List<TodoPageSettings>>(context);
          final pageName =
              todoPages.data[pageSettings[0].currentIndex].pageName;
          return Scaffold(
            drawer: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                //height: MediaQuery.of(context).size.height /1.50,
                width: MediaQuery.of(context).size.width / 2,
                child: Drawer(
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1a1c22),
                      
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 25),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16),
                              child: Text("Todo Pages",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: todoPages.data.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  print(todoPages.data[index].icon);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        DatabaseService()
                                            .setPageIndex(user.uid, index);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        getIcon(
                                            name: todoPages.data[index].icon),
                                        size: 30,
                                      ),
                                      title: Text(
                                        todoPages.data[index].pageName,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Icon(Icons.menu)),
                );
              }),
              centerTitle: false,
              title:
                  Text(todoPages.data[pageSettings[0].currentIndex].pageName),
              actions: [
                CupertinoButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        elevation: 10,
                        context: context,
                        builder: (BuildContext context) => StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        hintText: "Add a Task"),
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
                                                  user.uid,
                                                  todoPages
                                                      .data[pageSettings[0]
                                                          .currentIndex]
                                                      .pageName,
                                                );
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),
            body: StreamBuilder(
              stream: DatabaseService().doneTodos(user.uid, pageName),
              builder: (BuildContext context, AsyncSnapshot doneTodos) {
                if (!doneTodos.hasData) {
                  return TodoSkeletonPage(
                      themeChange: themeChange,
                      textEditingController: textEditingController,
                      todo: todo,
                      user: user);
                } else {
                  return CupertinoScrollbar(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ReorderableFirebaseList(
                            pageName: todoPages
                                .data[pageSettings[0].currentIndex].pageName,
                            query: FirebaseFirestore.instance
                                .collection("userDoc")
                                .doc(user.uid)
                                .collection("todos")
                                .where("page",
                                    isEqualTo: todoPages
                                        .data[pageSettings[0].currentIndex]
                                        .pageName)
                                .where("isDone", isEqualTo: false),
                            indexKey: "pos",
                            itemBuilder: (BuildContext context, int index,
                                DocumentSnapshot doc) {
                              return Stack(
                                key: Key(doc.id),
                                clipBehavior: Clip.hardEdge,
                                children: [
                                  RedDeleteBox(height: height),
                                  DismissibleTodoCard(
                                    height: height,
                                    todos: doc,
                                    index: index,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                elevation: 10,
                                context: context,
                                builder: (BuildContext context) =>
                                    StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40.0,
                                                    top: 25.0,
                                                    bottom: 15.0),
                                                child: Text("Completed Tasks",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    )),
                                              ),
                                              Expanded(
                                                child: ReorderableFirebaseList(
                                                  uid: user.uid,
                                                  pageName: todoPages
                                                      .data[pageSettings[0]
                                                          .currentIndex]
                                                      .pageName,
                                                  query: FirebaseFirestore
                                                      .instance
                                                      .collection("userDoc")
                                                      .doc(user.uid)
                                                      .collection("todos")
                                                      .where("page",
                                                          isEqualTo: todoPages
                                                              .data[pageSettings[
                                                                      0]
                                                                  .currentIndex]
                                                              .pageName)
                                                      .where("isDone",
                                                          isEqualTo: true),
                                                  // .where("page",
                                                  //     isEqualTo: "Important"),
                                                  indexKey: "pos",
                                                  itemBuilder: (BuildContext
                                                          context,
                                                      int index,
                                                      DocumentSnapshot doc) {
                                                    return Stack(
                                                      key: Key(doc.id),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      children: [
                                                        RedDeleteBox(
                                                            height: height),
                                                        DismissibleTodoCard(
                                                          height: height,
                                                          todos: doc,
                                                          index: index,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: themeChange.darkTheme
                                                  ? Color(0xff1a1c22)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.5,
                                          width: double.infinity,
                                        );
                                      },
                                    ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    height: height / 14,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: kGradientBlueRasperry),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  height: height / 16,
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    "${doneTodos.data.length} Completed Task",
                                    style: TextStyle(fontSize: 20),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Visibility(
                        //   key: Key("Heading Key"),
                        //   visible:
                        //       ((doneTodos.data.length) ?? false) == 0 ? false : true,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 40.0, top: 10),
                        //     child: Text(
                        //       "Completed",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: ReorderableFirebaseList(
                        //     query: FirebaseFirestore.instance
                        //         .collection("userDoc")
                        //         .doc(user.uid)
                        //         .collection("todos")
                        //         .where("isDone", isEqualTo: true),
                        //     indexKey: "pos",
                        //     itemBuilder: (BuildContext context, int index,
                        //         DocumentSnapshot doc) {
                        //       return Stack(
                        //         key: Key("$Random()"),
                        //         clipBehavior: Clip.hardEdge,
                        //         children: [
                        //           RedDeleteBox(height: height),
                        //           DismissibleTodoCard(
                        //             height: height,
                        //             todos: doc,
                        //             index: index,
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  IconData getIcon({name}) {
    if (name == "brightness_low") {
      return Icons.brightness_low;
    } else if (name == "grade") {
      return Icons.grade;
    } else if (name == "home_work") {
      return Icons.home_work;
    } else {
      return Icons.list;
    }
  }
}

typedef ReorderableWidgetBuilder = Widget Function(
    BuildContext context, int index, DocumentSnapshot doc);

class ReorderableFirebaseList extends StatefulWidget {
  const ReorderableFirebaseList({
    Key key,
    @required this.query,
    @required this.indexKey,
    @required this.itemBuilder,
    @required this.pageName,
    this.uid,
    this.descending = false,
  }) : super(key: key);

  final String pageName;
  final String uid;
  final Query query;
  final String indexKey;
  final bool descending;
  final ReorderableWidgetBuilder itemBuilder;

  @override
  _ReorderableFirebaseListState createState() =>
      _ReorderableFirebaseListState();
}

class _ReorderableFirebaseListState extends State<ReorderableFirebaseList> {
  List<DocumentSnapshot> _docs;
  Future _saving;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _saving,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
            stream: widget.query
                //.where("page", isEqualTo: widget.pageName)
                .orderBy(widget.indexKey, descending: widget.descending)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _docs = snapshot.data.docs;
                return ReorderableListView(
                  //header: Text("Todos"),
                  onReorder: _onReorder,
                  children: List.generate(_docs.length, (int index) {
                    return widget.itemBuilder(context, index, _docs[index]);
                  }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    _docs.insert(newIndex, _docs.removeAt(oldIndex));

    final batch = FirebaseFirestore.instance.batch();
    for (int pos = 0; pos < _docs.length; pos++) {
      batch.update(_docs[pos].reference, {widget.indexKey: pos});
    }
    batch.commit();
  }
}
