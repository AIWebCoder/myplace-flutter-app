class ApiConfig {
  // API Gemini
  static const String geminiApiKey = 'AIzaSyAzkk9yXHgTHtPRPu6nt45cWKgy3ql0AL4';
  static const String defaultModel = 'gemini-2.0-flash';
  static const double temperature = 0.7;
  
  // ElevenLabs API pour la synthèse vocale
  static const String elevenLabsApiKey = 'sk_20ddad4670be0469a645bc84e461c0990cec1444bad8bc2d';
  static const String defaultVoiceId = '21m00Tcm4TlvDq8ikWAM'; // Rachel
  
  // Configuration pour le mode hors ligne
  static const bool useLocalDataWhenOffline = true;
}
