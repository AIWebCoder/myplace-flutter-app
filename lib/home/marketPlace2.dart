import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/home/marketPlaceSubscription.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class MarketPlace2Screen extends StatefulWidget {
  const MarketPlace2Screen({super.key});

  @override
  State<MarketPlace2Screen> createState() => _MarketPlace2ScreenState();
}

class _MarketPlace2ScreenState extends State<MarketPlace2Screen> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildCard("Subscription",
                  "Click to discover the range of subscriptions available for your pleasure",
                  () {
                AppRoutes.push(context, (MarketPlaceSubscriptionScreen()));
              }),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  AppRoutes.push(context, (MarketPlaceSubscriptionScreen()));
                },
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade700),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: (0.1 * 255).toDouble()),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Connected Sextoys',
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Click to discover our wide range of sextoys, connect to our platform to enjoy the experience to the fullest",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: greyColor),
                            boxShadow: [
                              BoxShadow(
                                color: whiteColor.withValues(alpha: (0.1 * 255).toDouble()),
                                spreadRadius: 5,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]),
                        child: Icon(Icons.check),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String description, function) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade700),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: (0.1 * 255).toDouble()),
              spreadRadius: 5,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
