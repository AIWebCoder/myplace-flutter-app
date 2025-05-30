import 'package:flutter/material.dart';
import 'package:x_place/socialMedia/posts_detail.dart';
// import 'package:x_place/socialMedia/profileScreen.dart';
import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/const.dart';

class PublicationScreen extends StatelessWidget {
  const PublicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: List.generate(10, (index) {
        return GestureDetector(
          onTap: () {
            AppRoutes.push(context, PostDetail());
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/p4.jpg'),
              ),
            ),
          ),
        );
      }),
    );
  }
}
