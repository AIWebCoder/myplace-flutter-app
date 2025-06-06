// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:x_place/auth/loginPage.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/handler.dart' show button;
import 'package:x_place/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:x_place/services/auth.dart';

class SignUpPageScreen extends StatefulWidget {
  const SignUpPageScreen({super.key});

  @override
  State<SignUpPageScreen> createState() => _SignUpPageScreenState();
}

class _SignUpPageScreenState extends State<SignUpPageScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmpasswordController =
      TextEditingController();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f0f0f), Color(0xff2b2b2b)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(fit: StackFit.expand, children: [
              Image.asset(
                'assets/bg.png',
                fit: BoxFit.cover,
              ),
              Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.9,

                        // child: GlassContainer(
                        //   // alignment: Alignment.r,
                        //   margin: EdgeInsets.only(top: 50),
                        //   height: MediaQuery.of(context).size.height * 0.8,
                        //   width: MediaQuery.of(context).size.width * 0.9,
                        //   gradient: LinearGradient(
                        //     colors: [
                        //       Colors.black.withOpacity(0.50),
                        //       Colors.black.withOpacity(0.60),
                        //     ],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //   ),
                        //   borderGradient: LinearGradient(
                        //     colors: [
                        //       Colors.black.withOpacity(0.20),
                        //       Colors.black.withOpacity(0.20),
                        //       Colors.black.withOpacity(0.10),
                        //       Colors.black.withOpacity(0.10),
                        //     ],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //     stops: [0.0, 0.39, 0.40, 1.0],
                        //   ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          // child:
                          // borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: (0.30 * 255).toDouble()),
                            ),
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/logo.png',
                                    height: 100,
                                    width: 170,
                                  ),
                                ),
                                // const SizedBox(height: 20),
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Name',
                                  style: TextStyle(color: lightWhiteColor),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: nameController,
                                  cursorColor: primaryColor,
                                  style: TextStyle(color: whiteColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blackColor,
                                    hintText: 'Type Your Name',
                                    hintStyle: TextStyle(color: greyColor),
                                    prefixIcon:
                                        Icon(Icons.email, color: greyColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: greyColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Email',
                                  style: TextStyle(color: lightWhiteColor),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: emailController,
                                  cursorColor: primaryColor,
                                  style: TextStyle(color: whiteColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blackColor,
                                    hintText: 'Enter email address',
                                    hintStyle: TextStyle(color: greyColor),
                                    prefixIcon:
                                        Icon(Icons.email, color: greyColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: greyColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Password',
                                  style: TextStyle(color: lightWhiteColor),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: passwordController,
                                  obscureText: !isPasswordVisible,
                                  cursorColor: primaryColor,
                                  style: TextStyle(color: whiteColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blackColor,
                                    hintText: 'Enter password',
                                    hintStyle: TextStyle(color: greyColor),
                                    prefixIcon:
                                        Icon(Icons.lock, color: greyColor),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: greyColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: greyColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: primaryColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Enter Password',
                                  style: TextStyle(color: lightWhiteColor),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: ConfirmpasswordController,
                                  obscureText: !isPasswordVisible,
                                  cursorColor: primaryColor,
                                  style: TextStyle(color: whiteColor),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blackColor,
                                    hintText: 'Confirm password',
                                    hintStyle: TextStyle(color: greyColor),
                                    prefixIcon:
                                        Icon(Icons.lock, color: greyColor),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: greyColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: greyColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: primaryColor),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),
                                button('Register', () async {
                                  final auth = Provider.of<Auth>(context, listen: false);

                                  final name = nameController.text.trim();
                                  final email = emailController.text.trim();
                                  final password = passwordController.text;
                                  final confirmPassword =
                                      ConfirmpasswordController.text;

                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty ||
                                      confirmPassword.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Please fill in all fields'),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }

                                  if (password != confirmPassword) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Passwords do not match'),
                                      backgroundColor: Colors.red,
                                    ));
                                    return;
                                  }

                                  final success = await auth.register(data: {
                                    'name': name,
                                    'email': email,
                                    'password': password,
                                    'password_confirmation': confirmPassword,
                                  });

                                  if (success) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Registration successful!'),
                                      backgroundColor: Colors.green,
                                    ));
                                    AppRoutes.replace(
                                        context, LoginPageScreen());
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Registration failed'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                }, primaryColor),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(color: greyColor),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        AppRoutes.push(
                                            context, LoginPageScreen());
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))),
            ])));
  }
}
