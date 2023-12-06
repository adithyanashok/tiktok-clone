import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumpnail;
  String profilePhoto;

  VideoModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.caption,
    required this.profilePhoto,
    required this.songName,
    required this.thumpnail,
    required this.videoUrl,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "shareCount": shareCount,
        "songName": songName,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumpnail": thumpnail,
        "profilePhoto": profilePhoto,
      };

  static VideoModel fromSnap(DocumentSnapshot snapshot) {
    return VideoModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      likes: snapshot['likes'],
      commentCount: snapshot['commentCount'],
      shareCount: snapshot['shareCount'],
      caption: snapshot['caption'],
      profilePhoto: snapshot['profilePhoto'],
      songName: snapshot['songName'],
      thumpnail: snapshot['thumpnail'],
      videoUrl: snapshot['videoUrl'],
    );
  }
}
