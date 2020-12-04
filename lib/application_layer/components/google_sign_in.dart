import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_management_app/service_layer/database.dart';

//Google Sign-in
final GoogleSignIn googleSignIn = GoogleSignIn();
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = FirebaseAuth.instance.currentUser;
  assert(user.uid == currentUser.uid);

  int min = 100000; //min and max values act as your 6 digit range
  int max = 999999;
  var randomizer = new Random();
  var rNum = min + randomizer.nextInt(max - min);

  if (FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .id
      .isEmpty) {
    DatabaseService().updateUserData(currentUser.displayName, currentUser.email,
        currentUser.photoURL, [], currentUser.uid, rNum, Timestamp.now());
  } else {
    print("user has already been created on database");
  }

  return 'signInWithGoogle succeeded: $user';
}
