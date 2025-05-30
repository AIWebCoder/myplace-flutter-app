import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:x_place/model/post_model.dart';
import 'package:x_place/socialMedia/reelDiscover.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
import 'package:x_place/utils/handler.dart';

class VideoDetailScreen extends StatefulWidget {
  final Post post;  // add this

  const VideoDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  // int _currentPage = 1;
  
  int _current = 0;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl( Uri.parse(widget.post.videoUrl), );

    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        );
      });
    });
  }

  // _videoPlayer() async {}

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  final CarouselSliderController _controller = CarouselSliderController();
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
            child: AppbarScreen(
              isBack: true,
              showLogo: false,
              showProfile: false,
              showSearch: false,
              title: 'Fear Filter',
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(top: 10, bottom: 10),
              //   child: Image.asset(
              //     'assets/sliders/3.png',
              //     width: double.infinity,
              //   ),
              // ),

              Container(
                height: 200,
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const Center(child: CircularProgressIndicator()),
              ),
              Divider(color: greyColor, thickness: 1),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: const Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up_alt_rounded,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text('150k'),
                        SizedBox(width: 15),
                        Icon(
                          Icons.remove_red_eye,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text('50k')
                      ],
                    ),
                    Spacer(),
                    Text(
                      '5 days ago',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.topLeft,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Dorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.topLeft,
                child: ReadMoreText(
                  'Staring: Eliot Crane, Sienna Ray, Tobias Grey, Nyla Quinn',
                  trimMode: TrimMode.Line,
                  trimLines: 1,
                  colorClickableText: Theme.of(context).indicatorColor,
                  trimCollapsedText: ' Show more',
                  trimExpandedText: ' Show less',
                  lessStyle: TextStyle(fontSize: 10, color: greyColor),
                  moreStyle: TextStyle(fontSize: 10, color: greyColor),
                  style: TextStyle(fontSize: 10, color: greyColor),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.topLeft,
                child: ReadMoreText(
                  'Creators: Directed by Lena Hargrove, written by Marcus Veldt and Isla Chen.',
                  trimMode: TrimMode.Line,
                  trimLines: 1,
                  colorClickableText: Theme.of(context).indicatorColor,
                  trimCollapsedText: ' Show more',
                  trimExpandedText: ' Show less',
                  lessStyle: TextStyle(fontSize: 10, color: greyColor),
                  moreStyle: TextStyle(fontSize: 10, color: greyColor),
                  style: TextStyle(fontSize: 10, color: greyColor),
                ),
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  // _userAction('Like', Icons.thumb_up_alt_rounded),
                  // _userAction('Rate', Icons.star),
                  // _userAction('Share', Icons.share),
                  // _userAction('Report', Icons.report),
                  socialIconButton(Icons.thumb_up_alt_rounded),
                  socialIconButton(Icons.star),
                  socialIconButton(Icons.share),
                  socialIconButton(Icons.report),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // AppRoutes.push(context, VideoDetailScreen());
                      },
                      child: Row(
                        children: [
                          Text("Similar Video",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios_sharp, size: 20),
                        ],
                      ),
                    ),
                    Text("See more",
                        style: TextStyle(color: whiteColor, fontSize: 14)),
                  ],
                ),
              ),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: CarouselSlider(
                  items: [1, 9, 4].map((i) {
                    return GestureDetector(
                        onTap: () {
                          AppRoutes.push(context, ReelDiscoverScreen());
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        "assets/sliders/$i.jpg",
                                      ))),

                              // child: Image.asset("assets/sliders/$i.png",
                              //     fit: BoxFit.fill),
                            ),
                            Positioned(top: 10, left: 10, child: Icon(Icons.hd))
                          ],
                        ));
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
                    viewportFraction: 0.7,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
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
                            : whiteColor.withValues(alpha: (0.4 * 255).toDouble()),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              sectionTitle("Recent"),
              thumbnailRow([
                "p3.jpg",
                "p1.jpg",
                "p4.jpg",
                "p1.jpg",
                "p3.jpg",
                "p4.jpg",
                "p1.jpg",
              ], 'Jennifer'),
            ],
          ),
        ),
        // bottomNavigationBar: BottomBarScreen(),
        // extendBody: true,
      ),
    );
  }

  // _userAction(text, icon) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
  //     padding: EdgeInsets.all(1.5),
  //     decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [secondaryColor, primaryColor],
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //         ),
  //         // borderRadius: BorderRadius.circular(6),
  //         // border: Border.all(color: primaryColor),
  //         borderRadius: BorderRadius.circular(30)),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //       decoration: BoxDecoration(
  //           color: blackColor, borderRadius: BorderRadius.circular(30)),
  //       child: Row(
  //         children: [
  //           Text(
  //             text,
  //             style: TextStyle(fontSize: 15),
  //           ),
  //           SizedBox(width: 10),
  //           Icon(icon, size: 15)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget sectionTitle(String title) {
    return Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(title,
            style: TextStyle(
                color: whiteColor, fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget thumbnailRow(List<String> images, name) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // Image Container
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

              // Add Icon (Only on First Image)
              if (index == 0)
                Positioned(
                  top: 10,
                  left: 15,
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

              Positioned(
                bottom: 5,
                left: 15,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(),
                  child: Text(
                    name,
                    style: TextStyle(color: whiteColor, fontSize: 12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
