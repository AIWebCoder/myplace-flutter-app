import 'dart:convert';

class WebAudioHelper {
  static Future<void> playAudioOnWeb(List<int> audioBytes) async {
    try {
      // Cette méthode est un stub qui sera remplacée par l'implémentation réelle
      // sur le web via JS interop
      print('Tentative de lecture audio sur le web (mode développement)');
      await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      print('Erreur WebAudioHelper: $e');
    }
  }
  
  static Future<void> stopAudio() async {
    // Stub pour arrêter l'audio
  }
  
  static String bytesToBase64(List<int> bytes) {
    return base64Encode(bytes);
  }
}
