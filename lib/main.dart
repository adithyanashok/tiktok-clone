import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/colors.dart';
import 'package:tiktok_clone/controller/auth/auth.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthController());
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundNotificationHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundNotificationHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TikTok',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        splashColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
      routes: {
        'register': (context) => SignupScreen(),
        'login': (context) => LoginScreen(),
      },
    );
  }
}
