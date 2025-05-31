import 'package:flutter/foundation.dart';

class ContentRecommendation {
  final String id;
  final String title;
  final String type;
  final String imageUrl;
  final String year;
  final double rating;
  final List<String> genres;
  final List<String> platforms;
  final String description;
  final String director;

  ContentRecommendation({
    required this.id,
    required this.title,
    this.type = 'film',
    this.imageUrl = '',
    this.year = '',
    this.rating = 0.0,
    this.genres = const [],
    this.platforms = const [],
    this.description = '',
    this.director = '',
  });

  // Méthode pour extraire les recommandations d'un texte
  static List<ContentRecommendation> parseFromText(String text) {
    List<ContentRecommendation> recommendations = [];
    
    // Rechercher les titres en gras
    final RegExp titleRegex = RegExp(r'\*\*([^*]+)\*\*');
    final matches = titleRegex.allMatches(text);
    
    int counter = 0;
    for (var match in matches) {
      if (match.group(1) != null) {
        String titleText = match.group(1)!;
        String id = 'rec_${counter++}';
        String title = titleText;
        String type = 'film';
        String year = '';
        
        // Extraire l'année si présente dans le titre
        final yearRegex = RegExp(r'\((\d{4})\)');
        final yearMatch = yearRegex.firstMatch(titleText);
        if (yearMatch != null && yearMatch.group(1) != null) {
          year = yearMatch.group(1)!;
          title = title.replaceAll('(${year})', '').trim();
        }
        
        // Détecter si c'est une série
        if (text.toLowerCase().contains('série') || titleText.toLowerCase().contains('série')) {
          type = 'série';
        }
        
        // Essayer d'extraire la note
        double rating = 0.0;
        final ratingRegex = RegExp(r'Note\s*:\s*([0-9.]+)');
        final ratingMatch = ratingRegex.firstMatch(text.substring(match.start));
        if (ratingMatch != null && ratingMatch.group(1) != null) {
          rating = double.tryParse(ratingMatch.group(1)!) ?? 0.0;
        }
        
        // Extraire les genres
        List<String> genres = [];
        final genreRegex = RegExp(r'Genres?\s*:\s*([^.]+)');
        final genreMatch = genreRegex.firstMatch(text.substring(match.start));
        if (genreMatch != null && genreMatch.group(1) != null) {
          genres = genreMatch.group(1)!
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        }
        
        // Extraire les plateformes
        List<String> platforms = [];
        final platformRegex = RegExp(r'Disponible sur\s*:\s*([^.]+)');
        final platformMatch = platformRegex.firstMatch(text.substring(match.start));
        if (platformMatch != null && platformMatch.group(1) != null) {
          platforms = platformMatch.group(1)!
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        }
        
        // Extraire le réalisateur
        String director = '';
        final directorRegex = RegExp(r'Réalisateur\s*:\s*([^.]+)');
        final directorMatch = directorRegex.firstMatch(text.substring(match.start));
        if (directorMatch != null && directorMatch.group(1) != null) {
          director = directorMatch.group(1)!.trim();
        }
        
        // Extraire la description
        String description = '';
        final descriptionRegex = RegExp(r'Description\s*:\s*([^.]+)');
        final descriptionMatch = descriptionRegex.firstMatch(text.substring(match.start));
        if (descriptionMatch != null && descriptionMatch.group(1) != null) {
          description = descriptionMatch.group(1)!.trim();
        }
        
        recommendations.add(ContentRecommendation(
          id: id,
          title: title,
          type: type,
          year: year,
          rating: rating,
          genres: genres,
          platforms: platforms,
          description: description,
          director: director,
        ));
      }
    }
    
    return recommendations;
  }
}
