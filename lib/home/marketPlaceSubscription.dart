import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class MarketPlaceSubscriptionScreen extends StatefulWidget {
  const MarketPlaceSubscriptionScreen({super.key});

  @override
  State<MarketPlaceSubscriptionScreen> createState() =>
      _MarketPlaceSubscriptionScreenState();
}

class _MarketPlaceSubscriptionScreenState
    extends State<MarketPlaceSubscriptionScreen> {
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
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      // margin: EdgeInsets.only(, top: 10),
                      child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Sextoys Connect',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20)
                    ],
                  )),
                  const SizedBox(height: 10),
                  Text(
                    "Nous proposons une gamme complete de sex Toys, connecte et interactif avec notre plate-forme pour profiter au maximum de l'experience immersive.",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSubscriptionCard(),
                  _buildSubscriptionCard(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildSubscriptionCard() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade700),
        boxShadow: [
          BoxShadow(
            color: whiteColor.withValues(alpha: (0.1 * 255).toDouble()),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Home",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "\$24 /Month",
            style: TextStyle(
              color: whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Clique ici pour decouvrir une selection complete de sex toys pour homme connecte interactif notre plate-forme et experimente l'experience multi sensoriel.",
            style: TextStyle(
              color: whiteColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffD92026),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Découvrir maintenant",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildFeatureRow(Icons.headset_mic, "Get Standby Customer Support"),
          _buildFeatureRow(Icons.diamond, "Premium Service"),
          _buildFeatureRow(Icons.cancel, "Cancel at anytime"),
          _buildFeatureRow(Icons.security, "No Restrictions"),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: whiteColor, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: whiteColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
