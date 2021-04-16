import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/screens/edit_profile/edit_profile_screen.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key key,
    this.isCurrentUser,
    this.isFollowing
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? FlatButton(
        onPressed: () => Navigator.of(context).pushNamed(
            EditProfileScreen.routeName,
            arguments: EditProfileScreenArgs(context: context),
        ),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 16.0),
        ),
    )
        : FlatButton(
      onPressed: () => isFollowing
          ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
          :context.read<ProfileBloc>().add(ProfileFollowUser()),
      color: isFollowing ? Colors.grey[300] :Theme.of(context).primaryColor,
      textColor: isFollowing ? Colors.black : Colors.white,
      child: Text(
        isFollowing ? 'follow' : 'unfollow',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
