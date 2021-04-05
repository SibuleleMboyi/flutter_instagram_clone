import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/screen.dart';

class CustomRouter{

  /// This function takes a name that is passed through the route settings, checks if there is an existing route
  /// and navigates to that route.
  /// If there is no existing route, it displays an Error route.
  static Route onGenerateRoute(RouteSettings settings){
    print('Route: ${settings.name}');
    switch (settings.name){
      case '/':
        return MaterialPageRoute(
          ///Reason of including 'RouteSettings' in  'MaterialPageRoute' is so that when we look at 'Analytics'
          /// we can see what page the user visits.
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );

      case SplashScreen.routeName:
        return SplashScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignupScreen.routeName:
        return SignupScreen.route();

      case NavScreen.routeName:
        return NavScreen.route();

      default :
        return _errorRoute();

    }
  }

  /// This method is private because we won't be accessing outside this class, 'CustomRouter'.
  static Route _errorRoute(){
    return MaterialPageRoute(
      settings:  const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Error')),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}