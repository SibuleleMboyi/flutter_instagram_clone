import 'package:flutter/material.dart';
import 'package:flutter_instagram/enums/enum.dart';
import 'package:flutter_instagram/screens/screen.dart';

class TabNavigator extends StatelessWidget {

  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key key,
    this.navigatorKey,
    this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Allows to switch between Bottom Nav Items without losing the state of each stack

    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute){
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          )
        ];
      },

      //onGenerateRoute: CustomRouter.onGenerateNestedRoute(settings),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(){
    return {
      tabNavigatorRoot: (context) => _getScreen(context, item)
    };
  }

  Widget _getScreen(BuildContext context, BottomNavItem item){
    switch(item){
      case BottomNavItem.feed:
        return FeedScreen();

      case BottomNavItem.search:
        return SearchScreen();

      case BottomNavItem.create:
        return CreatePostScreen();

      case BottomNavItem.notifications:
        return NotificationsScreen();

      case BottomNavItem.profile:
        return ProfileScreen();

      default:
        return Scaffold();
    }
  }
}
