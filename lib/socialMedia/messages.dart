import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:x_place/services/auth.dart';
// import 'package:lottie/lottie.dart';
import 'package:x_place/socialMedia/chatScreen.dart';
import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/socialmediaDrawer.dart';
import 'package:x_place/services/dio.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<dynamic> _messages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    Auth authProvider = Provider.of<Auth>(context, listen: false);
    fetchMessages(authProvider.token);
  }

  Future<void> fetchMessages(token) async {
    print("fetchMessages called");
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await DioClient.dio.get(
        '/my/messenger',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final contacts = data['availableContacts'] as List<dynamic>;
        print(contacts);
        setState(() {
          _messages = contacts;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error =
              'Failed to load messages (status code: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Request failed: $e');
      print('StackTrace: $stackTrace');
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

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

        // appBar: AppBar(
        //   leading: Builder(
        //     builder: (context) => IconButton(
        //       icon: Container(
        //         padding: EdgeInsets.all(5),
        //         decoration: BoxDecoration(
        //           color: primaryColor,
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //         child: Icon(
        //         Icons.arrow_back_ios,
        //           color: whiteColor,
        //         ),
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ),
        //   title: Container(
        //     height: 40,
        //     decoration: BoxDecoration(
        //       color: Colors.grey[900], // Adjust color as needed
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: TextField(
        //       style: TextStyle(color: whiteColor),
        //       cursorColor: whiteColor,
        //       decoration: InputDecoration(
        //         hintText: "Search...",
        //         hintStyle: TextStyle(color: greyColor),
        //         prefixIcon: Icon(Icons.search, color: greyColor),
        //         border: InputBorder.none,
        //         contentPadding: EdgeInsets.symmetric(vertical: 10),
        //       ),
        //     ),
        //   ),
        //   actions: [
        //     Container(
        //       height: 35, padding: EdgeInsets.only(right: 12.0),
        //       // child: CircleAvatar(
        //       //   radius: 16,
        //       //   backgroundImage:
        //       child: Lottie.asset('assets/lottie/avatar.json'),
        //       // ),
        //     )
        //   ],
        // ),

        body: _buildMessageList(),
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!, style: TextStyle(color: Colors.red)));
    }

    if (_messages.isEmpty) {
      return Center(child: Text("No messages found", style: TextStyle(color: whiteColor)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Messages",
            style: TextStyle(
              color: whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final contact = _messages[index];
                return _buildMessageTile( 
                  contact['name'], "Tap to open chat", "",  contact['avatar'], () {
                    AppRoutes.push(
                      context,
                      ChatScreen(
                        contactId: contact['id'],
                        contactName: contact['name'],
                        avatarUrl: contact['avatar'],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildMessageList() {
  //   List<Map<String, String>> messages = [
  //     {
  //       "name": "tbi",
  //       "message": "Hi, I have been meaning to reach out to you for a...",
  //       "time": "Now",
  //       "image": "assets/user1.jpg"
  //     },
  //     {
  //       "name": "Rebecca Steph",
  //       "message": "Hi, I have been meaning to reach out to you for a...",
  //       "time": "30 minutes ago",
  //       "image": "assets/user2.jpg"
  //     },
  //     {
  //       "name": "Stephanie Machoone",
  //       "message": "Hi, I have been meaning to reach out to you for a...",
  //       "time": "1 hour ago",
  //       "image": "assets/user3.jpg"
  //     },
  //     {
  //       "name": "James Harrison",
  //       "message": "Hi, I have been meaning to reach out to you for a...",
  //       "time": "A day ago",
  //       "image": "assets/user4.jpg"
  //     },
  //     {
  //       "name": "Natasha Cobbs",
  //       "message": "Hi, I have been meaning to reach out to you for a...",
  //       "time": "2 weeks ago",
  //       "image": "assets/user5.jpg"
  //     },
  //   ];

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(height: 10),
  //         Text(
  //           "Messages",
  //           style: TextStyle(
  //             color: whiteColor,
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 15),
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: messages.length,
  //             itemBuilder: (context, index) {
  //               return _buildMessageTile(
  //                   messages[index]["name"]!,
  //                   messages[index]["message"]!,
  //                   messages[index]["time"]!,
  //                   messages[index]["image"]!, () {
  //                 AppRoutes.push(context, ChatScreen());
  //               });
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMessageTile(  String name, String message, String time, String imageUrl, VoidCallback func) {
    return Column(
      children: [
        InkWell(
          onTap: func,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 22,
            ),
            title: Text(
              name,
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              message,
              style: TextStyle(color: greyColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              time,
              style: TextStyle(color: greyColor, fontSize: 12),
            ),
          ),
        ),
        Divider(color: Colors.grey[800]),
      ],
    );
  }

  // Widget _buildMessageTile(
  // String name, String message, String time, String imagePath, func) {
  //  return Column(
  //     children: [
  //       InkWell(
  //         onTap: func,
  //         child: ListTile(
  //           leading: const CircleAvatar(
  //             backgroundImage: AssetImage('assets/p3.jpg'),
  //             radius: 22,
  //           ),
  //           title: Text(
  //             name,
  //             style: TextStyle(
  //               color: whiteColor,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           subtitle: Text(
  //             message,
  //             style: TextStyle(color: greyColor),
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           trailing: Text(
  //             time,
  //             style: TextStyle(color: greyColor, fontSize: 12),
  //           ),
  //         ),
  //       ),
  //       Divider(color: Colors.grey[800]), // Light grey divider line
  //     ],
  //   );
  // }
}
