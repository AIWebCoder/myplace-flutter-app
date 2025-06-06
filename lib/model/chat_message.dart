import 'package:flutter/material.dart';
import 'content_recommendation.dart';
import 'post_model.dart';

enum MessageRole { user, assistant }

class ChatMessage {
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isProcessing;
  final List<Post> recommendedPosts;

  ChatMessage({
    required this.content,
    required this.role,
    DateTime? timestamp,
    this.isProcessing = false,
    this.recommendedPosts = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  // Getter pour compatibilité avec l'ancien code (deprecated)
  List<dynamic> get recommendedVideos => [];
  
  // Getter pour les anciennes recommendations (fallback vide)
  List<ContentRecommendation> get recommendations => [];
}
