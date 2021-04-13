import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_instagram/blocs/simple_bloc_observer.dart';
import 'package:flutter_instagram/config/custom_router/custom_router.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        /// The providers can now be accessed through the App
        /// context.read<AuthRepository>()   is used to access contents of AuthRepository
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<UserRepository>(create: (_) => UserRepository()),
        RepositoryProvider<StorageRepository>(create: (_) => StorageRepository()),
        RepositoryProvider<PostRepository>(create: (_) => PostRepository()),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
        ],
        /// This is the root of this App
        child: MaterialApp(
          title: 'Flutter Instagram',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                color: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                textTheme: const TextTheme(
                    headline6: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    )
                )
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          /// since we going to use named routes in this App, we don't need 'home: ' parameter
          ///Here 'onGenerateRoute' doesn't take parameter because it's already passed(automatically) in CustomRouter class.
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}