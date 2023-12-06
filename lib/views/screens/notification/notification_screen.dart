import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/notification/notification_controller.dart';
import 'package:tiktok_clone/views/screens/profile/profile_screen.dart';
import 'package:tiktok_clone/views/widgets/text.dart';
import 'package:timeago/timeago.dart' as tago;

class NotificationScreen extends StatefulWidget {
  final String? uid;
  const NotificationScreen({super.key, this.uid});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationClass notificationClass = Get.put(NotificationClass());

  @override
  void initState() {
    super.initState();
    notificationClass.updateId(widget.uid!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationClass>(
        init: NotificationClass(),
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const CustomText(
                  text: 'Notifications',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
              ),
              backgroundColor: Colors.black,
              body: Obx(() {
                return notificationClass.notifications.isEmpty
                    ? const Center(
                        child: CustomText(
                          text: "No Notifications",
                          fontSize: 20,
                        ),
                      )
                    : ListView.builder(
                        itemCount: notificationClass.notifications.length,
                        itemBuilder: (context, index) {
                          final notification =
                              notificationClass.notifications[index];

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: notification['userId']),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: SizedBox(
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(notification['profilePic']),
                                ),
                              ),
                              title: Row(
                                children: [
                                  SizedBox(
                                    child: CustomText(
                                      text: notification['username'],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: CustomText(
                                text: notification['body'],
                                fontSize: 15,
                              ),
                              trailing: TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          31, 204, 157, 157),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CustomText(
                                      text: tago.format(
                                          notification['dateTime'].toDate()),
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          );
                        },
                      );
              }));
        });
  }
}
