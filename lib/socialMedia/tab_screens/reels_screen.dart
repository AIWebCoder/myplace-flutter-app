import 'package:flutter/material.dart';

class ReelsScreen extends StatelessWidget {
  final List<String> images = [
    'assets/p1.jpg',
    'assets/p3.jpg',
    'assets/p4.jpg',
    'assets/p3.jpg',
    'assets/p1.jpg',
    'assets/p4.jpg',
    'assets/p1.jpg',
    'assets/p3.jpg',
    'assets/p4.jpg',
    'assets/p3.jpg',
    'assets/p1.jpg',
    'assets/p4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: (0.6 * 255).toDouble()),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: (0.5 * 255).toDouble()),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
