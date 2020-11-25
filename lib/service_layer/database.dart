
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
  final CollectionReference trackersCollection =
      FirebaseFirestore.instance.collection("trackers");

  // * ordered collection for trackers
  final Query orderedCollection = FirebaseFirestore.instance
      .collection("trackers")
      .orderBy("createdAt", descending: true);

  // * collection reference for todos
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection("todos");

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
    return await trackersCollection.doc(eventID).set({
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
    return await todosCollection.doc(eventID).set({
      "createdAt": createdAt,
      "eventID": eventID,
      "isDone": isDone,
      "task": task,
      "userID": userID,
    });
  }

  List<Todos> _todosListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todos(
        createdAt: doc.data()["craetedAt"],
        eventID: doc.data()["eventID"],
        task: doc.data()["task"],
        isDone: doc.data()["isDone"],
        userID: doc.data()["userID"],
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

  // * Trackers
  // get trackers stream
  Stream<List<Trackers>> get trackers {
    return orderedCollection.snapshots().map(_trackersListFromSnapShot);
  }

  // ************************************

  // userID from sharedPreferences
  Future<String> get sharedPreferences async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getString("userID"));
    return prefs.getString("userID");
  }

  Stream<List<Trackers>> trackersFromFilteredData(String userID) {
    return orderedCollection
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map(_trackersListFromSnapShot);
  }

  // Remove event with EventID
  Future<void> deleteEventbyID(documentID) async {
    return trackersCollection
        .doc(documentID)
        .delete()
        .then((value) => print("Selected Event: documentID Deleted!"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // ************************************

  // * Todos
  // get todos stream
  Stream<List<Todos>> get todos {
    return todosCollection.snapshots().map(_todosListFromSnapshot);
  }

  // user specified todos
  Stream<List<Todos>> todosFromFilteredData(String userID) {
    return todosCollection
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map(_todosListFromSnapshot);
  }

  // set isDone true
  Future<void> setIsDoneTrue(documentID) async {
    return todosCollection.doc(documentID).set({"isDone": true});
  }

  // ************************************

  // ************************************

  // * Getting profile data with userID

  Stream<List<Users>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  Future updateUserData(
    String name,
    String email,
    String profilePicture,
    List<String> friends,
    String userID,
    String userName,
    Timestamp createdAt,
  ) async {
    return await usersCollection.doc(userID).set({
      "name": name,
      "email": email,
      "profilePicture" : profilePicture,
      "userID" : userID,
      "userName" : userName,
      "friends" : friends,
      "createdAt" : createdAt,
    });
  }

  List<Users> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Users(
        createdAt: doc.data()["craetedAt"],
        email: doc.data()["email"],
        friends: doc.data()["friends"],
        name: doc.data()["name"],
        userName: doc.data()["userName"],
        userID: doc.data()["userID"],
        profilePicture: doc.data()["profilePicture"],
      );
    }).toList();
  }



   Stream<List<Users>> userData(String userID) {
    return usersCollection
        .where("userID", isEqualTo: userID)
        .snapshots()
        .map(_userListFromSnapshot);
  }

  // ************************************
}
