import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/components/tracker_adder.dart';
import 'package:time_management_app/application_layer/screens/todos/red_delete_box.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

class DismissibleTodoCard extends StatefulWidget {
  const DismissibleTodoCard({
    Key key,
    @required this.height,
    @required this.todos,
    @required this.index,
  }) : super(key: key);

  final double height;
  final DocumentSnapshot todos;
  final int index;

  @override
  _DismissibleTodoCardState createState() => _DismissibleTodoCardState();
}

class _DismissibleTodoCardState extends State<DismissibleTodoCard> {
  String todo = "";

  TextEditingController _textEditingController;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final user = Provider.of<User>(context);
    //print("EVENT ID = " + widget.todos.data[widget.index].eventID);
    return Dismissible(
      key: Key(widget.todos.get("eventID")),
      direction: DismissDirection.endToStart,
      onResize: () {
        setState(() {
          DatabaseService().deleteTodoByEventID(
              widget.todos.get("userID"), widget.todos.get("eventID"));
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Container(
        //         height: 50,
        //         width: double.infinity,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(12),
        //             color: Colors.indigoAccent),
        //         margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        //         child: Center(
        //           child: Text(
        //             "${widget.todos.get("todo")} dismissed",
        //             style: TextStyle(color: Colors.white, fontSize: 15),
        //           ),
        //         )),
        //     backgroundColor: Colors.transparent,
        //     elevation: 0,
        //   ),
        // );
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
          child: GestureDetector(
            onDoubleTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  elevation: 10,
                  context: context,
                  builder: (BuildContext context) => StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            child: ListView(
                              children: [
                                ListTile(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 5),
                                      child: Text(
                                        "Edit Todo",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: themeChange.darkTheme
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    )),
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
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    title: TextFormField(
                                      //initialValue: widget.todos.get("todo"),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: themeChange.darkTheme
                                              ? Colors.grey
                                              : Colors.black),
                                      controller: _textEditingController,
                                      decoration:
                                          kAddingTodoInputDecoration.copyWith(
                                              hintStyle: TextStyle(
                                                  fontSize: 17,
                                                  color: themeChange.darkTheme
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w400),
                                              hintText:
                                                  "${widget.todos.get("todo")}"),
                                      onChanged: (_) {
                                        setState(() {
                                          todo = _;
                                          print(todo);
                                        });
                                      },
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          todo = value;
                                          // DatabaseService().updateTODO(
                                          //     Timestamp.now(),
                                          //     uuid.v1(),
                                          //     false,
                                          //     todo,
                                          //     user.uid);
                                          DatabaseService().updateTodoName(
                                              user.uid,
                                              widget.todos.get("eventID"),
                                              todo);
                                          print(todo);
                                          //textEditingController.clear();
                                          Navigator.pop(context);
                                        });
                                      },
                                    )),
                                Divider(
                                  height: 1,
                                  thickness: 0.6,
                                  color: themeChange.darkTheme
                                      ? Colors.grey[600]
                                      : Colors.black,
                                  indent: 50,
                                  endIndent: 50,
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      "Remind Me",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: themeChange.darkTheme
                                              ? Colors.grey
                                              : Colors.black,
                                          fontSize: 17),
                                    ),
                                  ),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, top: 5),
                                    child: Icon(
                                      FontAwesomeIcons.solidBell,
                                      color: themeChange.darkTheme
                                          ? Colors.grey[600]
                                          : Colors.black,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 0, 20, 0),
                                ),
                                ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, top: 5),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: themeChange.darkTheme
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      "Add Due Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: themeChange.darkTheme
                                              ? Colors.grey
                                              : Colors.black,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, top: 5),
                                    child: Icon(
                                      Icons.shuffle_rounded,
                                      color: themeChange.darkTheme
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      "Repeat",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: themeChange.darkTheme
                                              ? Colors.grey
                                              : Colors.black,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 0.6,
                                  color: themeChange.darkTheme
                                      ? Colors.grey
                                      : Colors.black,
                                  indent: 50,
                                  endIndent: 50,
                                ),
                                ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, top: 5),
                                      child: Icon(
                                        Icons.note_add,
                                        color: themeChange.darkTheme
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    title: TextFormField(
                                      //initialValue: widget.todos.get("todo"),
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: themeChange.darkTheme
                                              ? Colors.grey
                                              : Colors.black),
                                      controller: _textEditingController,
                                      decoration:
                                          kAddingTodoInputDecoration.copyWith(
                                              hintStyle: TextStyle(
                                                  fontSize: 17,
                                                  color: themeChange.darkTheme
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w400),
                                              hintText:
                                                  "Add note"),
                                      onChanged: (_) {
                                        setState(() {
                                          todo = _;
                                          print(todo);
                                        });
                                      },
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          todo = value;
                                          // DatabaseService().updateTODO(
                                          //     Timestamp.now(),
                                          //     uuid.v1(),
                                          //     false,
                                          //     todo,
                                          //     user.uid);
                                          DatabaseService().updateTodoName(
                                              user.uid,
                                              widget.todos.get("eventID"),
                                              todo);
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
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: double.infinity,
                          );
                        },
                      ));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  checkColor: Colors.white,
                  tileColor: Colors.transparent,
                  activeColor: Colors.indigo,
                  selectedTileColor: Colors.black,
                  value: widget.todos.get("isDone"),
                  onChanged: (value) {
                    if (value == false) {
                      DatabaseService().setIsDoneFalse(
                          widget.todos.get("userID"),
                          widget.todos.get("eventID"));
                    } else {
                      DatabaseService().setIsDoneTrue(
                          widget.todos.get("userID"),
                          widget.todos.get("eventID"));
                    }
                  },
                  title: Text(
                    "${widget.todos.get("todo")}",
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
      ),
    );
  }
}
