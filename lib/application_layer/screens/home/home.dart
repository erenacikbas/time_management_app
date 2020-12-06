import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/components/Charts/bar_charts/large_bar_chart.dart';
import 'package:time_management_app/application_layer/components/Charts/bar_charts/small_bar_chart.dart';
import 'package:time_management_app/application_layer/components/Charts/pie_charts/pie_chart_1.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/screens/profile/profile.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;
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
                    padding: const EdgeInsets.only(right: 34.0, bottom: 5),
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
                padding: const EdgeInsets.only(left: 0, right: 0, top: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              //gradient: gradientByTime(greeting()),
                              color: themeChange.darkTheme
                                  ? Color(0xff16162f)
                                  : Color(0xff191d21),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Good ${greeting()}, ${snapshot.data[0].name} 👋",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 10, 5, 10),
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: Container(
                                        height: height / 6.5,
                                        width: height / 6.5,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // old yellow.accent
                                            color: Colors.amber),
                                      )),
                                      Center(
                                        child: Container(
                                          height: height / 8,
                                          width: height / 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: themeChange.darkTheme
                                                ? Color(0xff16162f)
                                                : Color(0xff191d21),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "5\nTasks",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: themeChange.darkTheme
                                        ? Color(0xff16162f)
                                        : Color(0xff191d21),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 10, 25, 10),
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: Container(
                                        height: height / 6.5,
                                        width: height / 6.5,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.cyan),
                                      )),
                                      Center(
                                        child: Container(
                                          height: height / 8,
                                          width: height / 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: themeChange.darkTheme
                                                ? Color(0xff16162f)
                                                : Color(0xff191d21),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "8\nHours",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: themeChange.darkTheme
                                        ? Color(0xff16162f)
                                        : Color(0xff191d21),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: BarChartSample3(),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: AspectRatio(
                      //         aspectRatio: 3,
                      //         child: Padding(
                      //           padding:
                      //               const EdgeInsets.fromLTRB(25, 0, 25, 20),
                      //           child: Container(
                      //             // child: Row(
                      //             //   mainAxisAlignment: MainAxisAlignment.center,
                      //             //   children: [
                      //             //     Icon(Icons.add,size: 30),
                      //             //     Text("Add Quick Todo",style: TextStyle(color: Colors.white,fontSize: 30),),
                      //             //   ],
                      //             // ),
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(15),
                      //                 color: Color(0xff16162f)),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
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
