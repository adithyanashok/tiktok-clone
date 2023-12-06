import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/controller/notification/notification_controller.dart';
import 'package:tiktok_clone/models/comments.dart';

class CommentsController extends GetxController {
  final Rx<List<CommentModel>> _comments = Rx<List<CommentModel>>([]);

  List<CommentModel> get comments => _comments.value;
  final NotificationClass notificationClass = NotificationClass();

  String _postId = '';

  updatePostid(String id) {
    _postId = id;
    getComments();
  }

  getComments() async {
    _comments.bindStream(
      firestore
          .collection('videos')
          .doc(_postId)
          .collection("comments")
          .snapshots()
          .map(
        (event) {
          List<CommentModel> returnValue = [];
          for (var element in event.docs) {
            returnValue.add(CommentModel.fromSnap(element));
          }
          return returnValue;
        },
      ),
    );
  }

  Future<void> postComment(String commentTxt, String profileId) async {
    try {
      // Check if the comment is not empty
      if (commentTxt.isNotEmpty) {
        // Retrieve the current user's document from the 'users' collection
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser?.uid)
            .get();

        // Retrieve all comments for a specific video
        var allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection("comments")
            .get();

        // Get the length of existing comments to determine the new comment's ID
        int len = allDocs.docs.length;

        // Extract user data from the user document
        var userData = userDoc.data() as dynamic;

        // Create a CommentModel instance with the comment information
        CommentModel commentModel = CommentModel(
          username: userData['username'],
          comment: commentTxt.trim(),
          publishedDate: DateTime.now(),
          uid: firebaseAuth.currentUser!.uid,
          profilePic: userData['profilePic'],
          likes: [],
          id: 'Comment $len',
        );

        // Add the new comment to the 'comments' collection for the specific video
        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc("comment $len")
            .set(commentModel.toJson());

        // Notify about the new comment
        notificationClass.commentPost(
          userData['username'],
          authController.user!.uid,
          profileId,
          _postId,
          "commented: $commentTxt",
          userData['fcmToken'],
        );

        // Update the comment count in the video document
        DocumentSnapshot snap =
            await firestore.collection('videos').doc(_postId).get();
        final comment = snap.data()! as dynamic;
        firestore.collection('videos').doc(_postId).update(
          {"commentCount": comment['commentCount'] + 1},
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> likeComment(String id) async {
    // Get the current user's ID
    var uid = firebaseAuth.currentUser!.uid;

    // Retrieve the document for the specified comment
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    // Check if the current user has already liked the comment
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      // If liked, remove the user's ID from the 'likes' array
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        "likes": FieldValue.arrayRemove([uid])
      });
    } else {
      // If not liked, add the user's ID to the 'likes' array
      await firestore
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        "likes": FieldValue.arrayUnion([uid])
      });
    }
  }
}
