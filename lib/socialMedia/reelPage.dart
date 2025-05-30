import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:x_place/socialMedia/profileScreen.dart';
// import 'package:x_place/socialMedia/reelDiscover.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';

class ReelPageScreen extends StatefulWidget {
  @override
  State<ReelPageScreen> createState() => _ReelPageScreenState();
}

class _ReelPageScreenState extends State<ReelPageScreen> {
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
            body: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/reel.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Top Bar
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          AppRoutes.push(context, ProfileScreen());
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/p1.jpg'),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jennifer Lopez',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '@craig_love',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.close,
                            color: whiteColor,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Bar
                Positioned(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 28,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '328.7K',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.circleDollarSign,
                            color: whiteColor,
                            size: 28,
                          ),
                          SizedBox(width: 16),
                          Icon(
                            LucideIcons.share2,
                            color: whiteColor,
                            size: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
