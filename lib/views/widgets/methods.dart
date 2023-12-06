import 'package:flutter/material.dart';

buildProfilePic(String profileUrl) {
  return SizedBox(
    width: 60,
    height: 60,
    child: Stack(
      children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profileUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

buildMusicAlbum(String profileUrl) {
  return SizedBox(
    width: 60,
    height: 60,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.grey, Colors.white],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image(
              image: NetworkImage(profileUrl),
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    ),
  );
}
