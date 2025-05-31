import 'dart:collection';

class ConversationMemory {
  final String topic;
  final DateTime startTime;
  final List<String> relatedEntities;
  
  ConversationMemory({
    required this.topic,
    required this.startTime,
    this.relatedEntities = const [],
  });
}

class ContextMemoryService {
  // Mémoire à court terme (conversation actuelle)
  List<String> _shortTermMemory = [];
  
  // Mémoire à moyen terme (sujets récents)
  Queue<ConversationMemory> _mediumTermMemory = Queue();
  
  // Mémoire à long terme (préférences persistantes)
  Map<String, dynamic> _longTermMemory = {};
  
  // Taille maximale des mémoires
  final int _shortTermMaxSize = 10;
  final int _mediumTermMaxSize = 5;
  
  // Ajouter un message à la mémoire à court terme
  void addToShortTermMemory(String message) {
    _shortTermMemory.add(message);
    if (_shortTermMemory.length > _shortTermMaxSize) {
      _shortTermMemory.removeAt(0);
    }
  }
  
  // Créer un résumé de la mémoire à court terme
  void summarizeToMediumTerm(String topic) {
    if (_shortTermMemory.isEmpty) return;
    
    // Analyser les messages récents pour extraire les entités pertinentes
    List<String> entities = _extractEntities(_shortTermMemory);
    
    // Créer une nouvelle mémoire de conversation
    final memory = ConversationMemory(
      topic: topic,
      startTime: DateTime.now(),
      relatedEntities: entities,
    );
    
    // Ajouter à la mémoire à moyen terme
    _mediumTermMemory.add(memory);
    
    // Maintenir la taille maximale
    if (_mediumTermMemory.length > _mediumTermMaxSize) {
      _mediumTermMemory.removeFirst();
    }
  }
  
  // Extraire des entités à partir des messages
  List<String> _extractEntities(List<String> messages) {
    // Implémentation simplifiée
    Set<String> entities = {};
    
    final keywords = [
      "film", "série", "acteur", "réalisateur", "netflix", "amazon", "disney",
      "comédie", "drame", "action", "thriller", "science-fiction", "horreur"
    ];
    
    for (final message in messages) {
      for (final keyword in keywords) {
        if (message.toLowerCase().contains(keyword.toLowerCase())) {
          entities.add(keyword.toLowerCase());
        }
      }
    }
    
    return entities.toList();
  }
  
  // Récupérer le contexte actuel
  Map<String, dynamic> getCurrentContext() {
    return {
      'short_term': _shortTermMemory,
      'conversation_topics': _mediumTermMemory.map((m) => m.topic).toList(),
      'conversation_entities': _mediumTermMemory.isNotEmpty 
          ? _mediumTermMemory.last.relatedEntities 
          : [],
    };
  }
  
  // Vérifier si un sujet est en rapport avec les conversations récentes
  bool isRelatedToRecentConversations(String topic) {
    if (_mediumTermMemory.isEmpty) return false;
    
    for (final memory in _mediumTermMemory) {
      if (memory.topic.toLowerCase().contains(topic.toLowerCase())) {
        return true;
      }
      
      for (final entity in memory.relatedEntities) {
        if (entity.toLowerCase().contains(topic.toLowerCase())) {
          return true;
        }
      }
    }
    
    return false;
  }
}
