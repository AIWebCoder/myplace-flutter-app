// import 'package:flutter/material.dart';
// import 'package:x_place/home/IntelligenceArtifical.dart';
// import 'package:x_place/home/bluetoothScreen.dart';
// import 'package:x_place/home/marketPlace2.dart';
// import 'package:x_place/home/marketplace1.dart';
// import 'package:x_place/home/reelSearch.dart';
// import 'package:x_place/home/starScreen.dart';
// import 'package:x_place/home/videoPage.dart';
// import 'package:x_place/socialMedia/messages.dart';
// import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/const.dart';

// class SocialMediaDrawerScreen extends StatefulWidget {
//   const SocialMediaDrawerScreen({super.key});

//   @override
//   State<SocialMediaDrawerScreen> createState() =>
//       _SocialMediaDrawerScreenState();
// }

// class _SocialMediaDrawerScreenState extends State<SocialMediaDrawerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       bool isLargeScreen = constraints.maxWidth >= 600;

//       return Drawer(
//         
//         child: SingleChildScrollView(
//           child: Container(
//             alignment: Alignment.topLeft,
//             margin: EdgeInsets.only(left: 10, top: 60),
//             child: Column(
//               children: [
//                 isLargeScreen
//                     ? SizedBox()
//                     : InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                             alignment: Alignment.topLeft,
//                             child: Icon(Icons.cancel_outlined,
//                                 color: whiteColor, size: 35)),
//                       ),
//                 const SizedBox(height: 20),
//                 _list(Icons.person, 'Profile', () {}),
//                 _list(Icons.subscriptions_outlined, 'Subscription', () {}),
//                 _list(Icons.checklist_rounded, 'Lists', () {}),
//                 _list(Icons.bookmark_border, 'Bookmarks', () {}),
//                 _list(Icons.message, 'Messages', () {
//                   AppRoutes.push(context, MessagesScreen());
//                 }),
//                 _list(Icons.notifications_none_sharp, 'Notifications', () {}),
//                 _list(Icons.add_business_outlined, 'Refferral', () {}),
//                 _list(Icons.model_training_outlined, 'Become a Model', () {}),
//                 _list(Icons.help_center_outlined, 'Help Center', () {}),
//                 _list(Icons.terminal_sharp, 'Terms', () {}),
//                 _list(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
//                 _list(Icons.settings, 'Settings', () {}),
//                 _list(Icons.language, 'Language', () {}),
//                 _list(Icons.light_mode_outlined, 'Light Mode', () {}),
//                 _list(Icons.logout_rounded, 'Logout', () {}),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   _list(IconData iconData, String title, VoidCallback func) {
//     return Container(
//       alignment: Alignment.topLeft,
//       margin: EdgeInsets.only(top: 20),
//       child: InkWell(
//         onTap: func,
//         child: Row(
//           children: [
//             Icon(iconData, color: whiteColor), // Use iconData directly
//             SizedBox(width: 25),
//             Container(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 title,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   color: whiteColor,
//                   fontSize: 18,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
