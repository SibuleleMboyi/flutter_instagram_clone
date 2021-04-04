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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,  // Prevents the user from sliding back to the previous screen OR using the back button.
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,  // blocks the screen from getting pushed up on Keyboard display
          body: Center(
            child: Card(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Instagram',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12.0),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email'),
                      onChanged: (value) => print(value),
                      validator: (value) => !value.contains('@')
                          ? 'Please entered valid email'
                          : null,
                    ),

                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                      obscureText: true,
                      onChanged: (value) => print(value),
                      validator: (value) => value.length < 6
                          ? 'Must be at least 6 characters'
                          : null,
                    ),

                    const SizedBox(height: 28.0),
                    RaisedButton(
                      elevation: 1.0,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => print("LOGIN"),
                      child: const Text(
                          'Log In'
                      ),
                    ),

                    const SizedBox(height: 12.0),
                    RaisedButton(
                      elevation: 1.0,
                      color: Colors.grey[200],
                      textColor: Colors.black,
                      onPressed: () => print("GO TO"),
                      child: const Text('No account? Sign up'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
