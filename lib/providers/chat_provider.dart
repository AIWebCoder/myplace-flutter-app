// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/content_recommendation.dart';
import '../services/gemini_service.dart';
import '../services/speech_service.dart';
import '../services/context_memory_service.dart';
import '../services/audio_spectrum_service.dart';

class ChatProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final SpeechService _speechService = SpeechService();
  final ContextMemoryService _contextMemory = ContextMemoryService();
  final AudioSpectrumService _audioSpectrum = AudioSpectrumService(); // Nouveau service
  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isSpeaking = false;

  // État de suivi de la conversation
  String _currentTopic = '';

  List<ChatMessage> get messages => _messages;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;

  // Exposer les services
  GeminiService get geminiService => _geminiService;
  SpeechService get speechService => _speechService;
  ContextMemoryService get contextMemory => _contextMemory;
  AudioSpectrumService get audioSpectrum => _audioSpectrum; // Nouveau getter pour le service audio

  ChatProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _speechService.initialize();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Ajouter le message à la mémoire contextuelle
    _contextMemory.addToShortTermMemory(message);

    // Ajouter le message de l'utilisateur
    _messages.add(ChatMessage(
      content: message,
      role: MessageRole.user,
    ));
    notifyListeners();

    // Ajouter un message "en cours" pour l'assistant
    _messages.add(ChatMessage(
      content: '',
      role: MessageRole.assistant,
      isProcessing: true,
    ));
    notifyListeners();

    String response = "";
    try {
      // Obtenir le contexte actuel pour améliorer la réponse
      final context = _contextMemory.getCurrentContext();

      // Obtenir la réponse de Gemini avec le contexte enrichi
      response = await _geminiService.sendMessageWithContext(message, context);

      // Détecter le sujet de la conversation si nécessaire
      _detectAndUpdateTopic(message, response);

      // Analyser la réponse pour y chercher des recommandations
      final isRecommendationRequest = _isRecommendationRequest(message.toLowerCase()) ||
          _containsRecommendationMarkers(response);
      final List<ContentRecommendation> recommendations =
          isRecommendationRequest ? _parseRecommendations(response) : [];

      // Remplacer le message "en cours" par la vraie réponse
      _messages.removeLast();

      if (recommendations.isNotEmpty) {
        // Si des recommandations ont été détectées
        _messages.add(ChatMessage.withRecommendations(
          response,
          recommendations,
        ));

        // Enregistrer cette interaction comme liée aux recommandations
        if (_currentTopic.isEmpty) {
          _currentTopic = "Recommandations";
          _contextMemory.summarizeToMediumTerm(_currentTopic);
        }
      } else {
        // Sinon, message normal
        _messages.add(ChatMessage(
          content: response,
          role: MessageRole.assistant,
        ));
      }

      // Si la réponse semble demander un feedback utilisateur
      if (_containsFeedbackRequest(response)) {
      }

      // Lire la réponse à haute voix si activé
      if (_speechService.isTtsEnabled && response.isNotEmpty) {
        _isSpeaking = true;
        // Démarrer l'analyse du spectre en mode parole
        _audioSpectrum.startAnalysis(isSpeaking: true);
        notifyListeners();

        try {
          await _speechService.speak(response);
        } catch (e) {
          print("Erreur lors de la synthèse vocale: $e");
        } finally {
          _isSpeaking = false;
          // Arrêter l'analyse du spectre
          _audioSpectrum.stopAnalysis();
          notifyListeners();
        }
      }
    } catch (e) {
      // En cas d'erreur, afficher un message d'erreur
      _messages.removeLast();
      _messages.add(ChatMessage(
        content: "Je suis désolé, une erreur s'est produite lors du traitement de votre demande.",
        role: MessageRole.assistant,
      ));
      print('Erreur lors de l\'envoi du message: $e');
      response = "Je suis désolé, une erreur s'est produite lors du traitement de votre demande.";
    }

    notifyListeners();
  }

  void _detectAndUpdateTopic(String userMessage, String botResponse) {
    if (_currentTopic.isEmpty) {
      if (_isAboutMovies(userMessage, botResponse)) {
        _currentTopic = "Films et séries";
        _contextMemory.summarizeToMediumTerm(_currentTopic);
      }
    }
    else if (!_contextMemory.isRelatedToRecentConversations(userMessage)) {
      _currentTopic = "";
    }
  }

  bool _isAboutMovies(String userMessage, String botResponse) {
    final combined = "${userMessage.toLowerCase()} ${botResponse.toLowerCase()}";
    final movieTerms = [
      'film', 'série', 'cinéma', 'épisode', 'saison',
      'acteur', 'actrice', 'réalisateur', 'regarder', 'netflix'
    ];

    return movieTerms.any((term) => combined.contains(term));
  }

  bool _containsRecommendationMarkers(String response) {
    final lowerResponse = response.toLowerCase();
    return (lowerResponse.contains('voici') || lowerResponse.contains('je te recommande')) &&
        (lowerResponse.contains('film') || lowerResponse.contains('série'));
  }

  bool _containsFeedbackRequest(String response) {
    final lowerResponse = response.toLowerCase();
    final feedbackPatterns = [
      'qu\'en penses-tu', 'est-ce que cela te convient',
      'cela t\'intéresse', 'souhaites-tu',
      'préférerais-tu', 'aimerais-tu', 'veux-tu'
    ];

    return feedbackPatterns.any((pattern) => lowerResponse.contains(pattern));
  }

  bool _isRecommendationRequest(String message) {
    final lowerMessage = message.toLowerCase().trim();
    
    final explicitTriggers = [
      'recommand', 'suggère', 'conseil',
      'quels films', 'quelles séries', 'quel film', 'quelle série',
      'propose', 'montre', 'films similaires', 'film similaire',
      'séries similaires', 'série similaire', 'que regarder',
      'à voir', 'idée', 'envie de voir', 'film à voir',
      'top films', 'meilleures séries', 'meilleur film'
    ];
    
    final contentTerms = [
      'film', 'série', 'documentaire', 'épisode',
      'netflix', 'disney', 'prime video', 'amazon prime', 'canal+', 'apple tv'
    ];
    
    final nonTriggers = [
      'bonjour', 'salut', 'hello', 'coucou', 'bonsoir',
      'comment ça va', 'comment vas-tu', 'ça va',
      'merci', 'au revoir', 'à bientôt', 'ok'
    ];
    
    if (nonTriggers.any((trigger) => lowerMessage == trigger)) {
      return false;
    }
    
    if (explicitTriggers.any((trigger) => lowerMessage.contains(trigger))) {
      return true;
    }
    
    final actionTerms = ['cherche', 'veux', 'aimerais', 'souhaite', 'besoin', 'connais', 'sais'];
    
    bool hasActionTerm = actionTerms.any((term) => lowerMessage.contains(term));
    bool hasContentTerm = contentTerms.any((term) => lowerMessage.contains(term));
    
    if (hasActionTerm && hasContentTerm) {
      return true;
    }
    
    return false;
  }

  List<ContentRecommendation> _parseRecommendations(String response) {
    bool containsRecommendations = response.toLowerCase().contains('recommand') || 
        (response.contains('**') && 
        (response.contains('film') || response.contains('série')));
    
    if (containsRecommendations) {
      try {
        return ContentRecommendation.parseFromText(response);
      } catch (e) {
        print('Erreur lors de l\'analyse des recommandations: $e');
      }
    }
    
    return [];
  }

  Future<void> startListening() async {
    _isListening = true;
    // Démarrer l'analyse du spectre en mode écoute
    _audioSpectrum.startAnalysis(isSpeaking: false);
    notifyListeners();
    
    // Ajouter un message utilisateur vide qui sera mis à jour en temps réel
    _messages.add(ChatMessage(
      content: "",
      role: MessageRole.user,
      isProcessing: true,
    ));
    notifyListeners();
    
    try {
      await _speechService.startListening((text) {
        // Mise à jour du message en temps réel
        if (_isListening && _messages.isNotEmpty) {
          final lastMessage = _messages.last;
          if (lastMessage.role == MessageRole.user && lastMessage.isProcessing) {
            // Mettre à jour le contenu du message sans créer un nouveau message
            _messages[_messages.length - 1] = ChatMessage(
              content: text,
              role: MessageRole.user,
              isProcessing: true,
            );
            notifyListeners();
          }
        }
      });
    } catch (e) {
      print("Erreur startListening: $e");
      if (_isListening) {
        _isListening = false;
        notifyListeners();
      }
    }
  }

