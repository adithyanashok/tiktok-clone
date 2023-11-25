import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/models/user.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Future<String> _uploadImage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String dowloadUrl = await snap.ref.getDownloadURL();
    return dowloadUrl;
  }

  // Register the user
  void registerUser(
      String email, String password, String username, File? image) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          image != null) {
        // Register the user
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        // Download Url
        String downloadUrl = await _uploadImage(image);

        final user = UserModel(
          username: username,
          email: email,
          password: password,
          profilePic: downloadUrl,
          uid: userCredential.user!.uid,
        );

        // Add to firestore database
        await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          "Error while creating account",
          "Please enter all the fields",
        );
      }
    } catch (e) {
      Get.snackbar("Error while creating account", e.toString());
    }
  }
}
