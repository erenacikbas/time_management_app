import 'package:flutter/material.dart';
import 'package:time_management_app/shared/constants.dart';

class RedDeleteBox extends StatelessWidget {
  const RedDeleteBox({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 30.0),
              child: Icon(Icons.delete,
                  color: Colors.white),
            )),
        height: height / 12,
        margin: EdgeInsets.fromLTRB(
            20.0, 6.0, 20.0, 0.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(12),
          gradient: kRedGradient,
          //color: Color(0xff979ca0)
        ),
      ),
    );
  }
}
