import 'package:get/get.dart';
import 'package:tiktok_clone/constant/firebase.dart';
import 'package:tiktok_clone/models/user.dart';

class SearchingController extends GetxController {
  final Rx<List<UserModel>> _searchedser = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUsers => _searchedser.value;

  searchUsers(String searchQuery) async {
    _searchedser.bindStream(
      firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchQuery)
          .snapshots()
          .map(
        (event) {
          List<UserModel> returnValue = [];
          for (var element in event.docs) {
            returnValue.add(UserModel.fromSnap(element));
          }
          return returnValue;
        },
      ),
    );
  }
}
