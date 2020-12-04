import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String userID;
  final String email;
  final int userCode;
  final String profilePicture;
  final String name;
  final List<dynamic> friends;
  final Timestamp createdAt;

  Users(
      {this.userID,
      this.email,
      this.userCode,
      this.profilePicture,
      this.name,
      this.friends,
      this.createdAt});
}
