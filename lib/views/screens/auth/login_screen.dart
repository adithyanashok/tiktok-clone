import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/colors.dart';
import 'package:tiktok_clone/constant/controller.dart';
import 'package:tiktok_clone/controller/auth/auth.dart';
import 'package:tiktok_clone/views/widgets/text.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      return authController.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'TikTok Login',
                      fontSize: 35,
                      color: buttonColor!,
                      fontWeight: FontWeight.w900,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _emailController,
                        labelText: "Email",
                        icon: Icons.email,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _passwordController,
                        labelText: "Password",
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        authController.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );
                      },
                      child: Container(
                        width: width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: 'Login',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: "Don't have an account?",
                          fontSize: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('register');
                          },
                          child: CustomText(
                            text: "Register",
                            color: buttonColor!,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
    });
  }
}
