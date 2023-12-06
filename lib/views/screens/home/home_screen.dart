import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/colors.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/controller/notification/notification_controller.dart';
import 'package:tiktok_clone/controller/notification/notification_services.dart';
import 'package:tiktok_clone/controller/video/video_controller.dart';
import 'package:tiktok_clone/views/screens/add_video/add_video.dart';
import 'package:tiktok_clone/views/screens/notification/notification_screen.dart';
import 'package:tiktok_clone/views/screens/profile/profile_screen.dart';
import 'package:tiktok_clone/views/screens/search/search_screen.dart';
import 'package:tiktok_clone/views/screens/video/video_screen.dart';
import 'package:tiktok_clone/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationsService notification = NotificationsService();
  final VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();

    notification.getnotificationPermission();
    notification.firebaseInit(context);
    notification.getDeviceToken().then((value) {});
    notification.onTokenRefresh();
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      VideoScreen(),
      SearchScreen(),
      const AddVideoScreen(),
      NotificationScreen(uid: authController.user!.uid),
      ProfileScreen(uid: authController.user!.uid)
    ];
    return Scaffold(
      body: Center(
        child: screens[pageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: buttonColor,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        currentIndex: pageIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            label: "Search",
          ),
          const BottomNavigationBarItem(
            icon: CustomIcons(),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              return Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  videoController.showNotification == true
                      ? Positioned(
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50)),
                            width: 5,
                            height: 5,
                          ),
                        )
                      : const SizedBox()
                ],
              );
            }),
            label: "Notification",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
