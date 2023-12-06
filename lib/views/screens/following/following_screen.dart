import 'package:flutter/material.dart';

class FollowingScreen extends StatelessWidget {
  final data;
  const FollowingScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(data),
      ),
    );
  }
}
