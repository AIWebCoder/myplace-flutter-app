import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:x_place/auth/forgetPassword.dart';
import 'package:x_place/auth/signUpPage.dart';
import 'package:x_place/home/bottom_bar_screen.dart';
// import 'package:x_place/home/landingPage.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/handler.dart' show button;
import 'package:x_place/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:x_place/services/auth.dart';


class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                    child: Form(
                      key: _formKey,
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
                            'Login',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: emailController,
                            cursorColor: primaryColor,
                            style: TextStyle(color: whiteColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withValues(alpha: (0.20 * 255).toDouble()),
                              hintText: 'Enter email address',
                              hintStyle: TextStyle(color: greyColor),
                              prefixIcon: Icon(Icons.email, color: greyColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: greyColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Password',
                            style: TextStyle(color: lightWhiteColor),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            cursorColor: primaryColor,
                            style: TextStyle(color: whiteColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withValues(alpha: (0.20 * 255).toDouble()),
                              hintText: 'Enter password',
                              hintStyle: TextStyle(color: greyColor),
                              prefixIcon: Icon(Icons.lock, color: greyColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: greyColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: greyColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                AppRoutes.push(context, ForgetpasswordScreen());
                              },
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(color: greyColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          button('Login', () async {
                            if (_formKey.currentState!.validate()) {
                              final authProvider = Provider.of<Auth>(context, listen: false);

                              // Show a loading dialog or indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(child: CircularProgressIndicator()),
                              );

                              final result = await authProvider.login(creds: {
                                'email': emailController.text.trim(),
                                'password': passwordController.text,
                              });

                              // Dismiss loading
                              Navigator.of(context).pop();

                              if (result is List && result[0] == true) {
                                // Login successful
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => BottomBarScreen()),
                                  (route) => false,
                                );
                              } else {
                                // Show error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result.toString())),
                                );
                              }
                            }
                          }, primaryColor),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account yet? ",
                                style: TextStyle(color: greyColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AppRoutes.push(context, SignUpPageScreen());
                                },
                                child: Text(
                                  'Create account',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
