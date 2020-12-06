// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:time_management_app/application_layer/components/tracker_adder.dart';
// import 'package:time_management_app/providers/dark_theme_provider.dart';
// import 'package:time_management_app/service_layer/database.dart';
// import 'package:time_management_app/shared/constants.dart';

// class TodoSliverAppBar extends StatelessWidget {
//   TodoSliverAppBar({
//     Key key,
//     @required this.themeChange,
//     @required this.textEditingController,
//     @required this.todo,
//     @required this.user,
//   }) : super(key: key);

//   final DarkThemeProvider themeChange;
//   final TextEditingController textEditingController;
//   String todo;
//   final User user;

//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       centerTitle: false,
//       title: Padding(
//         padding: const EdgeInsets.only(left: 24.0),
//         child: Text("Todos"),
//       ),
//       actions: [
//         CupertinoButton(
//           onPressed: () {
//             showModalBottomSheet(
//                 backgroundColor: Colors.transparent,
//                 elevation: 10,
//                 context: context,
//                 builder: (BuildContext context) =>
//                     StatefulBuilder(
//                       builder: (BuildContext context,
//                           StateSetter setState) {
//                         return Container(
//                           child: Column(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                             children: [
//                               ListTile(
//                                   leading: Padding(
//                                     padding:
//                                         const EdgeInsets.only(
//                                             left: 30.0,
//                                             top: 5),
//                                     child: Icon(
//                                       Icons
//                                           .radio_button_off_outlined,
//                                       color: themeChange
//                                               .darkTheme
//                                           ? Colors.grey
//                                           : Colors.black,
//                                     ),
//                                   ),
//                                   contentPadding:
//                                       EdgeInsets.all(20),
//                                   title: TextFormField(
//                                     style: TextStyle(
//                                         color: themeChange
//                                                 .darkTheme
//                                             ? Colors.white
//                                             : Colors.black),
//                                     controller:
//                                         textEditingController,
//                                     decoration: kAddingTodoInputDecoration.copyWith(
//                                         hintStyle: TextStyle(
//                                             color: themeChange
//                                                     .darkTheme
//                                                 ? Colors.grey
//                                                 : Colors
//                                                     .black,
//                                             fontWeight:
//                                                 FontWeight
//                                                     .w400),
//                                         hintText:
//                                             "Add a Task"),
//                                     onChanged: (_) {
//                                       setState(() {
//                                         todo = _;
//                                         print(todo);
//                                       });
//                                     },
//                                     textInputAction:
//                                         TextInputAction.done,
//                                     onFieldSubmitted:
//                                         (value) {
//                                       setState(() {
//                                         todo = value;
//                                         DatabaseService()
//                                             .updateTODO(
//                                                 Timestamp
//                                                     .now(),
//                                                 uuid.v1(),
//                                                 false,
//                                                 todo,
//                                                 user.uid);
//                                         print(todo);
//                                         //textEditingController.clear();
//                                         Navigator.pop(
//                                             context);
//                                       });
//                                     },
//                                   )),
//                             ],
//                           ),
//                           decoration: BoxDecoration(
//                               color: themeChange.darkTheme
//                                   ? Color(0xff1a1c22)
//                                   : Colors.white,
//                               borderRadius: BorderRadius.only(
//                                   topLeft:
//                                       Radius.circular(30),
//                                   topRight:
//                                       Radius.circular(30))),
//                           height: MediaQuery.of(context)
//                                   .size
//                                   .height /
//                               6,
//                           width: double.infinity,
//                         );
//                       },
//                     ));
//           },
//           child: Icon(
//             Icons.add,
//           ),
//         ),
//       ],
//     );
//   }
// }

