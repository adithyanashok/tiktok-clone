import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/controller/profile/profile_controller.dart';
import 'package:tiktok_clone/views/screens/video/video.dart';
import 'package:tiktok_clone/views/widgets/text.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    profileController.updateUserId(uid);

    return GetBuilder<ProfileController>(
      builder: (controller) {
        return controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: const Icon(
                    Icons.person_add_alt_outlined,
                    color: Colors.white,
                  ),
                  actions: const [
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    )
                  ],
                  title: CustomText(
                    text: controller.user['username'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  centerTitle: true,
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: controller.user['profilePic'],
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    CustomText(
                                      text: controller.user['following'],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 5),
                                    const CustomText(
                                      text: "Following",
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    CustomText(
                                      text: controller.user['followers'],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 5),
                                    const CustomText(
                                      text: "Followers",
                                      fontSize: 15,
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                Column(
                                  children: [
                                    CustomText(
                                      text: controller.user['likes'],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 5),
                                    const CustomText(
                                      text: "Likes",
                                      fontSize: 14,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 140,
                              height: 47,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                              ),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    if (uid == authController.user!.uid) {
                                      authController.signout();
                                    } else {
                                      controller.followUser(
                                        uid,
                                        controller.user['profilePic'],
                                        controller.user['fcmToken'],
                                      );
                                    }
                                  },
                                  child: CustomText(
                                    text: uid == authController.user!.uid
                                        ? 'Sign out'
                                        : controller.user['isFollowing']
                                            ? 'Unfollow'
                                            : 'Follow',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Videos here--
                            controller.user['thumbnails'].isEmpty
                                ? const Center(
                                    child: CustomText(
                                        text: 'No videos', fontSize: 15),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        controller.user['thumbnails'].length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemBuilder: (context, index) {
                                      final thumbnail =
                                          controller.user['thumbnails'][index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Video(
                                                  videoId: thumbnail['id']),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: thumbnail['thumpnail'],
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
