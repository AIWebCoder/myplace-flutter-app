// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_place/model/post_model.dart';
import 'package:x_place/services/auth.dart';
import 'package:x_place/services/dio.dart';
import 'package:x_place/services/reel_service.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key});

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  int _currentVideoIndex = 0;
  Map<String, dynamic>? user;
  late Auth authProvider;
  late String token;
  bool isLoading = true;
  int subscriptionsCount = 0;
  int subscribersCount = 0;
  int reelsCount = 0;
  int videosCount = 0;
  List<Post> reels = [];
  List<Post> posts = [];

  // Création de PageControllers à la place
  final PageController _videoPageController = PageController(initialPage: 0, viewportFraction: 0.7);

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<Auth>(context, listen: false);
    token = authProvider.token!;
    user = authProvider.user;
    loadProfile(token, user);
    fetchUserPosts(token);
  }

  @override
  void dispose() {
    _videoPageController.dispose();
    super.dispose();
  }

  Options _dioOptions() => Options(
    headers: {
      "Content-Type": "multipart/form-data",
      'Authorization': 'Bearer $token',
    },
  );

  Future<void> fetchUserPosts(token) async {
    final authProvider = Provider.of<Auth>(context, listen: false);
    final token = authProvider.token;

    try {
      final reelsData = await PostService.fetchUserPosts(token, postType: "1");
      final postsData = await PostService.fetchUserPosts(token, postType: "0");

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
        reelsCount = responseData['reelsCount'] ?? 0;
        videosCount = responseData['videosCount'] ?? 0;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint('Failed to load profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color redAccent = secondaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppbarScreen(
          isBack: true,
          showLogo: false,
          showProfile: false,
          showSearch: false,
          title: 'Profil',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec photo de profil et anneau rouge
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [redAccent, Colors.red.shade900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                      image: DecorationImage(
                        image: user?['avatar'].startsWith('http')
                            ? NetworkImage(user?['avatar'])
                            : AssetImage(user?['avatar']) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Nom d'utilisateur et badge vérifié
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${user!['name']}',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Icon(
                  Icons.verified,
                  color: redAccent,
                  size: 20,
                ),
              ],
            ),
            Text('${user!['username']}',
                style: TextStyle(color: Colors.grey, fontSize: 14)),

            // Boutons d'action - UPDATED with reduced spacing
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 80,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Top row with two buttons at the same level with reduced spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Changed to center for better control
                    children: [
                      _buildCircularActionButton(
                          Icons.settings, "Réglages", redAccent),
                      SizedBox(
                          width:
                              90), // Reduced spacing between side buttons from 100 to 60
                      _buildCircularActionButton(
                          Icons.edit, "Modifier mon\nProfil", redAccent),
                    ],
                  ),

                  // Lower button (Ajouter) - Better positioning
                  Positioned(
                    top: 25,
                    child: _buildCircularActionButton(
                        Icons.add, "Ajouter", redAccent),
                  ),
                ],
              ),
            ),

            // Add extra space after the buttons
            SizedBox(height: 35),

            // Barre de statistiques
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('$videosCount', "Vidéos"),
                  _buildVerticalDivider(),
                  _buildStatItem('$reelsCount', "Reels"),
                  _buildVerticalDivider(),
                  _buildStatItem('$subscribersCount', "Abonnés"),
                  _buildVerticalDivider(),
                  _buildStatItem('$subscriptionsCount', "Suivis"),
                ],
              ),
            ),

            // Section statistiques avec graphique
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vos statistiques",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(15),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                String text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = 'Élément 1';
                                    break;
                                  case 1:
                                    text = 'Élément 2';
                                    break;
                                  case 2:
                                    text = 'Élément 3';
                                    break;
                                  case 3:
                                    text = 'Élément 4';
                                    break;
                                  case 4:
                                    text = 'Élément 5';
                                    break;
                                  default:
                                    text = '';
                                }
                                return Text(
                                  text,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 4,
                        minY: 0,
                        maxY: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 3),
                              FlSpot(1, 1),
                              FlSpot(2, 4),
                              FlSpot(3, 2),
                              FlSpot(4, 5),
                            ],
                            isCurved: true,
                            color: redAccent,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  redAccent.withValues(
                                      alpha: (0.3 * 255).toDouble()),
                                  redAccent.withValues(
                                      alpha: (0.01 * 255).toDouble()),
                                ],
                                stops: [0.5, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Section contenu
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vidéos section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vos vidéos",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Action pour voir toutes les vidéos
                        },
                        child: Text(
                          "Voir tout",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildVideoContent(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [1, 2, 3, 4].asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () {
                          _videoPageController.animateToPage(
                            entry.key,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentVideoIndex == entry.key
                                  ? secondaryColor
                                  : whiteColor.withValues(
                                      alpha: (0.4 * 255).toDouble())),
                        ),
                      );
                    }).toList(),
                  ),
                  // Reels section modifiée pour avoir l'affichage normal
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Vos reels",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Action pour voir tous les reels
                        },
                        child: Text(
                          "Voir tout",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 230,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: reels.map((reel) {
                        return GestureDetector(
                          onTap: () {
                            // AppRoutes.push(context, VideoDetailScreen());
                          },
                          child: Container(
                            width: 120,
                            margin: EdgeInsets.all(8),
                            child: Stack(
                              children: [
                                // ✅ Replace AssetImage with your custom widget
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: VideoThumbnailWidget(videoUrl: reel.videoUrl),
                                  ),
                                ),

                                // Reel icon
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Icon(
                                    Icons.video_library,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),

                                // Reel stats
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.blue.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.favorite, color: Colors.white, size: 14),
                                            SizedBox(width: 4),
                                            Text(
                                              "${reel.likes}", // make sure Post model has this
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.remove_red_eye, color: Colors.white, size: 14),
                                            SizedBox(width: 4),
                                            Text(
                                              "${reel.likes}", // make sure Post model has this
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Suppression des indicateurs de point qui étaient utilisés avec PageView
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Method to build circular action buttons with reduced spacing between icons and borders
  Widget _buildCircularActionButton(
      IconData icon, String label, Color accentColor) {
    bool isAddButton = icon == Icons.add;

    return Container(
      width: 42, // Slightly reduced from 45
      height: 42, // Slightly reduced from 45
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: isAddButton ? accentColor : Colors.white,
            width: 1.8 // Slightly reduced from 2.0
            ),
        color: Colors.transparent,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22, // Slightly reduced from 24
      ),
    );
  }

  // Method to build video content using PageView instead of CarouselSlider
  Widget _buildVideoContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.50,
      width: double.infinity,
      child: PageView.builder(
        controller: _videoPageController,
        itemCount: posts.length,
        onPageChanged: (index) {
          setState(() {
            _currentVideoIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final video = posts[index];
          final videoUrl = video.videoUrl; 

          return GestureDetector(
            onTap: () {
              // AppRoutes.push(context, VideoDetailScreen(post: video));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: VideoThumbnailWidget(videoUrl: videoUrl),
                  ),
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: Icon(Icons.hd, color: Colors.white),
                  ),
                  const Positioned.fill(
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 28,
                        child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 25,
      width: 1,
      color: Colors.grey.withValues(alpha: (0.3 * 255).toDouble()),
    );
  }
}


class VideoThumbnailWidget extends StatelessWidget {
  final String videoUrl;

  const VideoThumbnailWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 75,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover, height: 200);
        } else {
          return Container(
            height: 200,
            color: Colors.black12,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
