part of 'auth_bloc.dart';



 enum AuthStatus {unknown, authenticated, unauthenticated }

 /// Manages user's Authentication in the App.
 /// So we need to know which user is signed in.
 /// And know the status of AuthBloc, based on the current  status we will render a different UI.
 class AuthState extends Equatable {
   final auth.User user;
   final AuthStatus status;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
  });

   factory AuthState.unknown() => const AuthState();

   factory AuthState.authenticated( {@required auth.User user }) {
     return AuthState(user: user, status: AuthStatus.authenticated);
   }

   factory AuthState.unauthenticated() => const AuthState(status: AuthStatus.unauthenticated);

   @override
   bool get stringify => true;

  @override
  List<Object> get props => [user, status]; // allows us to compare 2 objects

}

