import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_instagram/blocs/blocs.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/repositories.dart';

part 'create_post_state.dart';

/* Dependencies that are needed on the Create Post Screen are : -
   1) PostRepository to create posts in firebase.
   2) StorageRepository to upload photos into FirebaseStorage
   3) AuthBloc to have access to the userId of a signed in user (also check if AuthRepository cannot perform this task)
 */
class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;


  CreatePostCubit({
    PostRepository postRepository,
    StorageRepository storageRepository,
    AuthBloc authBloc,
  }) : _postRepository = postRepository,
       _storageRepository = storageRepository,
       _authBloc = authBloc,
       super(CreatePostState.initial());

  void postImageChanged(File file){
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption){
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async{
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try{
      // we use 'empty' because when toDocument() is called, it only cares the authorId, not other author information
      // so creates an empty user with a correct Id.
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final postImageUrl = await _storageRepository.uploadPostImage(image: state.postImage);

      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
      );

      await _postRepository.createPost(post: post);

      emit(state.copyWith(status: CreatePostStatus.success));

    } catch(err){
      emit(state.copyWith(status: CreatePostStatus.error, failure: Failure(message: 'We were unable to create your post.')));
    }
  }

  void reset(){
    emit(CreatePostState.initial());
  }
}
