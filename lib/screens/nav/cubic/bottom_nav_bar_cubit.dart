import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_instagram/enums/enum.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(
       /// Because it is the 1st item in our navigation bar
      BottomNavBarState(selectedItem: BottomNavItem.feed)
  );

  void updateSelectedItem(BottomNavItem item){
    if(item != state.selectedItem){
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
