import 'package:flutter/material.dart';
// import 'package:x_place/socialMedia/profileScreen.dart';
import 'package:x_place/socialMedia/tab_screens/social_post_card.dart';
// import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: whiteColor)),
        title: Text('Posts', style: TextStyle(fontSize: 17)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SocialPostCard(),
              SocialPostCard(),
              SocialPostCard(),
            ],
          ),
        ),
      ),
    );
  }
}
