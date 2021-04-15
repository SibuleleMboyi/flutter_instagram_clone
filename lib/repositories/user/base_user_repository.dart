import 'package:flutter_instagram/models/user_model.dart';

abstract class BaseUserRepository{
  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});
  Future<List<User>> searchUsers({String query});
}