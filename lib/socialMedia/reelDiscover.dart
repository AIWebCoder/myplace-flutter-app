import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:x_place/controller/bottom_controller.dart';
import 'package:x_place/model/post_model.dart';
import 'package:x_place/services/auth.dart';
import 'package:x_place/services/reel_service.dart';
import 'package:x_place/socialMedia/profileScreen.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';
import 'package:video_player/video_player.dart';

class ReelDiscoverScreen extends StatefulWidget {
  const ReelDiscoverScreen({super.key});

  @override
  State<ReelDiscoverScreen> createState() => _ReelDiscoverScreenState();
}

class _ReelDiscoverScreenState extends State<ReelDiscoverScreen> {
  BottomController controller = BottomController();

  // Track which reels are liked by index
  Set<int> likedReels = {};
  bool showBigHeart = false;
  List<Post> reels = [];
  bool isLoading = true;

  // For page view control and current reel index
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadReels();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadReels() async {
    final authProvider = Provider.of<Auth>(context, listen: false);
    final token = authProvider.token;
    try {
      final data = await PostService.fetchPosts(token, postType: "1");
      print('output of reels fetch  : $data');
      setState(() {
        reels = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }
    
  Widget buildGradientScaffold(Widget child) {
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
        body: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return buildGradientScaffold(Center(child: CircularProgressIndicator()));
    }

    if (reels.isEmpty) {
      return buildGradientScaffold(Center(
          child: Text("No reels available",
              style: TextStyle(color: Colors.white))));
    }

    return buildGradientScaffold(
      Stack(
        children: [
          // Reels
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return buildReelItem(reels[index], index);
            },
          ),

          // Fixed Top Bar — appears once
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTopButton(Icons.live_tv_outlined, () {}),
                buildTopCenterTab(),
                buildTopButton(Icons.close, () => controller.toggleController(0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReelItem(Post reel, int index) {
    final isLiked = likedReels.contains(index);

    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          likedReels.add(index);
          showBigHeart = true;
        });
        Future.delayed(Duration(milliseconds: 700), () {
          setState(() => showBigHeart = false);
        });
      },
      child: Stack(
        children: [
          // Video background
          Positioned.fill(
            child: VideoWidget(url: reel.videoUrl),
          ),

          if (showBigHeart && currentIndex == index)
            Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                opacity: showBigHeart ? 1.0 : 0.0,
                child: Icon(Icons.favorite, color: Colors.red.withValues(alpha: (0.8 * 255).toDouble()), size: 100),
              ),
            ),

          // Top bar
          buildTopBar(),

          // Right side icons
          Positioned(
            right: 16,
            bottom: 170,
            child: Column(
              children: [
                Icon(
                  isLiked ? Icons.favorite : LucideIcons.heart,
                  color: isLiked ? Colors.redAccent : primaryColor,
                  size: 22,
                ),
                Text('${reel.likes + (isLiked ? 1 : 0)}',
                    style: TextStyle(color: whiteColor, fontSize: 12)),
                SizedBox(height: 16),
                Icon(LucideIcons.circleDollarSign, color: whiteColor, size: 22),
                Text('Tips', style: TextStyle(color: whiteColor, fontSize: 12)),
                SizedBox(height: 16),
                Icon(LucideIcons.share2, color: whiteColor, size: 22),
                Text('Share', style: TextStyle(color: whiteColor, fontSize: 12)),
              ],
            ),
          ),

          // Bottom info
          Positioned(
            bottom: 40,
            left: 16,
            right: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    AppRoutes.push(context, ProfileScreen());
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: whiteColor,
                    backgroundImage: NetworkImage(reel.profileImage),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reel.username,
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          if (reel.isVerified) Image.asset('assets/verify.png'),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [secondaryColor, primaryColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text('S’Abonner',
                                style:
                                    TextStyle(color: whiteColor, fontSize: 12)),
                          ),
                        ],
                      ),
                      Text('@${reel.userHandle}',
                          style: TextStyle(color: whiteColor, fontSize: 13)),
                      ReadMoreText(
                        reel.caption,
                        trimMode: TrimMode.Line,
                        trimLines: 2,
                        trimCollapsedText: ' Show more',
                        trimExpandedText: ' Show less',
                        moreStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTopButton(Icons.live_tv_outlined, () {}),
          buildTopCenterTab(),
          buildTopButton(Icons.close, () => controller.toggleController(0)),
        ],
      ),
    );
  }

  Widget buildTopButton(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: whiteColor),
        color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(onTap: onTap, child: Icon(icon, color: whiteColor)),
    );
  }

  Widget buildTopCenterTab() {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: whiteColor),
        color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text('Vos abonnements',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(width: 8),
          Text('|', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(width: 8),
          Text('For You',
              style: TextStyle(
                  color: whiteColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Icon(Icons.search, color: whiteColor, size: 24),
        ],
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;

  VideoWidget({required this.url});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        : Center(child: CircularProgressIndicator(color: Colors.white));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
