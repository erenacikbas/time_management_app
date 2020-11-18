import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/components/tracker_tile.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (context, dynamic element) => TrackerTile(
            tracker: element,
          ),
          useStickyGroupSeparators: false,
          //itemComparator: ,
          floatingHeader: false, // options
          //order: GroupedListOrder.DESC,
          groupComparator: (value1, value2) => value2.compareTo(value1),
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
