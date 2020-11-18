import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';



class DatabaseService {
  // shared preferences
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // final String uid;
  // DatabaseService({this.uid});

  // collection reference
  final CollectionReference trackersCollection =
      Firestore.instance.collection("trackers");

  // Future createNewUser() async {
  //   return await trackersCollection.add({"uid": uid});
  // }

  Future updateUserData(String startingTime, String finishingTime, String name,
      String date, String duration, String userID, String eventID) async {
    return await trackersCollection.doc(eventID).set(
      {
      "starting_time": startingTime,
      "finishing_time": finishingTime,
      "name": name,
      "date": date,
      "duration": duration,
      "userID": userID,
      "eventID": eventID,
    });
  }

  // trackers list from snapshot
  List<Trackers> _trackersListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Trackers(
        startingTime: doc.data()["starting_time"],
        finishingTime: doc.data()["finishing_time"],
        name: doc.data()["name"],
        date: doc.data()["date"],
        duration: doc.data()["duration"],
        userID: doc.data()["userID"],
        eventID: doc.data()["eventID"],
      );
    }).toList();
  }

  // user data from snapshot
  // UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
  //   return UserData(
  //     uid: uid,
  //     startingTime: snapshot.data["starting_time"],
  //     finishingTime: snapshot.data["finishing_time"],
  //     name: snapshot.data["name"],
  //     date: snapshot.data["date"],
  //     duration: snapshot.data["duration"],
  //   );
  // }

  //   Future sortUserData() {
  //   return Firestore.instance
  //       .collection('trackers')
  //       .where('userID', isEqualTo: userID)
  //       .getDocuments().then((value) {
  //         print(value.documents.map((e) {print(e);}));
  //       });
  // }

  // get trackers stream
  Stream<List<Trackers>> get trackers {
    return trackersCollection.snapshots().map(_trackersListFromSnapShot);
  }

  Future<String> get sharedPreferences async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString("userID"));
    return await prefs.getString("userID");
  }

  Stream<List<Trackers>> trackersFromFilteredData(String userID) {
    return trackersCollection
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map(_trackersListFromSnapShot);
  }


  
  // // get user doc stream
  // Stream<UserData> get userData {
  //   return trackersCollection
  //       .document(uid)
  //       .snapshots()
  //       .map(_userDataFromSnapShot);
  // }

  // Remove event with EventID
  Future<void> deleteEventbyID(documentID) async{
    return trackersCollection
        .doc(documentID)
        .delete()
        .then((value) => print("Selected Event: documentID Deleted!"))
        .catchError((error) => print("Failed to delete user: $error")); 
  }

  //New Functions

}
