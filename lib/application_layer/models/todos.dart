import 'package:cloud_firestore/cloud_firestore.dart';

class Todos {
  final Timestamp createdAt;
  final String eventID;
  final bool isDone;
  final String task;
  final String userID;

  Todos({this.createdAt,this.eventID,this.isDone,this.task,this.userID});
}