import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/mock_data_store_provider.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../utils/haptic_manager.dart';

class SharedTopNavBar extends ConsumerWidget {
  const SharedTopNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(mockDataStoreProvider);
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "TAEED",
            style: AppTypography.title1.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Button
              GestureDetector(
                onTap: () {
                  HapticManager.shared.impactLight();
                  context.push('/search');
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                  ),
                  child: Icon(
                    Icons.search,
                    size: 20,
                    color: colors.text,
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Messages Button
              GestureDetector(
                onTap: () {
                  HapticManager.shared.impactLight();
                  context.push('/chats');
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: colors.text,
                      ),
                    ),
                    if (dataStore.unreadMessageCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${dataStore.unreadMessageCount}",
                            style: AppTypography.caption.copyWith(
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
              
              const SizedBox(width: AppSpacing.sm),
              
              // Notifications Bell
              GestureDetector(
                onTap: () {
                  HapticManager.shared.impactLight();
                  context.push('/notifications');
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 20,
                        color: colors.text,
                      ),
                    ),
                    if (dataStore.unreadNotificationCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.destructive,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${dataStore.unreadNotificationCount}",
                            style: AppTypography.caption.copyWith(
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
            ],
          ),
        ],
      ),
    );
  }
}
