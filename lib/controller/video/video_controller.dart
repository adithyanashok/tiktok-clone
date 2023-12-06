import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/controller/notification/notification_controller.dart';
import 'package:tiktok_clone/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<VideoModel>> _videoList = Rx<List<VideoModel>>([]);
  final Rx<VideoModel> _video = Rx<VideoModel>(VideoModel(
    username: '',
    uid: '',
    id: '',
    likes: [],
    commentCount: 0,
    shareCount: 100,
    caption: '',
    profilePhoto: '',
    songName: '',
    thumpnail: '',
    videoUrl: '',
  ));

  List<VideoModel> get videoList => _videoList.value;
  VideoModel get video => _video.value;
  final RxBool _showNotificaion = false.obs;
  bool get showNotification => _showNotificaion.value;

  bool isLoading = false;

  NotificationClass notificationClass = NotificationClass();

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      firestore.collection('videos').snapshots().map(
        (event) {
          List<VideoModel> returnVal = [];
          for (var elements in event.docs) {
            returnVal.add(VideoModel.fromSnap(elements));
          }
          return returnVal;
        },
      ),
    );
  }

  Future<void> likeVideo(
      String id, profilePic, String profileId, String username) async {
    // Retrieve the video document
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();

    // Retrieve the user document for the video owner
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(profileId).get();

    // Get the current user's ID
    var uid = authController.user!.uid;

    // Extract data from the documents
    final video = doc.data() as dynamic;
    final user = userDoc.data() as dynamic;

    // Check if the current user has already liked the video
    if (video['likes'].contains(uid)) {
      // If liked, remove the user's ID from the 'likes' array
      await firestore.collection('videos').doc(id).update({
        "likes": FieldValue.arrayRemove([uid])
      });
    } else {
      // If not liked, add the user's ID to the 'likes' array
      await firestore.collection('videos').doc(id).update({
        "likes": FieldValue.arrayUnion([uid])
      });

      // If the video owner is the current user, show a notification
      if (profileId == authController.user!.uid) {
        _showNotificaion.value = true;
      }

      // Send a notification to the video owner about the new like
      notificationClass.likeUser(
        video['id'],
        profileId,
        username,
        "liked your video",
        user['fcmToken'],
      );
    }
  }

  Future<void> getOneVideo(String videoId) async {
    try {
      // Set loading indicator to true
      isLoading = true;
      // Trigger UI update
      update();

      // Retrieve the document for the specified video
      var doc = await firestore.collection('videos').doc(videoId).get();
      // Extract video data from the document
      final video = doc.data() as dynamic;

      // Update the _video value with the VideoModel based on the retrieved data
      _video.value = VideoModel(
        username: video['username'],
        uid: video['uid'],
        id: video['id'],
        likes: video['likes'],
        commentCount: video['commentCount'],
        shareCount: video['shareCount'],
        caption: video['caption'],
        profilePhoto: video['profilePhoto'],
        songName: video['songName'],
        thumpnail: video['thumpnail'],
        videoUrl: video['videoUrl'],
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      // Set loading indicator to false
      isLoading = false;
      // Trigger UI update
      update();
    }
  }
}
