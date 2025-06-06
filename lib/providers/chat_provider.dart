import 'package:flutter/material.dart';
import '../model/chat_message.dart';
import '../model/content_recommendation.dart';
import '../model/post_model.dart';
import '../services/gemini_service.dart';
import '../services/speech_service.dart';
import '../services/context_memory_service.dart';
import '../services/audio_spectrum_service.dart';
import '../services/rag_service.dart';

class ChatProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final SpeechService _speechService = SpeechService();
  final ContextMemoryService _contextMemory = ContextMemoryService();
  final AudioSpectrumService _audioSpectrum = AudioSpectrumService();
  
  List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isSpeaking = false;
  List<String> _conversationContext = [];

  // État de suivi de la conversation
  String _currentTopic = '';
  bool _awaitingUserFeedback = false;

  List<ChatMessage> get messages => _messages;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;

  // Exposer les services
  GeminiService get geminiService => _geminiService;
  SpeechService get speechService => _speechService;
  ContextMemoryService get contextMemory => _contextMemory;
  AudioSpectrumService get audioSpectrum => _audioSpectrum;

  ChatProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _speechService.initialize();
    // Ajouter un message de bienvenue
    addMessage(ChatMessage(
      role: MessageRole.assistant,
      content: "Salut ! 😊 Je suis Myla, ton assistante X Place. Comment puis-je t'aider à découvrir du super contenu aujourd'hui ?",
    ));
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Ajouter le message à la mémoire contextuelle
    _contextMemory.addToShortTermMemory(message);
    _conversationContext.add("Utilisateur: $message");

    // Garder seulement les 10 derniers échanges pour le contexte
    if (_conversationContext.length > 20) {
      _conversationContext = _conversationContext.sublist(_conversationContext.length - 20);
    }

    // Ajouter le message de l'utilisateur
    addMessage(ChatMessage(
      content: message,
      role: MessageRole.user,
    ));

    // Ajouter un message "en cours" pour l'assistant
    addMessage(ChatMessage(
      content: '',
      role: MessageRole.assistant,
      isProcessing: true,
    ));

    try {
      // Utiliser le système RAG pour générer la réponse
      final ragResponse = await RAGService.generateRAGResponse(message, _conversationContext);
      
      // Supprimer le message de traitement
      _messages.removeWhere((msg) => msg.isProcessing);
      
      // Nettoyer et valider la réponse
      String cleanResponse = ragResponse.text.trim();
      
      // S'assurer que la réponse est complète et naturelle
      if (cleanResponse.isEmpty) {
        cleanResponse = _generateContextualFallback(message);
      }
      
      // Ajouter la réponse à l'historique
      _conversationContext.add("Myla: $cleanResponse");
      
      // Ajouter la réponse de l'assistant avec les posts recommandés
      addMessage(ChatMessage(
        content: cleanResponse,
        role: MessageRole.assistant,
        recommendedPosts: ragResponse.recommendedPosts,
      ));
      
      // Synthèse vocale si activée
      if (_speechService.isTtsEnabled) {
        _isSpeaking = true;
        _audioSpectrum.startAnalysis(isSpeaking: true);
        notifyListeners();
        
        try {
          await _speechService.speak(cleanResponse);
        } catch (e) {
          print("Erreur lors de la synthèse vocale: $e");
        } finally {
          _isSpeaking = false;
          _audioSpectrum.stopAnalysis();
          notifyListeners();
        }
      }
      
    } catch (e) {
      print('Erreur lors de l\'envoi du message: $e');
      
      // Supprimer le message de traitement
      _messages.removeWhere((msg) => msg.isProcessing);
      
      // Message d'erreur avec fallback contextuel
      final fallbackMessage = _generateContextualFallback(message);
      addMessage(ChatMessage(
        content: fallbackMessage,
        role: MessageRole.assistant,
      ));
    }

    notifyListeners();
  }

  // Génération de réponses de fallback contextuelles
  String _generateContextualFallback(String userMessage) {
    final messageLower = userMessage.toLowerCase();
    
    if (messageLower.contains('salut') || messageLower.contains('bonjour') || messageLower.contains('hello')) {
      return "Salut ! 😊 Je suis Myla, ton assistante sur X Place ! Comment ça va ? Tu cherches quelque chose en particulier ?";
    } else if (messageLower.contains('aide') || messageLower.contains('help')) {
      return "Bien sûr, je suis là pour t'aider ! Tu peux me demander du contenu par type, chercher des posts spécifiques, ou juste explorer ce qu'on a de cool sur X Place ! 🎬";
    } else if (messageLower.contains('merci')) {
      return "De rien ! 😊 C'est toujours un plaisir de t'aider ! Tu veux découvrir autre chose ?";
    } else if (messageLower.contains('vidéo') || messageLower.contains('contenu') || messageLower.contains('post')) {
      return "Super ! On a plein de contenu génial sur X Place ! Tu cherches quelque chose en particulier ? Vidéos, images, posts premium... ? 🎥";
    } else {
      return "Hmm, je vois que tu t'intéresses à ça ! Dis-moi plus précisément ce que tu aimerais voir et je vais te trouver le contenu parfait sur X Place ! ✨";
    }
  }

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _conversationContext.clear();
    _contextMemory.clearShortTermMemory();
    notifyListeners();
  }

  Future<void> startListening() async {
    if (_isListening) return;
    
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
      print('🎯 Démarrage de l\'écoute avec arrêt automatique intelligent');
      
      await _speechService.startListening((recognizedText) {
        // Vérifier si c'est un message de finalisation automatique
        if (recognizedText.startsWith("__FINALIZE__:")) {
          final finalText = recognizedText.substring("__FINALIZE__:".length);
          print('🏁 Finalisation automatique détectée: "$finalText"');
          _finalizeAutomatically(finalText);
          return;
        }
        
        // Mise à jour du message en temps réel si on est encore en écoute
        if (_isListening && _messages.isNotEmpty) {
          final lastMessage = _messages.last;
          if (lastMessage.role == MessageRole.user && lastMessage.isProcessing) {
            // Mettre à jour le contenu du message sans créer un nouveau message
            _messages[_messages.length - 1] = ChatMessage(
              content: recognizedText,
              role: MessageRole.user,
              isProcessing: true,
            );
            notifyListeners();
            
            print('📝 Mise à jour en temps réel: "$recognizedText"');
          }
        }
      });
    } catch (e) {
      print('❌ Erreur lors de l\'écoute: $e');
      _isListening = false;
      _audioSpectrum.stopAnalysis();
      
      // Supprimer le message en cours si erreur
      if (_messages.isNotEmpty && _messages.last.isProcessing) {
        _messages.removeLast();
      }
      
      notifyListeners();
    }
  }

  // Nouvelle méthode pour la finalisation automatique
  void _finalizeAutomatically(String finalText) async {
    if (!_isListening) return;
    
    print('🤖 Finalisation automatique du message: "$finalText"');
    
    _isListening = false;
    _audioSpectrum.stopAnalysis();
    
    // Finaliser le message utilisateur et l'envoyer au bot
    if (_messages.isNotEmpty && 
        _messages.last.role == MessageRole.user && 
        _messages.last.isProcessing) {
      
      _messages.removeLast();
      
      if (finalText.isNotEmpty && finalText.length > 1) {
        print('📨 Message finalisé automatiquement et envoyé: "$finalText"');
        
        // Ajouter le message finalisé de l'utilisateur
        addMessage(ChatMessage(
          content: finalText,
          role: MessageRole.user,
        ));
        
        // Traiter le message avec le système RAG
        _processUserMessage(finalText);
      } else {
        print('⚠️ Message trop court ignoré: "$finalText"');
      }
    }
    
    notifyListeners();
  }

  // Vérifier si le texte semble complet (gardé pour compatibilité mais moins utilisé)
  bool _isTextComplete(String text) {
    if (text.trim().isEmpty) return false;
    
    // Vérifier la ponctuation de fin
    final endsWithPunctuation = text.trim().endsWith('.') || 
                               text.trim().endsWith('!') || 
                               text.trim().endsWith('?');
    
    // Vérifier la longueur (au moins 3 mots)
    final hasMinimumWords = text.trim().split(' ').length >= 3;
    
    // Mots-clés de fin de phrase
    final endWords = ['merci', 'voilà', 'c\'est tout', 'fini', 'terminé'];
    final endsWithEndWord = endWords.any((word) => text.toLowerCase().trim().endsWith(word));
    
    return (endsWithPunctuation && hasMinimumWords) || 
           (endsWithEndWord && hasMinimumWords) ||
           (hasMinimumWords && text.length > 20);
  }

  // Finaliser l'écoute manuellement (pour le bouton stop)
  void _finalizeListening() async {
    if (!_isListening) return;
    
    try {
      await _speechService.stopListening();
    } catch (e) {
      print("Erreur stopListening: $e");
    }
    
    _isListening = false;
    _audioSpectrum.stopAnalysis();
    
    // Finaliser le message utilisateur et l'envoyer au bot
    if (_messages.isNotEmpty && 
        _messages.last.role == MessageRole.user && 
        _messages.last.isProcessing) {
      
      String userMessage = _messages.last.content.trim();
      _messages.removeLast();
      
      if (userMessage.isNotEmpty && userMessage.length > 1) {
        print('📨 Message finalisé manuellement et envoyé: "$userMessage"');
        
        // Ajouter le message finalisé de l'utilisateur
        addMessage(ChatMessage(
          content: userMessage,
          role: MessageRole.user,
        ));
        
        // Traiter le message avec le système RAG
        _processUserMessage(userMessage);
      } else {
        print('⚠️ Message trop court ignoré: "$userMessage"');
      }
    }
    
    notifyListeners();
  }

  Future<void> stopListening() async {
    if (!_isListening) return;
    
    print('🛑 Arrêt manuel de l\'écoute par l\'utilisateur');
    _finalizeListening();
  }

  Future<void> stopSpeaking() async {
    if (!_isSpeaking) return;
    
    await _speechService.stopSpeaking();
    _isSpeaking = false;
    _audioSpectrum.stopAnalysis();
    notifyListeners();
  }

  // Ajouter une méthode pour les suggestions contextuelles
  List<String> getContextualSuggestions() {
    return [
      "Contenu populaire",
      "Vidéos récentes", 
      "Posts premium",
      "Contenu gratuit",
      "Nouveautés",
      "Featured"
    ];
  }

  // Traiter le message utilisateur avec le système RAG
  Future<void> _processUserMessage(String message) async {
    // Ajouter un message "en cours" pour l'assistant
    addMessage(ChatMessage(
      content: '',
      role: MessageRole.assistant,
      isProcessing: true,
    ));

    try {
      // Utiliser le système RAG pour générer la réponse
      final ragResponse = await RAGService.generateRAGResponse(message, _conversationContext);
      
      // Supprimer le message de traitement
      _messages.removeWhere((msg) => msg.isProcessing);
      
      // Nettoyer et valider la réponse
      String cleanResponse = ragResponse.text.trim();
      
      if (cleanResponse.isEmpty) {
        cleanResponse = _generateContextualFallback(message);
      }
      
      // Ajouter la réponse à l'historique
      _conversationContext.add("Myla: $cleanResponse");
      
      // Ajouter la réponse de l'assistant avec les posts recommandés
      addMessage(ChatMessage(
        content: cleanResponse,
        role: MessageRole.assistant,
        recommendedPosts: ragResponse.recommendedPosts,
      ));
      
      // Synthèse vocale si activée
      if (_speechService.isTtsEnabled) {
        _isSpeaking = true;
        _audioSpectrum.startAnalysis(isSpeaking: true);
        notifyListeners();
        
        try {
          await _speechService.speak(cleanResponse);
        } catch (e) {
          print("Erreur lors de la synthèse vocale: $e");
        } finally {
          _isSpeaking = false;
          _audioSpectrum.stopAnalysis();
          notifyListeners();
        }
      }
      
    } catch (e) {
      print('Erreur lors du traitement du message: $e');
      
      // Supprimer le message de traitement
      _messages.removeWhere((msg) => msg.isProcessing);
      
      // Message d'erreur
      addMessage(ChatMessage(
        content: _generateContextualFallback(message),
        role: MessageRole.assistant,
      ));
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _isListening = false;
    _isSpeaking = false;
    _audioSpectrum.stopAnalysis();
    super.dispose();
  }
}
