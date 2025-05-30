import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/home/intelligenceAtrificial2.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';

class IntelligenceartificalScreen extends StatefulWidget {
  const IntelligenceartificalScreen({super.key});

  @override
  State<IntelligenceartificalScreen> createState() =>
      _IntelligenceartificalScreenState();
}

class _IntelligenceartificalScreenState
    extends State<IntelligenceartificalScreen> {
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
          body: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    InkWell(
                      onTap: () {
                        AppRoutes.push(
                            context, Intelligenceatrificial2Screen());
                      },
                      child: Container(
                        alignment: Alignment.center,

                        height: 160,
                        // child: CircleAvatar(
                        //   radius: 16,
                        //   backgroundImage:
                        child: Lottie.asset('assets/lottie/avatar.json'),
                        // ),
                        //Image.asset('assets/eclipse.png'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Hello\n I am Myla, your assistant here. \nTell me your desires...',
                        style: TextStyle(color: whiteColor, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Text(
                  'Patientez s’il vous plait...',
                  style: TextStyle(color: whiteColor, fontSize: 16),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: BottomBarScreen(),
        ));
  }
}
