import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/controller/notification/notification_services.dart';
import 'package:tiktok_clone/models/user.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/home/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  Rx<File?> image = Rx<File?>(null);
  User? get user => _user.value;
  File? get profilePic => image.value;

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  // Method to pick image
  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Show a snackbar if the picked image not null
      Get.snackbar(
        "Profile Image",
        "Selected image successfully",
        colorText: Colors.white,
      );
      // Assign the picked image path to global variable "image"
      image.value = File(pickedImage.path);
    }
  }

  Future<String> _uploadImage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    // Get the download url
    String dowloadUrl = await snap.ref.getDownloadURL();
    // After getting the download url return it
    return dowloadUrl;
  }

  // Register the user
  Future<void> registerUser(
      String email, String password, String username, File image) async {
    try {
      _isLoading.value = true; // Set isLoading to true
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        // Register the user
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(username);

        // Download Url
        String downloadUrl = await _uploadImage(image);

        //Fcm token
        final NotificationsService notificationClass = NotificationsService();
        final token = await notificationClass.getDeviceToken();
        final user = UserModel(
          username: username,
          email: email,
          password: password,
          profilePic: downloadUrl,
          uid: userCredential.user!.uid,
          fcmToken: token!,
        );

        await userCredential.user!.updateDisplayName(username);

        // Add to firestore database
        await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          "Error while creating account",
          "Please enter all the fields",
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // Snackbar to show Exceptions
      Get.snackbar(
        "Error while creating account",
        e.toString(),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false; // Set isLoading back to false
    }
  }

  // Login user
  Future<void> loginUser(String email, String password) async {
    try {
      _isLoading.value = true; // Set isLoading to true

      // Check that email and password are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        // Sign in with email and password
        UserCredential credential =
            await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Fcm token
        final NotificationsService notificationClass = NotificationsService();
        final token = await notificationClass.getDeviceToken();
        await firestore
            .collection('users')
            .doc(credential.user?.uid)
            .update({'fcmToken': token!});
      }
    } catch (e) {
      // Snackbar to show Exceptions
      Get.snackbar(
        "Error while log in account",
        e.toString(),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false; // Set isLoading back to false
    }
  }

  //Signout method
  Future<void> signout() async {
    await firebaseAuth.signOut();
    // update();
  }
}
