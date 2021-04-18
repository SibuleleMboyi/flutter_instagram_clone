import 'package:flutter_instagram/models/models.dart';

abstract class BasePostRepository{

  Future<void> createPost({Post post});

  void createLike({Post post, String userId});

  Future<void> createComment({Comment comment});

  Stream<List<Future<Post>>> getUserPosts({String userId});

  Stream<List<Future<Comment>>> getPostComments({String postId});

  Future<List<Post>> getUserFeed({String userId, String lastPostId});

  Future<Set<String>> getLikedPostIds({String userId, List<Post> posts});

  void deleteLike({String postId, String userId});
}