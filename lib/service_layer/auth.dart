
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  
  // firebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      User user = result.user;

      // create a new document for the user with uid
      // await DatabaseService(uid: user.uid)
      // .updateUserData("10.30", "10.50", "Writing this app", "08.11.2020","20");
      //return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      // if there's any problem return null
      return null;
    }
  }

  


}




// New Function for Great Tracker

Stream<User> authState () {
  FirebaseAuth _auth = FirebaseAuth.instance;
   _auth.
  authStateChanges().
  listen((User user) { 
    if(user == null) {
      print("User is currently signed out!");
    } else {
      print("User is signed in!");
    }
  });
}