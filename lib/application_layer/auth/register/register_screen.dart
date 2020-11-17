import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/service_layer/auth.dart';
import 'package:time_management_app/shared/constants.dart';

class RegisterScreen extends StatefulWidget {
  final Function toogleView;
  RegisterScreen({this.toogleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
              //     label: Text("Sign in"),
              //     onPressed: () => widget.toogleView(),
              //   ),
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
                      height: 20,
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
                      height: 20,
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
                                'Register',
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
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = "please supply a valid email";
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    // RaisedButton(
                    //   color: Colors.indigoAccent,
                    //   child: Text(
                    //     "Register",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   onPressed: () async {
                    //     if (_formKey.currentState.validate()) {
                    //       setState(() => loading = true);
                    //       dynamic result = await _auth
                    //           .registerWithEmailAndPassword(email, password);
                    //       if (result == null) {
                    //         setState(() {
                    //           error = "please supply a valid email";
                    //           loading = false;
                    //         });
                    //       }
                    //     }
                    //   },
                    // ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    GestureDetector(
                        onTap: () => widget.toogleView(),
                        child: Text("Do you have an account ? Sign in"))
                  ],
                ),
              ),
            ),
          );
  }
}
