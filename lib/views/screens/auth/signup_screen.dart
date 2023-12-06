import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/colors.dart';
import 'package:tiktok_clone/controller/auth/auth.dart';
import 'package:tiktok_clone/views/widgets/text.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "TikTok Signup",
                fontSize: 35,
                color: buttonColor!,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  authController.pickImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.grey,
                      child: authController.profilePic != null
                          ? Image.file(authController.profilePic!)
                          : Icon(
                              Icons.person,
                              color: Colors.grey[100],
                              size: 100,
                            ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 10,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _usernameController,
                  labelText: "Username",
                  icon: Icons.person,
                ),
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
                onTap: () async {
                  authController.registerUser(
                    _emailController.text,
                    _passwordController.text,
                    _usernameController.text,
                    authController.profilePic!,
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
                      text: "Signup",
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
                    text: "Already have an account?",
                    fontSize: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('login');
                    },
                    child: CustomText(
                      text: "Login",
                      fontSize: 20,
                      color: buttonColor!,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
