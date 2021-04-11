import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_instagram/config/paths.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:meta/meta.dart';

class Comment extends Equatable{
  final String id;
  final String postId;
  final User author;
  final String content;
  final DateTime date;

  const Comment({
    this.id, // not necessarily required as it automatically gets created on Firebase.
    @required this.postId,
    @required this.author,
    @required this.content,
    @required this.date
  });

  @override
  List<Object> get props => [id, postId, author, content, date];

  /// Allows us to update some values of a class without losing information about other values that are not getting updated
  Comment copyWith({
    String id,
    String postId,
    User author,
    String content,
    DateTime date,
 }){
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
 }

 Map<String, dynamic> toDocument(){
    return {
      'postId': postId,
      'author': FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
    };
 }

  /// returns a Comment document snapshot from firebase and converts it into the Comment madel
  //because we need to convert the document reference 'author' to a document,
  // we are not going to use a factory constructor.
  static Future<Comment>fromDocument(DocumentSnapshot doc) async{
    if(doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if(authorRef != null){
      final authorDoc = await authorRef.get();  // gets a user document (author) from the 'users' collection
      if(authorDoc.exists){
        return Comment(
          id: doc.id,
          postId: data['postId'] ?? '',
          author: User.fromDocument(authorDoc), // converts returned Firebase user document to the format of our User Model
          content: data['content'] ?? '',
          date: (data['date'] as Timestamp) ?.toDate(), //'?' makes sure that data[date] is not null
        );
      }
    }
    return null;
  }

}