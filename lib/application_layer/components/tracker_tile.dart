import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:time_management_app/shared/constants.dart';


class TrackerTile extends StatefulWidget {
  final Trackers tracker;
  TrackerTile({this.tracker});

  @override
  _TrackerTileState createState() => _TrackerTileState();
}

class _TrackerTileState extends State<TrackerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
            gradient: greyGradient
            //color: Color(0xff979ca0)
            ),
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${widget.tracker.name}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                Expanded(child: Container(),),
                // Text(
                //     "${widget.tracker.startingTime} - ${widget.tracker.finishingTime}"),
                Text("${widget.tracker.duration}"),
                SizedBox(
                  width: 10,
                ),
               
              ],
            ),
          ),
        ),
        /*
        ListTile(
          title: Text(tracker.name),
          subtitle: Text("${tracker.startingTime} - ${tracker.finishingTime}"),
        ), */
      ),
    );
  }
}
