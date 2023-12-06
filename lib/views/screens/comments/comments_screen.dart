import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/controller/comments/comments_controller.dart';
import 'package:tiktok_clone/views/widgets/text.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentsScreen extends StatelessWidget {
  final String id;
  final String profileId;
  CommentsScreen({super.key, required this.id, required this.profileId});

  final TextEditingController _commentController = TextEditingController();
  final CommentsController commentsController = Get.put(CommentsController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentsController.updatePostid(id);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: commentsController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentsController.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment.profilePic),
                        ),
                        title: Row(
                          children: [
                            CustomText(
                              text: comment.username,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 150,
                              child: CustomText(
                                text: comment.comment,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            CustomText(
                              text: tago.format(comment.publishedDate.toDate()),
                              fontSize: 12,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomText(
                              text: '${comment.likes.length} likes',
                              fontSize: 12,
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () => commentsController
                              .likeComment(comment.id.toLowerCase()),
                          child: Icon(
                            Icons.favorite,
                            color:
                                comment.likes.contains(authController.user!.uid)
                                    ? Colors.red
                                    : Colors.white,
                            size: 25,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Comment",
                    labelStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => commentsController.postComment(
                      _commentController.text, profileId),
                  child: const CustomText(
                    text: 'Send',
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
