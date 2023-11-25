// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String email;
  String password;
  String profilePic;
  String uid;
  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.uid,
  });
  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "profilePic": profilePic,
        "uid": uid,
      };

  static UserModel fromSnap(DocumentSnapshot doc) {
    var snapshot = doc.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot['username'],
      email: snapshot['email'],
      password: snapshot['password'],
      profilePic: snapshot['profilePic'],
      uid: snapshot['uid'],
    );
  }
}
