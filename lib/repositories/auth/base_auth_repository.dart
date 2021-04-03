import 'package:firebase_auth/firebase_auth.dart' as auth;

/// Holds method definitions for AuthRepository
abstract class BaseAuthRepository{

  // We import firebase_auth as as auth so we can be able to distinguish between our 'User model'  and
  // the 'User model' that Firebase gives us

  /// This 'get user' is a listener that constantly listens to the current state of our Firebase Authentication.
  /// Whenever a user logs in or logs out, this method will give a new Firebase user or no Firebase user.
  Stream<auth.User> get user;

  Future<auth.User> signUpWithEmailAndPassword({
    String username,
    String email,
    String password,
  });

  Future<auth.User> logInWithEmailAndPassword({
    String email,
    String password,
  });

  Future<void> logOut();

}