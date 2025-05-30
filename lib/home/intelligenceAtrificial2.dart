import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class Intelligenceatrificial2Screen extends StatefulWidget {
  const Intelligenceatrificial2Screen({super.key});

  @override
  State<Intelligenceatrificial2Screen> createState() =>
      _Intelligenceatrificial2ScreenState();
}

class _Intelligenceatrificial2ScreenState
    extends State<Intelligenceatrificial2Screen> {
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
        // drawer: const DrawerScreen(),
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppbarScreen(isBack: true)),
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    alignment: Alignment.center,

                    height: 160,
                    // child: CircleAvatar(
                    //   radius: 16,
                    //   backgroundImage:
                    child: Lottie.asset('assets/lottie/avatar.json'),
                    // ),
                    //Image.asset('assets/eclipse.png'),
                    // ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      "I wish you a great viewing.\nIf you want to change your request, \ndon't hesitate to call me.",
                      style: TextStyle(color: whiteColor, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildMessageInput(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                // Icon(Icons.emoji_emotions, color: whiteColor),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: whiteColor),
                    decoration: const InputDecoration(
                      hintText: "J'attend avec impatience",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // Icon(Icons.attach_file, color: whiteColor),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        // CircleAvatar(
        //   backgroundColor: primaryColor,
        //   child: Icon(Icons.send, color: whiteColor),
        // ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [secondaryColor, primaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
                3.0), // optional: to create a border effect
            child: ClipOval(
              child: Icon(Icons.send, color: whiteColor),
            ),
          ),
        )
      ],
    );
  }
}