// Nombre minimum de mots pour synthétiser

  Future<void> stopListening() async {
    try {
      await _speechService.stopListening();
    } catch (e) {
      print("Erreur stopListening: $e");
    }
    
    _isListening = false;
    // Arrêter l'analyse du spectre
    _audioSpectrum.stopAnalysis();
    
    // Finaliser le message utilisateur et l'envoyer au bot
    if (_messages.isNotEmpty && 
        _messages.last.role == MessageRole.user && 
        _messages.last.isProcessing) {
      
      String userMessage = _messages.last.content.trim();
      _messages.removeLast();
      
      if (userMessage.isNotEmpty) {
        // Ajouter le message finalisé de l'utilisateur
        _messages.add(ChatMessage(
          content: userMessage,
          role: MessageRole.user,
        ));
        notifyListeners();
        
        // Ajouter un message "en cours" pour l'assistant
        _messages.add(ChatMessage(
          content: '',
          role: MessageRole.assistant,
          isProcessing: true,
        ));
        notifyListeners();
        
        // Réinitialiser les variables de streaming de réponse
        
        // Obtenir la réponse de Gemini
        _sendMessageWithStreamingResponse(userMessage);
      }
    }
    
    notifyListeners();
  }

  // Nouvelle méthode pour envoyer un message et traiter la réponse en streaming
  Future<void> _sendMessageWithStreamingResponse(String message) async {
    try {
      final context = _contextMemory.getCurrentContext();
      final response = await _geminiService.sendMessageWithContext(message, context);
      
      // Détecter le sujet de la conversation si nécessaire
      _detectAndUpdateTopic(message, response);
      
      // Analyser la réponse pour y chercher des recommandations
      final isRecommendationRequest = 
          _isRecommendationRequest(message.toLowerCase()) ||
          _containsRecommendationMarkers(response);
      
      final List<ContentRecommendation> recommendations =
          isRecommendationRequest ? _parseRecommendations(response) : [];
      
      // Remplacer le message "en cours"
      _messages.removeLast();
      
      // Traiter la réponse
      if (recommendations.isNotEmpty) {
        // Si des recommandations ont été détectées
        _messages.add(ChatMessage.withRecommendations(
          response,
          recommendations,
        ));
        
        if (_currentTopic.isEmpty) {
          _currentTopic = "Recommandations";
          _contextMemory.summarizeToMediumTerm(_currentTopic);
        }
        
        // Synthétiser vocalement toute la réponse
        if (_speechService.isTtsEnabled) {
          _isSpeaking = true;
          notifyListeners();
          
          // Extraire le texte principal avant les recommandations
          final mainText = _extractMainText(response);
          
          try {
            await _speechService.speak(mainText);
          } catch (e) {
            print("Erreur lors de la synthèse vocale: $e");
          } finally {
            _isSpeaking = false;
            notifyListeners();
          }
        }
      } else {
        // Message normal
        _messages.add(ChatMessage(
          content: response,
          role: MessageRole.assistant,
        ));
        
        // Synthétiser la réponse par phrases ou segments
        if (_speechService.isTtsEnabled) {
          _streamTextToSpeech(response);
        }
      }
      
      notifyListeners();
    } catch (e) {
      // Gestion d'erreur
      _messages.removeLast();
      _messages.add(ChatMessage(
        content: "Je suis désolé, une erreur s'est produite lors du traitement de votre demande.",
        role: MessageRole.assistant,
      ));
      print('Erreur lors de l\'envoi du message: $e');
      notifyListeners();
    }
  }

  // Nouvelle méthode pour synthétiser le texte par segments
  Future<void> _streamTextToSpeech(String text) async {
    if (text.isEmpty) return;
    
    _isSpeaking = true;
    notifyListeners();
    
    try {
      // Diviser le texte en phrases ou segments
      final segments = _splitTextIntoSegments(text);
      
      // Synthétiser chaque segment
      for (final segment in segments) {
        if (segment.trim().isEmpty) continue;
        
        try {
          await _speechService.speak(segment);
          
          // Attendre un court instant entre les segments
          await Future.delayed(Duration(milliseconds: 300));
        } catch (e) {
          print("Erreur lors de la synthèse vocale d'un segment: $e");
        }
      }
    } catch (e) {
      print("Erreur lors du streaming TTS: $e");
    } finally {
      _isSpeaking = false;
      notifyListeners();
    }
  }

  // Méthode pour diviser un texte en segments
  List<String> _splitTextIntoSegments(String text) {
    // Diviser par phrases (points, points d'exclamation, points d'interrogation)
    final pattern = RegExp(r'[.!?]+');
    final segments = text.split(pattern);
    
    // Filtrer les segments vides et les limiter à une taille maximale
    final result = <String>[];
    
    // Si le texte est très court, retourner tel quel
    if (segments.length <= 1 && text.length < 100) {
      return [text];
    }
    
    String currentSegment = "";
    
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i].trim();
      if (segment.isEmpty) continue;
      
      // Ajouter la ponctuation de fin si ce n'est pas le dernier segment
      final punctuation = i < segments.length - 1 ? 
          text.substring(text.indexOf(segment) + segment.length, text.indexOf(segment) + segment.length + 1) : 
          "";
      
      if (currentSegment.isEmpty) {
        currentSegment = segment + punctuation;
      } else if (("$currentSegment $segment").split(" ").length <= 15) {
        // Combiner les segments courts
        currentSegment += " $segment$punctuation";
      } else {
        // Ajouter le segment accumulé et commencer un nouveau
        result.add(currentSegment);
        currentSegment = segment + punctuation;
      }
    }
    
    // Ajouter le dernier segment s'il en reste un
    if (currentSegment.isNotEmpty) {
      result.add(currentSegment);
    }
    
    return result;
  }

  // Extraire le texte principal d'une réponse (avant les recommandations)
  String _extractMainText(String response) {
    // Chercher le premier marqueur de recommandation
    final patterns = [
      "Voici mes recommandations",
      "Je vous recommande",
      "**",
      "Voici quelques"
    ];
    
    String mainText = response;
    
    for (final pattern in patterns) {
      final index = response.indexOf(pattern);
      if (index > 0 && index < mainText.length) {
        mainText = response.substring(0, index);
      }
    }
    
    return mainText;
  }

  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _speechService.stopSpeaking();
      _isSpeaking = false;
      // Arrêter l'analyse du spectre
      _audioSpectrum.stopAnalysis();
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
  
  List<String> getContextualSuggestions() {
    if (_messages.isEmpty) {
      return ["Recommande-moi un film", "Que puis-je regarder ce soir?"];
    }
    
    if (_currentTopic == "Films et séries") {
      return [
        "Des recommandations plus récentes",
        "Quelque chose de similaire mais différent",
        "Un classique du même genre"
      ];
    }
    
    return [
      "Recommande-moi un film",
      "Quelles sont les nouvelles séries populaires?",
      "Je cherche un bon thriller"
    ];
  }
}
