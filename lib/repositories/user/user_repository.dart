import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/config/paths.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/repositories/repositories.dart';

class UserRepository extends BaseUserRepository{
  /// The 1st thing to do is to create the dependency on Firebase Firestore because
  /// we are going to be accessing the data from this File

  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore}) 
      :_firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({@required String userId}) async{
    final doc = await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    /// we convert the 'doc'(document) that we get from Firestore to our user model.
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async{
    await _firebaseFirestore.collection(Paths.users).doc(user.id).update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({@required String query}) async{
    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({
   @required String userId,
   @required String followUserId
  }) {
    /// Add followUser to user's userFollowing
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});


    /// Add user to followUser's userFollowers.
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

  }

  @override
  void unfollowUser({
    @required String userId,
    @required String unfollowUserId
  }) {
    /// Remove unfollowUser from user's userFollowing
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId).delete();

    /// Remove user from unfollowUser's userFollowers

    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId).delete();
  }

  @override
  Future<bool> isFollowing({
   @required String userId,
   @required String otherUserId
  }) async{
    /// Is otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }


  
}