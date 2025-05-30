import 'package:flutter/material.dart';
// import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class BluetoothResultScreen extends StatefulWidget {
  const BluetoothResultScreen({super.key});

  @override
  State<BluetoothResultScreen> createState() => _BluetoothResultScreenState();
}

class _BluetoothResultScreenState extends State<BluetoothResultScreen> {
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
          // drawer: const DrawerScreen(),
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppbarScreen(isBack: true)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                  child: Text(
                    '20 Search Results found:',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                _list('assets/sliders/3.png', 'Jeniffer lopezz'),
                _list('assets/sliders/2.png', 'Jeniffer philips'),
                _list('assets/sliders/1.png', 'Jeniffer james'),
                _list('assets/sliders/3.png', 'Jeniffer rocks'),
                _list('assets/sliders/2.png', 'Jeniffer jenny'),
                _list('assets/sliders/1.png', 'Jeniffer james'),
                _list('assets/sliders/3.png', 'Jeniffer lopezz'),
                _list('assets/sliders/2.png', 'Jeniffer philips'),
                _list('assets/sliders/1.png', 'Jeniffer lopezz'),
                _list('assets/sliders/3.png', 'Jeniffer james'),
                _list('assets/sliders/1.png', 'Jeniffer rocks'),
                _list('assets/sliders/2.png', 'Jeniffer lopezz'),
              ],
            ),
          )),
    );
  }

  _list(img, name) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 15),
      child: Row(children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(img),
        ),
        SizedBox(width: 15),
        Text(
          name,
          style: TextStyle(
              color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}
