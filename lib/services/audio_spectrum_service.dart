import 'dart:math';
import 'package:flutter/foundation.dart';

class AudioSpectrumService extends ChangeNotifier {
  // Données simulées du spectre audio (à remplacer par de véritables données dans une implémentation réelle)
  List<double> _spectrumData = List.generate(10, (_) => 0.0);
  
  // Amplitude moyenne du spectre
  double _amplitudeAverage = 0.0;
  
  // État d'activité
  bool _isActive = false;
  
  // Getters
  List<double> get spectrumData => _spectrumData;
  double get amplitudeAverage => _amplitudeAverage;
  bool get isActive => _isActive;
  
  // Méthode pour démarrer l'analyse
  void startAnalysis({bool isSpeaking = false}) {
    _isActive = true;
    
    // Dans une implémentation réelle, nous connecterions ici à l'API WebAudio
    // ou à un autre analyseur de spectre natif
    // Pour ce prototype, nous simulons des données
    _startSimulation(isSpeaking);
    notifyListeners();
  }
  
  // Méthode pour arrêter l'analyse
  void stopAnalysis() {
    _isActive = false;
    
    // Réinitialiser les données du spectre
    _spectrumData = List.generate(10, (_) => 0.0);
    _amplitudeAverage = 0.0;
    notifyListeners();
  }
  
  // Méthode pour simuler des données de spectre audio
  // Dans une vraie implémentation, cette méthode serait remplacée par une analyse réelle
  void _startSimulation(bool isSpeaking) {
    Future.delayed(Duration(milliseconds: 50), () {
      if (!_isActive) return;
      
      final random = Random();
      
      // Simuler différents modèles pour l'écoute et la parole
      if (isSpeaking) {
        // Pour la parole, des oscillations plus régulières et rythmiques
        const base = 0.3;
        double sum = 0;
        for (int i = 0; i < _spectrumData.length; i++) {
          // Créer une forme d'onde qui varie en fonction du temps et de l'index
          double time = DateTime.now().millisecondsSinceEpoch / 200;
          double variation = sin(time + i * 0.5) * 0.5 + 0.5;
          
          // Ajouter du bruit aléatoire pour plus de naturel
          double noise = random.nextDouble() * 0.2;
          
          // Calculer l'amplitude finale
          _spectrumData[i] = base + (variation * 0.5) + noise;
          
          // L'intensité est plus forte au milieu du spectre pour simuler la voix humaine
          if (i > 2 && i < 8) {
            _spectrumData[i] *= 1.3;
          }
          
          sum += _spectrumData[i];
        }
        _amplitudeAverage = sum / _spectrumData.length;
      } else {
        // Pour l'écoute, des pics plus aléatoires et des oscillations plus nettes
        const base = 0.2;
        double sum = 0;
        for (int i = 0; i < _spectrumData.length; i++) {
          // Plus de randomisation avec occasionnellement des pics plus forts
          double spike = random.nextDouble() < 0.1 ? random.nextDouble() * 0.7 : 0.0;
          
          // Variation temporelle plus rapide
          double time = DateTime.now().millisecondsSinceEpoch / 150;
          double variation = sin(time + i * 0.8) * 0.4 + 0.4;
          
          // Amplitude finale
          _spectrumData[i] = base + variation + spike;
          
          sum += _spectrumData[i];
        }
        _amplitudeAverage = sum / _spectrumData.length;
      }
      
      notifyListeners();
      
      // Continuer la simulation tant que le service est actif
      _startSimulation(isSpeaking);
    });
  }
}
