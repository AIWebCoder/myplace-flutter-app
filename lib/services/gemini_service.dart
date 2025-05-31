import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class GeminiService {
  // ID utilisateur actuel
  String? _userId;
  
  // Historique de conversation pour le contexte
  final List<Map<String, String>> _conversationHistory = [];
  
  // Constante pour la taille maximale de l'historique
  final int _maxContextLength = 10;
  
  // Setter pour l'ID utilisateur
  Future<void> setUserId(String userId) async {
    _userId = userId;
  }
  
  // Méthode principale pour envoyer un message
  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1/models/${ApiConfig.defaultModel}:generateContent');
      
      // Ajouter le message au contexte
      _conversationHistory.add({
        'role': 'user',
        'parts': message,
      });
      
      // Limiter la taille du contexte
      if (_conversationHistory.length > _maxContextLength) {
        _conversationHistory.removeAt(0);
      }
      
      // Construire le corps de la requête
      final body = {
        'contents': _conversationHistory.map((msg) => {
          'role': msg['role'],
          'parts': [{'text': msg['parts']}]
        }).toList(),
        'generationConfig': {
          'temperature': ApiConfig.temperature,
          'topK': 40,
          'topP': 0.95,
        }
      };
      
      // Envoyer la requête
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': ApiConfig.geminiApiKey,
        },
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responseText = data['candidates'][0]['content']['parts'][0]['text'];
        
        // Ajouter la réponse au contexte
        _conversationHistory.add({
          'role': 'model',
          'parts': responseText,
        });
        
        return responseText;
      } else {
        throw Exception('Erreur API Gemini: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception Gemini: $e');
      return "Désolé, je n'ai pas pu traiter votre demande en raison d'une erreur.";
    }
  }
  
  // Envoyer un message avec contexte enrichi
  Future<String> sendMessageWithContext(String message, Map<String, dynamic> context) async {
    // On pourrait enrichir le message avec le contexte ici
    return sendMessage(message);
  }
  
  // Effacer l'historique de conversation
  void clearConversationHistory() {
    _conversationHistory.clear();
  }
  
  // Obtenir des recommandations par catégorie
  Future<String> getRecommendationsByCategory(String category) async {
    final prompt = "Recommande-moi 3 films ou séries dans la catégorie $category. Pour chaque recommandation, donne-moi le titre, l'année, le réalisateur, la note sur 10, et une brève description. Présente les résultats de manière structurée avec des titres en gras.";
    return sendMessage(prompt);
  }
}
