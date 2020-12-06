import 'package:flutter/material.dart';

class CompletedTaskHeader extends StatelessWidget {
  CompletedTaskHeader({
    Key key, this.doneTodos,
  }) : super(key: key);
  final AsyncSnapshot<dynamic> doneTodos;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Visibility(
          //key: Key("Heading Key"),
          visible: ((doneTodos.data.length) ?? false) == 0
              ? false
              : true,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 40.0, top: 10),
            child: Text(
              "Completed",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    );
  }
}