import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/auth/login/login_screen.dart';
import 'package:time_management_app/application_layer/auth/register/register_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toogleView() {
    setState(() => showSignIn = !showSignIn);
  }


  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(toogleView : toogleView);
    } else {
      return RegisterScreen(toogleView : toogleView);
    }
  }
}