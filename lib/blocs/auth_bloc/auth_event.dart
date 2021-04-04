part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}

/// This event is called whenever Firebase updates the user that is signed in
class AuthUserChanged extends AuthEvent{
  final auth.User user;

  AuthUserChanged({ @required this.user});

  @override
  List<Object> get props => [user];
}

/// This event is sent to the block when the user tries to log out
class AuthLogoutRequested extends AuthEvent{}
