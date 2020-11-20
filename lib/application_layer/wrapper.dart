import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/screens/home/home.dart';

import 'auth/auth_management/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authStatus = Provider.of<FirebaseAuth>(context).currentUser();
    //print(user);

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (ModalRoute.of(context).isCurrent == true) {
            print("snapshot is ==========> ${snapshot.data}");
            if (snapshot.data == null) {
              return Authenticate();
            } else {
              return Home();
            }
          }else {
             return LoadingScreen();
          }
        });

    // if (true == null) {
    //       return Authenticate();
    //     } else {R
    //       return Home();
    //     }
  }
}
