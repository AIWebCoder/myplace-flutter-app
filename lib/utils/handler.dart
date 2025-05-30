// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:x_place/utils/const.dart';

button(text, function, color) {
  // return Container(
  //     decoration: BoxDecoration(),
  //     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  //     child: MaterialButton(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       padding: EdgeInsets.all(10),
  //       minWidth: double.infinity,
  //       textColor: whiteColor,
  //       color: color,
  //       child: Text(
  //         text,
  //         style: TextStyle(fontSize: 20),
  //       ),
  //       onPressed: function,
  //     ));
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [secondaryColor, primaryColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: function,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white, // You can use whiteColor here
            ),
          ),
        ),
      ),
    ),
  );
}

iconButton(icon) {
  return Container(
    margin: EdgeInsets.only(left: 8),
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [secondaryColor, primaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(6)),
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: blackColor, borderRadius: BorderRadius.circular(6)),
      child: Icon(
        icon,
      ),
    ),
  );
}

socialIconButton(icon) {
  return
      // ClipRRect(
      //   borderRadius: BorderRadius.circular(6),
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //     child: Container(
      //       margin: EdgeInsets.only(right: 12),
      //       padding: EdgeInsets.all(9),
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(6),
      //         gradient: LinearGradient(
      //           colors: [secondaryColor, primaryColor],
      //           begin: Alignment.topCenter,
      //           end: Alignment.bottomCenter,
      //         ),
      //       ),
      //       child: Icon(icon, size: 15),
      //     ),
      //   ),
      // );
      Container(
    margin: EdgeInsets.only(right: 12),
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [secondaryColor, primaryColor],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
        borderRadius: BorderRadius.circular(6)),
    child: Container(
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: darkGreyColor, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, size: 15),
    ),
  );
}
