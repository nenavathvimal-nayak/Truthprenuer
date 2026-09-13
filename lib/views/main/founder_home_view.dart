import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/theme_mode_provider.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../components/badge_icon_button.dart';
import '../../components/brand_logo.dart';
import '../../components/category_pill.dart';
import '../../utils/haptic_manager.dart';

class FounderHomeView extends ConsumerStatefulWidget {
  const FounderHomeView({super.key});

  @override
  ConsumerState<FounderHomeView> createState() => _FounderHomeViewState();
}

class _FounderHomeViewState extends ConsumerState<FounderHomeView> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "AI", "SaaS", "FinTech", "HealthTech", "Consumer", "B2B"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final dataStore = ref.watch(mockDataStoreProvider);
    final currentUser = dataStore.currentUser;

    final myValidations = dataStore.validations.where((v) => v.authorId == currentUser?.id).toList();
    final otherValidations = dataStore.validations.where((v) => v.authorId != currentUser?.id).toList();
    final activeValidationsCount = myValidations.length;
    final totalResponsesCount = myValidations.fold<int>(0, (sum, v) => sum + v.responsesCount);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. EXECUTIVE BRAND APP BAR (TRUTHPRENUER TOP-LEFT)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BrandLogo.horizontal(height: 28),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            color: colors.textSecondary,
                            size: 20,
                          ),
                          tooltip: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
                          onPressed: () {
                            HapticManager.shared.impactLight();
                            ref.read(themeModeProvider.notifier).toggleTheme();
                          },
                        ),
                        BadgeIconButton(
                          icon: Icons.chat_bubble_outline,
                          count: dataStore.unreadMessageCount,
                          onTap: () => context.push('/chats'),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        BadgeIconButton(
                          icon: Icons.notifications_none,
                          count: dataStore.unreadNotificationCount,
                          onTap: () => context.push('/notifications'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. PRIMARY HERO CARD (BORDERLESS EXECUTIVE LAUNCHPAD)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.cardBackground,
                        colors.primary.withAlpha(20),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const BrandLogo.mark(size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  "VALIDATION ENGINE",
                                  style: AppTypography.labelSmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.insights, color: colors.primary, size: 20),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Turn your idea into evidence.",
                        style: AppTypography.title1.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Create a structured validation and learn what real founders and customers think before building.",
                        style: AppTypography.body.copyWith(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              title: "Start Validation",
                              action: () => context.push('/validation-wizard'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SecondaryButton(
                              title: "My Validations",
                              action: () => context.push('/explore'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 5. PROGRESS SUMMARY ROW (Active Validations, Responses, Confidence)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        value: "$activeValidationsCount",
                        label: "Active",
                        icon: Icons.verified_outlined,
                        accentColor: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        value: "$totalResponsesCount",
                        label: "Responses",
                        icon: Icons.forum_outlined,
                        accentColor: colors.text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        value: "68%",
                        label: "Confidence",
                        icon: Icons.trending_up,
                        accentColor: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 6. CONTINUE WORKING (Contextual In-Progress Item)
            if (myValidations.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "CONTINUE WORKING",
                              style: AppTypography.labelSmall.copyWith(
                                color: colors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Step 4 of 7",
                              style: AppTypography.caption.copyWith(color: colors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          myValidations.first.title,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.text,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.57,
                            backgroundColor: colors.divider,
                            valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => context.push('/validation-wizard'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                backgroundColor: colors.primary.withAlpha(25),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                "Continue →",
                                style: AppTypography.footnote.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 7. RECENT ACTIVITY FEED
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Activity",
                      style: AppTypography.title2.copyWith(color: colors.text, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => context.push('/notifications'),
                      child: Text(
                        "See all",
                        style: AppTypography.caption.copyWith(color: colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _buildActivityRow(
                        context,
                        icon: Icons.check_circle_outline,
                        iconColor: colors.primary,
                        title: "New response received",
                        subtitle: "Priya Sharma responded to your pricing assumption",
                        timestamp: "12m ago",
                        isUnread: true,
                        onTap: () => context.push('/notifications'),
                      ),
                      Divider(height: 1, color: colors.border.withAlpha(80)),
                      _buildActivityRow(
                        context,
                        icon: Icons.psychology_outlined,
                        iconColor: colors.primary,
                        title: "AI Analysis Ready",
                        subtitle: "Confidence signal updated to 68% based on new data",
                        timestamp: "1h ago",
                        isUnread: true,
                        onTap: () => context.push('/notifications'),
                      ),
                      Divider(height: 1, color: colors.border.withAlpha(80)),
                      _buildActivityRow(
                        context,
                        icon: Icons.person_add_outlined,
                        iconColor: colors.textSecondary,
                        title: "Connection Request",
                        subtitle: "Rahul Mehta wants to connect as a co-founder",
                        timestamp: "3h ago",
                        isUnread: false,
                        onTap: () => context.push('/notifications'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 8. CATEGORY FILTER CHIPS
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore Validations",
                      style: AppTypography.title2.copyWith(color: colors.text, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Needs your feedback",
                      style: AppTypography.caption.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                child: Row(
                  children: _categories.map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryPill(
                      label: cat,
                      isSelected: _selectedCategory == cat,
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  )).toList(),
                ),
              ),
            ),

            // 9. RECOMMENDED VALIDATIONS LIST
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final validation = otherValidations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 6),
                    child: _buildValidationCard(context, validation),
                  );
                },
                childCount: otherValidations.length,
              ),
            ),

            // Bottom space for floating nav bar
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    required Color accentColor,
  }) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: accentColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.title2.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String timestamp,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.text,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        timestamp,
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.footnote.copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationCard(BuildContext context, ValidationRequest validation) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarView(
                name: validation.authorName ?? "Founder",
                imageURL: validation.authorAvatarURL,
                size: 32,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      validation.authorName ?? "Founder",
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      validation.authorRole ?? "Builder",
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  "${validation.responsesCount} responses",
                  style: AppTypography.caption.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            validation.title,
            style: AppTypography.title3.copyWith(
              color: colors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            validation.problem,
            style: AppTypography.body.copyWith(
              color: colors.textSecondary,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: validation.tags.take(2).map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.divider.withAlpha(120),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final dataStore = ref.read(mockDataStoreProvider);
                  final author = dataStore.users.firstWhere(
                    (u) => u.id == validation.authorId,
                    orElse: () => User(
                      id: validation.authorId,
                      name: validation.authorName ?? 'Founder',
                      username: 'founder',
                      bio: '',
                      role: validation.authorRole ?? 'Builder',
                    ),
                  );
                  context.push('/validation-detail', extra: {
                    'validation': validation,
                    'author': author,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textInverted,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Give Feedback"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
