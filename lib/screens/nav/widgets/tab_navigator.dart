import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_instagram/config/custom_router/custom_router.dart';
import 'package:flutter_instagram/enums/enum.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_instagram/screens/screen.dart';
import 'package:flutter_instagram/screens/search/cubit/search_cubit.dart';

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

      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
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
        return BlocProvider<SearchCubit>(
          create: (content) => SearchCubit(userRepository: context.read<UserRepository>()),
          child: SearchScreen(),
        );

      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          create: (content) => CreatePostCubit(
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: CreatePostScreen(),
        );

      case BottomNavItem.notifications:
        return NotificationsScreen();

      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid)),
            child: ProfileScreen(),
        );

      default:
        return Scaffold();
    }
  }
}
