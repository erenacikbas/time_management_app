import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItems {
  final Timestamp createdAt;
  final String eventID;
  final bool isDone;
  final String todo;
  final int pos;
  final String userID;
  final String page;

  TodoItems(
      {this.createdAt,
      this.eventID,
      this.isDone,
      this.todo,
      this.userID,
      this.pos,
      this.page});
}
