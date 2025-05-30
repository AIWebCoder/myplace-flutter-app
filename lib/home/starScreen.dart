import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/home/userScreen.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/appbar.dart';
// import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class StarScreen extends StatefulWidget {
  const StarScreen({super.key});

  @override
  State<StarScreen> createState() => _StarScreenState();
}

class _StarScreenState extends State<StarScreen> {
  final List<String> images = [
    "assets/3.png",
    "assets/4.png",
    "assets/4.png",
    "assets/sliders/3.png",
    "assets/4.png",
    "assets/3.png",
    "assets/4.png",
    "assets/4.png",
    "assets/sliders/3.png",
    "assets/4.png",
    "assets/4.png",
    "assets/3.png",

    // Add more images here
  ];

  List<String> names = [
    "Emma",
    "Sophia",
    "Olivia",
    "Isabella",
    "Mia",
    "Charlotte",
    "Sophia",
    "Olivia",
    "Isabella",
    "Mia",
    "Charlotte",
    "Sophia",
  ];
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 9 / 16,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          AppRoutes.push(context, Userscreen());
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                images[index],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage("assets/sliders/3.png"),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            names[index],
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
