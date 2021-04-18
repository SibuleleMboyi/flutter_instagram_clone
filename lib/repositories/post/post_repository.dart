import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/config/paths.dart';
import 'package:flutter_instagram/models/comment_model.dart';
import 'package:flutter_instagram/models/post_model.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

class PostRepository extends BasePostRepository{
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({
     FirebaseFirestore firebaseFirestore
  }): _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;


  @override
  Future<void> createPost({@required Post post}) async{
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment({@required Comment comment}) async{
    await _firebaseFirestore.collection(Paths.comments).doc(comment.postId)
        .collection(Paths.postComments).add(comment.toDocument());
  }

  @override
  void createLike({@required Post post, @required String userId}) {
    // we not incrementing number of likes in this way 'likes': post.likes + 1,
    // Mainly because if users like the sma post at the sametime, Firebase will take the current value
    // of 'like' and increment it only for one user.

    _firebaseFirestore.collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore.collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});

  }

  @override
  Stream<List<Future<Post>>> getUserPosts({@required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore.collection(Paths.posts)
        .where('author', isEqualTo: authorRef) // because we are querying over 2 fields, 'author' and 'date',
        .orderBy('date', descending: true)     //we need to go our Firebase Console and add a Company Query.
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Stream<List<Future<Comment>>> getPostComments({@required String postId}) {
    return _firebaseFirestore.collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  Future<List<Post>> getUserFeed({@required String userId, String lastPostId}) async{
    QuerySnapshot postsSnap;
    if(lastPostId == null){
      postsSnap = await _firebaseFirestore.collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .limit(3)
          .get();
    } else{
      final lastPostDoc = await _firebaseFirestore.collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .doc(lastPostId)
          .get();

      if(!lastPostDoc.exists){
        return [];
      }

      postsSnap = await _firebaseFirestore.collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(3)
          .get();

    }

    final posts = Future.wait(postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList());
    return posts;
  }


  /// From each fetched batch posts, this method highlights the posts that have been already liked by a user
  @override
  Future<Set<String>> getLikedPostIds({@required String userId, @required List<Post> posts}) async{
    final postIds = <String>{};
    for(final post in posts){
      final likeDoc = await _firebaseFirestore.collection(Paths.likes)
          .doc(post.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();

      if(likeDoc.exists){
        postIds.add(post.id);
      }
    }

    return postIds;
  }

  @override
  void deleteLike({String postId, String userId}) {
    _firebaseFirestore.collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)}); // since there is no 'decrement'

    _firebaseFirestore.collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }

}