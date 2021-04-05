import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/repositories/auth/auth_repository.dart';
import 'package:flutter_instagram/screens/login/cubic/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  // Instead of doing a MaterialPageRoute which will show the LoginScreen sliding over the SplashScreen
  // We use PageRouteBuilder with a transition duration zero, in order to make LoginScreen appear on top of the SplashScreen.

  static Route route(){
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      /// Because Login Cubit won't be accessed out side Login Screen,
      /// we therefore provide it exactly where it's needed and used.
      pageBuilder: (context,_,__) => BlocProvider<LoginCubit>(
        create: (_) => LoginCubit(authRepository: context.read<AuthRepository>() ),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,  // Prevents the user from sliding back to the previous screen OR using the back button.
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit,LoginState>(
          listener: (context, state){
            if(state.status == LoginStatus.error){
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                        title: Text("Error"),
                        content: Text(state.failure.message)),
              );
            }
          },

          builder:(context, state) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
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
                              onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please entered valid email'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be at least 6 characters'
                                  : null,
                            ),
                            const SizedBox(height: 28.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () => _submitForm(
                                  context,
                                  state.status == LoginStatus.submitting
                              ),
                              child: const Text(
                                  'Log In'
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            RaisedButton(
                              elevation: 1.0,
                              color: Colors.grey[200],
                              textColor: Colors.black,
                              onPressed: () => print('Go to Signup Screen'),
                              child: const Text('No account? Sign up'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            );

          },

        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting){
    if(_formKey.currentState.validate() && !isSubmitting){  /// isSubmitting means the user has login in progress
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
