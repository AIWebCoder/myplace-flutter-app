import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/appbar.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final List<String> users = [
    "Jennifer Lopez",
    "Jennifer Philips",
    "Jennifer James",
    "Jennifer Mak",
    "Jennifer Phenom",
    "Jennifer Jones",
    "Jennifer James",
    "Jennifer Randy",
    "Jennifer Shanky",
    "Jennifer Bante",
    "Jennifer Bante",
    "Jennifer Bante",
    "Jennifer Bante",
  ];

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
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppbarScreen(isBack: true, showSearch: false),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Search 20 Search Results Found:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/sliders/3.png"),
                            ),
                            title: Text(
                              users[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
