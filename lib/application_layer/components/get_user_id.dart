import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// shared preferences
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

void getUserID() async {
    final SharedPreferences prefs = await _prefs;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = _auth.currentUser;
    Future<String> uid =
        prefs.setString("userID", user.uid).then((bool success) {
      return user.uid;
    });
    print("***************");
    print("User uid : $uid");
    print("***************");
  }