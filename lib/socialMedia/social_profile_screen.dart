import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class SocialProfilescreen extends StatefulWidget {
  const SocialProfilescreen({super.key});

  @override
  State<SocialProfilescreen> createState() => _SocialProfilescreenState();
}

class _SocialProfilescreenState extends State<SocialProfilescreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          // drawer: const DrawerScreen(),
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppbarScreen(isBack: true)),
          body: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset("assets/sliders/3.png",
                      width: double.infinity, height: 200, fit: BoxFit.cover),
                  Positioned(
                    bottom: -75,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: whiteColor,
                              child: CircleAvatar(
                                radius: 42,
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Jeniffer Lopez',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 55), // spacing for floating effect

              // Info Section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Information:",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Sex: Female\nAge: Young\nCharacter: Hot\nOrigin: Russian\nHeight: Short\nBody: Skinny, Athletic, Sexy\nBreast: Medium size, round shape\nButtocks: Round, Muscular",
                  style: TextStyle(
                      color: whiteColor,
                      height: 1.4,
                      fontSize: 13,
                      wordSpacing: 2),
                ),
              ),

              // TabBar
              TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: whiteColor,
                indicatorColor: primaryColor,
                indicatorWeight: 2,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: const [
                  Tab(text: "Videos"),
                  Tab(text: "Photos"),
                  Tab(text: "Prive"),
                ],
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildGrid(),
                    buildGrid(),
                    buildGrid(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.7,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage("assets/4.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
