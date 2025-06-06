import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:x_place/home/videoPage.dart';
import 'package:x_place/model/post_model.dart';
import 'package:x_place/services/auth.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';
import 'package:x_place/services/reel_service.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
  List<Post> reels = [];
  List<Post> posts = [];
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
    loadPosts();
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

  Future<void> loadPosts() async {
    final authProvider = Provider.of<Auth>(context, listen: false);
    final token = authProvider.token;

    try {
      final reelsData = await PostService.fetchPosts(token, postType: "1");
      final postsData = await PostService.fetchPosts(token, postType: "0");

      print('this is the post Data : , $postsData');

      if (!mounted) return;

      setState(() {
        reels = reelsData;
        posts = postsData;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 20),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  categories[i],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 6),
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
                            _categoryButton("Categories", () {
                              _handleMenuPress();
                            }),
                          ],
                        ),
                      ),
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
                                      ),
                                    ),
                                  ),
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
                                      : whiteColor.withValues(
                                          alpha: (0.4 * 255).toDouble())),
                            ),
                          );
                        }).toList(),
                      ),
                      sectionTitle("Top tendancy"),
                      topTendencyVideo(posts, true),
                      sectionTitle("Continue Watching"),
                      thumbnailVideo(posts, true),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Top Aujourd'hui", style: TextStyle( color: whiteColor, fontSize: 1 ,fontWeight: FontWeight.bold)),
                            Text("See more", style: TextStyle(color: whiteColor, fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.45,
                        width: double.infinity,
                        child: CarouselSlider(
                          items: posts.asMap().entries.map((entry) {
                            Post post = entry.value;
                            return GestureDetector(
                              onTap: () {
                                AppRoutes.push(context, VideoDetailScreen(post: post));
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CarouselVideoThumbnail(videoUrl: post.videoUrl),
                                  ),
                                  const Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Icon(Icons.hd, color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          carouselController: _controller3,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
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
                                    : whiteColor.withValues(alpha: 0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Selection pour vous",
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
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        selectionVideo(reels, false),
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
              // AppRoutes.push(context, VideoDetailScreen(post: null,));
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

  Widget topTendencyVideo(List<Post> posts, bool showProgress) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return GestureDetector(
            onTap: () {
              AppRoutes.push(
                  context,
                  VideoDetailScreen(
                    post: post,
                  ));
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
                    child: VideoThumbnailWidget(videoUrl: post.videoUrl),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget thumbnailVideo(List<Post> posts, bool showProgress) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return GestureDetector(
            onTap: () {
              // AppRoutes.push(context, VideoDetailScreen(post: null,));
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 150,
                  child: VideoThumbnailWidget(videoUrl: post.videoUrl),
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

  Widget selectionVideo(List<Post> reels, bool showProgress) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          final reel = reels[index];

          return GestureDetector(
            onTap: () {
              AppRoutes.push(context, VideoDetailScreen(post: reel));
            },
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 150,
                  height: 200,
                  child: VideoThumbnailWidget(videoUrl: reel.videoUrl),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withValues(alpha: (0.6 * 255).toDouble()),
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
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      reel.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final thumb = await VideoThumbnail.thumbnailFile(
      video: widget.videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150,
      quality: 50,
    );

    if (mounted) {
      setState(() {
        _thumbnailPath = thumb;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnailPath == null) {
      return Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(_thumbnailPath!),
        width: 150,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CarouselVideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const CarouselVideoThumbnail({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _CarouselVideoThumbnailState createState() => _CarouselVideoThumbnailState();
}

class _CarouselVideoThumbnailState extends State<CarouselVideoThumbnail> {
  String? _thumbnailPath;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final thumb = await VideoThumbnail.thumbnailFile(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 150, // you can adjust this size
        quality: 50,
      );

      if (!mounted) return;

      setState(() {
        _thumbnailPath = thumb;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const Icon(Icons.error, color: Colors.red, size: 40),
        ),
      );
    }

    if (_isLoading) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Show thumbnail image if loaded successfully
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: _thumbnailPath != null
          ? Image.file(
              File(_thumbnailPath!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          : Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const Icon(Icons.error, color: Colors.red, size: 40),
            ),
    );
  }
}