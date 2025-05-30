import 'package:flutter/material.dart';
import 'package:x_place/socialMedia/profileScreen.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';

class SocialPostCard extends StatelessWidget {
  const SocialPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/p1.jpg',
      'assets/p3.jpg',
      'assets/p4.jpg',
    ];

    // PageController with viewportFraction to add space between images
    // final PageController pageController = PageController(viewportFraction: 0.85);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Profile Row
        Row(children: [
          InkWell(
            onTap: () {
              AppRoutes.push(context, ProfileScreen());
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/p3.jpg'), // Profile image
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jennifer Lopez',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Text('10 minutes ago',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Icon(Icons.more_horiz, color: Colors.white)
        ]),

        const SizedBox(height: 5),

        /// Caption

        Container(
          height: 230,
          child: Row(
            children: [
              Container(
                width: 1,
                height: 270,
                color: Colors.grey,
                margin: const EdgeInsets.only(left: 25),
              ),
              // const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit.',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        // controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                images[index],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        /// Actions row
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Icon(Icons.favorite_outline, color: Colors.white, size: 30),
              const SizedBox(width: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/dollar.png',
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    Text('Personal Request',
                        style: TextStyle(color: Colors.black, fontSize: 10)),
                  ],
                ),
              ),
              const Spacer(),
              Icon(Icons.bookmark_border_outlined, color: Colors.white),
              const SizedBox(width: 15),
              Icon(Icons.share, color: Colors.white),
            ],
          ),
        ),

        /// Likes row
        Container(
          margin: const EdgeInsets.only(left: 10, top: 5),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/p3.jpg'),
              ),
              SizedBox(width: 3),
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/p4.jpg'),
              ),
              SizedBox(width: 15),
              Text(
                '70 Likes',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Divider(color: greyColor),
        // const Divider(color: Colors.grey),
      ],
    );
  }
}
