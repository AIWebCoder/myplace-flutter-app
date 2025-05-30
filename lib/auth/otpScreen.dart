import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:x_place/auth/ResetPasswordPage.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';
import 'package:x_place/utils/handler.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
                                  'Enter OTP Code',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                PinCodeTextField(
                                  length: 4,
                                  appContext: context,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(8),
                                    fieldHeight: 85,
                                    fieldWidth: 65,
                                    activeColor: Colors.white38,
                                    selectedColor: Colors.white38,
                                    inactiveColor: Colors.white38,
                                    inactiveFillColor: Colors.transparent,
                                    activeFillColor: Colors.transparent,
                                    selectedFillColor: Colors.transparent,
                                  ),
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  cursorColor: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  backgroundColor: Colors.transparent,
                                  enableActiveFill: false,
                                  onCompleted: (value) {
                                    print("OTP Entered: $value");
                                  },
                                  onChanged: (value) {},
                                ),
                                button('Reset Password', () {
                                  AppRoutes.push(context, Resetpasswordpage());
                                }, primaryColor),
                              ],
                            ),
                          ),
                        ),
                      )))
            ])));
  }
}
