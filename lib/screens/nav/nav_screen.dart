import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  // Instead of doing a MaterialPageRoute which will show the NavScreen sliding over the SplashScreen
  // We use PageRouteBuilder with a transition duration zero, in order to make NavScreen appear on top of the SplashScreen.

  static Route route(){
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_,__,___) => NavScreen(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Nav Screen"),
    );
  }
}
