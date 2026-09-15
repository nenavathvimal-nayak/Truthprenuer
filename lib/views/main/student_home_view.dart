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

class StudentHomeView extends ConsumerStatefulWidget {
  const StudentHomeView({super.key});

  @override
  ConsumerState<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends ConsumerState<StudentHomeView> {
  String _selectedTrack = "All";
  final List<String> _tracks = [
    "All",
    "Customer Discovery",
    "Hypothesis Testing",
    "Pricing Science",
    "MVP Scoping",
    "PMF Metrics"
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final dataStore = ref.watch(mockDataStoreProvider);
    final validations = dataStore.validations;

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

          // 2. HERO LEARNING LAUNCHPAD CARD
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
                    // Badge row
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
                                    "VALIDATION ACADEMY",
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
                              const Icon(Icons.school_rounded, size: 14, color: Color(0xFF3B82F6)),
                              const SizedBox(width: 4),
                              Text(
                                "Level 3 Explorer",
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
                      "Learn startup validation by deconstructing real ventures.",
                      style: AppTypography.title1.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Skip passive theory. Practice auditing genuine customer assumptions, run simulated customer interviews, and connect with veteran founders.",
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Daily challenge
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.background.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.military_tech_rounded, color: colors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DAILY PRACTICE CHALLENGE",
                                  style: AppTypography.labelSmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Critique a \$20/mo B2B willingness-to-pay assumption to earn +100 XP.",
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
                            title: "Practice Arena",
                            action: () => context.push('/explore'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SecondaryButton(
                            title: "Find a Mentor",
                            action: () => context.push('/network'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. STUDENT METRICS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "MODULES",
                      value: "14 Done",
                      subtitle: "Validation Core",
                      icon: Icons.menu_book_outlined,
                      accentColor: colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "PRACTICE",
                      value: "9 Cases",
                      subtitle: "Hypothesis Audits",
                      icon: Icons.psychology_outlined,
                      accentColor: const Color(0xFF3B82F6),
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
                      title: "MENTOR SESSIONS",
                      value: "3 Held",
                      subtitle: "1 scheduled soon",
                      icon: Icons.co_present_outlined,
                      accentColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "ACADEMY XP",
                      value: "890 XP",
                      subtitle: "Level 3 Explorer",
                      icon: Icons.stars_outlined,
                      accentColor: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. TRACK PILLS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.sm),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _tracks.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final track = _tracks[index];
                    final isSelected = track == _selectedTrack;
                    return CategoryPill(
                      label: track,
                      isSelected: isSelected,
                      onTap: () {
                        HapticManager.shared.selection();
                        setState(() {
                          _selectedTrack = track;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // 5. SECTION: PRACTICE CASES
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
                          "Live Practice Crucible",
                          style: AppTypography.title3.copyWith(
                            color: colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Real founder submissions open for student practice reviews",
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
                      "All Cases",
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

          // 6. PRACTICE CASES LIST
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= validations.length) return null;
                final v = validations[index];
                return _buildStudentPracticeCard(context, colors, v);
              },
              childCount: validations.length,
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

  Widget _buildStudentPracticeCard(
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
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "PRACTICE CASE",
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "+75 XP REWARD",
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.bookmark_border_rounded, size: 18, color: colors.textSecondary),
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

              // CTA
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticManager.shared.impactMedium();
                        context.push('/validation-detail/${v.id}');
                      },
                      icon: const Icon(Icons.fitness_center_rounded, size: 16),
                      label: const Text("Practice Hypothesis Audit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
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
