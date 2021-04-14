import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc; //we want get the Current logged in user and compare it with the person view the profile


  StreamSubscription<List<Future<Post>>> _postsSubscription;

  ProfileBloc({
    @required  UserRepository userRepository,
    @required  PostRepository postRepository,
    @required  AuthBloc authBloc,
  }) :  _userRepository = userRepository,
        _postRepository = postRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());

  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if(event is ProfileLoadUser){
      yield* _mapProfileLoadUserToState(event);

    } else if( event is ProfileToggleGridView){
      yield* _mapProfileToggleGridViewToState(event);

    } else if(event is ProfileUpdatePosts){
      yield* _mapProfileUpdatePostsToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(ProfileLoadUser event) async*{
    yield state.copyWith(status: ProfileStatus.loading);
    try{
      final user = await  _userRepository.getUserWithId(userId: event.userId);  // gets by userId the user whose profile is being viewed.
      final isCurrentUser = _authBloc.state.user.uid == event.userId; //checks if the signed in user is the same user whose profile is being viewed.

      // '?.' checks if '_postsSubscription' is null, if it is null then it does not cancel non existing stream.
      _postsSubscription?.cancel();
      _postsSubscription = _postRepository.getUserPosts(userId: event.userId).listen((posts) async{
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      });


      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        status: ProfileStatus.loaded,
      );
    } catch(err){
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: const Failure(message: 'We are unable to load this profile.')
      );
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(ProfileToggleGridView event) async*{
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(ProfileUpdatePosts event) async*{
    yield state.copyWith(posts: event.posts);
  }

}
