import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItems {
  final Timestamp createdAt;
  final String eventID;
  final bool isDone;
  final String todo;
  final String userID;

  TodoItems({this.createdAt,this.eventID,this.isDone,this.todo,this.userID});
}