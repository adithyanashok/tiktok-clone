import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controller/search/search_controller.dart';
import 'package:tiktok_clone/views/screens/profile/profile_screen.dart';
import 'package:tiktok_clone/views/widgets/text.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchingController searchController = Get.put(SearchingController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextFormField(
              decoration: const InputDecoration(
                filled: false,
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onFieldSubmitted: (value) => searchController.searchUsers(value),
            ),
          ),
          body: searchController.searchedUsers.isEmpty
              ? const Center(
                  child: CustomText(
                    text: "Search users",
                    fontSize: 15,
                  ),
                )
              : ListView.builder(
                  itemCount: searchController.searchedUsers.length,
                  itemBuilder: (context, index) {
                    final users = searchController.searchedUsers[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: users.uid),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(users.profilePic),
                        ),
                        title: CustomText(
                          text: users.username,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
