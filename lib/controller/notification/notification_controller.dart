import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:http/http.dart' as http;

class NotificationClass extends GetxController {
  final Rx<List> _notifications = Rx<List>([]);
  List get notifications => _notifications.value;

  final RxBool _showNotificaion = false.obs;
  bool get showNotification => _showNotificaion.value;

  Future<void> likeUser(
    String postId,
    String profileId,
    String username,
    String body,
    String fcmToken,
  ) async {
    try {
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      final user = userDoc.data()! as dynamic;
      // Ceate a map of notification
      Map<String, dynamic> notification = {
        "postId": postId,
        "profileId": profileId,
        "username": username,
        "profilePic": user['profilePic'],
        "body": body,
        "userId": authController.user!.uid,
        "dateTime": DateTime.now(),
      };
      // Check current user id and video owner id
      if (profileId != firebaseAuth.currentUser!.uid) {
        // Store the notification to firestore
        await firestore.collection('notifications').add(notification);
        // Send notification to the user
        await sendPushMessage(
          fcmToken: fcmToken,
          title: 'Like',
          body: "$username $body",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> followUser(
    String username,
    String userId,
    String profileId,
    String body,
    String fcmToken,
  ) async {
    try {
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .get();
      final user = userDoc.data()! as dynamic;
      // Ceate a map of notification
      Map<String, dynamic> notification = {
        "username": username,
        "userId": userId,
        "profileId": profileId,
        "profilePic": user['profilePic'],
        "body": body,
        "dateTime": DateTime.now(),
      };
      // Check current user id and video owner id
      if (profileId != authController.user?.uid) {
        await firestore.collection('notifications').add(notification);

        // Send notification to the user
        await sendPushMessage(
          fcmToken: fcmToken,
          title: 'Following',
          body: body,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> commentPost(
    String username,
    String userId,
    String profileId,
    String postId,
    String body,
    String fcmToken,
  ) async {
    try {
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .get();
      final user = userDoc.data()! as dynamic;
      Map<String, dynamic> notification = {
        "username": username,
        "userId": userId,
        "profileId": profileId,
        "profilePic": user['profilePic'],
        "postId": postId,
        "body": body,
        "dateTime": DateTime.now(),
      };
      // Check current user id and video owner id
      if (profileId != firebaseAuth.currentUser!.uid) {
        // Store the notification to firestore
        await firestore.collection('notifications').add(notification);
        // Send notification
        await sendPushMessage(
          fcmToken: fcmToken,
          title: 'Comment',
          body: "$username $body",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  String _userId = '';

  updateId(String id) {
    _userId = id;
    getnotifications();
  }

  getnotifications() async {
    _notifications.bindStream(
      firestore
          .collection('notifications')
          .where("profileId", isEqualTo: _userId)
          .snapshots()
          .map(
        (event) {
          List returnValue = [];
          for (var element in event.docs) {
            returnValue.add(element.data());
          }
          return returnValue;
        },
      ),
    );
  }

  //Send a push notification
  Future<void> sendPushMessage(
      {String? body, String? title, required String fcmToken}) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'content-type': 'application/json',
            'Authorization':
                'key=AAAAqHRylq0:APA91bFKENyP09TG9ks5306LE5qIlF031q8ItelhJrbVgvpsD68fFQtRHmfEF0k7L3DAghoo0EIwdWiQDTX26aQfoJHLjVnO5IEMN1KO9vTXNRbdeAWBjWABE3Jg9p5QfGD5kwK1g1Vk'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'tictok_clone',
              },
              "to": fcmToken,
            },
          ));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
        print(e.toString());
      }
    }
  }
}
