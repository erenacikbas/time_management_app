import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/shared/constants.dart';

class LoginScreen extends StatefulWidget {
  final Function toogleView;
  LoginScreen({this.toogleView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = "";

  // shared preferences
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // text field state
  String email = "";
  String password = "";

  //FirebaseAuth
  FirebaseAuth _authInstance = FirebaseAuth.instance;

  void getUserID() async {
    final SharedPreferences prefs = await _prefs;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = await _auth.currentUser;
    Future<String> uid =
        prefs.setString("userID", user.uid).then((bool success) {
      return user.uid;
    });
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.brown[100],
              appBar: AppBar(
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                title: Text("Sign in to Brew Crew"),
                actions: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text("Register"),
                    onPressed: () => widget.toogleView(),
                  )
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Email"),
                        validator: (val) =>
                            val.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Password"),
                        validator: (val) => val.length < 6
                            ? "Enter a password 6+ chars long"
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);

                            if (result == null) {
                              print("$email and $password");
                              setState(() {
                                error =
                                    "could not sign in with those credentials.";
                                loading = false;
                              });
                            }
                            getUserID();
                          }
                        },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
