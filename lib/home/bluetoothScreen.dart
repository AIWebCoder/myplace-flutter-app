import 'package:flutter/material.dart';
import 'package:x_place/home/bluetoothResult.dart';
import 'package:x_place/utils/appRoutes.dart';
// import 'package:x_place/utils/appbar.dart';
import 'package:x_place/utils/const.dart';
// import 'package:x_place/utils/drawer.dart';

class Bluetoothscreen extends StatefulWidget {
  const Bluetoothscreen({super.key});

  @override
  State<Bluetoothscreen> createState() => _BluetoothscreenState();
}

class _BluetoothscreenState extends State<Bluetoothscreen> {
  bool isBluetoothOn = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBluetoothSwitch(),
          const SizedBox(height: 20),
          _buildDeviceSection('Connexion à mes sex toys', 4),
          const SizedBox(height: 20),
          _buildDeviceSection('Connexion Alix Autres sex toys', 1),
        ],
      ),
    );
  }

  Widget _buildBluetoothSwitch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Bluetooth', style: TextStyle(color: whiteColor, fontSize: 18)),
          Switch(
            value: isBluetoothOn,
            onChanged: (value) => setState(() => isBluetoothOn = value),
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceSection(String title, int count) {
    return InkWell(
      onTap: () {
        AppRoutes.push(context, BluetoothResultScreen());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(color: whiteColor, fontSize: 16)),
              const SizedBox(width: 10),
              const Icon(Icons.replay_circle_filled_outlined)
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children:
                  List.generate(count, (index) => _buildDeviceTile(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(int index) {
    List<IconData> icons = [
      Icons.refresh_outlined,
      Icons.bluetooth,
      Icons.replay_circle_filled_outlined,
      Icons.refresh_outlined
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('SEX1230590', style: TextStyle(color: whiteColor, fontSize: 16)),
          Icon(icons[index % icons.length], color: whiteColor),
        ],
      ),
    );
  }
}
