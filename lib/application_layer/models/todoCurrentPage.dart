import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/models/todoPage.dart';

class TodoPageSettings {
  final int currentIndex;
  final String userID;
  final int pageAmount;
  TodoPageSettings({
    this.currentIndex,
    this.userID,
    this.pageAmount,
  });
}
