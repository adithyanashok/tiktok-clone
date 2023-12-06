import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  final publishedDate;
  String uid;
  String profilePic;
  List likes;
  String id;

  CommentModel({
    required this.username,
    required this.comment,
    required this.publishedDate,
    required this.uid,
    required this.profilePic,
    required this.likes,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'uid': uid,
        'publishedDate': publishedDate,
        'profilePic': profilePic,
        'likes': likes,
        'id': id,
      };

  static CommentModel fromSnap(DocumentSnapshot snap) {
    final snapshot = snap.data()! as dynamic;
    return CommentModel(
      username: snapshot['username'],
      comment: snapshot['comment'],
      publishedDate: snapshot['publishedDate'],
      uid: snapshot['uid'],
      profilePic: snapshot['profilePic'],
      id: snapshot['id'],
      likes: snapshot['likes'] as List,
    );
  }
}
