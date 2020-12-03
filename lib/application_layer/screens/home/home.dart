import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/application_layer/screens/profile/profile.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream: DatabaseService().userData(user.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return LoadingScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  kAppBarTitle,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Profile()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0, bottom: 5),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "${snapshot.data[0].profilePicture == "" ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLuECLXQrCdU1e1npz8Y0NAHi7xqilHSa2DVrpWVDDmGWSz3W_5ApcsAjRPeW37__YUvcGQlxYca1jBhcWgAV0CLHtWbv09qU&usqp=CAU&ec=45730948" : snapshot.data[0].profilePicture}"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 35, top: 30),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: gradientByTime(greeting()),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Good ${greeting()}, ${snapshot.data[0].name} 👋",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 38),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour > 6 && hour < 12) {
    return "Morning";
  } else if (hour < 20) {
    return "Afternoon";
  } else {
    return "Evening";
  }
}

LinearGradient gradientByTime(String time) {
  LinearGradient gradient;
  if (time == "Morning") {
    gradient = kMorningGradient;
  } else if (time == "Afternoon") {
    gradient = kIbizaSunset;
  } else if (time == "Evening") {
    gradient = kEveningGradient;
  }
  print(gradient);
  return gradient;
}
