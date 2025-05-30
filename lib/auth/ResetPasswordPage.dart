import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:x_place/auth/otpScreen.dart';
// import 'package:x_place/auth/signUpPage.dart';
// import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/handler.dart' show button;
import 'package:x_place/utils/const.dart';

class Resetpasswordpage extends StatefulWidget {
  const Resetpasswordpage({super.key});

  @override
  State<Resetpasswordpage> createState() => _ResetpasswordpageState();
}

class _ResetpasswordpageState extends State<Resetpasswordpage> {
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
                                )),
                                const SizedBox(height: 20),
                                Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'New Password',
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
                                    hintText: 'Enter Password',
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
                                const SizedBox(height: 20),
                                button('Login', () {}, primaryColor),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      )))
            ])));
  }
}
