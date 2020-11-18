import 'package:cloud_firestore/cloud_firestore.dart';

class Trackers {

  final String startingTime;
  final String finishingTime;
  final String name;
  final String date;
  final String duration;
  final String userID;
  final String eventID;
  final Timestamp createdAt;

  Trackers({this.startingTime,this.finishingTime,this.name,this.date,this.duration,this.userID,this.eventID,this.createdAt});

}