import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/enums/enum.dart';
import 'package:flutter_instagram/screens/nav/cubic/bottom_nav_bar_cubit.dart';
import 'package:flutter_instagram/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  // Instead of doing a MaterialPageRoute which will show the NavScreen sliding over the SplashScreen
  // We use PageRouteBuilder with a transition duration zero, in order to make NavScreen appear on top of the SplashScreen.

  static Route route(){
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_,__,___) => BlocProvider<BottomNavBarCubit>(
          create: (_) => BottomNavBarCubit(),
          child: NavScreen()
      ),
    );
  }

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notifications: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      /// Prevents user going back to the Login Screen OR Sign Up Screen
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state){
          return Scaffold(
            body: Text("Nav Screen"),
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];
                context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
              },
            ),
          );
        },
      ),
    );
  }
}
