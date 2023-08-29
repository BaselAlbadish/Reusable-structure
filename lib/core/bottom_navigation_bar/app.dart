import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:structure/core/bottom_navigation_bar/tab_item.dart';
import 'package:structure/core/bottom_navigation_bar/tab_navigator.dart';
import 'package:structure/main.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  Widget _currentTab = tabs[0];
  int _selectedIndex = 0;
  final _navigatorKeys = {
    tabs[0]: GlobalKey<NavigatorState>(),
    tabs[1]: GlobalKey<NavigatorState>(),
    tabs[2]: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != tabs[0]) {
            _navigatorKeys[widget]!.currentState!.popUntil((route) => route.isFirst);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator(tabs[0]),
            _buildOffstageNavigator(tabs[1]),
            _buildOffstageNavigator(tabs[2]),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: context.theme.primaryColor,
          items: [],
          onTap: (index) {
            if (tabs[index] == _currentTab) {
              _navigatorKeys[tabs[index]]!.currentState!.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                _selectedIndex = index;
                _currentTab = tabs[index];
              });
            }
          },
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(Widget widget) {
    return Offstage(
      offstage: _currentTab != widget,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[widget],
        item: widget,
      ),
    );
  }
}
