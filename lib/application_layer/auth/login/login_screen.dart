import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_management_app/application_layer/components/get_user_id.dart';
import 'package:time_management_app/application_layer/components/google_sign_in.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // text field state
  String email = "";
  String password = "";

  //FirebaseAuth



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return loading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigoAccent,
              elevation: 0.0,
              title: Text("Great Tracker"),
              // actions: <Widget>[
              //   FlatButton.icon(
              //     icon: Icon(Icons.person),
              //     label: Text("Register"),
              //     onPressed: () => widget.toogleView(),
              //   )
              // ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) => val.isEmpty ? "Enter an email" : null,
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    InkWell(
                      child: Container(
                          width: width / 3,
                          height: height / 18,
                          margin: EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.indigoAccent),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                      onTap: () async {
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
                    SizedBox(height: 10),
                    GestureDetector(
                        onTap: () => widget.toogleView(),
                        child: Text("Don't you have an account ? Register")),
                    SizedBox(height: 10),
                    //Sign in with Google
                    InkWell(
                      child: Container(
                          width: width / 1.7,
                          height: height / 18,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/google_logo.png'),
                                      fit: BoxFit.contain),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                      onTap: () => signInWithGoogle(),
                    ),
                    //Sign in with Apple
                    // InkWell(
                    //   child: Container(
                    //       width: width / 1.7,
                    //       height: height / 18,
                    //       margin: EdgeInsets.only(top: 10),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: Colors.black),
                    //       child: Center(
                    //           child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           Container(
                    //             height: 25.0,
                    //             width: 25.0,
                    //             decoration: BoxDecoration(
                    //               image: DecorationImage(
                    //                   image:
                    //                       AssetImage('assets/apple_logo.png'),
                    //                   fit: BoxFit.contain),
                    //               shape: BoxShape.circle,
                    //             ),
                    //           ),
                    //           SizedBox(width: 15,),
                    //           Text(
                    //             'Sign in with Apple',
                    //             style: TextStyle(
                    //                 fontSize: 16.0,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white),
                    //           ),
                    //         ],
                    //       ))),
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ),
            ),
          );
  }
}
