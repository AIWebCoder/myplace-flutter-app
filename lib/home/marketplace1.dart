import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/home/marketPlace2.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  final List<String> imagePaths = [
    'assets/mk1.png',
    'assets/mk2.png',
    'assets/mk3.png',
    'assets/mk4.png',
    'assets/mk5.png',
    'assets/mk2.png',
    'assets/mk3.png',
    'assets/mk4.png',
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
          body: Column(
            children: [
              Row(
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
                    'Femme',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20)
                ],
              ),
              SizedBox(height: 5),
              Container(
                  margin: EdgeInsets.only(left: 25),
                  alignment: Alignment.topLeft,
                  child: Text(
                      'Clique sur ton sex toy favoris pour le \ndécouvrir le choisir')),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8, // Adjusted to improve image size
                    ),
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Expanded(
                            // Wrap image inside Expanded to take up more space
                            child: InkWell(
                              onTap: () {
                                AppRoutes.push(context, MarketPlace2Screen());
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imagePaths[index],
                                  fit: BoxFit.cover,
                                  width: double
                                      .infinity, // Ensures it fills available width
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            height: 20,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
