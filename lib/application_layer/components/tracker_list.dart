import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/components/tracker_tile.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:flutter/foundation.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

import 'grouped.list.dart';

final double raidus = 0;

class TrackerList extends StatefulWidget {
  @override
  _TrackerListState createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
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
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    child:
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          )),
                    height: 68,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: kRedGradient),
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  ),
                ),
                Dismissible(
                  key: Key(element.eventID),
                  direction: DismissDirection.endToStart,

                  // background: Padding(
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         gradient: byDesignGradient),
                  //     margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  //   ),
                  // ),

                  onDismissed: (direction) {
                    setState(() {
                      DatabaseService().deleteEventbyID(element.userID,element.eventID);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.indigoAccent),
                            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                            child: Center(
                              child: Text(
                                "${element.name} dismissed",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  },
                  child: TrackerTile(
                    tracker: element,
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
