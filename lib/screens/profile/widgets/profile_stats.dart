import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/profile/widgets/widgets.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    Key key,
    this.isCurrentUser,
    this.isFollowing,
    this.posts,
    this.followers,
    this.following
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
            children: [
              Stats(count: posts, label: 'posts'),
              Stats(count: followers, label: 'followers'),
              Stats(count: following, label: 'following'),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ProfileButton(
                isCurrentUser: isCurrentUser,
                isFollowing: isFollowing,
              )
          ),
        ],
      ),
    );
  }
}

