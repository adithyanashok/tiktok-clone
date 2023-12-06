import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/controller/notification/notification_controller.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _users = Rx<Map<String, dynamic>>({});
  final NotificationClass notificationClass = NotificationClass();

  Map<String, dynamic> get user => _users.value;

  final Rx<String> _uid = "".obs;

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    try {
      // Set loading indicator to true
      _isLoading.value = true;
      // List to store video thumbnails
      List thumbnails = [];

      // Query videos where the UID matches the user's UID
      var query = await firestore
          .collection('videos')
          .where('uid', isEqualTo: _uid.value)
          .get();

      // Get user document
      var doc = await firestore.collection('users').doc(_uid.value).get();
      final user = doc.data();

      // Iterate through video documents to retrieve thumbnails
      for (var data in query.docs) {
        var thumbnail = data.data();
        thumbnails.add(thumbnail);
      }

      // Get user data
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(_uid.value).get();
      final userData = userDoc.data() as dynamic;
      final String username = userData['username'];
      final String profilePic = userData['profilePic'];
      int followers = 0;
      int likes = 0;
      int following = 0;
      bool isFollowing = false;

      // Calculate total likes from video documents
      for (var item in query.docs) {
        likes += (item.data()['likes'] as List).length;
      }

      // Get follower and following documents
      var followerDoc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .get();
      var followingDoc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('following')
          .get();

      // Count the number of followers and following
      followers = followerDoc.docs.length;
      following = followingDoc.docs.length;

      // Check if the current user is following the profile user
      firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user!.uid)
          .get()
          .then(
        (value) {
          if (value.exists) {
            isFollowing = true;
          } else {
            isFollowing = false;
          }
        },
      );

      // Update users value with the gathered information
      _users.value = {
        "followers": followers.toString(),
        "following": following.toString(),
        "isFollowing": isFollowing,
        "likes": likes.toString(),
        "profilePic": profilePic,
        "username": username,
        "thumbnails": thumbnails,
        "fcmToken": user?['fcmToken'],
      };

      // Trigger UI update
      update();
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "Error while loading profile");
    } finally {
      // Set loading indicator to false
      _isLoading.value = false;
    }
  }

  followUser(String profileId, String profilePic, String fcmToken) async {
    // Check if the current user is already following the profile user
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user!.uid)
        .get();

    if (!doc.exists) {
      // If not following, add the current user to the followers list of the profile user
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user?.uid)
          .set({});
      // Also, add the profile user to the following list of the current user
      await firestore
          .collection('users')
          .doc(authController.user?.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      // Update the followers count in the local state
      _users.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
      // Trigger UI update
      update();

      // Send a notification to the profile user about the new follower
      notificationClass.followUser(
        "${authController.user?.displayName}",
        "${authController.user?.uid}",
        profileId,
        '${authController.user?.displayName} followed you',
        fcmToken,
      );
    } else {
      // If already following, remove the current user from the followers list
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authController.user?.uid)
          .delete();
      // Also, remove the profile user from the following list of the current user
      await firestore
          .collection('users')
          .doc(authController.user?.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      // Update the followers count in the local state
      _users.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
      // Trigger UI update
      update();
    }
    // Toggle the 'isFollowing' status in the local state
    _users.value.update('isFollowing', (value) => !value);
    // Trigger UI update
    update();
  }
}
