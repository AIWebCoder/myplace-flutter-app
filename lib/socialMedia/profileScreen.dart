import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:x_place/socialMedia/tab_screens/discover_screen.dart';
import 'package:x_place/socialMedia/tab_screens/publication_screen.dart';
import 'package:x_place/socialMedia/tab_screens/reels_screen.dart';
// import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';
import 'package:x_place/utils/handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  void _handleScroll() {
    final offset = _scrollController.offset;
    // 200 is your SliverAppBar's expanded height minus toolbar height
    if (offset > 160 && !_isCollapsed) {
      setState(() {
        _isCollapsed = true;
      });
    } else if (offset <= 160 && _isCollapsed) {
      setState(() {
        _isCollapsed = false;
      });
    }
  }

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
            // appBar: const PreferredSize(
            //   preferredSize: Size.fromHeight(kToolbarHeight),
            //   child: AppbarScreen(isBack: true),
            // ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  leading: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [secondaryColor, primaryColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Icon(Icons.arrow_back_ios, color: whiteColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: _isCollapsed
                      ? Image.asset("assets/logo.png", height: 50)
                      : null,
                  expandedHeight: 240.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    // title: const PreferredSize(
                    //   preferredSize: Size.fromHeight(kToolbarHeight),
                    //   child: AppbarScreen(isBack: true),
                    // ),
                    background: Stack(clipBehavior: Clip.none, children: [
                      // Background Image
                      Image.asset("assets/banner.jpg",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover),
                      // Positioned Profile Icon and "LIVE" label
                      Positioned(
                        bottom: 10,
                        left: 16,
                        right: 0,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        primaryColor,
                                        Colors.purple.shade900
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('assets/profile2.png'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 7,
                                  right: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'LIVE',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 5, top: 25),
                              child: Row(
                                children: [
                                  // iconButton(Icons.message_outlined),
                                  iconButton(LucideIcons.circleDollarSign),
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            secondaryColor,
                                            primaryColor
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        // border: Border.all(width: 2, color: primaryColor),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            secondaryColor,
                                            primaryColor
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        // border: Border.all(width: 2, color: primaryColor),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      'Message',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  iconButton(Icons.more_horiz_outlined),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Positioned Information Boxes (Followers, Likes, etc.)
                      Positioned(
                        top: 30,
                        right: 10,
                        child: Row(
                          children: [
                            _infoBox('Followers', '12K'),
                            _infoBox('Likes', '34K'),
                            _infoBox('Photos', '210'),
                            _infoBox('Videos', '54'),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stack(
                        //   clipBehavior: Clip.none,
                        //   children: [
                        //     // Container(
                        //     //   height: 150,
                        //     //   decoration: const BoxDecoration(
                        //     //     image: DecorationImage(
                        //     //       image: AssetImage('assets/banner.jpg'),
                        //     //       fit: BoxFit.cover,
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //     Image.asset("assets/banner.jpg",
                        //         width: double.infinity, height: 200, fit: BoxFit.cover),
                        //     Positioned(
                        //       bottom: -55,
                        //       left: 0,
                        //       right: 0,
                        //       child: Row(
                        //         children: [
                        //           Stack(
                        //             children: [
                        //               Container(
                        //                 padding: EdgeInsets.all(3),
                        //                 decoration: BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   gradient: LinearGradient(
                        //                     colors: [
                        //                       whiteColor,
                        //                       secondaryColor,
                        //                       primaryColor,
                        //                       Colors.purple.shade900
                        //                     ],
                        //                     begin: Alignment.topCenter,
                        //                     end: Alignment.bottomCenter,
                        //                   ),
                        //                 ),
                        //                 child: Container(
                        //                   decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,
                        //                     // border: Border.all(color: whiteColor, width: 3),
                        //                   ),
                        //                   child: const CircleAvatar(
                        //                     radius: 50,
                        //                     backgroundImage:
                        //                         AssetImage('assets/profile2.png'),
                        //                   ),
                        //                 ),
                        //               ),
                        //               Positioned(
                        //                 top: 7,
                        //                 right: 2,
                        //                 child: Container(
                        //                   padding: EdgeInsets.symmetric(
                        //                       horizontal: 5, vertical: 2),
                        //                   decoration: BoxDecoration(
                        //                     color: primaryColor,
                        //                     borderRadius: BorderRadius.circular(10),
                        //                   ),
                        //                   child: Text(
                        //                     'LIVE',
                        //                     style: TextStyle(
                        //                         fontSize: 9,
                        //                         color: whiteColor,
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           // Spacer(),
                        //         ],
                        //       ),
                        //     ),
                        //     Positioned(
                        //       top: 10,
                        //       right: 10,
                        //       child: Row(
                        //         children: [
                        //           _infoBox('Followers', '12K'),
                        //           _infoBox('Likes', '34K'),
                        //           _infoBox('Photos', '210'),
                        //           _infoBox('Videos', '54'),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [],
                        // ),

                        // const SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Jennifer Lopez",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.verified,
                                      color: Colors.blue, size: 16),
                                ],
                              ),
                              Text("@jenniferlopez",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit.',
                            style: TextStyle(color: whiteColor, fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Subscriptions',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SubscriptionBox(
                                  duration: '1 Month', price: '9,50 €'),
                              SubscriptionBox(
                                  duration: '3 Months', price: '9,50 €'),
                              SubscriptionBox(
                                  duration: '6 Months', price: '9,50 €'),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: primaryColor,
                                dividerColor: Colors.transparent,
                                indicatorWeight: 3.0,
                                labelColor: whiteColor,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(child: Icon(Icons.dashboard)
                                      // Text("Publication",
                                      //     style: TextStyle(
                                      //         color: whiteColor,
                                      //         fontSize: 13,
                                      //         fontWeight: FontWeight.bold),
                                      //         ),
                                      ),
                                  Tab(
                                      child: ImageIcon(AssetImage(
                                    'assets/icons/reel.png',
                                  ))

                                      // Text("Reels",
                                      //     style: TextStyle(
                                      //         color: whiteColor,
                                      //         fontSize: 13,
                                      //         fontWeight: FontWeight.bold)),
                                      ),
                                  Tab(child: Icon(Icons.video_collection_sharp)
                                      //  Text("Discover",
                                      //     style: TextStyle(
                                      //         color: whiteColor,
                                      //         fontSize: 13,
                                      //         fontWeight: FontWeight.bold)),
                                      ),
                                ],
                              ),
                            ),
                            // SizedBox(height: 10),
                            // Ensure TabBarView takes the full space
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PublicationScreen(),
                    ReelsScreen(),
                    SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: DiscoverScreen()),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _infoBox(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                color: whiteColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class SubscriptionBox extends StatelessWidget {
  final String duration;
  final String price;

  SubscriptionBox({required this.duration, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: primaryColor,
        gradient: LinearGradient(
          colors: [secondaryColor, primaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            price,
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Subscription\n$duration',
            textAlign: TextAlign.center,
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
