import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String userID;
  final String userName;
  final String profilePicture;
  final String name;
  final List<dynamic> friends;
  final Timestamp createdAt;

  Users(
      {this.userID,
      this.userName,
      this.profilePicture,
      this.name,
      this.friends,
      this.createdAt});
}
