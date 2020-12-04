import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/models/todos.dart';
import 'package:time_management_app/application_layer/models/trackers.dart';
import 'package:time_management_app/application_layer/models/users.dart';

class DatabaseService {
  // shared preferences
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // final String uid;
  // DatabaseService({this.uid});

  // * trackers collection reference
  final CollectionReference userDocuments =
      FirebaseFirestore.instance.collection("userDoc");

  // * collection reference for users
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  // Future createNewUser() async {

  //   return await trackersCollection.add({"uid": uid});
  // }
  Future updateTrackersData(
      String startingTime,
      String finishingTime,
      String name,
      String date,
      String duration,
      String userID,
      String eventID,
      Timestamp timeStamp) async {
    return await userDocuments
        .doc(userID)
        .collection("trackers")
        .doc(eventID)
        .set({
      "starting_time": startingTime,
      "finishing_time": finishingTime,
      "name": name,
      "date": date,
      "duration": duration,
      "userID": userID,
      "eventID": eventID,
      "createdAt": timeStamp,
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
        createdAt: doc.data()["timeStamp"],
      );
    }).toList();
  }

  // update TODOs
  Future updateTODO(Timestamp createdAt, String eventID, bool isDone,
      String task, String userID) async {
    return await userDocuments
        .doc(userID)
        .collection("todos")
        .doc(eventID)
        .set({
      "createdAt": createdAt,
      "eventID": eventID,
      "isDone": isDone,
      "todo": task,
      "userID": userID,
    });
  }

  List<TodoItems> _todosListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TodoItems(
        createdAt: doc.data()["createdAt"],
        eventID: doc.data()["eventID"],
        todo: doc.data()["todo"],
        isDone: doc.data()["isDone"],
        userID: doc.data()["userID"],
      );
    }).toList();
  }

  // ************************************

  // userID from sharedPreferences
  Future<String> get sharedPreferences async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString("userID"));
    return prefs.getString("userID");
  }

  Stream<List<Trackers>> trackersFromFilteredData(String userID) {
    return FirebaseFirestore.instance
        .collection("userDoc")
        .doc(userID)
        .collection("trackers")
        .orderBy("createdAt", descending: true)
        //.where("userID", isEqualTo: userID)
        .snapshots()
        .map(_trackersListFromSnapShot);
  }

  // Remove event with EventID
  Future<void> deleteEventbyID(userID, documentID) async {
    return userDocuments
        .doc(userID)
        .collection("trackers")
        .doc(documentID)
        .delete()
        .then((value) => print("Selected Event: documentID Deleted!"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // ************************************

  // // * Todos
  // // get todos stream
  // Stream<List<TodoItems>> get todos {
  //   return todosCollection.snapshots().map(_todosListFromSnapshot);
  // }

  // user specified todos
  Stream<List<TodoItems>> todosFromFilteredData(String userID) {
    return userDocuments
        .doc(userID)
        .collection("todos")
        //.orderBy("createdAt", descending: true)
        .where("isDone", isEqualTo: false)
        //.where("userID", isEqualTo: userID)
        .snapshots()
        .map(_todosListFromSnapshot);
  }

  Stream<List<TodoItems>> doneTodos(String userID) {
    return userDocuments
        .doc(userID)
        .collection("todos")
        .where("isDone", isEqualTo: true)
        //.orderBy("createdAt", descending: true)
        .snapshots()
        .map(_todosListFromSnapshot);
  }

  Future<void> deleteTodoByEventID(userID, documentID) async {
    return userDocuments
        .doc(userID)
        .collection("todos")
        .doc(documentID)
        .delete()
        .then((value) => print("Selected Event: documentID Deleted!"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // set isDone true
  Future<void> setIsDoneTrue(userID, documentID) async {
    return userDocuments
        .doc(userID)
        .collection("todos")
        .doc(documentID)
        .update({"isDone": true});
  }

  Future<void> setIsDoneFalse(userID, documentId) async {
    return userDocuments
        .doc(userID)
        .collection("todos")
        .doc(documentId)
        .update({"isDone": false});
  }

  // ************************************

  // ************************************

  // * Getting profile data with userID

  Stream<List<Users>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Users>> userData(String userID) {
    return usersCollection
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map(_userListFromSnapshot);
  }

  Stream<List<Users>> findMatchedUser(int userCode) {
    return usersCollection
        .where("userCode", isEqualTo: userCode)
        .snapshots()
        .map(_userListFromSnapshot);
  }

  Future updateUserData(
    String name,
    String email,
    String profilePicture,
    List<String> friends,
    String userID,
    int userCode,
    Timestamp createdAt,
  ) async {
    return await usersCollection.doc(userID).set({
      "name": name,
      "email": email,
      "profilePicture": profilePicture,
      "userID": userID,
      "userCode": userCode,
      "friends": friends,
      "createdAt": createdAt,
    });
  }

  List<Users> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Users(
        createdAt: doc.data()["craetedAt"],
        email: doc.data()["email"],
        friends: doc.data()["friends"],
        name: doc.data()["name"],
        userCode: doc.data()["userCode"],
        userID: doc.data()["userID"],
        profilePicture: doc.data()["profilePicture"],
      );
    }).toList();
  }

  // ************************************
}
