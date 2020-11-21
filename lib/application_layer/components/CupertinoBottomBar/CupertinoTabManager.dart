import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CupertinoBottomBar.dart';

class CupertinoTabManager extends StatelessWidget {
  final TabItemEnum currentTab;

  final Map<TabItemEnum, Widget> selectedTabItem;
  final Map<TabItemEnum, GlobalKey<NavigatorState>> navigatorKeys;

  const CupertinoTabManager({
    Key key,
    @required this.currentTab,
    @required this.selectedTabItem,
    @required this.navigatorKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.transparent,
      tabBar: CupertinoTabBar(
        currentIndex: currentTab.index,
        backgroundColor: Color(0xff1f2224),
        items: TabItem.getBottomNavigationBarItems(),
        onTap: (index) => TabItemEnum.values[index],
      ),

      tabBuilder: (context, index) {
        final TabItemEnum value = TabItemEnum.values[index];

        return CupertinoTabView(
          builder: (_) => selectedTabItem[value],
          navigatorKey: navigatorKeys[value],
        );
      },
    );
  }
}
