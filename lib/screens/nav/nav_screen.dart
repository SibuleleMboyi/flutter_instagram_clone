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

  /// These keys are used to maintain the current navigator state for each of the navigator items.
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

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
            /// We use the Stack Widget so we can be able to render different screens,
            /// and making sure we save the current navigation state for each of the screens
            ///
            body: Stack(
              children: items.map((item, _) => MapEntry(
                item,
                _buildOffStageNavigator(
                    item,
                    item == state.selectedItem),
              )).values.toList(),

            ),
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              onTap: (index) {
                final selectedItem = BottomNavItem.values[index];

                _selectBottomNavItem(
                    context,
                    selectedItem,
                    selectedItem == state.selectedItem
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _selectBottomNavItem(BuildContext context, BottomNavItem selectedItem, bool isSameItem){

    if(isSameItem){

      /// e.g if while on the feed screen, the user routes by clicking a friend's post,
      /// goes to her profile, and check other posts on this person's profile down to the comments of any post,
      /// if the user then tabs the feed screen icon, all the other navigated screens will be popped up from the navigation stack,
      /// and the user returns to the feed screen.

      navigatorKeys[selectedItem].currentState.popUntil((route) => route.isFirst);
    }

    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);

  }

  Widget _buildOffStageNavigator(BottomNavItem currentItem, bool isSelected){

    /// 'Offstage' Creates a widget that visually hides its child.
    return Offstage(
      // Only shows the item that is selected
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        item: currentItem,
      ),
    );
  }
}