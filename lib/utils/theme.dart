import 'package:flutter/material.dart';
import 'package:x_place/utils/const.dart';

class ThemeController {
  darkTheme() {
    return
        // ThemeData(
        //   fontFamily: 'segoei',
        //   primarySwatch: const MaterialColor(
        //     0xffE50049,
        //     <int, Color>{
        //       50: primaryColor,
        //       100: Color(0xffE50049),
        //       200: Color(0xffE50049),
        //       300: Color(0xffE50049),
        //       400: Color(0xffE50049),
        //       500: Color(0xffE50049),
        //       600: Color(0xffE50049),
        //       700: Color(0xffE50049),
        //       800: Color(0xffE50049),
        //       900: Color(0xffE50049),
        //     },
        //   ),
        //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //        elevation: 0),
        //   appBarTheme: AppBarTheme(
        //       iconTheme: IconThemeData(color: blackColor),
        //       elevation: 0,
        //
        //       centerTitle: true),
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // );
        ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        // secondary: Colors.pinkAccent,
      ),
      // bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //      elevation: 0),
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: blackColor),
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          centerTitle: true),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
