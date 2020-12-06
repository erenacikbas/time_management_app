import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/components/Skeletons/todo_skeleton_card.dart';
import 'package:time_management_app/application_layer/screens/todos/todo_sliver_app_bar.dart';
import 'package:time_management_app/providers/dark_theme_provider.dart';

class TodoSkeletonPage extends StatelessWidget {
  const TodoSkeletonPage({
    Key key,
    @required this.themeChange,
    @required this.textEditingController,
    @required this.todo,
    @required this.user,
  }) : super(key: key);

  final DarkThemeProvider themeChange;
  final TextEditingController textEditingController;
  final String todo;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // TodoSliverAppBar(
          //     themeChange: themeChange,
          //     textEditingController: textEditingController,
          //     todo: todo,
          //     user: user),
          TodoCardSkeleton(),
        ],
      ),
    );
  }
}
