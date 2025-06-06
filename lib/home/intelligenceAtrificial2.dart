// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:x_place/home/videoPage.dart';
import '../utils/const.dart';
import '../providers/chat_provider.dart';
import '../model/chat_message.dart';
import 'dart:math';

class Intelligenceatrificial2Screen extends StatefulWidget {
  const Intelligenceatrificial2Screen({super.key});

  @override
  State<Intelligenceatrificial2Screen> createState() =>
      _Intelligenceatrificial2ScreenState();
}

class _Intelligenceatrificial2ScreenState extends State<Intelligenceatrificial2Screen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  final List<double> _simulatedSpectrumData = List.filled(8, 0.0);
  
  // Amplitude constante pour le TTS
  final double _constantAmplitude = 0.7;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _startSpectrumSimulation();
  }

  void _startSpectrumSimulation() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        final random = Random();
        for (int i = 0; i < _simulatedSpectrumData.length; i++) {
          _simulatedSpectrumData[i] = random.nextDouble() * 0.8 + 0.2;
        }
      });

      _startSpectrumSimulation();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0f0f0f), Color(0xff2b2b2b)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: whiteColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  child: Lottie.asset(
                    'assets/lottie/avatar.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Myla",
                          style: TextStyle(color: whiteColor, fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.verified, color: Colors.blue, size: 16),
                      ],
                    ),
                    Consumer<ChatProvider>(
                      builder: (context, chatProvider, _) {
                        return Text(
                          chatProvider.isListening 
                              ? "Écoute..." 
                              : chatProvider.isSpeaking 
                                  ? "Parle..." 
                                  : "En ligne",
                          style: TextStyle(
                            color: Colors.grey, 
                            fontSize: 12,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  final isTtsEnabled = chatProvider.speechService.isTtsEnabled;
                  return IconButton(
                    icon: Icon(
                      isTtsEnabled ? Icons.volume_up : Icons.volume_off,
                      color: isTtsEnabled ? primaryColor : Colors.grey,
                    ),
                    onPressed: () {
                      chatProvider.speechService.toggleTts();
                      setState(() {});
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: whiteColor),
                tooltip: 'Nouvelle conversation',
                onPressed: () {
                  final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                  chatProvider.clearChat();
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Center(
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, _) {
                    final isActive = chatProvider.isListening || chatProvider.isSpeaking;
                    
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cercles boom avec intensité constante pendant TTS
                        if (isActive)
                          ...List.generate(5, (index) {
                            return BoomCircle(
                              size: 70 + (index * 10),
                              color: chatProvider.isSpeaking ? Colors.green : Colors.blue,
                              intensity: chatProvider.isSpeaking 
                                  ? _constantAmplitude
                                  : _simulatedSpectrumData[index % _simulatedSpectrumData.length],
                              delay: index * 100,
                            );
                          }),
                        TweenAnimationBuilder(
                          tween: Tween<double>(
                            begin: 1.0, 
                            end: isActive ? 1.1 : 1.0,
                          ),
                          duration: Duration(milliseconds: 300),
                          builder: (context, double scale, child) {
                            final boomScale = isActive 
                                ? scale * (0.95 + (chatProvider.isSpeaking 
                                    ? _constantAmplitude * 0.15
                                    : _getAverageAmplitude() * 0.15))
                                : scale;
                                
                            return Transform.scale(
                              scale: boomScale,
                              child: ColorFiltered(
                                colorFilter: chatProvider.isSpeaking
                                    ? ColorFilter.mode(
                                        Colors.green,
                                        BlendMode.modulate,
                                      )
                                    : isActive
                                        ? ColorFilter.mode(
                                            Colors.blue,
                                            BlendMode.modulate,
                                          )
                                        : ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.modulate,
                                          ),
                                child: Lottie.asset(
                                  'assets/lottie/avatar.json',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.contain,
                                  animate: true,
                                ),
                              ),
                            );
                          },
                        ),
                        // Glow effect vert constant pendant TTS
                        if (isActive)
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (chatProvider.isSpeaking ? Colors.green : Colors.blue)
                                      .withOpacity(chatProvider.isSpeaking 
                                          ? _constantAmplitude * 0.5
                                          : _getAverageAmplitude() * 0.4),
                                  blurRadius: chatProvider.isSpeaking 
                                      ? 20 * _constantAmplitude
                                      : 20 * _getAverageAmplitude(),
                                  spreadRadius: chatProvider.isSpeaking 
                                      ? 5 * _constantAmplitude
                                      : 5 * _getAverageAmplitude(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  final messages = chatProvider.messages;
                  
                  return messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Appuyez sur le microphone ou posez une question',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: whiteColor, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          return _buildImprovedMessageItem(messages[index], index);
                        },
                      );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: _buildImprovedMessageInput(),
            ),
          ],
        ),
      ),
    );
  }

  double _getAverageAmplitude() {
    if (_simulatedSpectrumData.isEmpty) return 0.5;
    return _simulatedSpectrumData.reduce((a, b) => a + b) / _simulatedSpectrumData.length;
  }

  Widget _buildImprovedMessageItem(ChatMessage message, int index) {
    final isUser = message.role == MessageRole.user;
    final time = DateTime.now().subtract(Duration(minutes: index * 2));
    final timeString = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? Colors.grey[800] : primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: message.isProcessing
              ? Container(
                  height: 24,
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => 
                      Container(
                        margin: EdgeInsets.all(2),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isUser
                            ? Colors.white.withOpacity(0.6 + (i * 0.2))
                            : Colors.white.withOpacity(0.6 + (i * 0.2)),
                          shape: BoxShape.circle,
                        ),
                      )
                    ),
                  ),
                )
              : isUser
                ? Text(
                    message.content,
                    style: TextStyle(color: Colors.white),
                  )
                : MarkdownBody(
                    data: message.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: Colors.white),
                      h1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      h2: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      h3: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      em: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                      strong: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      blockquote: TextStyle(color: Colors.grey[300], fontStyle: FontStyle.italic),
                      code: TextStyle(color: Colors.amber[300], fontFamily: 'monospace'),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 2, 
              left: isUser ? 0 : 5,
              right: isUser ? 5 : 0,
              bottom: 8,
            ),
            child: Text(
              timeString,
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ),
          // Posts recommandés (système RAG) avec redirection vers VideoDetailScreen
          if (!isUser && message.recommendedPosts.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
                    child: Text(
                      'Contenu recommandé:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: message.recommendedPosts.length,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemBuilder: (context, index) {
                        final post = message.recommendedPosts[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              // Redirection vers VideoPage avec le post
                              // Navigator.push( context, MaterialPageRoute( builder: (context) => VideoDetailScreen()));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoDetailScreen(
                                    post: post, // Passer le post sélectionné
                                  ),
                                ),
                              );
                            },
                            child: _buildPostRecommendationCard(post),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostRecommendationCard(post) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Thumbnail du post
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                  ),
                  child: post.primaryThumbnail != null
                    ? Image.network(
                        post.primaryThumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: Icon(
                              post.primaryMediaType == 'video' ? Icons.play_circle_filled : Icons.image,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: Icon(
                          post.primaryMediaType == 'video' ? Icons.play_circle_filled : Icons.image,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                ),
                // Badge du type de contenu
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: post.primaryMediaType == 'video' ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      post.primaryMediaType == 'video' ? 'VIDÉO' : 'IMAGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Badge premium si le contenu est payant
                if (post.isPaidContent)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Badge qualité si thumbnail du post disponible

                if (post.thumbnail != null && post.thumbnail!.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'HD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Overlay play button pour les vidéos
                if (post.primaryMediaType == 'video')
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Contenu du post
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du post
                  Text(
                    post.displayText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Informations supplémentaires
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prix ou gratuit
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: post.isPaidContent ? Colors.amber.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          post.isPaidContent ? '${post.price}€' : 'GRATUIT',
                          style: TextStyle(
                            color: post.isPaidContent ? Colors.amber : Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Indicateur featured
                      if (post.isFeatured)
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Nombre d'attachments
                  Text(
                    '${post.attachments.length} fichier${post.attachments.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovedMessageInput() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final isListening = chatProvider.isListening;
        
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              TextField(
                controller: _textController,
                style: TextStyle(color: whiteColor),
                decoration: InputDecoration(
                  hintText: isListening 
                      ? "Je vous écoute..."
                      : "Tapez un message...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 4,
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    chatProvider.sendMessage(text);
                    _textController.clear();
                  }
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isListening) {
                        chatProvider.stopListening();
                      } else {
                        chatProvider.startListening();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isListening ? Colors.red : Colors.grey[700]!,
                        ),
                      ),
                      child: Icon(
                        isListening ? Icons.mic_off : Icons.mic,
                        color: isListening ? Colors.red : whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_textController.text.trim().isNotEmpty) {
                        chatProvider.sendMessage(_textController.text);
                        _textController.clear();
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [secondaryColor, primaryColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class BoomCircle extends StatefulWidget {
  final double size;
  final Color color;
  final double intensity;
  final int delay;
  
  const BoomCircle({super.key, 
    required this.size, 
    required this.color,
    this.intensity = 1.0,
    this.delay = 0,
  });

  @override
  _BoomCircleState createState() => _BoomCircleState();
}

class _BoomCircleState extends State<BoomCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    
    _animation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final effectiveScale = _animation.value * widget.intensity;
        
        return Opacity(
          opacity: (1.0 - _animation.value) * widget.intensity * 0.3,
          child: Container(
            width: widget.size * effectiveScale,
            height: widget.size * effectiveScale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.color.withOpacity(0.7),
                width: 2.0 * widget.intensity,
              ),
            ),
          ),
        );
      },
    );
  }
}
