import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';
import 'package:go_router/go_router.dart';

enum NotifFilter {
  all("All"),
  unread("Unread"),
  mentions("Mentions");

  final String label;
  const NotifFilter(this.label);
}

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  NotifFilter _selectedFilter = NotifFilter.all;

  List<AppNotification> _getFilteredNotifications(List<AppNotification> notifications) {
    switch (_selectedFilter) {
      case NotifFilter.all:
        return notifications;
      case NotifFilter.unread:
        return notifications.where((n) => !n.isRead).toList();
      case NotifFilter.mentions:
        return notifications.where((n) => n.type == AppNotificationType.message).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final filteredNotifications = _getFilteredNotifications(dataStore.notifications);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.cardBackgroundLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 16, color: colors.textSecondary),
          ),
          onPressed: () {
            HapticManager.shared.impactLight();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          "Notifications",
          style: AppTypography.appBarTitle.copyWith(color: colors.text),
        ),
        centerTitle: true,
        actions: [
          if (dataStore.unreadNotificationCount > 0)
            TextButton(
              onPressed: () {
                HapticManager.shared.notificationSuccess();
                ref.read(mockDataStoreProvider).markAllNotificationsRead();
              },
              child: Text(
                "Mark All Read",
                style: AppTypography.callout.copyWith(color: colors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: colors.surface,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: NotifFilter.values.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      HapticManager.shared.selection();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      decoration: const BoxDecoration(
                        color: Colors.transparent, // required for tap
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                filter.label,
                                style: AppTypography.callout.copyWith(
                                  color: isSelected ? colors.text : colors.textSecondary,
                                ),
                              ),
                              if (filter == NotifFilter.unread && dataStore.unreadNotificationCount > 0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    "${dataStore.unreadNotificationCount}",
                                    style: AppTypography.label.copyWith(color: Colors.white),
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 2,
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
          Divider(color: colors.divider, height: 1, thickness: 1),
          
          // Content
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colors.cardBackgroundLight,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.notifications_off,
                            size: 36,
                            color: colors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          "No ${_selectedFilter.label.toLowerCase()} notifications",
                          style: AppTypography.headline.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notif = filteredNotifications[index];
                      return _NotificationRowView(
                        notification: notif,
                        onTap: () {
                          if (!notif.isRead) {
                            ref.read(mockDataStoreProvider).markNotificationRead(notif.id);
                          }
                          HapticManager.shared.impactLight();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRowView extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationRowView({
    required this.notification,
    required this.onTap,
  });

  IconData _iconForType(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.message: return Icons.message;
      case AppNotificationType.feedback: return Icons.feedback;
      case AppNotificationType.match: return Icons.people;
      case AppNotificationType.system: return Icons.info;
      case AppNotificationType.mention: return Icons.alternate_email;
      case AppNotificationType.milestone: return Icons.star;
      case AppNotificationType.welcome: return Icons.waving_hand;
      case AppNotificationType.connection: return Icons.people;
      case AppNotificationType.upvote: return Icons.arrow_upward;
      case AppNotificationType.follow: return Icons.person_add;
      case AppNotificationType.comment: return Icons.chat_bubble;
    }
  }

  Color _colorForType(AppNotificationType type, AppThemeColors colors) {
    switch (type) {
      case AppNotificationType.message: return colors.primary;
      case AppNotificationType.feedback: return colors.evidenceGreen;
      case AppNotificationType.match: return colors.confidenceBlue;
      case AppNotificationType.system: return colors.textSecondary;
      case AppNotificationType.mention: return colors.primary;
      case AppNotificationType.milestone: return colors.primary;
      case AppNotificationType.welcome: return colors.primary;
      case AppNotificationType.connection: return colors.confidenceBlue;
      case AppNotificationType.upvote: return colors.evidenceGreen;
      case AppNotificationType.follow: return colors.primary;
      case AppNotificationType.comment: return colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final typeColor = _colorForType(notification.type, colors);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: colors.destructive.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      onDismissed: (direction) {
        // Technically we should delete the notification from dataStore here
        // The original code only sets a local dismiss state (it hides the row visually)
        // A true implementation would remove it.
        HapticManager.shared.notificationWarning();
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead ? colors.cardBackground : colors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + Icon
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  AvatarView(
                    name: notification.actorName,
                    imageURL: null,
                    size: 48,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: typeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _iconForType(notification.type),
                      size: 9,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: (notification.isRead ? AppTypography.subheadline : AppTypography.bodyMedium).copyWith(
                        color: colors.text,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.time.timeAgoDisplay,
                      style: AppTypography.caption2.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
              ),
              
              // Unread Dot
              if (!notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
