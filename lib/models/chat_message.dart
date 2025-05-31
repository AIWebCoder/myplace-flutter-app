import 'package:flutter/material.dart';
import 'content_recommendation.dart';

enum MessageRole { user, assistant }

class ChatMessage {
  final String content;
  final MessageRole role;
  final bool isProcessing;
  final List<ContentRecommendation> recommendations;

  ChatMessage({
    required this.content,
    required this.role,
    this.isProcessing = false,
    this.recommendations = const [],
  });

  // Factory constructor pour créer un message avec des recommandations
  factory ChatMessage.withRecommendations(
    String content,
    List<ContentRecommendation> recommendations,
  ) {
    return ChatMessage(
      content: content,
      role: MessageRole.assistant,
      recommendations: recommendations,
    );
  }
}
