import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class ChatRoomView extends ConsumerStatefulWidget {
  final Conversation conversation;
  final User otherUser;

  const ChatRoomView({
    super.key,
    required this.conversation,
    required this.otherUser,
  });

  @override
  ConsumerState<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends ConsumerState<ChatRoomView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  ChatMessage? _replyingTo;

  Timer? _initTimer;
  Timer? _initSubTimer;
  Timer? _replyTypingTimer;
  Timer? _replyTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      ref.read(mockDataStoreProvider).markConversationAsRead(widget.conversation.id);

      // Natural typing simulation on room entry if unread messages existed
      if (widget.conversation.unreadCount > 0) {
        _initTimer = Timer(const Duration(milliseconds: 1200), () {
          if (mounted) {
            setState(() => _isTyping = true);
            _initSubTimer = Timer(const Duration(milliseconds: 2000), () {
              if (mounted) setState(() => _isTyping = false);
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _initTimer?.cancel();
    _initSubTimer?.cancel();
    _replyTypingTimer?.cancel();
    _replyTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage({
    String? attachmentType,
    String? attachmentUrl,
    String? attachmentTitle,
    String? attachmentSubtitle,
  }) {
    final text = _controller.text.trim();
    if (text.isEmpty && attachmentType == null) return;

    HapticManager.shared.impactLight();

    ref.read(mockDataStoreProvider).sendMessage(
          widget.conversation.id,
          text,
          attachmentType: attachmentType,
          attachmentUrl: attachmentUrl,
          attachmentTitle: attachmentTitle,
          attachmentSubtitle: attachmentSubtitle,
          replyToText: _replyingTo?.text,
          replyToAuthor: _replyingTo != null
              ? (_replyingTo!.senderId == (ref.read(mockDataStoreProvider).currentUser?.id ?? "me")
                  ? "You"
                  : widget.otherUser.name)
              : null,
        );

    _controller.clear();
    setState(() => _replyingTo = null);
    _scrollToBottom();

    // Auto-reply simulation based on participant role
    _replyTypingTimer?.cancel();
    _replyTimer?.cancel();
    _replyTypingTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isTyping = true);
      _scrollToBottom();

      _replyTimer = Timer(const Duration(milliseconds: 2200), () {
        if (mounted) {
          setState(() => _isTyping = false);
          List<String> replies;
          if (widget.otherUser.id == "ai_mentor") {
            replies = [
              "Based on your recent validation metrics, I recommend running a pricing survey with 5 targeted beta users 💡.",
              "Looking at your startup health score (82/100), your Problem-Space validation is strong, but Go-To-Market distribution needs early experimentation.",
              "Great question! Focus on validating willingness-to-pay before building complex custom features. Have you collected pre-orders or intent letters?",
              "Analyzing founder feedback: 4 out of 5 validators asked for the core collaboration workflow. I suggest prioritizing that in your MVP roadmap 🚀.",
              "I'm continuously monitoring your validation progress. Let's draft your next structured feedback questions together!"
            ];
          } else if (widget.otherUser.role.toLowerCase().contains("investor")) {
            replies = [
              "Impressive traction on the validation score. Send over the deck and your target cap table 📈.",
              "What is your customer acquisition hypothesis for Q4? Let's discuss on our next sync.",
              "Thanks for the update! The unit economics look promising at this stage."
            ];
          } else {
            replies = [
              "That makes complete sense! 💡",
              "100% aligned on this approach.",
              "Would love to test this prototype when you deploy it!",
              "Thanks for sharing, this is super actionable 🙏",
              "Let's set up a quick 15-min sync to walk through this!"
            ];
          }

          final store = ref.read(mockDataStoreProvider);
          final replyText = (replies.toList()..shuffle()).first;
          store.messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: widget.conversation.id,
            senderId: widget.otherUser.id,
            text: replyText,
            sentAt: DateTime.now(),
            isRead: false,
          ));
          store.conversations.firstWhere((c) => c.id == widget.conversation.id).lastMessage = replyText;
          store.conversations.firstWhere((c) => c.id == widget.conversation.id).lastMessageTime = DateTime.now();
          setState(() {});
          _scrollToBottom();
        }
      });
    });
  }

  void _showAttachmentOptions() {
    HapticManager.shared.impactLight();
    final colors = Theme.of(context).appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.textTertiary.withAlpha(80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  "Share with ${widget.otherUser.name.split(' ').first}",
                  style: AppTypography.headline.copyWith(color: colors.text),
                ),
                const SizedBox(height: AppSpacing.md),
                _AttachmentOptionTile(
                  icon: Icons.picture_as_pdf_rounded,
                  iconColor: Colors.redAccent,
                  title: "Startup Pitch Deck",
                  subtitle: "Truthprenuer_Seed_Deck_v2.pdf (12 slides • 4.2 MB)",
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendMessage(
                      attachmentType: "pitch_deck",
                      attachmentTitle: "Truthprenuer_Seed_Deck_v2.pdf",
                      attachmentSubtitle: "12 slides • 4.2 MB",
                    );
                  },
                ),
                _AttachmentOptionTile(
                  icon: Icons.rocket_launch_rounded,
                  iconColor: colors.primary,
                  title: "Active Validation Project",
                  subtitle: "Truthprenuer — Automated Startup Validation (Idea Stage)",
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendMessage(
                      attachmentType: "validation",
                      attachmentTitle: "Truthprenuer — Automated Startup Validation",
                      attachmentSubtitle: "Health Score: 82/100 • 14 Validators",
                    );
                  },
                ),
                _AttachmentOptionTile(
                  icon: Icons.image_rounded,
                  iconColor: Colors.blueAccent,
                  title: "Prototype Screenshot",
                  subtitle: "Truthprenuer_UI_Mockup_v3.png (High Resolution)",
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendMessage(
                      attachmentType: "image",
                      attachmentTitle: "Truthprenuer_UI_Mockup_v3.png",
                      attachmentSubtitle: "1240 × 2800 • Prototype Preview",
                    );
                  },
                ),
                _AttachmentOptionTile(
                  icon: Icons.mic_rounded,
                  iconColor: Colors.purpleAccent,
                  title: "Voice Memo Note",
                  subtitle: "Quick founder audio summary (0:45)",
                  onTap: () {
                    Navigator.pop(ctx);
                    _sendMessage(
                      attachmentType: "audio",
                      attachmentTitle: "Founder Audio Memo (0:45)",
                      attachmentSubtitle: "Recorded just now • 44.1 kHz",
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCallSimulation() {
    HapticManager.shared.impactMedium();
    final colors = Theme.of(context).appColors;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(AppSpacing.xl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarView(name: widget.otherUser.name, imageURL: widget.otherUser.avatarURL, size: 72),
            const SizedBox(height: AppSpacing.md),
            Text(widget.otherUser.name, style: AppTypography.title2.copyWith(color: colors.text)),
            const SizedBox(height: 4),
            Text("Calling Founder Network Audio...", style: AppTypography.caption1.copyWith(color: colors.primary)),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colors.surfaceElevated,
                  child: Icon(Icons.mic_off_rounded, color: colors.textSecondary),
                ),
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colors.surfaceElevated,
                  child: Icon(Icons.volume_up_rounded, color: colors.textSecondary),
                ),
                GestureDetector(
                  onTap: () {
                    HapticManager.shared.impactMedium();
                    Navigator.pop(ctx);
                  },
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.call_end_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final messages = dataStore.messages.where((m) => m.conversationId == widget.conversation.id).toList();
    final myId = dataStore.currentUser?.id ?? "me";

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.text, size: 28),
          onPressed: () {
            HapticManager.shared.impactLight();
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            HapticManager.shared.impactLight();
            context.push('/user-profile', extra: {'user': widget.otherUser});
          },
          child: Row(
            children: [
              Stack(
                children: [
                  AvatarView(name: widget.otherUser.name, imageURL: widget.otherUser.avatarURL, size: 38),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.background, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.otherUser.name,
                      style: AppTypography.headline.copyWith(color: colors.text),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _isTyping ? "typing... ✍️" : "Active now • ${widget.otherUser.role}",
                      style: AppTypography.caption2.copyWith(
                        color: _isTyping ? colors.primary : colors.textSecondary,
                        fontWeight: _isTyping ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_rounded, color: colors.text, size: 22),
            onPressed: _showCallSimulation,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: colors.text),
            color: colors.cardBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (val) {
              HapticManager.shared.impactLight();
              if (val == 'profile') {
                context.push('/user-profile', extra: {'user': widget.otherUser});
              } else if (val == 'pin') {
                ref.read(mockDataStoreProvider).togglePinConversation(widget.conversation.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget.conversation.isPinned ? "Conversation unpinned" : "Conversation pinned"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (val == 'mute') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notifications muted for 8 hours"), duration: Duration(seconds: 2)),
                );
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 18, color: colors.text),
                    const SizedBox(width: 8),
                    Text("View Profile", style: AppTypography.body.copyWith(color: colors.text)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'pin',
                child: Row(
                  children: [
                    Icon(widget.conversation.isPinned ? Icons.push_pin_outlined : Icons.push_pin, size: 18, color: colors.text),
                    const SizedBox(width: 8),
                    Text(widget.conversation.isPinned ? "Unpin Chat" : "Pin Chat", style: AppTypography.body.copyWith(color: colors.text)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 18, color: colors.text),
                    const SizedBox(width: 8),
                    Text("Mute Notifications", style: AppTypography.body.copyWith(color: colors.text)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return _TypingIndicatorView(
                    userName: widget.otherUser.name.split(' ').first,
                    avatarUrl: widget.otherUser.avatarURL,
                  );
                }

                final message = messages[index];
                final isMine = message.senderId == myId;

                // Check if date separator is needed
                bool showDateSeparator = false;
                if (index == 0) {
                  showDateSeparator = true;
                } else {
                  final prevMessage = messages[index - 1];
                  final sameDay = message.sentAt.year == prevMessage.sentAt.year &&
                      message.sentAt.month == prevMessage.sentAt.month &&
                      message.sentAt.day == prevMessage.sentAt.day;
                  if (!sameDay) showDateSeparator = true;
                }

                return Column(
                  children: [
                    if (showDateSeparator) _DateSeparatorView(date: message.sentAt),
                    _ChatBubbleView(
                      message: message,
                      isMine: isMine,
                      senderName: widget.otherUser.name,
                      onReply: () {
                        setState(() => _replyingTo = message);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Container(height: 1, color: colors.divider),

          // Replying-to Preview Bar
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: colors.surfaceElevated,
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Replying to ${_replyingTo!.senderId == myId ? "yourself" : widget.otherUser.name.split(' ').first}",
                          style: AppTypography.caption1.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _replyingTo!.text.isNotEmpty ? _replyingTo!.text : (_replyingTo!.attachmentTitle ?? "Attachment"),
                          style: AppTypography.caption2.copyWith(color: colors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: colors.textSecondary),
                    onPressed: () => setState(() => _replyingTo = null),
                  ),
                ],
              ),
            ),

          // Input Bar
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SafeArea(
              child: Row(
                children: [
                  // Attachment (+) Button
                  GestureDetector(
                    onTap: _showAttachmentOptions,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colors.cardBackgroundLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_rounded, color: colors.textSecondary, size: 22),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Message Text Field
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
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "Message ${widget.otherUser.name.split(' ').first}...",
                          hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Send / Mic Action Button
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isEmpty) {
                        // Quick Voice Note action
                        _sendMessage(
                          attachmentType: "audio",
                          attachmentTitle: "Quick Audio Note (0:15)",
                          attachmentSubtitle: "Recorded just now",
                        );
                      } else {
                        _sendMessage();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _controller.text.trim().isEmpty ? colors.cardBackgroundLight : colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: _controller.text.trim().isNotEmpty
                            ? [
                                BoxShadow(
                                  color: colors.primary.withAlpha(80),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        _controller.text.trim().isEmpty ? Icons.mic_rounded : Icons.send_rounded,
                        color: _controller.text.trim().isEmpty ? colors.textSecondary : Colors.white,
                        size: 19,
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

class _AttachmentOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AttachmentOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: AppTypography.headline.copyWith(color: colors.text)),
      subtitle: Text(subtitle, style: AppTypography.caption1.copyWith(color: colors.textSecondary)),
      onTap: onTap,
    );
  }
}

class _DateSeparatorView extends StatelessWidget {
  final DateTime date;
  const _DateSeparatorView({required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final now = DateTime.now();
    String text;

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      text = "Today";
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      text = "Yesterday";
    } else {
      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      text = "${months[date.month - 1]} ${date.day}, ${date.year}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
          decoration: BoxDecoration(
            color: colors.cardBackgroundLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: AppTypography.caption2.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _ChatBubbleView extends ConsumerStatefulWidget {
  final ChatMessage message;
  final bool isMine;
  final String senderName;
  final VoidCallback onReply;

  const _ChatBubbleView({
    required this.message,
    required this.isMine,
    required this.senderName,
    required this.onReply,
  });

  @override
  ConsumerState<_ChatBubbleView> createState() => _ChatBubbleViewState();
}

class _ChatBubbleViewState extends ConsumerState<_ChatBubbleView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showContextMenu(BuildContext context) {
    HapticManager.shared.impactMedium();
    final colors = Theme.of(context).appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Reaction Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.cardBackgroundLight,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ["❤️", "🔥", "🚀", "💡", "👍", "👏"].map((emoji) {
                      final isSelected = widget.message.reaction == emoji;
                      return GestureDetector(
                        onTap: () {
                          HapticManager.shared.impactLight();
                          ref.read(mockDataStoreProvider).reactToMessage(widget.message.id, emoji);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary.withAlpha(40) : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(emoji, style: const TextStyle(fontSize: 26)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Context Options
                ListTile(
                  leading: Icon(Icons.reply_rounded, color: colors.text),
                  title: Text("Reply", style: AppTypography.body.copyWith(color: colors.text)),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.onReply();
                  },
                ),
                if (widget.message.text.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.copy_rounded, color: colors.text),
                    title: Text("Copy Message", style: AppTypography.body.copyWith(color: colors.text)),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.message.text));
                      HapticManager.shared.impactLight();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Message copied to clipboard"), duration: Duration(seconds: 2)),
                      );
                    },
                  ),
                if (widget.isMine)
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    title: Text("Delete Message", style: AppTypography.body.copyWith(color: Colors.redAccent)),
                    onTap: () {
                      HapticManager.shared.impactMedium();
                      ref.read(mockDataStoreProvider).deleteMessage(widget.message.id);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final diff = DateTime.now().difference(widget.message.sentAt);
    String timeDisplay = "just now";
    if (diff.inMinutes > 0 && diff.inHours == 0) timeDisplay = "${diff.inMinutes}m ago";
    if (diff.inHours > 0 && diff.inDays == 0) timeDisplay = "${diff.inHours}h ago";
    if (diff.inDays > 0) timeDisplay = "${diff.inDays}d ago";

    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 3),
          child: Row(
            mainAxisAlignment: widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.isMine) ...[
                AvatarView(name: widget.senderName, imageURL: null, size: 28),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm + 2,
                          ),
                          decoration: BoxDecoration(
                            color: widget.isMine ? colors.primary : colors.cardBackgroundLight,
                            borderRadius: BorderRadius.circular(18).copyWith(
                              bottomLeft: widget.isMine ? const Radius.circular(18) : const Radius.circular(4),
                              bottomRight: widget.isMine ? const Radius.circular(4) : const Radius.circular(18),
                            ),
                            boxShadow: widget.isMine
                                ? [
                                    BoxShadow(
                                      color: colors.primary.withAlpha(50),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              // Reply Quote Bubble
                              if (widget.message.replyToText != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: widget.isMine
                                        ? Colors.black.withAlpha(35)
                                        : colors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 2,
                                        height: 24,
                                        color: widget.isMine ? Colors.white70 : colors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.message.replyToAuthor ?? "Original Message",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: widget.isMine ? Colors.white70 : colors.primary,
                                              ),
                                            ),
                                            Text(
                                              widget.message.replyToText!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: widget.isMine ? Colors.white60 : colors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Rich Attachment Card
                              if (widget.message.attachmentType != null) ...[
                                _buildAttachmentCard(context, colors),
                                if (widget.message.text.isNotEmpty) const SizedBox(height: 6),
                              ],

                              // Main Message Text
                              if (widget.message.text.isNotEmpty)
                                Text(
                                  widget.message.text,
                                  style: AppTypography.body.copyWith(
                                    color: widget.isMine ? Colors.white : colors.text,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Reaction Badge
                        if (widget.message.reaction != null)
                          Positioned(
                            bottom: -10,
                            right: widget.isMine ? null : -8,
                            left: widget.isMine ? -8 : null,
                            child: GestureDetector(
                              onTap: () => _showContextMenu(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(widget.message.reaction!, style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Timestamp & Read Receipts
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(timeDisplay, style: AppTypography.caption2.copyWith(color: colors.textTertiary)),
                          if (widget.isMine) ...[
                            const SizedBox(width: 4),
                            Icon(
                              widget.message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                              size: 13,
                              color: widget.message.isRead ? colors.primary : colors.textTertiary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(BuildContext context, AppThemeColors colors) {
    final type = widget.message.attachmentType;
    final title = widget.message.attachmentTitle ?? "Attachment";
    final subtitle = widget.message.attachmentSubtitle ?? "";

    IconData icon;
    Color iconColor;

    switch (type) {
      case 'pitch_deck':
        icon = Icons.picture_as_pdf_rounded;
        iconColor = Colors.redAccent;
        break;
      case 'validation':
        icon = Icons.rocket_launch_rounded;
        iconColor = widget.isMine ? Colors.white : colors.primary;
        break;
      case 'image':
        icon = Icons.image_rounded;
        iconColor = Colors.blueAccent;
        break;
      case 'audio':
        icon = Icons.graphic_eq_rounded;
        iconColor = Colors.purpleAccent;
        break;
      default:
        icon = Icons.insert_drive_file_rounded;
        iconColor = colors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isMine ? Colors.black.withAlpha(35) : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(40),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isMine ? Colors.white : colors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isMine ? Colors.white70 : colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicatorView extends StatefulWidget {
  final String userName;
  final String? avatarUrl;
  const _TypingIndicatorView({required this.userName, this.avatarUrl});

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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AvatarView(name: widget.userName, imageURL: widget.avatarUrl, size: 26),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
            decoration: BoxDecoration(
              color: colors.cardBackgroundLight,
              borderRadius: BorderRadius.circular(18).copyWith(bottomLeft: const Radius.circular(4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    var t = (_controller.value - delay);
                    if (t < 0) t += 1.0;

                    double scale = 0.75;
                    double opacity = 0.35;

                    if (t < 0.4) {
                      scale = 0.75 + (t / 0.4) * 0.45;
                      opacity = 0.35 + (t / 0.4) * 0.65;
                    } else if (t < 0.8) {
                      scale = 1.2 - ((t - 0.4) / 0.4) * 0.45;
                      opacity = 1.0 - ((t - 0.4) / 0.4) * 0.65;
                    }

                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
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
