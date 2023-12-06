import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class VideoUploadController extends GetxController {
  // Compress the video
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    // Return the compressed video
    return compressedVideo!.file;
  }

  Future<String> uploadVideoToFirebase(
      String videoPath, String fileName) async {
    try {
      // Create a Reference to the video file on Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('videos').child(fileName);

      // Upload the video file
      UploadTask uploadTask =
          storageReference.putFile(await _compressVideo(videoPath));

      // Get the download URL once the upload is complete
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle any errors that occurred during the upload process
      Get.snackbar("Can't upload video", e.toString());
      return '';
    }
  }

  // Create a thumbnail for the video
  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    // Return the thumbnail
    return thumbnail;
  }

  // Upload thumbnail to firebase
  Future<String> _uploadImageToStorage(
      String videoPath, String fileName) async {
    Reference ref =
        firebaseStorage.ref().child('thumbnails').child("$fileName.jpg");
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    // Get the download url
    String downloadUrl = await snap.ref.getDownloadURL();
    // Return the url
    return downloadUrl;
  }

  //Upload video
  uploadVideo(
      String songName, String caption, String videoPath, context) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      // Get the length
      int len = allDocs.docs.length;

      String fileName = basename(videoPath);
      // Uploaded videoUrl
      String videoUrl = await uploadVideoToFirebase(videoPath, fileName);

      // Uploaded thumbnailUrl
      String thumbnail = await _uploadImageToStorage(videoPath, fileName);

      VideoModel video = VideoModel(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
        thumpnail: thumbnail,
      );

      // Upload the Video
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      Navigator.of(context).pop();
    } catch (e) {
      log("Error $e");
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }
}
