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

  DatabaseService().updateUserData(
      currentUser.displayName,
      currentUser.photoURL,
      [],
      currentUser.uid,
      currentUser.tenantId,
      Timestamp.now());
  //getUserID();

  return 'signInWithGoogle succeeded: $user';
}
