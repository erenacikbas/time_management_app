
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoPage{
  final String pageName;
  final int index;
  final String icon;
  final Timestamp timestamp;

  TodoPage(
    {this.pageName,this.index,this.icon,this.timestamp}
  );
  
}