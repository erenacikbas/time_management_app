import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/screens/analyze/analyze.dart';
import 'package:time_management_app/application_layer/screens/home/home.dart';
import 'package:time_management_app/application_layer/screens/trackers/trackers_screen.dart';
import 'package:time_management_app/application_layer/screens/profile/profile.dart';
import 'package:time_management_app/application_layer/screens/todos/todos_screen.dart';

enum TabItemEnum { Trackers, Todos,Home, Analyze, Profile }

class TabItem {
  static List<BottomNavigationBarItem> getBottomNavigationBarItems() {
    final List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();

    items.addAll([
      // * Trackers
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.view_agenda,
            size: 30,
            //Color(0xffFFE44B)
            //color: Colors.black
          ),
          icon: Icon(
            Icons.view_agenda_outlined,
            size: 30,
            //color: Colors.black
          )),
      // * TODOs
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.rule_outlined,
            size: 31,
            //color: Colors.black,
          ),
          icon: Icon(
            Icons.rule,
            
            size: 30,
            //color: Colors.black,
          )),
      // * Home - Dashboard
      BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          size: 30,
          //color: Colors.black,
        ),
        icon: Icon(
          Icons.home_outlined,
          size: 30,
          //color: Colors.black,
        ),
      ),
      // * Analyze
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.assessment,
            size: 30,
            //color: Colors.black,
          ),
          icon: Icon(
            Icons.assessment_outlined,
            size: 30,
            //color: Colors.black,
          )),
      // * Profile
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.person,
            size: 30,
            //color: Colors.black,
          ),
          icon: Icon(
            Icons.person_outline,
            size: 30,
            //color: Colors.black,
          )),
    ]);

    return items;
  }

  static Map<TabItemEnum, Widget> getSelectedPage() {
    return {
      TabItemEnum.Trackers: TrackerScreen(),
      TabItemEnum.Todos: Todos(),
      TabItemEnum.Home: Home(),
      TabItemEnum.Analyze: Analyze(),
      TabItemEnum.Profile: Profile(),
    };
  }

  static Map<TabItemEnum, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItemEnum.Trackers: GlobalKey<NavigatorState>(),
    TabItemEnum.Todos: GlobalKey<NavigatorState>(),
    TabItemEnum.Home: GlobalKey<NavigatorState>(),
    TabItemEnum.Analyze: GlobalKey<NavigatorState>(),
    TabItemEnum.Profile: GlobalKey<NavigatorState>(),
  };
}
