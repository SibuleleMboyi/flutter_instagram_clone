import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/blocs.dart';
import 'package:flutter_instagram/screens/screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  /// is used by onGenerateRoute method in the CustomRouter class
  static Route route(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 'onWillPop' prevents a user from using the phone's back button while this screen is displayed
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if(state.status == AuthStatus.unauthenticated){
            // Go to the Login Screen
            Navigator.of(context).pushNamed(LoginScreen.routeName);

          } else if(state.status == AuthStatus.authenticated){
            // Got to the Nav Screen
            Navigator.of(context).pushNamed(NavScreen.routeName);
          }
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
