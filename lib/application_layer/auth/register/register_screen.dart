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
    return loading
        ? LoadingScreen()
        : Scaffold(
          backgroundColor: Colors.brown[100],
          appBar: AppBar(
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
            title: Text("Sign up to Brew Crew"),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text("Sign in"),
                onPressed: () => widget.toogleView(),
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
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
                      "RegisterScreen",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
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
        );
  }
}
