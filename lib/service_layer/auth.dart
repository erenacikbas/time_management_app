import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';

class AuthService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _userID;
  // firebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // create user obj base on FireBaseUser
  // User _userFromFirebaseUser(FirebaseUser user) {
  //   return user != null ? User(uid: user.uid) : null;
  // }

  // auth change user stream
  // Stream<User> get user {
  //   return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  // }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    int min = 100000; //min and max values act as your 6 digit range
                int max = 999999;
                var randomizer = new Random(); 
                var rNum = min + randomizer.nextInt(max - min);
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (DatabaseService().userData(user.uid) == null) {
        DatabaseService().updateUserData(
            _auth.currentUser.displayName,
            _auth.currentUser.email,
            _auth.currentUser.photoURL,
            [],
            _auth.currentUser.uid,
            rNum,
            Timestamp.now());
      }

      //return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password, String name) async {
    int min = 100000; //min and max values act as your 6 digit range
                int max = 999999;
                var randomizer = new Random(); 
                var rNum = min + randomizer.nextInt(max - min);
    
    _userID = _prefs.then((SharedPreferences preferences) {
      return (preferences.getString("userID") ?? "");
    });
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      User user = result.user;

      // UserCredential result = await _auth.createUserWithEmailAndPassword(
      //     email: email, password: password);
      // User user = result.user;
      DatabaseService().updateUserData(
          name,
          user.email,
          "",
          [],
          user.uid,
          rNum,
          Timestamp.now());

      // create a new document for the user with uid
      // await DatabaseService(uid: user.uid)
      // .updateUserData("10.30", "10.50", "Writing this app", "08.11.2020","20");
      //return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      // if there's any problem return null
      return null;
    }
  }

  Future googleSignOut() async {
    try {
      return await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
    }
    // if there's any problem return null
    return null;
  }
}

// New Function for Great Tracker

// Stream<User> authState() {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   _auth.authStateChanges().listen((User user) {
//     if (user == null) {
//       print("User is currently signed out!");
//     } else {
//       print("User is signed in!");
//     }
//   });
// }
