// lib/services/web_audio_player.dart
import 'dart:js' as js;

void playAudioBase64(String base64Data) {
  js.context.callMethod('playAudioBase64', [base64Data]);
}

void stopWebAudio() {
  js.context.callMethod('stop', []);
}
