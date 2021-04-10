import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';

//context from 'Profile Button'
class EditProfileScreenArgs{
  final BuildContext context;

  const EditProfileScreenArgs({@required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  static Route route({@required EditProfileScreenArgs args}){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider(
            create: (_) => EditProfileCubit(
                userRepository: context.read<UserRepository>(),
                storageRepository: context.read<StorageRepository>(),
                //'profileBloc' uses 'context' from  'ProfileButton' inside profile screen
                profileBloc: args.context.read<ProfileBloc>(),
            ),
          child: EditProfileScreen(),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Edit Profile'),),
      ),
    );
  }
}

