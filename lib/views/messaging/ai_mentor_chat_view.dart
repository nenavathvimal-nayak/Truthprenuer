import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';

class MockAIMessage {
  final String id;
  final String text;
  final bool isMine;

  MockAIMessage({required this.id, required this.text, required this.isMine});
}

class AIMentorChatView extends ConsumerStatefulWidget {
  const AIMentorChatView({super.key});

  @override
  ConsumerState<AIMentorChatView> createState() => _AIMentorChatViewState();
}

class _AIMentorChatViewState extends ConsumerState<AIMentorChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<MockAIMessage> _messages = [
    MockAIMessage(id: "1", text: "Hi! I'm your AI Co-Founder. I've reviewed your latest validation metrics. How can I help you make your next decision?", isMine: false),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    HapticManager.shared.impactLight();
    
    setState(() {
      _messages.add(MockAIMessage(id: DateTime.now().millisecondsSinceEpoch.toString(), text: text, isMine: true));
    });
    
    _controller.clear();
    _scrollToBottom();

    // Mock AI Response
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isTyping = true);
      _scrollToBottom();
      
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add(MockAIMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: _generateMockAIResponse(text),
              isMine: false,
            ));
          });
          _scrollToBottom();
        }
      });
    });
  }

  String _generateMockAIResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains("pricing")) {
      return "Based on your recent validation data, 3 out of 5 users indicated they would pay \$49/mo, but hesitated at \$99/mo. I recommend launching a pricing experiment targeting the \$49/mo tier.";
    } else if (lower.contains("pivot")) {
      return "A pivot is a major decision. Before pivoting, ensure you have exhausted all acquisition channels for the current model. Have you tried cold outbound to mid-market yet?";
    } else {
      return "That's an interesting point. To make a confident decision, we need more evidence. Try creating a new validation request focusing on that specific assumption.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            HapticManager.shared.impactLight();
            Navigator.pop(context);
          },
          child: Text("Close", style: AppTypography.body.copyWith(color: colors.text)),
        ),
        leadingWidth: 80,
        title: Text("AI Co-Founder", style: AppTypography.headline.copyWith(color: colors.text)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome, color: colors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const _TypingIndicatorView();
                }
                final message = _messages[index];
                return _AIChatBubbleView(message: message);
              },
            ),
          ),
          Container(height: 1, color: colors.divider),
          
          // Input Bar
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.cardBackgroundLight,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: AppTypography.body.copyWith(color: colors.text),
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Ask AI Co-Founder...",
                          hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _controller.text.isEmpty ? colors.cardBackgroundLight : colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _controller.text.isEmpty ? Icons.mic : Icons.send,
                        color: _controller.text.isEmpty ? colors.textSecondary : Colors.white,
                        size: 18,
                      ),
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
}

class _AIChatBubbleView extends StatefulWidget {
  final MockAIMessage message;

  const _AIChatBubbleView({required this.message});

  @override
  State<_AIChatBubbleView> createState() => _AIChatBubbleViewState();
}

class _AIChatBubbleViewState extends State<_AIChatBubbleView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return ScaleTransition(
      scale: _animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
        child: Row(
          mainAxisAlignment: widget.message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.message.isMine) ...[
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: colors.primary, size: 14),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
                decoration: BoxDecoration(
                  color: widget.message.isMine ? colors.primary : colors.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomLeft: widget.message.isMine ? const Radius.circular(18) : const Radius.circular(6),
                    bottomRight: widget.message.isMine ? const Radius.circular(6) : const Radius.circular(18),
                  ),
                  boxShadow: widget.message.isMine ? [
                    BoxShadow(color: colors.primary.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2)),
                  ] : null,
                ),
                child: Text(
                  widget.message.text,
                  style: AppTypography.body.copyWith(color: widget.message.isMine ? Colors.white : colors.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicatorView extends StatefulWidget {
  const _TypingIndicatorView();

  @override
  State<_TypingIndicatorView> createState() => _TypingIndicatorViewState();
}

class _TypingIndicatorViewState extends State<_TypingIndicatorView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.cardBackgroundLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    var t = (_controller.value - delay);
                    if (t < 0) t += 1.0;
                    
                    double scale = 0.8;
                    double opacity = 0.4;
                    
                    if (t < 0.4) {
                      scale = 0.8 + (t / 0.4) * 0.4;
                      opacity = 0.4 + (t / 0.4) * 0.6;
                    } else if (t < 0.8) {
                      scale = 1.2 - ((t - 0.4) / 0.4) * 0.4;
                      opacity = 1.0 - ((t - 0.4) / 0.4) * 0.6;
                    }
                    
                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8, height: 8,
                          decoration: BoxDecoration(color: colors.textSecondary, shape: BoxShape.circle),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
