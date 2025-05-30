import 'package:flutter/material.dart';
import 'package:x_place/socialMedia/profileScreen.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _widget(context),
          _widget(context),
          _widget(context),
        ],
      ),
    );
  }

  _widget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          InkWell(
            onTap: () {
              AppRoutes.push(context, ProfileScreen());
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/p3.jpg'),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jennifer Lopez",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text("10 minutes ago",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Spacer(),
          Icon(Icons.more_horiz, color: whiteColor)
        ]),
        SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 2,
              height: 250,
              color: greyColor,
              margin: EdgeInsets.only(right: 15, left: 15),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Dorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit.",
                    style: TextStyle(color: whiteColor, fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/p4.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Icon(
                Icons.favorite_outline,
                color: whiteColor,
                size: 30,
              ),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Image.asset('assets/dollar.png'),
                    SizedBox(width: 5),
                    Text(
                      'Personal Request',
                      style: TextStyle(color: blackColor, fontSize: 10),
                    )
                  ],
                ),
              ),
              Spacer(),
              Icon(Icons.bookmark_border_outlined, color: whiteColor),
              SizedBox(width: 15),
              Icon(Icons.share, color: whiteColor),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 5),
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
      ],
    );
  }
}
