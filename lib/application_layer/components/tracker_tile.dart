import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:time_management_app/service_layer/database.dart';
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
            gradient: greyGradient),
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
                SizedBox(
                  width: 10,
                ),
                Text(
                    "${widget.tracker.startingTime} - ${widget.tracker.finishingTime}"),
                SizedBox(width: 10),
                Text("${widget.tracker.duration}"),
                SizedBox(
                  width: 10,
                ),
                // Row(
                //   children: [
                //     MaterialButton(
                //       minWidth: 0,
                //       shape: RoundedRectangleBorder(),
                //       padding: EdgeInsets.all(0),
                //       onPressed: () {

                //       },
                //       child: Icon(Icons.play_arrow_outlined),
                //     ),
                //     MaterialButton(
                //       minWidth: 0,
                //       shape: CircleBorder(),
                //       padding: EdgeInsets.all(0),
                //       onPressed: () async {
                //         // eventID = documentID
                //         DatabaseService()
                //             .deleteEventbyID(widget.tracker.eventID);
                //       },
                //       child: Icon(Icons.more_vert),
                //     ),
                //   ],
                // ),
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
