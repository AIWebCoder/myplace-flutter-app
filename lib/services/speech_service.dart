// ignore_for_file: depend_on_referenced_packages, avoid_print, deprecated_member_use

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_audio_player_stub.dart'
    if (dart.library.js) 'web_audio_player.dart';
import '../config/api_config.dart';

class SpeechService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool isTtsEnabled = true;
  bool get isSpeaking => _isSpeaking;
  bool get isListening => _speechToText.isListening;

  // Voix disponibles
  final Map<String, String> _voices = {
    'Rachel': '21m00Tcm4TlvDq8ikWAM',
    'Domi': 'AZnzlk1XvdvUeBnXmlld',
    'Bella': 'EXAVITQu4vr4xnSDxMaL',
    'Antoni': 'ErXwobaYiN019PkySvjV',
    'Elli': 'MF3mGyEYCl7XYWbV9V6O',
    'Josh': 'TxGEqnHWrfWFTfGW9XjX',
  };

  String _activeVoiceId = ApiConfig.defaultVoiceId;

  Map<String, String> get availableVoices => _voices;
  String get activeVoiceId => _activeVoiceId;
  set activeVoiceId(String voiceId) {
    if (_voices.containsValue(voiceId)) {
      _activeVoiceId = voiceId;
    }
  }

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        // Initialiser Speech-to-Text
        _isInitialized = await _speechToText.initialize(
          onError: (error) => print("Erreur STT: $error"),
          debugLogging: true,
        );
      } catch (e) {
        print("Erreur lors de l'initialisation des services de parole: $e");
        // Assurer que l'échec d'initialisation n'empêche pas l'application de fonctionner
        _isInitialized = true; 
      }
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty || !isTtsEnabled) return;

    _isSpeaking = true;
    try {
      // Appel à l'API ElevenLabs pour tous les environnements
      await _callElevenLabsAPI(text);
    } catch (e) {
      print('Exception lors de la synthèse vocale: $e');
      _isSpeaking = false;
    }
  }

  Future<void> _callElevenLabsAPI(String text) async {
    try {
      // URL de l'API ElevenLabs pour la synthèse vocale
      final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$_activeVoiceId');

      // Headers avec l'authentification
      Map<String, String> headers = {
        'accept': 'audio/mpeg',
        'xi-api-key': ApiConfig.elevenLabsApiKey,
        'Content-Type': 'application/json',
      };

      // Payload contenant le texte à synthétiser et les options
      Map<String, dynamic> body = {
        'text': text,
        'model_id': 'eleven_multilingual_v2',
        'voice_settings': {
          'stability': 0.5,
          'similarity_boost': 0.5,
          'style': 0.0,
          'use_speaker_boost': true
        }
      };

      // Envoi de la requête
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        if (kIsWeb) {
          // Utiliser la méthode JavaScript pour jouer l'audio sur le web
          await _playAudioOnWeb(response.bodyBytes);
        } else {
          // Solution pour les plateformes natives
          await _playAudioOnNative(response.bodyBytes);
        }
      } else {
        throw Exception('Erreur ElevenLabs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la synthèse vocale: $e');
      _isSpeaking = false;
    }
  }

  Future<void> _playAudioOnWeb(List<int> audioBytes) async {
    try {
      // Convertir les bytes en Base64 pour les transmettre au JavaScript
      final base64Data = base64Encode(audioBytes);
      
      // Appeler la fonction JavaScript pour jouer l'audio
      playAudioBase64(base64Data);
      
      // Attendre une durée estimée pour simuler la fin de l'audio
      // Environ 1 seconde pour 15 caractères de texte
      await Future.delayed(Duration(seconds: 5));
      _isSpeaking = false;
    } catch (e) {
      print('Erreur de lecture audio Web: $e');
      _isSpeaking = false;
    }
  }

  Future<void> _playAudioOnNative(List<int> audioBytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/tts_output_${DateTime.now().millisecondsSinceEpoch}.mp3';

      // Écrire les données audio dans un fichier
      final file = File(filePath);
      await file.writeAsBytes(audioBytes);

      // Jouer l'audio
      await _audioPlayer.play(DeviceFileSource(filePath));

      // Attendre que l'audio se termine
      await _audioPlayer.onPlayerComplete.first;

      // Supprimer le fichier temporaire
      if (await file.exists()) {
        await file.delete();
      }
      
      _isSpeaking = false;
    } catch (e) {
      print('Erreur de lecture audio natif: $e');
      _isSpeaking = false;
    }
  }

  Future<bool> stopSpeaking({bool andDisable = false}) async {
    if (andDisable) {
      isTtsEnabled = false;
    }

    if (_isSpeaking) {
      if (kIsWeb) {
        try {
          stopWebAudio();
        } catch (e) {
          print('Erreur lors de l\'arrêt de la lecture web: $e');
        }
      } else {
        await _audioPlayer.stop();
      }
      _isSpeaking = false;
      return true;
    }
    return false;
  }

  bool toggleTts() {
    isTtsEnabled = !isTtsEnabled;
    if (!isTtsEnabled && _isSpeaking) {
      stopSpeaking();
    }
    return isTtsEnabled;
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Vérifier si la reconnaissance vocale est disponible
      bool available = await _speechToText.initialize(
        onError: (error) => print("Error STT: $error"),
        debugLogging: true,
      );

      if (available) {
        await _speechToText.listen(
          onResult: (result) {
            final recognizedWords = result.recognizedWords;
            if (recognizedWords.isNotEmpty) {
              onResult(recognizedWords);
            }
          },
          listenFor: Duration(seconds: 60), // Écouter plus longtemps
          pauseFor: Duration(seconds: 3),
          partialResults: true,
          localeId: 'fr_FR',
          cancelOnError: false, // Ne pas annuler en cas d'erreur
          listenMode: stt.ListenMode.dictation, // Mode dictée pour une reconnaissance continue
        );
      } else {
        print("La reconnaissance vocale n'est pas disponible sur cet appareil");
        onResult("La reconnaissance vocale n'est pas disponible");
      }
    } catch (e) {
      print("Erreur lors du démarrage de la reconnaissance vocale: $e");
      onResult("Erreur de reconnaissance vocale");
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}