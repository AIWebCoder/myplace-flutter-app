import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:x_place/home/IntelligenceArtifical.dart';
import 'package:x_place/home/intelligenceAtrificial2.dart';
import 'package:x_place/home/searchScreen.dart';
import 'package:x_place/providers/chat_provider.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/const.dart';
import 'package:provider/provider.dart';

class AppbarScreen extends StatefulWidget {
  final String title;
  final bool isBack, showSearch, showLogo, showProfile;
  const AppbarScreen(
      {this.isBack = false,
      this.showLogo = true,
      this.showProfile = true,
      this.title = '',
      this.showSearch = true});

  @override
  State<AppbarScreen> createState() => _AppbarScreenState();
}

class _AppbarScreenState extends State<AppbarScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isLargeScreen = constraints.maxWidth >= 800;

      return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,

              // child: GlassContainer(
              //   // alignment: Alignment.r,
              //   margin: EdgeInsets.only(top: 50),
              //   height: MediaQuery.of(context).size.height * 0.8,
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   gradient: LinearGradient(
              //     colors: [
              //       Colors.black.withOpacity(0.50),
              //       Colors.black.withOpacity(0.60),
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              //   borderGradient: LinearGradient(
              //     colors: [
              //       Colors.black.withOpacity(0.20),
              //       Colors.black.withOpacity(0.20),
              //       Colors.black.withOpacity(0.10),
              //       Colors.black.withOpacity(0.10),
              //     ],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     stops: [0.0, 0.39, 0.40, 1.0],
              //   ),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: (0.30 * 255).toDouble()),
                      ),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        leading: Builder(
                          builder: (context) => isLargeScreen && !widget.isBack
                              ? SizedBox()
                              : IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        // color: primaryColor,
                                        gradient: LinearGradient(
                                          colors: [
                                            secondaryColor,
                                            primaryColor
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      widget.isBack
                                          ? Icons.arrow_back_ios
                                          : Icons.menu,
                                      color: whiteColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.isBack
                                        ? Navigator.pop(context)
                                        : Scaffold.of(context).openDrawer();
                                  },
                                ),
                        ),
                        centerTitle: widget.title == '' ? true : false,
                        title: widget.showLogo
                            ? Image.asset("assets/logo.png", height: 40)
                            : Text(widget.title),
                        // leadingWidth: 50.0,
                        // flexibleSpace: ,
                        titleSpacing: 0,
                        actions: [
                          Row(children: [
                            widget.showSearch
                                ? InkWell(
                                    onTap: () {
                                      AppRoutes.push(context, SearchScreen());
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(color: greyColor)),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ]),
                          SizedBox(width: 10),
                          widget.showProfile
                              ? InkWell(
                                  onTap: () {
                                    AppRoutes.push(
                                      context,
                                      ChangeNotifierProvider(
                                        create: (_) => ChatProvider(),
                                        child: Intelligenceatrificial2Screen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 35,
                                    padding: EdgeInsets.only(right: 12.0),
                                    // child: CircleAvatar(
                                    //   radius: 16,
                                    //   backgroundImage:
                                    child: Lottie.asset(
                                        'assets/lottie/avatar.json'),
                                    // ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      )))));
    });
  }
}
