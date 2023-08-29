import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, required this.navigatorKey, required this.item});

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget item;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => GestureDetector(
            child: item,
            onTap: () => _routeBuilders(context)[TabNavigatorRoutes.detail]!(context)
                .launch(context, pageRouteAnimation: PageRouteAnimation.Scale),
          ),

      TabNavigatorRoutes.detail: (context) => const Center(
            child: Text('Detail', style: TextStyle(fontSize: 60.0,color: Colors.teal,fontWeight: FontWeight.bold)),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
