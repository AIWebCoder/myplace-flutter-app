// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
// import 'package:x_place/socialMedia/profileScreen.dart';
// import 'package:x_place/socialMedia/reelDiscover.dart';
import 'package:x_place/socialMedia/reelPage.dart';
// import 'package:x_place/socialMedia/social_profile_screen.dart';
import 'package:x_place/socialMedia/tab_screens/social_post_card.dart';
import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/socialmediaDrawer.dart';

class SocialMediaScreen extends StatefulWidget {
  const SocialMediaScreen({super.key});

  @override
  State<SocialMediaScreen> createState() => _SocialMediaScreenState();
}

class _SocialMediaScreenState extends State<SocialMediaScreen>
    with SingleTickerProviderStateMixin {
  // int _current = 0;
  // final CarouselController _controller = CarouselController();

  final List<Map<String, String>> reels = [
    {'image': 'assets/p1.jpg', 'name': 'Jennifer Lopez'},
    {'image': 'assets/p3.jpg', 'name': 'Michelle Jordan'},
    {'image': 'assets/p4.jpg', 'name': 'Michael James'},
    {'image': 'assets/p3.jpg', 'name': 'Jackson Philips'},
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> profiles = [
    {
      'image': 'assets/p1.jpg',
      'name': 'Jennifer Lopez',
      'username': '@jenniferlopez',
    },
    {
      'image': 'assets/p3.jpg',
      'name': 'Emily Clark',
      'username': '@emilyclark',
    },
    {
      'image': 'assets/p4.jpg',
      'name': 'Sophie Turner',
      'username': '@sophieturner',
    },
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                thumbnailRow([
                  "p3.jpg",
                  "p1.jpg",
                  "p4.jpg",
                  "p1.jpg",
                  "p3.jpg",
                  "p4.jpg",
                  "p1.jpg",
                ], 'Jennifer'),
                SizedBox(height: 15),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TabBar(
                        // isScrollable: true,
                        controller: _tabController,
                        indicatorColor: primaryColor,
                        indicatorWeight: 3.0,
                        labelColor: whiteColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(
                            child: Text("Pour vous",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Tab(
                            child: Text("Abonnement",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Ensure TabBarView takes the full space
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          buildTabContent(),
                          buildTabContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildTabContent() {
    return

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(children: [
        //         InkWell(
        //           onTap: () {
        //             AppRoutes.push(context, ProfileScreen());
        //           },
        //           child: CircleAvatar(
        //             backgroundImage: AssetImage('assets/p3.jpg'),
        //           ),
        //         ),
        //         SizedBox(width: 10),
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text("Jennifer Lopez",
        //                 style: TextStyle(
        //                     color: whiteColor,
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.bold)),
        //             Text("10 minutes ago",
        //                 style: TextStyle(color: Colors.grey, fontSize: 12)),
        //           ],
        //         ),
        //         Spacer(),
        //         Icon(Icons.more_horiz, color: whiteColor)
        //       ]),
        //       SizedBox(height: 5),
        //       Container(
        //         margin: EdgeInsets.only(left: 50),
        //         child: Text(
        //           "Dorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit.",
        //           style: TextStyle(color: whiteColor, fontSize: 14),
        //         ),
        //       ),
        //       SizedBox(height: 8),
        //       Row(
        //         children: [
        //           Container(
        //             width: 2,
        //             height: 300,
        //             color: greyColor,
        //             margin: EdgeInsets.only(right: 15, left: 15),
        //           ),

        //           /// Main Image (p4.jpg)
        //           Expanded(
        //             child: ClipRRect(
        //               borderRadius: BorderRadius.circular(10),
        //               child: Image.asset(
        //                 'assets/p4.jpg',
        //                 width: double.infinity,
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: 8),
        //       Container(
        //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.favorite_outline,
        //               color: whiteColor,
        //               size: 30,
        //             ),
        //             SizedBox(width: 5),
        //             Container(
        //               padding: EdgeInsets.all(5),
        //               decoration: BoxDecoration(
        //                   color: whiteColor,
        //                   borderRadius: BorderRadius.circular(10)),
        //               child: Row(
        //                 children: [
        //                   Image.asset(
        //                     'assets/dollar.png',
        //                   ),
        //                   SizedBox(width: 5),
        //                   Text(
        //                     'Personal Request',
        //                     style: TextStyle(color: blackColor),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             Spacer(),
        //             Icon(Icons.bookmark_border_outlined, color: whiteColor),
        //             SizedBox(width: 15),
        //             Icon(Icons.share, color: whiteColor),
        //           ],
        //         ),
        //       ),
        //       Container(
        //         margin: EdgeInsets.only(left: 10, top: 5),
        //         child: const Row(
        //           children: [
        //             CircleAvatar(
        //               radius: 15,
        //               backgroundImage: AssetImage('assets/p3.jpg'),
        //             ),
        //             SizedBox(width: 3),
        //             CircleAvatar(
        //               radius: 15,
        //               backgroundImage: AssetImage('assets/p4.jpg'),
        //             ),
        //             SizedBox(width: 15),
        //             Text(
        //               '70 Likes',
        //               style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        //             )
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
        SingleChildScrollView(
            child: Column(
      children: [
        SocialPostCard(),
        // SizedBox(height: 10),
        // Container(
        //   margin: EdgeInsets.only(left: 20),
        //   child: Row(
        //     children: [
        //       Text("Selected Just for You",
        //           style: TextStyle(
        //               color: whiteColor,
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold)),
        //       const SizedBox(width: 10),
        //       Icon(Icons.arrow_forward_ios_sharp,
        //           size: 18, color: whiteColor),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 10),
        // buildTabContent(),
        Container(
          margin: EdgeInsets.only(left: 20, top: 5, bottom: 10),
          child: Row(
            children: [
              Text("Selected for You",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_sharp, size: 18, color: whiteColor),
            ],
          ),
        ),
        SizedBox(
          height: 220, // Height of each card
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 👈 makes it scroll sideways
            itemCount: profiles.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Container(
                width: 160,
                margin:
                    const EdgeInsets.only(right: 12), // spacing between cards
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(profile['image']!),
                    ),
                    SizedBox(height: 5),
                    Text(
                      profile['name']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      profile['username']!,
                      style: TextStyle(fontSize: 11, color: greyColor),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(5),
                        textColor: blackColor,
                        color: whiteColor,
                        child: const Text(
                          'Follow',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        SocialPostCard(),
        SocialPostCard(),
        SocialPostCard(),
        SizedBox(height: 90),
      ],
    ));
  }

  Widget thumbnailRow(List<String> images, String name) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                AppRoutes.push(context, ReelPageScreen());
              }
            },
            child: Stack(
              children: [
                Opacity(
                  opacity: index == 0 ? 0.5 : 1.0,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage("assets/${images[index]}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (index == 0)
                  Positioned(
                    top: 10,
                    left: 15,
                    child: GestureDetector(
                      onTapDown: ((details) {
                        alert(context, details);
                      }),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: blackColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 5,
                  left: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      name,
                      style: TextStyle(color: whiteColor, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  alert(BuildContext context, TapDownDetails details) {
    final Offset position = details.globalPosition;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: position.dx - 50,
              top: position.dy - 80,
              child: Material(
                color: Colors.transparent,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _list('assets/icons/subscription.png', 'New Post'),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Icon(Icons.subscriptions, size: 15),
                            SizedBox(width: 10),
                            Text(
                              'New Reel',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      _list('assets/icons/story.png', 'New Story'),
                      _list('assets/icons/live.png', 'Start a Live'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _list(img, text) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Image.asset(img),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
