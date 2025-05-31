import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:x_place/utils/const.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:math';

class Intelligenceatrificial2Screen extends StatefulWidget {
  const Intelligenceatrificial2Screen({super.key});

  @override
  State<Intelligenceatrificial2Screen> createState() =>
      _Intelligenceatrificial2ScreenState();
}

class _Intelligenceatrificial2ScreenState
    extends State<Intelligenceatrificial2Screen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  final List<double> _simulatedSpectrumData = List.filled(8, 0.0);

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
                        if (isActive)
                          ...List.generate(5, (index) {
                            return BoomCircle(
                              size: 70 + (index * 10),
                              color: chatProvider.isListening ? Colors.blue : Colors.green,
                              intensity: _simulatedSpectrumData[index % _simulatedSpectrumData.length],
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
                                ? scale * (0.95 + _getAverageAmplitude() * 0.15) 
                                : scale;
                                
                            return Transform.scale(
                              scale: boomScale,
                              child: Lottie.asset(
                                'assets/lottie/avatar.json',
                                height: 80,
                                width: 80,
                                fit: BoxFit.contain,
                                animate: true,
                              ),
                            );
                          },
                        ),
                        if (isActive)
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (chatProvider.isListening ? Colors.blue : Colors.green)
                                      .withOpacity(_getAverageAmplitude() * 0.4),
                                  blurRadius: 20 * _getAverageAmplitude(),
                                  spreadRadius: 5 * _getAverageAmplitude(),
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
                  
                  if (messages.isNotEmpty) {
                    _scrollToBottom();
                  }
                  
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
          if (!isUser && message.recommendations.isNotEmpty)
            Container(
              height: 200,
              margin: EdgeInsets.only(bottom: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: message.recommendations.length,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemBuilder: (context, index) {
                  final recommendation = message.recommendations[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildImprovedRecommendationCard(recommendation),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildImprovedRecommendationCard(recommendation) {
    return Container(
      width: 220,
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
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  color: Colors.grey[900],
                  child: Center(
                    child: Icon(
                      recommendation.type == 'film' ? Icons.movie : Icons.tv,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recommendation.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (recommendation.year.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          recommendation.year,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text(
                          recommendation.rating > 0 
                            ? recommendation.rating.toString()
                            : "N/A",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
