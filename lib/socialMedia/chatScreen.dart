import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:x_place/services/auth.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/const.dart';
import 'package:x_place/services/dio.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int contactId;
  final String contactName;
  final String avatarUrl;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    required this.avatarUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  List<dynamic> _messages = [];
  bool _isLoading = true;
  final String todayFormatted = DateFormat('MMM d, yyyy').format(DateTime.now());
  String formatMessageDate(String isoDateStr) {
    final dateTime = DateTime.parse(isoDateStr).toLocal();
    // Format: May 16, 08:38 AM
    return DateFormat('MMM d, hh:mm a').format(dateTime);
  }

  int? myUserId;
  String? myUserName;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    Auth authProvider = Provider.of<Auth>(context, listen: false);
    await fetchMessages(authProvider.token);

    final secureStorage = FlutterSecureStorage();
    String? userJson = await secureStorage.read(key: 'user');

    if (userJson != null) {
      Map<String, dynamic> user = jsonDecode(userJson);
      setState(() {
        myUserId = user['id'];
        myUserName = user['name'];
      });
    }
  }

  Future<void> fetchMessages(token) async {
    setState(() => _isLoading = true);
    try {
      final response = await DioClient.dio.get('/my/messenger/fetchMessages/${widget.contactId}', 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('this is the response : $response');
      if (response.statusCode == 200) {
        final data = response.data['data']['messages'] as List;
        setState(() {
          _messages = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() => _isLoading = false);
    }
  }
  
  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    Auth authProvider = Provider.of<Auth>(context, listen: false);

    try {
      final response = await DioClient.dio.post(
        '/my/messenger/sendMessage',
         data: {
          'message': messageText,
          'receiverIDs': [widget.contactId.toString()],
          'price': '0',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authProvider.token}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Message sent successfully
        setState(() { messageController.clear(); });
        await fetchMessages(authProvider.token);
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
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
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: whiteColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.avatarUrl), 
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.contactName,
                          style: TextStyle(color: whiteColor, fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.verified, color: Colors.blue, size: 16),
                      ],
                    ),
                    Text(
                      todayFormatted,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          body: Column(
            children: [
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        reverse: true, // to show latest messages at the bottom
                        padding: const EdgeInsets.all(10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[_messages.length - 1 - index];
                          final isMine = message['sender_id'] == myUserId; 
                          final hasUnlocked = message['hasUserUnlockedMessage'] ?? true;
                          final messageText = message['message'] ?? '';
                          final createdAt = formatMessageDate(message['created_at']) ;
                          final price = message['price'];
                          final attachments = message['attachments'] as List;

                          if (!hasUnlocked && attachments.isNotEmpty) {
                            return _buildLockedMedia(price: price);
                          }

                          return _buildChatBubble(
                            messageText,
                            isMine ? Colors.grey[800]! : primaryColor,
                            isMine ? Alignment.centerRight : Alignment.centerLeft,
                            textColor: isMine ? whiteColor : whiteColor,
                            time: createdAt,
                          );
                        },
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildMessageInput(),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildChatBubble(String text, Color color, Alignment alignment, {Color textColor = Colors.white, String? time}) {
    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: alignment == Alignment.centerLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(text, style: TextStyle(color: textColor)),
          ),
          if (time != null)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: Text(
                time,
                style: TextStyle(color: greyColor, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLockedMedia({int? price}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: 130,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("assets/mk4.png"), // Replace with actual thumbnail if needed
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black45, BlendMode.darken),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // TODO: handle payment logic
              },
              child: Text(
                "Payer \$${price ?? 49}",
                style: TextStyle(color: primaryColor, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildLockedMedia() {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: Stack(
  //       children: [
  //         Opacity(
  //           opacity: 0.5,
  //           child: Container(
  //             width: 130,
  //             height: 140,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               image: const DecorationImage(
  //                 image: AssetImage("assets/mk4.png"),
  //                 fit: BoxFit.cover,
  //                 colorFilter:
  //                     ColorFilter.mode(Colors.black45, BlendMode.darken),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 10,
  //           left: 20,
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: whiteColor,
  //               shape: RoundedRectangleBorder(
  //                 side: BorderSide(color: primaryColor),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //             onPressed: () {},
  //             child: Text(
  //               "Payer \$49",
  //               style: TextStyle(color: primaryColor, fontSize: 13),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: blackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                TextField(
                  controller: messageController,
                  onChanged: (v) {
                    setState(() {});  // Just trigger rebuild to update send button state or UI
                  },
                  style: TextStyle(color: whiteColor),
                  decoration: const InputDecoration(
                    hintText: "J'attend avec impatience",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: greyColor),
                      ),
                      child: Icon(Icons.emoji_emotions, color: whiteColor),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: greyColor),
                      ),
                      child: Icon(Icons.attach_file, color: whiteColor),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (messageController.text.trim().isEmpty) return;
                        await sendMessage(messageController.text.trim());
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: messageController.text.isEmpty
                          ? BoxDecoration( shape: BoxShape.circle, color: greyColor)
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [secondaryColor, primaryColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ClipOval(
                            child: Icon(Icons.arrow_upward,
                              color: messageController.text.isEmpty
                                  ? Colors.grey.shade900
                                  : whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
