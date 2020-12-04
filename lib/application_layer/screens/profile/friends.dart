import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/application_layer/loading_screen.dart/loading_screen.dart';
import 'package:time_management_app/application_layer/models/users.dart';
import 'package:time_management_app/service_layer/database.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: DatabaseService().userData(user.uid),
        builder: (BuildContext context,AsyncSnapshot friends) {
          print(friends.data[0].friends.length);
          if (friends.data[0].friends.length == 0) {
            return Text(
              "You don't have any friend",
              style: TextStyle(color: Colors.white),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: friends.data[0].friends.length,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder<List<Users>>(
                  stream: DatabaseService()
                      .findMatchedUser(friends.data[0].friends[index]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(snapshot.data[0].name),
                            leading: CircleAvatar(
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
                      );
                    } else {
                      return LoadingScreen();
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
