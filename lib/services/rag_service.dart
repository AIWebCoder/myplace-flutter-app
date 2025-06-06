import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/post_model.dart';
import '../model/attachment_model.dart';
import '../config/api_config.dart';
import 'dart:math' as Math;

class RAGResponse {
  final String text;
  final List<Post> recommendedPosts;

  RAGResponse({
    required this.text,
    this.recommendedPosts = const [],
  });
}

class RAGService {
  static const String _baseUrl = 'https://backend.preprod.myxplace.com/api/fetch-all-post';
  static const Duration _requestTimeout = Duration(seconds: 15);
  static const Duration _cacheTimeout = Duration(minutes: 10);
  
  static List<Post> _cachedPosts = [];
  static DateTime? _lastFetchTime;

  // Récupération des posts depuis l'API uniquement
  static Future<List<Post>> fetchAllPosts() async {
    // Vérifier le cache
    if (_cachedPosts.isNotEmpty && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheTimeout) {
      print('📦 Utilisation du cache: ${_cachedPosts.length} posts');
      return _cachedPosts;
    }

    try {
      print('🌐 Récupération des posts depuis: $_baseUrl');
      
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        List<dynamic> jsonData;
        
        // Gérer différents formats de réponse API
        if (responseData is Map<String, dynamic>) {
          jsonData = responseData['data'] as List<dynamic>? ?? 
                    responseData['posts'] as List<dynamic>? ?? 
                    [responseData];
        } else if (responseData is List<dynamic>) {
          jsonData = responseData;
        } else {
          throw Exception('Format de réponse API inattendu');
        }

        _cachedPosts = jsonData
            .map((json) => Post.fromJson(json as Map<String, dynamic>))
            .where((post) => post.attachments.isNotEmpty) // Filtrer les posts avec contenu
            .toList();
            
        _lastFetchTime = DateTime.now();
        print('✅ Posts récupérés depuis l\'API: ${_cachedPosts.length} posts avec contenu');
        return _cachedPosts;
      } else {
        print('❌ Erreur HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Erreur HTTP ${response.statusCode}: Impossible de récupérer les posts');
      }
    } catch (e) {
      print('❌ Erreur API: $e');
      // Retourner une liste vide en cas d'erreur
      return [];
    }
  }

  // Recherche de posts pertinents basée sur la requête
  static Future<List<Post>> searchRelevantPosts(String query, {int? maxResults}) async {
    print('🔍 Recherche pour: "$query"');
    
    final posts = await fetchAllPosts();
    print('📄 ${posts.length} posts chargés depuis l\'API');
    
    if (posts.isEmpty) {
      print('⚠️ Aucun post disponible depuis l\'API');
      return [];
    }

    final queryLower = query.toLowerCase();
    final queryWords = queryLower.split(' ').where((word) => word.length > 1).toList();
    
    print('🔤 Mots-clés recherchés: $queryWords');

    // Déterminer si la question nécessite du contenu
    if (!_shouldReturnContent(query)) {
      print('❌ Pas de contenu nécessaire pour cette question');
      return [];
    }

    // Score de pertinence pour chaque post
    final Map<Post, double> scores = {};

    for (final post in posts) {
      double score = 0.0;

      // Correspondances exactes dans le texte (score très élevé)
      if (post.text.toLowerCase().contains(queryLower)) {
        score += 15.0;
        print('✅ Texte exact match: "${post.contentSummary}" +15 points');
      }

      // Correspondances exactes dans le type de post
      if (post.postType.toLowerCase() == queryLower) {
        score += 20.0;
        print('✅ Type exact match: "${post.displayText}" (${post.postType}) +20 points');
      }

      // Correspondances de mots-clés
      for (final word in queryWords) {
        // Texte du post
        if (post.text.toLowerCase().contains(word)) {
          score += 8.0;
          print('✅ Texte contient "$word": "${post.contentSummary}" +8 points');
        }
        
        // Type de post
        if (post.postType.toLowerCase().contains(word)) {
          score += 12.0;
          print('✅ Type contient "$word": "${post.displayText}" (${post.postType}) +12 points');
        }
        
        // Nom des fichiers attachés
        for (final attachment in post.attachments) {
          if (attachment.filename.toLowerCase().contains(word)) {
            score += 6.0;
            print('✅ Fichier contient "$word": "${post.displayText}" (fichier: ${attachment.filename}) +6 points');
          }
        }

        // Recherche spécifique par type de contenu
        if ((word == 'vidéo' || word == 'video') && post.hasVideoAttachments) {
          score += 10.0;
          print('✅ Contient des vidéos: "${post.displayText}" +10 points');
        }
        
        if ((word == 'image' || word == 'photo') && post.hasImageAttachments) {
          score += 10.0;
          print('✅ Contient des images: "${post.displayText}" +10 points');
        }
      }

      // Bonus pour le contenu featured/pinned
      if (post.isFeatured) {
        score += 5.0;
        print('⭐ Featured bonus: "${post.displayText}" +5 points');
      }

      // Bonus pour contenu gratuit vs payant
      if (!post.isPaidContent) {
        score += 2.0;
        print('🆓 Contenu gratuit bonus: "${post.displayText}" +2 points');
      }

      // Bonus pour contenu avec médias
      if (post.attachments.isNotEmpty) {
        score += 3.0;
        print('📎 Contenu avec médias: "${post.displayText}" +3 points');
      }

      if (score > 0) {
        scores[post] = score;
        print('📊 Score final pour "${post.displayText}": $score points');
      }
    }

    print('🎯 ${scores.length} posts avec un score > 0');

    // Trier par score
    final sortedPosts = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Déterminer le nombre de posts à retourner
    final postsToReturn = _determineContentCount(query, sortedPosts.length);
    final finalMaxResults = maxResults ?? postsToReturn;

    final result = sortedPosts.take(finalMaxResults).map((entry) => entry.key).toList();
    print('🏆 ${result.length} post(s) sélectionné(s): ${result.map((p) => '"${p.contentSummary}" (${scores[p]} pts)').join(', ')}');

    return result;
  }

  // Déterminer si la question nécessite du contenu
  static bool _shouldReturnContent(String query) {
    final queryLower = query.toLowerCase();
    
    // Questions générales qui ne nécessitent pas de contenu
    final conversationalKeywords = [
      'salut', 'bonjour', 'hello', 'comment', 'ça va', 'comment allez',
      'merci', 'au revoir', 'bonsoir', 'bonne nuit',
      'qui es tu', 'que peux tu faire', 'aide moi',
      'comment ça marche', 'explique', 'dis moi',
    ];

    if (conversationalKeywords.any((keyword) => queryLower.contains(keyword)) &&
        !queryLower.contains('vidéo') && !queryLower.contains('contenu') && 
        !queryLower.contains('post') && !queryLower.contains('regarder')) {
      return false;
    }

    // Questions d'information générale
    final informationalKeywords = [
      'qu\'est-ce que', 'pourquoi', 'quand', 'où', 'comment',
      'définition', 'signifie', 'veut dire'
    ];

    if (informationalKeywords.any((keyword) => queryLower.contains(keyword)) &&
        !queryLower.contains('vidéo') && !queryLower.contains('contenu') &&
        !queryLower.contains('post')) {
      return false;
    }

    return true;
  }

  // Déterminer le nombre de posts à retourner
  static int _determineContentCount(String query, int availablePosts) {
    final queryLower = query.toLowerCase();
    
    // Mots-clés indiquant un seul élément
    final singleContentKeywords = [
      'un post', 'une vidéo', 'un contenu', 'une recommandation',
      'quelque chose', 'propose moi un', 'trouve moi un',
      'le meilleur', 'la meilleure', 'ton préféré'
    ];

    if (singleContentKeywords.any((keyword) => queryLower.contains(keyword))) {
      return 1;
    }

    // Mots-clés indiquant plusieurs éléments
    final multipleContentKeywords = [
      'des posts', 'des vidéos', 'du contenu', 'plusieurs', 'liste', 'sélection',
      'propose moi des', 'trouve moi des', 'les meilleurs',
      'top', 'classement'
    ];

    if (multipleContentKeywords.any((keyword) => queryLower.contains(keyword))) {
      return availablePosts > 0 ? Math.min(5, availablePosts) : 0;
    }

    // Par défaut, retourner 2-3 posts s'il y a des résultats
    return availablePosts > 0 ? Math.min(3, availablePosts) : 0;
  }

  // Génération de réponse RAG avec Gemini
  static Future<RAGResponse> generateRAGResponse(
    String userQuery, 
    List<String> conversationContext
  ) async {
    try {
      // Rechercher des posts pertinents seulement si nécessaire
      final relevantPosts = await searchRelevantPosts(userQuery);
      
      // Préparer le contexte pour Gemini
      final prompt = _buildPrompt(userQuery, relevantPosts, conversationContext);
      
      // Appeler Gemini
      final geminiResponse = await _callGeminiAPI(prompt);
      
      return RAGResponse(
        text: geminiResponse,
        recommendedPosts: relevantPosts,
      );
    } catch (e) {
      print('Erreur RAG: $e');
      return RAGResponse(
        text: _generateFallbackResponse(userQuery),
        recommendedPosts: [],
      );
    }
  }

  // Construction du prompt pour Gemini
  static String _buildPrompt(
    String userQuery,
    List<Post> relevantPosts,
    List<String> conversationContext
  ) {
    final contextStr = conversationContext.isNotEmpty 
        ? "Contexte de conversation précédente: ${conversationContext.take(5).join(' | ')}"
        : "";

    String postsStr = "";
    if (relevantPosts.isNotEmpty) {
      if (relevantPosts.length == 1) {
        final post = relevantPosts[0];
        postsStr = "J'ai trouvé ce contenu parfait pour toi: '${post.displayText}' (${post.displayType})";
        if (post.hasVideoAttachments) postsStr += " - contient des vidéos";
        if (post.hasImageAttachments) postsStr += " - contient des images";
        if (post.isPaidContent) postsStr += " - contenu premium (${post.price}€)";
      } else {
        postsStr = "J'ai sélectionné ${relevantPosts.length} contenus qui pourraient t'intéresser: ${relevantPosts.map((p) => "'${p.contentSummary}' (${p.displayType})").join(', ')}";
      }
    }

    return """
Tu es Myla, l'assistante IA de X Place. Tu es enthousiaste, naturelle et amicale.

$contextStr

Message utilisateur: "$userQuery"

$postsStr

RÈGLES IMPORTANTES:
1. Réponds TOUJOURS de manière totalement naturelle et conversationnelle
2. JAMAIS de données techniques (ID, timestamps, etc.) dans ta réponse
3. Adapte ton comportement selon le type de question:

   QUESTIONS CONVERSATIONNELLES (salut, comment ça va, merci):
   → Réponds chaleureusement SANS proposer de contenu
   → Engage la conversation naturellement
   
   QUESTIONS D'INFORMATION GÉNÉRALE:
   → Réponds à la question SANS proposer de contenu
   → Sois informative et utile
   
   DEMANDES DE CONTENU SPÉCIFIQUE:
   → Si 1 post trouvé: Présente-le avec enthousiasme
   → Si plusieurs posts: Présente la sélection
   → Si aucun post: Guide vers du contenu similaire

4. Pour le contenu, mentionne naturellement:
   - Type de contenu (vidéo, image, post)
   - Si c'est gratuit ou premium
   - Aspects intéressants du contenu

5. Exemples de réponses naturelles:
   - "salut" → "Salut ! 😊 Je suis Myla ! Comment ça va ? Tu cherches quelque chose en particulier sur X Place ?"
   - "des vidéos d'action" → "Super ! J'ai quelques vidéos d'action géniales... [présente les posts]"

6. Garde tes réponses courtes (2-3 phrases max) et termine TOUJOURS tes phrases.

Réponds maintenant de façon 100% naturelle:
""";
  }

  // Appel à l'API Gemini
  static Future<String> _callGeminiAPI(String prompt) async {
    const geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
    
    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 200,
      },
    };

    try {
      final response = await http.post(
        Uri.parse('$geminiUrl?key=${ApiConfig.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'] ?? 
                 _generateFallbackResponse("");
        }
      }
      
      throw Exception('Erreur Gemini: ${response.statusCode}');
    } catch (e) {
      print('Erreur Gemini: $e');
      throw e;
    }
  }

  // Réponse de fallback simplifiée
  static String _generateFallbackResponse(String query) {
    final queryLower = query.toLowerCase();
    
    if (queryLower.contains('salut') || queryLower.contains('bonjour') || queryLower.contains('hello')) {
      return "Salut ! 😊 Je suis Myla, ton assistante X Place ! Comment puis-je t'aider ?";
    } else if (queryLower.contains('aide') || queryLower.contains('help')) {
      return "Je suis là pour t'aider à découvrir du contenu sur X Place ! Malheureusement, je n'arrive pas à accéder aux données en ce moment. Peux-tu réessayer ?";
    } else if (queryLower.contains('vidéo') || queryLower.contains('contenu') || queryLower.contains('post')) {
      return "Je cherche du contenu pour toi, mais il semble y avoir un problème de connexion. Peux-tu réessayer dans quelques instants ? 🎬";
    } else if (queryLower.contains('merci')) {
      return "De rien ! 😊 N'hésite pas si tu as besoin d'autre chose !";
    } else {
      return "Désolée, je rencontre quelques difficultés techniques en ce moment. Peux-tu reformuler ta demande ou réessayer ? 🤖";
    }
  }

  // Méthode utilitaire pour vider le cache
  static void clearCache() {
    _cachedPosts.clear();
    _lastFetchTime = null;
    print('🗑️ Cache vidé');
  }
}