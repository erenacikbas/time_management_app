import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/components/tracker_tile.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:flutter/foundation.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

import 'grouped.list.dart';

final double raidus = 0;

class TrackerList extends StatefulWidget {
  @override
  _TrackerListState createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
  TextEditingController _textEditingController;
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     //Trackers provider = Provider.of<Trackers>(context, listen: false);
  //     DatabaseService().sortUserData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;
    // define data set
    final _trackers = Provider.of<List<Trackers>>(context) ?? [];

    if (_trackers != null) {
      return Container(
        child: CupertinoScrollbar(
          controller: ScrollController(),
          child: GroupedListView<dynamic, String>(
            elements: _trackers,
            groupBy: (element) => element.date,
            //indexedItemBuilder: (context,dynamic element, index ) => Text(_trackers[index].name),
            //groupComparator: (value1, value2) => value2.compareTo(value1),
            // itemComparator: (item1, item2) =>
            //         item2.finishingTime.compareTo(item1.finishingTime),
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            itemBuilder: (context, dynamic element) => Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: height / 11,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: kRedGradient
                        //color: Color(0xff979ca0)
                        ),
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 30.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Container(
                //     child: Align(
                //         alignment: Alignment.centerRight,
                //         child: Padding(
                //           padding: const EdgeInsets.only(right: 30.0),
                //           child: Icon(Icons.delete, color: Colors.white),
                //         )),
                //     height: 68,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(12),
                //         gradient: kRedGradient),
                //     margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                //   ),
                // ),
                Dismissible(
                  key: Key(element.eventID),
                  direction: DismissDirection.endToStart,

                  // background: Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //     margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  //   ),
                  // ),

                  onDismissed: (direction) {
                    setState(() {
                      DatabaseService()
                          .deleteEventbyID(element.userID, element.eventID);
                    });
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Container(
                    //         height: 50,
                    //         width: double.infinity,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //             color: Colors.indigoAccent),
                    //         margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    //         child: Center(
                    //           child: Text(
                    //             "${element.name} dismissed",
                    //             style: TextStyle(
                    //                 color: Colors.white, fontSize: 20),
                    //           ),
                    //         )),
                    //     backgroundColor: Colors.transparent,
                    //     elevation: 0,
                    //   ),
                    // );
                  },
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 10,
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    child: ListView(
                                      children: [
                                        ListTile(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20, 20, 20, 0),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30, top: 5),
                                              child: Text(
                                                "Edit Tracker",
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
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            title: TextFormField(
                                              //initialValue: widget.todos.get("todo"),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  color: themeChange.darkTheme
                                                      ? Colors.grey
                                                      : Colors.black),
                                              controller:
                                                  _textEditingController,
                                              decoration: kAddingTodoInputDecoration
                                                  .copyWith(
                                                      hintStyle: TextStyle(
                                                          fontSize: 17,
                                                          color: themeChange
                                                                  .darkTheme
                                                              ? Colors.grey
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      hintText: "Tracker Name"),
                                              onChanged: (_) {
                                                setState(() {});
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) {
                                                setState(() {
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
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Text(
                                              "Project Name",
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
                                              FontAwesomeIcons.tags,
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
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
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
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
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
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            title: TextFormField(
                                              //initialValue: widget.todos.get("todo"),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                  color: themeChange.darkTheme
                                                      ? Colors.grey
                                                      : Colors.black),
                                              controller:
                                                  _textEditingController,
                                              decoration: kAddingTodoInputDecoration
                                                  .copyWith(
                                                      hintStyle: TextStyle(
                                                          fontSize: 17,
                                                          color: themeChange
                                                                  .darkTheme
                                                              ? Colors.grey
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      hintText: "Add note"),
                                              onChanged: (_) {
                                                setState(() {});
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (value) {
                                                setState(() {
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
                                    height: MediaQuery.of(context).size.height /
                                        1.5,
                                    width: double.infinity,
                                  );
                                },
                              ));
                    },
                    child: TrackerTile(
                      tracker: element,
                    ),
                  ),
                ),
              ],
            ),
            useStickyGroupSeparators: false,
            //itemComparator: ,
            floatingHeader: false, // options
            //order: GroupedListOrder.DESC,
            groupComparator: (value1, value2) => value2.compareTo(value1),
          ),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}

/*
return ListView.builder(
      shrinkWrap: true,
      itemCount: trackers.length,
      itemBuilder: (BuildContext context, int index) => TrackerTile(tracker : trackers[index]),
    );
    */
