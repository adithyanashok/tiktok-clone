import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/video/video_upload_controller.dart';
import 'package:tiktok_clone/views/widgets/text.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  const ConfirmScreen(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    songController.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: height * .7,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: width - 20,
              child: TextInputField(
                controller: songController,
                labelText: "Song name",
                icon: Icons.music_note,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: width - 20,
              child: TextInputField(
                controller: captionController,
                labelText: "Caption",
                icon: Icons.closed_caption,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue)),
              onPressed: () {
                VideoUploadController().uploadVideo(
                  songController.text,
                  captionController.text,
                  widget.videoPath,
                  context,
                );
              },
              child: const CustomText(
                text: "Share!",
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
