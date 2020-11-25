import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/shared/constants.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _users = Provider.of<List<Users>>(context) ?? [];
    final user = _users[0];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          kAppBarTitle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0,bottom: 5),
            child: CircleAvatar(
              backgroundColor: Colors.indigoAccent,
              radius: 24,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "${user.profilePicture.isEmpty ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLuECLXQrCdU1e1npz8Y0NAHi7xqilHSa2DVrpWVDDmGWSz3W_5ApcsAjRPeW37__YUvcGQlxYca1jBhcWgAV0CLHtWbv09qU&usqp=CAU&ec=45730948" : user.profilePicture}"),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 30),
          child: Column(
            children: [
              Text(
                "$kWelcomeHeading${user.name} 👋",
                style: kWelcomeHeadingStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
