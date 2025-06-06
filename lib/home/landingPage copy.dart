// import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:x_place/model/reel_model.dart';
import 'package:x_place/utils/const.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
  bool menuShown = false;
  double appbarHeight = 80.0;
  double menuHeight = 0.0;
  late Animation<double> openAnimation, closeAnimation;
  late AnimationController openController, closeController;
  // int _currentPage = 1;
  int _current = 0;
  // String? _selectedCategory;
  var videoImages = [5, 1, 6, 7, 5, 1, 6, 7, 5, 1, 6, 7];
  List<Reel> reels = [];
  bool isLoading = true;
  
  final CarouselSliderController _controller = CarouselSliderController();
  // final CarouselSliderController _controller2 = CarouselSliderController();
  final CarouselSliderController _controller3 = CarouselSliderController();
  // final CarouselSliderController _controller = CarouselSliderController();
  var categories = [
    'Ruse',
    'Muscle',
    'Add Categories',
    'Ruse',
    'Muscle',
    'Add Categories',
    'Ruse',
    'Muscle',
    'Add Categories',
    'Ruse',
    'Muscle',
    'Add Categories',
    'Ruse',
    'Muscle',
    'Add Categories'
  ];
  @override
  void initState() {
    super.initState();
    openController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    closeController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    openAnimation = Tween(begin: 0.0, end: 1.0).animate(openController)
      ..addListener(() {
        setState(() {
          menuHeight = openAnimation.value;
        });
      });
    closeAnimation = Tween(begin: 1.0, end: 0.0).animate(closeController)
      ..addListener(() {
        setState(() {
          menuHeight = closeAnimation.value;
        });
      });
  }

  _handleMenuPress() {
    setState(() {
      openController.reset();
      closeController.reset();
      menuShown = !menuShown;
      menuShown ? openController.forward() : closeController.forward();
    });
  }

  @override
  void dispose() {
    openController.dispose();
    closeController.dispose();
    super.dispose();
  }
  
  // Future<void> loadReels() async {
  //   try {
  //     final data = await ReelService.fetchReels(context);
  //     print('output of reels fetch  : $data');
  //     setState(() {
  //       reels = data;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print(e);
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return
        // Scaffold(
        //   drawer: DrawerScreen(),
        // appBar: const PreferredSize(
        //   preferredSize: Size.fromHeight(kToolbarHeight),
        //   child: AppbarScreen(),
        // ),
        // body:
        SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          menuShown
              ? Container(
                  color: Colors.transparent,
                  height: menuHeight,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            for (var i = 0; i < categories.length; i++) ...[
                              Container(
                                  padding: const EdgeInsets.only(  bottom: 10.0, left: 20),
                                  alignment: Alignment.topLeft,
                                  child: Text(categories[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18.0,
                                      ))),
                            ]
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                menuShown = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  border: Border.all(color: whiteColor),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.close, size: 30),
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (kIsWeb) Drawer(),
                      // Categories
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   alignment: Alignment.center,
                            //   height: 40,
                            //   // padding: EdgeInsets.symmetric(horizontal: 2),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     border: Border.all(color: whiteColor),
                            //   ),
                            //   child: DropdownButton<String>(
                            //     alignment: AlignmentDirectional.center,
                            //     // padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                            //     value: _selectedCategory,
                            //     // isExpanded: true,
                            //     // isDense: true,
                            //     hint: Text(
                            //       "Categories",
                            //       textAlign: TextAlign.center,
                            //       style: TextStyle(color: whiteColor, fontSize: 13),
                            //     ),

                            //     icon: Icon(Icons.keyboard_arrow_down_rounded,
                            //         color: whiteColor, size: 18),
                            //     // iconSize: 24,

                            //     // elevation: 16,
                            //     // style: TextStyle(color: Colors.black, fontSize: 16),
                            //     underline: SizedBox(),
                            //     onChanged: (String? newValue) {
                            //       setState(() {
                            //         _selectedCategory = newValue!;
                            //       });
                            //     },
                            //     items: ['Ruse', 'Muscle', 'Add Categories']
                            //         .map<DropdownMenuItem<String>>((String value) {
                            //       return DropdownMenuItem<String>(
                            //         value: value,
                            //         child: Text(
                            //           value,
                            //           style: TextStyle(color: whiteColor, fontSize: 13),
                            //         ),
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
                                // decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(8),
                                // border: Border.all(color: whiteColor)),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('All'),
                                        )),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: darkGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('Standered'),
                                        )),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: darkGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text('360/VR'),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            // Text('All | '),
                            // Text('Standered | '),
                            // Text('360/VR'),
                            // Spacer(),
                            // _categoryButton("All", () {}),
                            // _categoryButton("Strandard", () {}),
                            // _categoryButton("360/VR", () {}),
                            _categoryButton("Categories", () {
                              _handleMenuPress();
                            }),

                            //
                          ],
                        ),
                      ),

                      // Slider with active dots
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: double.infinity,
                        child: CarouselSlider(
                          items: [2, 2, 2].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                            "assets/sliders/$i.png",
                                          ))),
                                  // child: Image.asset("assets/sliders/$i.png",
                                  //     fit: BoxFit.fill),
                                );
                              },
                            );
                          }).toList(),
                          carouselController: _controller,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            height: 400,

                            aspectRatio: 16 / 9,
                            // viewportFraction: 0.95,
                            // initialPage: 0, viewportFraction: 0.8,
                            enableInfiniteScroll: true,
                            reverse: false,
                            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [1, 2, 1].asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == entry.key
                                    ? Theme.of(context).primaryColor
                                    : whiteColor.withValues(alpha: 0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Continue Watching
                      sectionTitle("Top tendancy"),
                      topTendencyVideo([
                        "video1.jpg",
                        "video2.jpg",
                        "video1.jpg",
                        "video1.jpg",
                        "video2.jpg",
                        "video1.jpg",
                        "video1.jpg",
                        "video2.jpg",
                        "video1.jpg"
                      ], true),
                      sectionTitle("Continue Watching"),
                      thumbnailVideo(
                          ["video1.jpg", "video2.jpg", "video1.jpg"], true),

                      // Nouveaute
                      // sectionTitle("Nouveaute"),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.width * 0.45,
                      //   width: double.infinity,
                      //   child: CarouselSlider(
                      //     items: [5, 1, 6, 7].map((i) {
                      //       return GestureDetector(
                      //           onTap: () {
                      //             AppRoutes.push(context, VideoDetailScreen());
                      //           },
                      //           child: Stack(
                      //             children: [
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(20),
                      //                     image: DecorationImage(
                      //                         fit: BoxFit.fill,
                      //                         image: AssetImage(
                      //                           "assets/sliders/$i.jpg",
                      //                         ))),

                      //                 // child: Image.asset("assets/sliders/$i.png",
                      //                 //     fit: BoxFit.fill),
                      //               ),
                      //               Positioned(
                      //                   top: 10,
                      //                   left: 10,
                      //                   child: Icon(Icons.hd))
                      //             ],
                      //           ));
                      //     }).toList(),
                      //     carouselController: _controller2,
                      //     options: CarouselOptions(
                      //       onPageChanged: (index, reason) {
                      //         setState(() {
                      //           _current = index;
                      //         });
                      //       },
                      //       // height: 400,
                      //       aspectRatio: 16 / 9,
                      //       viewportFraction: 0.7,
                      //       initialPage: 0,
                      //       enableInfiniteScroll: true,
                      //       reverse: false,
                      //       autoPlay: false,
                      //       enlargeCenterPage: true,
                      //       enlargeFactor: 0.3,
                      //     ),
                      //   ),
                      // ),
                      // import 'package:overlapped_carousel/overlapped_carousel.dart';

                          // Inside your build method
                      // Container(
                      //   height: min(
                      //       MediaQuery.of(context).size.width / 3.3 * (16 / 9),
                      //       MediaQuery.of(context).size.height * .9),
                      //   // width: double.infinity,
                      //   child: OverlappedCarousel(
                      //     // skewAngle: 0.1,
                      //     // itemCount: 4,
                      //     // skewAngle: -0.5,
                      //     // itemBuilder: (context, index) {
                      //     //   int i = [5, 1, 6, 7][index];
                      //     onClicked: (v) {
                      //       AppRoutes.push(context, VideoDetailScreen());
                      //     },
                      //     widgets: [
                      //       for (var i = 0; i < videoImages.length; i++) ...[
                      //         GestureDetector(
                      //           onTap: () {
                      //             AppRoutes.push(context, VideoDetailScreen());
                      //           },
                      //           child: Container(
                      //             // width: 350,
                      //             // margin:
                      //             //     const EdgeInsets.symmetric(vertical: 10),
                      //             // decoration: BoxDecoration(
                      //             //   borderRadius: BorderRadius.circular(20),
                      //             //   image: DecorationImage(
                      //             //       image: AssetImage(
                      //             //           "assets/sliders/${videoImages[i]}.jpg"),
                      //             //       fit: BoxFit.cover,
                      //             //       scale: 5.0),
                      //             //   boxShadow: [
                      //             //     BoxShadow(
                      //             //       color: Colors.black26,
                      //             //       blurRadius: 10,
                      //             //       offset: Offset(0, 5),
                      //             //     )
                      //             //   ],
                      //             // ),
                      //             // child: const Align(
                      //             //   alignment: Alignment.topLeft,
                      //             //   child: Padding(
                      //             //     padding: EdgeInsets.all(10.0),
                      //             //     child:
                      //             //         Icon(Icons.hd, color: Colors.white),
                      //             //   ),
                      //             // ),
                      //             child: Stack(
                      //               children: [
                      //                 ClipRRect(
                      //                   // decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   // ),
                      //                   child: Image.asset(
                      //                     "assets/sliders/${videoImages[i]}.jpg",
                      //                     width: 500,
                      //                     fit: BoxFit.cover,
                      //                     height: 700,
                      //                   ),
                      //                 ),
                      //                 Positioned(
                      //                   top: 2,
                      //                   child:
                      //                       Icon(Icons.hd, color: Colors.white),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ]
                      //     ],
                      //   ),
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [1, 2, 1].asMap().entries.map((entry) {
                      //     return GestureDetector(
                      //       onTap: () => _controller2.animateToPage(entry.key),
                      //       child: Container(
                      //         width: 8.0,
                      //         height: 8.0,
                      //         margin: const EdgeInsets.symmetric(
                      //             vertical: 4.0, horizontal: 2.0),
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: _current == entry.key
                      //               ? Theme.of(context).primaryColor
                      //               : whiteColor.withOpacity(0.4),
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Top Aujourd'hui",
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text("See more",
                                style:
                                    TextStyle(color: whiteColor, fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.45,
                        width: double.infinity,
                        child: CarouselSlider(
                          items: [6, 1, 9, 7].map((i) {
                            return GestureDetector(
                                onTap: () {
                                  // AppRoutes.push(context, VideoDetailScreen());
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                "assets/sliders/$i.jpg",
                                              ))),

                                      // child: Image.asset("assets/sliders/$i.png",
                                      //     fit: BoxFit.fill),
                                    ),
                                    Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Icon(Icons.hd))
                                  ],
                                ));
                          }).toList(),
                          carouselController: _controller3,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            // height: 400,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.7,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [1, 2, 1].asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller3.animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == entry.key
                                    ? Theme.of(context).primaryColor
                                    : whiteColor.withValues(alpha: (0.4 * 255).toDouble()),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Selection pour vous + See More Row
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Selection pour vous", style: TextStyle( color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("See more", style: TextStyle(color: whiteColor, fontSize: 14)),
                          ],
                        ),
                      ),

                      selectionVideo(
                          ["p1.jpg", "p3.jpg", "p4.jpg", "p1.jpg"], false),

                      // Nos Productions
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nos Production",
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Text("See more",
                                style:
                                    TextStyle(color: whiteColor, fontSize: 14)),
                          ],
                        ),
                      ),
                      thumbnailRow(["5.png", "3.png", "5.png", "3.png"]),

                      const SizedBox(height: 20),
                    ],
                  ),
                  // ),
                  // bottomNavigationBar: BottomBarScreen(),
                  // extendBody: true,
                ),
        ],
      ),
    );
  }

  Widget _categoryButton(title, function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: title == 'Categories' ? blackColor : whiteColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: whiteColor)),
        child: Row(
          children: [
            Text(title,
                style: TextStyle(
                    color: title != 'Categories' ? blackColor : whiteColor)),
            Icon(Icons.keyboard_arrow_down_rounded)
          ],
        ),
      ),
    );
  }

  Widget sectionTitleWithSeeMore(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title,
          style: TextStyle(
              color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title,
          style: TextStyle(
              color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget thumbnailRow(List<String> images) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // AppRoutes.push(context, VideoDetailScreen());
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage("assets/${images[index]}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget topTendencyVideo(List<String> images, bool showProgress) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // AppRoutes.push(context, VideoDetailScreen());
            },
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = primaryColor,
                    ),
                  ),
                ),
                Container(
                  width: 170,
                  alignment: Alignment.topRight,
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(left: 20, right: 5),
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage("assets/${images[index]}"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

                // Positioned(
                //     bottom: MediaQuery.of(context).size.width / 7,
                //     left: MediaQuery.of(context).size.width / 7,
                //     child: Icon(
                //       Icons.play_circle_outline_outlined,
                //       size: 30,
                //     )),
                // showProgress
                //     ? Positioned(
                //         bottom: 6,
                //         // left: 4,
                //         child: Center(
                //           child: new LinearPercentIndicator(
                //             // width: 100.0,
                //             width: MediaQuery.of(context).size.width * 0.38,
                //             lineHeight: 3.0,
                //             percent: 0.9,
                //             // fillColor: primaryColor,
                //             // linearStrokeCap: LinearStrokeCap.roundAll,
                //             progressColor: primaryColor,
                //           ),
                //         ))
                //     : SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget thumbnailVideo(List<String> images, bool showProgress) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // AppRoutes.push(context, VideoDetailScreen());
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage("assets/${images[index]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    bottom: MediaQuery.of(context).size.width / 7,
                    left: MediaQuery.of(context).size.width / 7,
                    child: Icon(
                      Icons.play_circle_outline_outlined,
                      size: 30,
                    )),
                showProgress
                    ? Positioned(
                        bottom: 6,
                        // left: 4,
                        child: Center(
                          child: LinearPercentIndicator(
                            // width: 100.0,
                            width: MediaQuery.of(context).size.width * 0.38,
                            lineHeight: 3.0,
                            percent: 0.9,
                            // fillColor: primaryColor,
                            // linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: primaryColor,
                          ),
                        ))
                    : SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget selectionVideo(List<String> images, bool showProgress) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // AppRoutes.push(context, VideoDetailScreen());
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage("assets/${images[index]}"),
                      fit: BoxFit.cover
                    )                    
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: (0.6 * 255).toDouble()),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
}
