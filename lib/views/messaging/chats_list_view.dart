import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

enum ChatFilter { active, archived }

extension ChatFilterExtension on ChatFilter {
  String get label {
    switch (this) {
      case ChatFilter.active:
        return "Active";
      case ChatFilter.archived:
        return "Archived";
    }
  }
}

class ChatsListView extends ConsumerStatefulWidget {
  const ChatsListView({super.key});

  @override
  ConsumerState<ChatsListView> createState() => _ChatsListViewState();
}

class _ChatsListViewState extends ConsumerState<ChatsListView> {
  String _searchText = "";
  ChatFilter _selectedFilter = ChatFilter.active;

  void _showNewMessageBottomSheet() {
    HapticManager.shared.impactLight();
    final colors = Theme.of(context).appColors;
    final dataStore = ref.read(mockDataStoreProvider);
    final myId = dataStore.currentUser?.id ?? "me";
    final allUsers = dataStore.users.where((u) => u.id != myId).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String filterQuery = "";
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = allUsers.where((u) {
              final q = filterQuery.toLowerCase().trim();
              if (q.isEmpty) return true;
              return u.name.toLowerCase().contains(q) ||
                  u.role.toLowerCase().contains(q) ||
                  u.skills.any((s) => s.toLowerCase().contains(q));
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.textTertiary.withAlpha(80),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("New Message", style: AppTypography.title2.copyWith(color: colors.text)),
                      IconButton(
                        icon: Icon(Icons.close, color: colors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Search Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.cardBackgroundLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: colors.textSecondary, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setModalState(() => filterQuery = val),
                            style: AppTypography.body.copyWith(color: colors.text),
                            decoration: InputDecoration(
                              hintText: "Search founders, mentors, investors...",
                              hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No matching contacts found",
                              style: AppTypography.body.copyWith(color: colors.textSecondary),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => Divider(height: 1, color: colors.divider),
                            itemBuilder: (context, index) {
                              final user = filtered[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                leading: AvatarView(name: user.name, imageURL: user.avatarURL, size: 42),
                                title: Row(
                                  children: [
                                    Text(user.name, style: AppTypography.headline.copyWith(color: colors.text)),
                                    if (user.isVerified) ...[
                                      const SizedBox(width: 4),
                                      Icon(Icons.verified, size: 14, color: colors.primary),
                                    ],
                                  ],
                                ),
                                subtitle: Text(
                                  "${user.role} • ${user.location}",
                                  style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colors.primary.withAlpha(30),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    "Chat",
                                    style: AppTypography.caption1.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  HapticManager.shared.impactLight();
                                  final conv = ref.read(mockDataStoreProvider).getOrCreateConversation(user.id);
                                  context.push(
                                    '/chat-room',
                                    extra: {
                                      'conversation': conv,
                                      'otherUser': user,
                                    },
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showConversationActions(Conversation conv, User otherUser) {
    HapticManager.shared.impactMedium();
    final colors = Theme.of(context).appColors;
    final store = ref.read(mockDataStoreProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Row(
                children: [
                  AvatarView(name: otherUser.name, imageURL: otherUser.avatarURL, size: 38),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(otherUser.name, style: AppTypography.headline.copyWith(color: colors.text)),
                      Text(otherUser.role, style: AppTypography.caption1.copyWith(color: colors.textSecondary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: Icon(conv.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded, color: colors.text),
                title: Text(conv.isPinned ? "Unpin Conversation" : "Pin to Top", style: AppTypography.body.copyWith(color: colors.text)),
                onTap: () {
                  Navigator.pop(ctx);
                  store.togglePin(conv.id);
                  setState(() {});
                },
              ),
              ListTile(
                leading: Icon(conv.unreadCount > 0 ? Icons.mark_chat_read_rounded : Icons.mark_chat_unread_rounded, color: colors.text),
                title: Text(conv.unreadCount > 0 ? "Mark as Read" : "Mark as Unread", style: AppTypography.body.copyWith(color: colors.text)),
                onTap: () {
                  Navigator.pop(ctx);
                  if (conv.unreadCount > 0) {
                    store.markConversationAsRead(conv.id);
                  } else {
                    store.markConversationAsUnread(conv.id);
                  }
                  setState(() {});
                },
              ),
              ListTile(
                leading: Icon(conv.isArchived ? Icons.unarchive_rounded : Icons.archive_rounded, color: colors.text),
                title: Text(conv.isArchived ? "Unarchive Conversation" : "Archive Conversation", style: AppTypography.body.copyWith(color: colors.text)),
                onTap: () {
                  Navigator.pop(ctx);
                  store.toggleArchive(conv.id);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);

    List<Conversation> filteredConversations = dataStore.conversations.where((conv) {
      if (_selectedFilter == ChatFilter.archived) return conv.isArchived;
      return !conv.isArchived;
    }).toList();

    if (_searchText.isNotEmpty) {
      filteredConversations = filteredConversations.where((conv) {
        final other = dataStore.otherUser(conv);
        if (other == null) return false;
        final searchLower = _searchText.toLowerCase();
        return other.name.toLowerCase().contains(searchLower) ||
            conv.lastMessage.toLowerCase().contains(searchLower);
      }).toList();
    }

    filteredConversations.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Messages", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.text, size: 28),
          onPressed: () {
            HapticManager.shared.impactLight();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_square, color: colors.primary),
            tooltip: "New Message",
            onPressed: _showNewMessageBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: colors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(Icons.search, color: colors.textSecondary, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchText = val),
                      style: AppTypography.body.copyWith(color: colors.text),
                      decoration: InputDecoration(
                        hintText: "Search messages...",
                        hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_searchText.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: colors.textSecondary, size: 18),
                      onPressed: () => setState(() => _searchText = ""),
                    ),
                ],
              ),
            ),
          ),

          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: ChatFilter.values.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticManager.shared.selection();
                      setState(() => _selectedFilter = filter);
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Column(
                        children: [
                          Text(
                            filter.label,
                            style: AppTypography.callout.copyWith(
                              color: isSelected ? colors.text : colors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isSelected ? colors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(height: 1, color: colors.divider),

          Expanded(
            child: filteredConversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 52, color: colors.textTertiary),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          "No ${_selectedFilter.label.toLowerCase()} conversations",
                          style: AppTypography.headline.copyWith(color: colors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton.icon(
                          onPressed: _showNewMessageBottomSheet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Start a Conversation"),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredConversations.length,
                    itemBuilder: (context, index) {
                      final conv = filteredConversations[index];
                      final otherUser = dataStore.otherUser(conv);
                      if (otherUser == null) return const SizedBox.shrink();

                      return Dismissible(
                        key: ValueKey(conv.id),
                        background: Container(
                          color: colors.textSecondary,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            conv.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          color: colors.primary,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            conv.isArchived ? Icons.unarchive : Icons.archive,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            HapticManager.shared.impactMedium();
                            dataStore.toggleArchive(conv.id);
                          } else if (direction == DismissDirection.startToEnd) {
                            HapticManager.shared.impactMedium();
                            dataStore.togglePin(conv.id);
                          }
                          setState(() {});
                          return false;
                        },
                        child: InkWell(
                          onTap: () {
                            context.push(
                              '/chat-room',
                              extra: {
                                'conversation': conv,
                                'otherUser': otherUser,
                              },
                            );
                          },
                          onLongPress: () => _showConversationActions(conv, otherUser),
                          child: _ConversationRow(conversation: conv, otherUser: otherUser),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ConversationRow extends StatelessWidget {
  final Conversation conversation;
  final User otherUser;

  const _ConversationRow({required this.conversation, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final diff = DateTime.now().difference(conversation.lastMessageTime);
    String timeAgo = "${diff.inHours}h";
    if (diff.inHours == 0) timeAgo = "${diff.inMinutes}m";
    if (diff.inDays > 0) timeAgo = "${diff.inDays}d";

    return Container(
      color: colors.background,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AvatarView(name: otherUser.name, imageURL: otherUser.avatarURL, size: 52),
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: colors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      otherUser.name,
                      style: conversation.unreadCount > 0
                          ? AppTypography.headline.copyWith(color: colors.text)
                          : AppTypography.bodyMedium.copyWith(color: colors.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (otherUser.isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, size: 14, color: colors.info),
                    ],
                    const Spacer(),
                    if (conversation.isPinned) ...[
                      Icon(Icons.push_pin, size: 13, color: colors.primary),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      timeAgo,
                      style: AppTypography.caption2.copyWith(
                        color: conversation.unreadCount > 0 ? colors.primary : colors.textTertiary,
                        fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.lastMessage,
                        style: AppTypography.subheadline.copyWith(
                          color: conversation.unreadCount > 0 ? colors.text : colors.textSecondary,
                          fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (conversation.unreadCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${conversation.unreadCount}",
                          style: AppTypography.label.copyWith(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
