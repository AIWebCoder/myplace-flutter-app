import 'dart:ui';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:x_place/auth/loginPage.dart';
import 'package:x_place/creators/creator_profile_screen.dart';
// import 'package:lottie/lottie.dart';
// import 'package:x_place/home/IntelligenceArtifical.dart';
// import 'package:x_place/home/intelligenceAtrificial2.dart';
import 'package:x_place/home/landingPage.dart';
import 'package:x_place/home/marketplace1.dart';
import 'package:x_place/home/starScreen.dart';
import 'package:x_place/services/auth.dart';
import 'package:x_place/services/dio.dart';
import 'package:x_place/socialMedia/messages.dart';
import 'package:x_place/socialMedia/reelDiscover.dart';
import 'package:x_place/socialMedia/socialMedia.dart';
import 'package:x_place/socialMedia/upload_file.dart';
import 'package:x_place/socialMedia/upload_post.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with TickerProviderStateMixin {
  final List<Widget> _screens = [
    LandingPage(),
    ReelDiscoverScreen(),
    SocialMediaScreen(),
    MessagesScreen(),
  ];

  final List<String> _iconPaths = [
    'assets/icons/home.png',
    'assets/icons/reel.png',
    'assets/icons/socialmedia.png',
    'assets/icons/chat.png',
  ];

  int index = 0;
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  Map<String, dynamic>? user;
  late Auth authProvider;
  late String token;
  int subscriptionsCount = 0;
  int subscribersCount = 0;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(Duration(seconds: 1), () {
      _fabAnimationController.forward();
      _borderRadiusAnimationController.forward();
    });

    authProvider = Provider.of<Auth>(context, listen: false);
    token = authProvider.token!;
    user = authProvider.user;
    loadProfile(token, user);
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }
   
  Options _dioOptions() => Options(
    headers: {
      "Content-Type": "multipart/form-data",
      'Authorization': 'Bearer $token',
    },
  );

  Future<void> loadProfile(String token, Map<String, dynamic>? user) async {
    final username = user?['username'] ?? '';
    if (username.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await DioClient.dio.get(
        '/$username',
        options: _dioOptions(),
      );

      final responseData = response.data['data'];

      if (!mounted) return;

      setState(() {
        user = responseData['user'];

        subscriptionsCount = responseData['subscriptionsCount'] ?? 0;
        subscribersCount = responseData['subscribersCount'] ?? 0;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint('Failed to load profile: $e');
    }
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              logout(); // Perform logout
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isLargeScreen = constraints.maxWidth >= 600;

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
            drawer: isLargeScreen ? null : index == 3 ? _socialDrawer(isLargeScreen) : _buildDrawer(isLargeScreen),
            appBar: index == 1
                ? PreferredSize( preferredSize: Size.fromHeight(0), child: SizedBox())
                : const PreferredSize( preferredSize: Size.fromHeight(kToolbarHeight), child: AppbarScreen()),
            extendBody: true,
            body: Row(
              children: [
                if (isLargeScreen)
                  SizedBox( width: 250, child: index == 3 ? _socialDrawer(isLargeScreen) : _buildDrawer(isLargeScreen), ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: onScrollNotification,
                    child: _screens[index],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: primaryColor, width: 1),
                ),
                // constraints: BoxConstraints.tight(Size(56, 56)),
                onPressed: () {
                  _showBottomSheet();
                },
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: Icon(Icons.add, color: whiteColor),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color:Colors.white.withValues(alpha: (0.1 * 255).toDouble()),
                    border: Border(
                      top: BorderSide( color: Colors.white.withValues(alpha: (0.2 * 255).toDouble()), width: 1),
                    ),
                  ),
                  child: AnimatedBottomNavigationBar.builder(
                    splashColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    itemCount: _iconPaths.length,
                    tabBuilder: (int i, bool isActive) {
                      return SizedBox(
                        height: 25,
                        width: 25,
                        child: Center(
                          child: Image.asset( _iconPaths[i], height: 25, color: isActive ? primaryColor : Colors.white, width: 25, ),
                        ),
                      );
                    },
                    activeIndex: index,
                    gapLocation: GapLocation.center,
                    onTap: (i) {
                      setState(() {
                        index = i;
                      });
                    }
                  ),
                ),
              ),
            ),
          ));
    });
  }

  // _buildDrawer(isLargeScreen) {
  //   return Drawer(
  //     backgroundColor: Colors.transparent,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(12),
  //       child: Container(
  //         height: MediaQuery.of(context).size.height * 0.8,
  //         width: MediaQuery.of(context).size.width * 0.9,

  //         // child: GlassContainer(
  //         //   // alignment: Alignment.r,
  //         //   margin: EdgeInsets.only(top: 50),
  //         //   height: MediaQuery.of(context).size.height * 0.8,
  //         //   width: MediaQuery.of(context).size.width * 0.9,
  //         //   gradient: LinearGradient(
  //         //     colors: [
  //         //       Colors.black.withOpacity(0.50),
  //         //       Colors.black.withOpacity(0.60),
  //         //     ],
  //         //     begin: Alignment.topLeft,
  //         //     end: Alignment.bottomRight,
  //         //   ),
  //         //   borderGradient: LinearGradient(
  //         //     colors: [
  //         //       Colors.black.withOpacity(0.20),
  //         //       Colors.black.withOpacity(0.20),
  //         //       Colors.black.withOpacity(0.10),
  //         //       Colors.black.withOpacity(0.10),
  //         //     ],
  //         //     begin: Alignment.topLeft,
  //         //     end: Alignment.bottomRight,
  //         //     stops: [0.0, 0.39, 0.40, 1.0],
  //         //   ),
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //           // child:
  //           // borderRadius: BorderRadius.circular(12),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.black.withValues(alpha: (0.30 * 255).toDouble()),
  //             ),
  //             child: SingleChildScrollView(
  //               child: Container(
  //                 alignment: Alignment.topLeft,
  //                 margin: EdgeInsets.only(left: 10, top: 60),
  //                 child: Column(
  //                   children: [
  //                     isLargeScreen
  //                         ? SizedBox()
  //                         : InkWell(
  //                             onTap: () {
  //                               Navigator.pop(context);
  //                             },
  //                             child: Container(
  //                                 alignment: Alignment.topLeft,
  //                                 child: Icon(Icons.cancel_outlined,
  //                                     color: whiteColor, size: 35)),
  //                           ),
  //                     const SizedBox(height: 20),
  //                     _list('assets/icons/add.png', 'My Lists', () {
  //                       setState(() {
  //                         index = 0;
  //                       });
  //                     }),
  //                     _list('assets/icons/category.png', 'Category', () {}),
  //                     _list('assets/icons/star.png', 'Star', () {
  //                       AppRoutes.push(context, StarScreen());
  //                     }),
  //                     _list('assets/icons/model.png', 'Modele', () {}),
  //                     _list('assets/icons/marketplace.png', 'Market Place', () {
  //                       AppRoutes.push(context, MarketPlaceScreen());
  //                     }),
  //                     _list('assets/icons/logout.png', 'logout', () {
  //                       logout();
  //                     }),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  
  _buildDrawer(isLargeScreen) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.30),
              ),
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      isLargeScreen
                          ? SizedBox()
                          : Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close, 
                                    color: whiteColor, size: 30),
                              ),
                            ),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.push(context, CreatorProfileScreen());
                        },
                        child: Column(
                          children: [
                            // Photo de profil
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                                image: DecorationImage(
                                  image: user?['avatar'].startsWith('http')
                                      ? NetworkImage(user?['avatar'])
                                      : AssetImage(user?['avatar']) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('${user!['name']}', style: TextStyle( color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('${user!['username']}', style: TextStyle( color: Colors.grey, fontSize: 14)),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Abonnés
                                Column(
                                  children: [
                                    Text('$subscribersCount',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Abonnés",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 25,
                                  width: 1,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                Column(
                                  children: [
                                    Text('$subscriptionsCount',
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Abonnements",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            _list('assets/icons/add.png', 'My Lists', () {
                              setState(() {
                                index = 0;
                              });
                            }),
                            _list('assets/icons/category.png', 'Category', () {}),
                            _list('assets/icons/star.png', 'Star', () {
                              AppRoutes.push(context, StarScreen());
                            }),
                            _list('assets/icons/model.png', 'Modele', () {}),
                            _list('assets/icons/marketplace.png', 'Market Place', () {
                              AppRoutes.push(context, MarketPlaceScreen());
                            }),
                            _list('assets/icons/logout.png', 'Logout', () {
                              confirmLogout();
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  void logout() {
    Auth authProvider = Provider.of<Auth>(context, listen: false);
    authProvider.logout();
    Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => const LoginPageScreen()));
  }

  _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 300,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  AppRoutes.push(context, UploadPostScreen());
                },
                child: ListTile(
                  minTileHeight: 30,
                  contentPadding: EdgeInsets.all(5),
                  leading: Image.asset('assets/icons/subscription.png'),
                  title: Text('New Post'),
                ),
              ),
              InkWell(
                onTap: () {
                  AppRoutes.push(context, UploadFileScreen());
                },
                child: ListTile(
                  minTileHeight: 30,
                  contentPadding: EdgeInsets.all(5),
                  leading: Icon(Icons.subscriptions, size: 15),
                  title: Text('New Reel'),
                ),
              ),
              ListTile(
                minTileHeight: 30,
                leading: Image.asset('assets/icons/story.png'),
                contentPadding: EdgeInsets.all(5),
                title: Text('New Story'),
              ),
              ListTile(
                minTileHeight: 30,
                leading: Image.asset('assets/icons/live.png'),
                contentPadding: EdgeInsets.all(5),
                title: Text('Start a Live'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  _socialDrawer(isLargeScreen) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,

            // child: GlassContainer(
            //   // alignment: Alignment.r,
            //   margin: EdgeInsets.only(top: 50),
            //   height: MediaQuery.of(context).size.height * 0.8,
            //   width: MediaQuery.of(context).size.width * 0.9,
            //   gradient: LinearGradient(
            //     colors: [
            //       Colors.black.withOpacity(0.50),
            //       Colors.black.withOpacity(0.60),
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            //   borderGradient: LinearGradient(
            //     colors: [
            //       Colors.black.withOpacity(0.20),
            //       Colors.black.withOpacity(0.20),
            //       Colors.black.withOpacity(0.10),
            //       Colors.black.withOpacity(0.10),
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     stops: [0.0, 0.39, 0.40, 1.0],
            //   ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              // child:
              // borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Colors.black.withValues(alpha: (0.30 * 255).toDouble()),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      children: [
                        isLargeScreen
                            ? SizedBox()
                            : InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Icon(Icons.cancel_outlined,
                                        color: whiteColor, size: 35)),
                              ),
                        const SizedBox(height: 20),
                        _list(Icons.person, 'Profile', () {}, iconData: true),
                        _list(
                            Icons.subscriptions_outlined, 'Subscription', () {},
                            iconData: true),
                        _list(Icons.checklist_rounded, 'Lists', () {},
                            iconData: true),
                        _list(Icons.bookmark_border, 'Bookmarks', () {},
                            iconData: true),
                        _list(Icons.message, 'Messages', () {
                          AppRoutes.push(context, MessagesScreen());
                        }, iconData: true),
                        _list(Icons.notifications_none_sharp, 'Notifications',
                            () {},
                            iconData: true),
                        _list(Icons.add_business_outlined, 'Refferral', () {},
                            iconData: true),
                        _list(Icons.model_training_outlined, 'Become a Model',
                            () {},
                            iconData: true),
                        _list(Icons.help_center_outlined, 'Help Center', () {},
                            iconData: true),
                        _list(Icons.terminal_sharp, 'Terms', () {},
                            iconData: true),
                        _list(
                            Icons.privacy_tip_outlined, 'Privacy Policy', () {},
                            iconData: true),
                        _list(Icons.settings, 'Settings', () {},
                            iconData: true),
                        _list(Icons.language, 'Language', () {},
                            iconData: true),
                        _list(Icons.light_mode_outlined, 'Light Mode', () {},
                            iconData: true),
                        _list(Icons.logout_rounded, 'Logout', () {},
                            iconData: true),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  _list(img, title, func, {iconData = false}) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: func,
        child: Row(
          children: [
            !iconData
                ? Image.asset(img, height: 20)
                : Icon(img, color: whiteColor),
            SizedBox(width: 25),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                textAlign: TextAlign.left,
                title,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

