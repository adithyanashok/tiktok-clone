import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constant/colors.dart';
import 'package:tiktok_clone/views/screens/confirm/confirm_screen.dart';
import 'package:tiktok_clone/views/widgets/text.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  Future<void> pickVideo(ImageSource source, BuildContext context) async {
    final pickedVideo = await ImagePicker().pickVideo(source: source);
    if (pickedVideo != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(
              videoFile: File(pickedVideo.path), videoPath: pickedVideo.path),
        ),
      );
    }
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.grey[850],
          children: [
            SimpleDialogOption(
              onPressed: () {
                pickVideo(ImageSource.gallery, context);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: CustomText(
                      text: "Gallery",
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                pickVideo(ImageSource.camera, context);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: CustomText(
                      text: "Camera",
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: CustomText(
                      text: "Cancel",
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showOptionsDialog(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: BoxDecoration(color: buttonColor),
            child: const Center(
              child: CustomText(
                text: "Add Video",
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
