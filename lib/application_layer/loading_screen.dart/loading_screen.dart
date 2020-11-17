import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    /*String logoName;

    if (width <= 480) {
      print("girdi 1");
      logoName = "mdpi.png";
    } else if (width <= 600) {
      print("girdi 2");
      logoName = "hdpi.png";
    } else if (width <= 720) {
      print("girdi 3");
      logoName = "xhdpi.png";
    } else if (width <= 720) {
      logoName = "xxhdpi.png";
    }*/

    /*
    Image(
          image: AssetImage("assets/images/LoadingScreen/$logoName"),
      )
    */
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
