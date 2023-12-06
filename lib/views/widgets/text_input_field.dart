import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tiktok_clone/constant/colors.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconData icon;

  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    log(controller.text);
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: borderColor),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
