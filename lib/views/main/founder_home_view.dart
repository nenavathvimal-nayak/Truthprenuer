import 'dart:ui';
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
import '../../components/role_switcher_modal.dart';
import '../../utils/haptic_manager.dart';

class FounderHomeView extends ConsumerStatefulWidget {
  const FounderHomeView({super.key});

  @override
  ConsumerState<FounderHomeView> createState() => _FounderHomeViewState();
}

class _FounderHomeViewState extends ConsumerState<FounderHomeView> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "AI", "SaaS", "FinTech", "HealthTech", "DevOps", "B2B"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final dataStore = ref.watch(mockDataStoreProvider);
    final currentUser = dataStore.currentUser;

    final myValidations = dataStore.validations.where((v) => v.authorId == currentUser?.id).toList();
    var otherValidations = dataStore.validations.where((v) => v.authorId != currentUser?.id).toList();

    if (_selectedCategory != "All") {
      otherValidations = otherValidations.where((v) {
        return v.tags.any((t) => t.toLowerCase() == _selectedCategory.toLowerCase()) ||
            v.title.toLowerCase().contains(_selectedCategory.toLowerCase());
      }).toList();
    }

    final activeValidationsCount = myValidations.length;
    final totalResponsesCount = myValidations.fold<int>(0, (sum, v) => sum + v.responsesCount);

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. PINNED FROSTED GLASS EXECUTIVE HEADER
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: colors.background.withValues(alpha: 0.85),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
            titleSpacing: AppSpacing.lg,
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BrandLogo.mark(size: 26),
                SizedBox(width: 8),
                RoleBadgePill(),
              ],
            ),
            actions: [
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
                icon: Icons.chat_bubble_outline_rounded,
                count: dataStore.unreadMessageCount,
                onTap: () => context.push('/chats'),
              ),
              const SizedBox(width: AppSpacing.xs),
              BadgeIconButton(
                icon: Icons.notifications_none_rounded,
                count: dataStore.unreadNotificationCount,
                onTap: () => context.push('/notifications'),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),

          // 2. PRIMARY HERO COMMAND CENTER (EXECUTIVE LAUNCHPAD)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.cardBackground,
                      colors.primary.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge & Status Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    "TRUTH ENGINE ACTIVE",
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.trending_up, size: 14, color: colors.primary),
                              const SizedBox(width: 4),
                              Text(
                                "78% Score",
                                style: AppTypography.caption.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Turn your idea into evidence.",
                      style: AppTypography.title1.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Deconstruct your riskiest market assumptions and collect verifiable customer signals before writing code.",
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Top Urgent Risk Banner
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.background.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.crisis_alert_rounded, color: colors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PRIMARY HYPOTHESIS RISK",
                                  style: AppTypography.labelSmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "62% of reviewers question your \$49/mo tier. Test willingness-to-pay assumption.",
                                  style: AppTypography.footnote.copyWith(
                                    color: colors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            title: "Start Validation",
                            action: () => context.push('/validation-wizard'),
                          ),
                        ),
                        const SizedBox(width: 10),
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

          // 3. PROGRESS SUMMARY ROW (Executive Health Metrics)
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      value: "$totalResponsesCount",
                      label: "Critiques",
                      icon: Icons.forum_outlined,
                      accentColor: colors.text,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      value: "78%",
                      label: "Truth Score",
                      icon: Icons.analytics_outlined,
                      accentColor: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      value: "740",
                      label: "Karma",
                      icon: Icons.bolt_rounded,
                      accentColor: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. ACTIVE SPRINT PROGRESS
          if (myValidations.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.4),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timelapse_rounded, size: 16, color: colors.primary),
                          const SizedBox(width: 6),
                          Text(
                            "CONTINUE SPRINT",
                            style: AppTypography.labelSmall.copyWith(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "Step 4 of 7 • Evidence Gathering",
                              style: AppTypography.caption.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                          backgroundColor: colors.divider.withValues(alpha: 0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "3 customer interviews recorded",
                            style: AppTypography.caption.copyWith(color: colors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => context.push('/validation-wizard'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              backgroundColor: colors.primary.withValues(alpha: 0.12),
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

          // 5. RECENT HIGH-SIGNAL ACTIVITY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
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
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    _buildActivityRow(
                      context,
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: colors.primary,
                      title: "Critical Pricing Critique",
                      subtitle: "Priya Sharma challenged your \$49/mo enterprise pricing model",
                      timestamp: "12m ago",
                      isUnread: true,
                      onTap: () => context.push('/notifications'),
                    ),
                    Divider(height: 1, color: colors.border.withValues(alpha: 0.3)),
                    _buildActivityRow(
                      context,
                      icon: Icons.psychology_outlined,
                      iconColor: colors.primary,
                      title: "AI Stress-Test Diagnostic",
                      subtitle: "Truth Index calibrated to 78% after 3 developer interviews",
                      timestamp: "1h ago",
                      isUnread: true,
                      onTap: () => context.push('/notifications'),
                    ),
                    Divider(height: 1, color: colors.border.withValues(alpha: 0.3)),
                    _buildActivityRow(
                      context,
                      icon: Icons.handshake_outlined,
                      iconColor: colors.textSecondary,
                      title: "Co-Founder Signal",
                      subtitle: "Tariq Al-Mansoor requested to review your Kubernetes architecture",
                      timestamp: "3h ago",
                      isUnread: false,
                      onTap: () => context.push('/notifications'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 6. CATEGORY FILTER CHIPS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Peer Crucible",
                    style: AppTypography.title2.copyWith(color: colors.text, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Earn validation karma",
                    style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
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
                      HapticManager.shared.selection();
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                )).toList(),
              ),
            ),
          ),

          // 7. PEER VALIDATIONS LIST
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

          // Space for floating bottom navigation bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 110),
          ),
        ],
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: accentColor),
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
              fontWeight: FontWeight.w500,
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
                color: iconColor.withValues(alpha: 0.12),
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
    final dataStore = ref.watch(mockDataStoreProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Row
          Row(
            children: [
              AvatarView(
                name: validation.authorName ?? "Founder",
                imageURL: validation.authorAvatarURL,
                size: 34,
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      validation.authorRole ?? "Builder",
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.forum_outlined, size: 12, color: colors.primary),
                    const SizedBox(width: 4),
                    Text(
                      "${validation.responsesCount} critiques",
                      style: AppTypography.caption.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            validation.title,
            style: AppTypography.title3.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),

          // Problem Statement
          Text(
            validation.problem,
            style: AppTypography.body.copyWith(
              color: colors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Wedge / Solution Highlight Callout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 14, color: colors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Wedge: ${validation.solution}",
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Action Row
          Row(
            children: [
              // Upvote Button
              InkWell(
                onTap: () {
                  HapticManager.shared.selection();
                  dataStore.toggleUpvote(validation.id);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: validation.isUpvoted
                        ? colors.primary.withValues(alpha: 0.15)
                        : colors.divider.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        validation.isUpvoted ? Icons.arrow_upward_rounded : Icons.arrow_upward_outlined,
                        size: 14,
                        color: validation.isUpvoted ? colors.primary : colors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${validation.upvotes}",
                        style: AppTypography.caption.copyWith(
                          color: validation.isUpvoted ? colors.primary : colors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Bookmark Button
              InkWell(
                onTap: () {
                  HapticManager.shared.lightImpact();
                  dataStore.toggleBookmark(validation.id);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: validation.isBookmarked
                        ? colors.primary.withValues(alpha: 0.15)
                        : colors.divider.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    validation.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    size: 16,
                    color: validation.isBookmarked ? colors.primary : colors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),

              // Sleek Review Action
              ElevatedButton.icon(
                onPressed: () {
                  HapticManager.shared.impactLight();
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
                icon: const Icon(Icons.rate_review_outlined, size: 14),
                label: const Text("Give Feedback"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  foregroundColor: colors.primary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: AppTypography.footnote.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

