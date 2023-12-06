import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/controller/profile/profile_controller.dart';
import 'package:tiktok_clone/controller/video/video_controller.dart';
import 'package:tiktok_clone/views/screens/comments/comments_screen.dart';
import 'package:tiktok_clone/views/widgets/circle_animation.dart';
import 'package:tiktok_clone/views/widgets/methods.dart';
import 'package:tiktok_clone/views/widgets/text.dart';
import 'package:tiktok_clone/views/widgets/video_player_item.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({super.key});

  final VideoController videoController = Get.put(VideoController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () {
          return PageView.builder(
            itemCount: videoController.videoList.length,
            scrollDirection: Axis.vertical,
            controller: PageController(viewportFraction: 1),
            itemBuilder: (context, index) {
              final video = videoController.videoList[index];
              return Stack(
                children: [
                  VideoPlayerItem(videourl: video.videoUrl),
                  Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomText(
                                      text: video.username,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      text: video.caption,
                                      fontSize: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        CustomText(
                                          text: video.songName,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfilePic(video.profilePhoto),
                                  InkWell(
                                    onTap: () => videoController.likeVideo(
                                      video.id,
                                      video.profilePhoto,
                                      video.uid,
                                      profileController.user['username'],
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: video.likes.contains(
                                              authController.user?.uid)
                                          ? Colors.red
                                          : Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  CustomText(
                                    text: '${video.likes.length}',
                                    fontSize: 20,
                                  ),
                                  const SizedBox(height: 7),
                                  InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => CommentsScreen(
                                        id: video.id,
                                        profileId: video.uid,
                                      ),
                                    )),
                                    child: const Icon(
                                      Icons.comment,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  CustomText(
                                    text: "${video.commentCount}",
                                    fontSize: 20,
                                  ),
                                  const SizedBox(height: 7),
                                  const InkWell(
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  CustomText(
                                    text: "${video.shareCount}",
                                    fontSize: 20,
                                  ),
                                  CircleAnimation(
                                    child: buildMusicAlbum(video.profilePhoto),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
