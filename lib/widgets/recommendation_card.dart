import 'package:flutter/material.dart';
import '../model/content_recommendation.dart';
import '../utils/const.dart';

class RecommendationCard extends StatelessWidget {
  final ContentRecommendation recommendation;
  final VoidCallback? onPressed;

  const RecommendationCard({
    Key? key,
    required this.recommendation,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: Center(
                      child: Icon(
                        recommendation.type == 'film' ? Icons.movie : Icons.tv,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  // Badge pour le type (film/série)
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: recommendation.type == 'film' ? primaryColor : Colors.indigo,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      recommendation.type.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Infos
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre et année
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recommendation.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (recommendation.year.isNotEmpty)
                          Text(
                            '(${recommendation.year})',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    // Rating
                    if (recommendation.rating > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            recommendation.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8.0),
                    // Genres
                    if (recommendation.genres.isNotEmpty)
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: recommendation.genres.take(3).map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[800],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 8.0),
                    // Plateformes
                    if (recommendation.platforms.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.play_circle_outline,
                            size: 14.0,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              recommendation.platforms.join(', '),
                              style: const TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
