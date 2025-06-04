import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // API Gemini
  static final String geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String defaultModel = dotenv.env['DEFAULT_GEMINI_MODEL'] ?? 'gemini-2.0-flash';
  static final double temperature = double.tryParse(dotenv.env['TEMPERATURE'] ?? '0.7') ?? 0.7;

  // ElevenLabs API
  static final String elevenLabsApiKey = dotenv.env['ELEVENLABS_API_KEY'] ?? '';
  static final String defaultVoiceId = dotenv.env['DEFAULT_VOICE_ID'] ?? '';

  // Offline mode
  static final bool useLocalDataWhenOffline = dotenv.env['USE_LOCAL_DATA_WHEN_OFFLINE']?.toLowerCase() == 'true';
}
