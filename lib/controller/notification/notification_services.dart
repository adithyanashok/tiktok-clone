import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tiktok_clone/constant/controller.dart';

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? uid = authController.user?.uid;

  //Initialize flutter local notification class
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Get notification permission
  Future<void> getnotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
  }

  //Method for initalizing flutter local notification
  Future<void> initLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    //Android initialization settings
    AndroidInitializationSettings androidInitSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization settings
    var initializationSettings =
        InitializationSettings(android: androidInitSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  //Firebase init
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  //Function to show notification
  Future<void> showNotification(RemoteMessage message) async {
    // Android notification channel
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "'High Importance Notifications",
      importance: Importance.max,
    );

    //Android notification details
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    //Notification details
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    //Id for localnotification
    final id = Random.secure().nextInt(150000);

    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotificationsPlugin.show(
          id,
          '${message.notification?.title}',
          '${message.notification?.body}',
          notificationDetails,
        );
      },
    );
  }

  //Get device token
  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  //Token refresh method
  Future<void> onTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {});
  }
}
