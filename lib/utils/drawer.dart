// import 'package:flutter/material.dart';
// import 'package:x_place/home/IntelligenceArtifical.dart';
// import 'package:x_place/home/bluetoothScreen.dart';
// import 'package:x_place/home/marketPlace2.dart';
// import 'package:x_place/home/marketplace1.dart';
// import 'package:x_place/home/reelSearch.dart';
// import 'package:x_place/home/starScreen.dart';
// import 'package:x_place/home/videoPage.dart';
// import 'package:x_place/socialMedia/socialMedia.dart';
// import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/socialmediaDrawer.dart';

// class DrawerScreen extends StatefulWidget {
//   const DrawerScreen({super.key});

//   @override
//   State<DrawerScreen> createState() => _DrawerScreenState();
// }

// class _DrawerScreenState extends State<DrawerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       
//       child: SingleChildScrollView(
//         child: Container(
//           alignment: Alignment.topLeft,
//           margin: EdgeInsets.only(left: 10, top: 60),
//           child: Column(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                     alignment: Alignment.topLeft,
//                     child: Icon(Icons.cancel_outlined,
//                         color: whiteColor, size: 35)),
//               ),
//               const SizedBox(height: 20),
//               _list('assets/icons/add.png', 'My Lists', () {
//                 // AppRoutes.push(context, IntelligenceartificalScreen());
//               }),
//               _list('assets/icons/category.png', 'Category', () {}),
//               _list('assets/icons/star.png', 'Star', () {
//                 AppRoutes.push(context, StarScreen());
//               }),
//               _list('assets/icons/marketplace.png', 'Market Place', () {
//                 AppRoutes.push(context, MarketPlaceScreen());
//               }),
//               _list('assets/icons/model.png', 'Model', () {}),
//               _list('assets/icons/model.png', 'Bluetooth', () {
//                 // AppRoutes.push(context, Bluetoothscreen());
//               }),
//               _list('assets/icons/model.png', 'Video', () {
//                 // AppRoutes.push(context, VideoPageScreen());
//               }),
//               _list('assets/icons/model.png', 'Reel Search/Discover', () {
//                 AppRoutes.push(context, ReelSearchScreen());
//               }),
//               _list('assets/icons/model.png', 'Social Media', () {
//                 AppRoutes.push(context, SocialMediaScreen());
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _list(img, title, func) {
//     return Container(
//       alignment: Alignment.topLeft,
//       margin: EdgeInsets.only(top: 40),
//       // decoration: BoxDecoration(color: const Color.fromARGB(255, 26, 25, 25)),
//       child: InkWell(
//         onTap: func,
//         child: Row(
//           children: [
//             Image.asset(
//               img,
//               height: 20,
//             ),
//             SizedBox(width: 25),
//             Container(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 textAlign: TextAlign.left,
//                 title,
//                 style: TextStyle(
//                   color: whiteColor,
//                   fontSize: 20,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
