import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc; //we want get the Current logged in user and compare it with the person view the profile

  ProfileBloc({
    @required  UserRepository userRepository,
    @required  AuthBloc authBloc,
  }) :  _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if(event is ProfileLoadUser){
      yield* _mapProfileLoadUserToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(ProfileLoadUser event) async*{
    yield state.copyWith(status: ProfileStatus.loading);
    try{
      final user = await  _userRepository.getUserWithId(userId: event.userId);  // gets by userId the user whose profile is being viewed.
      final isCurrentUser = _authBloc.state.user.uid == event.userId; // checks if the signed in user is the same user whose profile is being viewed.

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
}
