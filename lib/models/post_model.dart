import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_instagram/config/paths.dart';
import 'package:flutter_instagram/models/models.dart';

class Post extends Equatable{
  final String id;
  final User author;
  final String imageUrl;
  final String caption;
  final int likes;
  final DateTime date;

  const Post({
    this.id,  // not required because we allow Firebase to automatically create a unique post Id on post upload into Firebase.
    @required this.author,
    @required this.imageUrl,
    @required this.caption,
    @required this.likes,
    @required this.date
  });


  @override
  List<Object> get props => [id, author, imageUrl, caption, likes, date];

  /// Allows us to update some values of a class without losing information about other values that are not getting updated
  Post copyWith({
    String id,
    User author,
    String imageUrl,
    String caption,
    int likes,
    DateTime date,
 }){
  return Post(
    id : id ?? this.id,
    author: author ?? this.author,
    imageUrl: imageUrl ?? this.imageUrl,
    caption: caption ?? this.caption,
    likes: likes ?? this.likes,
    date: date ?? this.date,
  );
}

  /// converts post model into a JSON that firebase can take and create a document out of it
  Map<String, dynamic> toDocument(){
    return{
      // 'author' is mapped to  users/userId, e.g  author: users/12W2322.
      // 'author' is a reference to a user document in the users collection.
      // 'id' not passed because we allow Firebase to automatically create a unique postId on post upload into Firebase.
      'author': FirebaseFirestore.instance.collection(Paths.users).doc(author.id), // NOTE: try 'author': user's id
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'date': Timestamp.fromDate(date),
    };
  }

  /// returns a Post document snapshot from firebase and converts it into the Post madel
  //because we need to convert the document reference 'author' to a document,
  // we are not going to use a factory constructor.
  static Future<Post>fromDocument(DocumentSnapshot doc) async{
    if(doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if(authorRef != null){
      final authorDoc = await authorRef.get();  // gets a user document (author) from the 'users' collection
      if(authorDoc.exists){
        return Post(
            id: doc.id,
            author: User.fromDocument(authorDoc), // converts returned Firebase user document to the format of our User Model
            imageUrl: data['imageUrl'] ?? '',
            caption: data['caption'] ?? '',
            likes: (data['likes'] ?? 0).toInt(),
            date: (data['date'] as Timestamp) ?.toDate(), //'?' makes sure that data[date] is not null
        );
      }
    }
    return null;
  }


}