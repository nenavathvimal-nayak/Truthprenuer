import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/badge_icon_button.dart';
import '../../components/brand_logo.dart';
import '../../components/buttons.dart';
import '../../components/category_pill.dart';
import '../../components/role_switcher_modal.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/theme_mode_provider.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class ProfessionalHomeView extends ConsumerStatefulWidget {
  const ProfessionalHomeView({super.key});

  @override
  ConsumerState<ProfessionalHomeView> createState() => _ProfessionalHomeViewState();
}

class _ProfessionalHomeViewState extends ConsumerState<ProfessionalHomeView> {
  String _selectedSkill = "All";
  final List<String> _skills = [
    "All",
    "UX & Product",
    "Tech Architecture",
    "Go-To-Market",
    "Pricing & Unit Econ",
    "Security & DevOps"
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final dataStore = ref.watch(mockDataStoreProvider);
    final validations = dataStore.validations;

    // Startups requesting expertise
    final pendingRequests = _selectedSkill == "All"
        ? validations
        : validations.where((v) =>
            v.tags.any((t) => t.toLowerCase().contains(_selectedSkill.toLowerCase().split(' ').first)) ||
            v.title.toLowerCase().contains(_selectedSkill.toLowerCase().split(' ').first)).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. PINNED FROSTED GLASS APP BAR
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

          // 2. HERO EXPERTISE COMMAND CARD
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.cardBackground,
                      colors.primary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Row
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
                                    "EXPERTISE PASSPORT ACTIVE",
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
                              const Icon(Icons.military_tech_rounded, size: 14, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 4),
                              Text(
                                "Top 5% Validator",
                                style: AppTypography.caption.copyWith(
                                  color: colors.text,
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
                      "Your domain expertise de-risks real ventures.",
                      style: AppTypography.title1.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Audit early hypotheses, challenge flawed assumptions, and build an immutable track record of high-signal advisory contributions.",
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Audit request alert
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.background.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.assignment_late_outlined, color: colors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "VALIDATION AUDIT INBOX",
                                  style: AppTypography.labelSmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "3 early-stage founders requested your critique on pricing elasticity and architecture scaling.",
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

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            title: "Audit Requests",
                            action: () => context.push('/explore'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SecondaryButton(
                            title: "Leaderboard",
                            action: () => context.push('/leaderboard'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. PROFESSIONAL METRIC CARDS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "AUDITS DONE",
                      value: "28 Audits",
                      subtitle: "↑ 4 this month",
                      icon: Icons.fact_check_outlined,
                      accentColor: colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "KARMA XP",
                      value: "1,420 XP",
                      subtitle: "Rank #4 globally",
                      icon: Icons.military_tech_outlined,
                      accentColor: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "TRUST RATING",
                      value: "98.4%",
                      subtitle: "Founder consensus",
                      icon: Icons.verified_user_outlined,
                      accentColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "ADVISORY OFFERS",
                      value: "5 Invites",
                      subtitle: "Equity & advisory",
                      icon: Icons.handshake_outlined,
                      accentColor: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. SKILL DOMAIN PILLS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.sm),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _skills.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final skill = _skills[index];
                    final isSelected = skill == _selectedSkill;
                    return CategoryPill(
                      label: skill,
                      isSelected: isSelected,
                      onTap: () {
                        HapticManager.shared.selection();
                        setState(() {
                          _selectedSkill = skill;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // 5. SECTION HEADER: PENDING REQUESTS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Startups Seeking Your Lens",
                          style: AppTypography.title3.copyWith(
                            color: colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Provide structured peer reviews to earn karma & advisory tokens",
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: () => context.push('/explore'),
                    child: Text(
                      "View All",
                      style: AppTypography.caption.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. REQUEST LIST
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= pendingRequests.length) return null;
                final v = pendingRequests[index];
                return _buildProfessionalRequestCard(context, colors, v);
              },
              childCount: pendingRequests.length,
            ),
          ),

          // 7. BOTTOM SPACING
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required AppThemeColors colors,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
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
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.title2.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalRequestCard(
    BuildContext context,
    AppThemeColors colors,
    ValidationRequest v,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: InkWell(
        onTap: () {
          HapticManager.shared.impactLight();
          context.push('/validation-detail/${v.id}');
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colors.border.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${v.stage.value.toUpperCase()} STAGE",
                      style: AppTypography.labelSmall.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "+50 KARMA BOUNTY",
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFFF59E0B),
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${v.responsesCount} Reviews",
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                v.title,
                style: AppTypography.headline.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                v.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.subheadline.copyWith(
                  color: colors.textSecondary,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: v.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#$tag",
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticManager.shared.impactMedium();
                        context.push('/validation-detail/${v.id}');
                      },
                      icon: const Icon(Icons.rate_review_outlined, size: 16),
                      label: const Text("Provide Critique"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.bookmark_border_rounded, color: colors.textSecondary),
                    onPressed: () {
                      HapticManager.shared.selection();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Saved ${v.title} to review later"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
