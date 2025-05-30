import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/socialMedia/reelDiscover.dart';
import 'package:x_place/socialMedia/reelPage.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class ReelSearchScreen extends StatefulWidget {
  const ReelSearchScreen({super.key});

  @override
  State<ReelSearchScreen> createState() => _ReelSearchScreenState();
}

class _ReelSearchScreenState extends State<ReelSearchScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<Map<String, String>> reels = [
    {'image': 'assets/p1.jpg', 'name': 'Jennifer Lopez'},
    {'image': 'assets/p3.jpg', 'name': 'Michelle Jordan'},
    {'image': 'assets/p4.jpg', 'name': 'Michael James'},
    {'image': 'assets/p3.jpg', 'name': 'Jackson Philips'},
  ];

  final List<String> users = [
    'Jennifer Lopez',
    'Jackson Philips',
    'Michael James',
    'Michelle Mak',
    'Magrette Jones',
    'Dan James',
    'Mattias Randy',
    'Anita Shanky',
    'Jeromy Bante',
    'Mattias Randy',
    'Anita Shanky',
    'Jeromy Bante'
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
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppbarScreen(isBack: true),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      AppRoutes.push(context, ReelPageScreen());
                    },
                    child: Row(
                      children: [
                        Text("Reels",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios_sharp,
                            size: 18, color: whiteColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  CarouselSlider.builder(
                    // carouselController: _controller,
                    itemCount: reels.length,
                    itemBuilder: (context, index, realIdx) {
                      final reel = reels[index];
                      return InkWell(
                        onTap: () {
                          AppRoutes.push(context, ReelDiscoverScreen());
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                Image.asset(reel['image']!,
                                    fit: BoxFit.cover, width: double.infinity),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundImage:
                                              AssetImage(reel['image']!)),
                                      const SizedBox(width: 8),
                                      Text(reel['name']!,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 70,
                                  left: 70,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.play_arrow,
                                        color: whiteColor, size: 28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 220,
                      viewportFraction: 0.6,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: false,
                      autoPlay: false,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInOut,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: reels.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller,
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key
                                ? primaryColor
                                : whiteColor.withValues(alpha: (0.4 * 255).toDouble()),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: greyColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: greyColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list_rounded, color: greyColor),
                              SizedBox(width: 5),
                              Text("Les les populaires",
                                  style: TextStyle(
                                      color: greyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Icon(Icons.keyboard_arrow_down_sharp,
                                  color: greyColor),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 10), // Adjust spacing inside list items
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/sliders/3.png"),
                                ),
                                title: Text(users[index],
                                    style: TextStyle(color: whiteColor)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
