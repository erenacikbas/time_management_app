import 'package:flutter/material.dart';
import 'package:time_management_app/application_layer/screens/analyze/analyze.dart';
import 'package:time_management_app/application_layer/screens/home/home.dart';
import 'package:time_management_app/application_layer/screens/trackers/trackers_screen.dart';
import 'package:time_management_app/application_layer/screens/profile/profile.dart';
import 'package:time_management_app/application_layer/screens/todos/todos.dart';

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
            color: Color(0xffFFE44B)
          ),
          icon: Icon(
            Icons.view_agenda,
            size: 30,
            color: Colors.white,
          )),
      // * TODOs
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.rule,
            size: 30,
            color: Color(0xffFFE44B),
          ),
          icon: Icon(
            Icons.rule,
            size: 30,
            color: Colors.white,
          )),
      // * Home - Dashboard
      BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          size: 30,
          color: Color(0xffFFE44B),
        ),
        icon: Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
      ),
      // * Analyze
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.assessment,
            size: 30,
            color: Color(0xffFFE44B),
          ),
          icon: Icon(
            Icons.assessment,
            size: 30,
            color: Colors.white,
          )),
      // * Profile
      BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.person,
            size: 30,
            color: Color(0xffFFE44B),
          ),
          icon: Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
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
