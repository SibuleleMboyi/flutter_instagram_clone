import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  // Instead of doing a MaterialPageRoute which will show the LoginScreen sliding over the SplashScreen
  // We use PageRouteBuilder with a transition duration zero, in order to make LoginScreen appear on top of the SplashScreen.

  static Route route(){
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_,__,___) => LoginScreen(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Login Screen"),
    );
  }
}
