import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/home/home.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';

import 'application_layer/auth/auth_management/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    //final authStatus = Provider.of<FirebaseAuth>(context).currentUser();
    //print(user);

    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
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
