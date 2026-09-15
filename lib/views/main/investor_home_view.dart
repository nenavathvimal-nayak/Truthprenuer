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

class InvestorHomeView extends ConsumerStatefulWidget {
  const InvestorHomeView({super.key});

  @override
  ConsumerState<InvestorHomeView> createState() => _InvestorHomeViewState();
}

class _InvestorHomeViewState extends ConsumerState<InvestorHomeView> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "AI/ML", "B2B SaaS", "FinTech", "HealthTech", "DevOps"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final dataStore = ref.watch(mockDataStoreProvider);
    final validations = dataStore.validations;

    // Filter validations based on category
    final filteredValidations = _selectedCategory == "All"
        ? validations
        : validations.where((v) =>
            v.tags.any((t) => t.toLowerCase() == _selectedCategory.toLowerCase()) ||
            v.title.toLowerCase().contains(_selectedCategory.toLowerCase())).toList();

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

          // 2. HERO DEAL FLOW RADAR BANNER
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
                                    "SIGNAL INTELLIGENCE ENGINE",
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
                              Icon(Icons.radar_rounded, size: 14, color: colors.primary),
                              const SizedBox(width: 4),
                              Text(
                                "14 Active Deals",
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
                      "Invest in verified demand, not pitch deck hype.",
                      style: AppTypography.title1.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Monitor live customer willingness-to-pay, pre-orders, hypothesis audits, and peer crucibles across your portfolio radar.",
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Risk / Opportunity alert
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.background.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.insights_rounded, color: colors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "HIGH-CONVICTION BREAKOUT",
                                  style: AppTypography.labelSmall.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "2 startups in your watchlist cleared 85%+ Willingness-To-Pay with 34 verified customer interviews.",
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
                            title: "Explore Deal Flow",
                            action: () => context.push('/explore'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SecondaryButton(
                            title: "Portfolio Health",
                            action: () => context.push('/startup-health'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. INVESTOR METRICS GRID (4 CARDS)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "WATCHLIST",
                      value: "8 Deals",
                      subtitle: "↑ 2 new this wk",
                      icon: Icons.bookmark_added_outlined,
                      accentColor: colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "EVIDENCE",
                      value: "52 Proofs",
                      subtitle: "Interviews & trials",
                      icon: Icons.folder_shared_outlined,
                      accentColor: const Color(0xFF10B981),
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
                      title: "RISK ALERTS",
                      value: "2 Flags",
                      subtitle: "Pricing friction",
                      icon: Icons.warning_amber_rounded,
                      accentColor: const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      colors: colors,
                      title: "AVG TRUTH",
                      value: "84%",
                      subtitle: "Top 10% benchmark",
                      icon: Icons.verified_outlined,
                      accentColor: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. CATEGORY FILTER PILLS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.sm),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = cat == _selectedCategory;
                    return CategoryPill(
                      label: cat,
                      isSelected: isSelected,
                      onTap: () {
                        HapticManager.shared.selection();
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // 5. SECTION: HIGH-SIGNAL WATCHLIST
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
                          "Diligence & Deal Radar",
                          style: AppTypography.title3.copyWith(
                            color: colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Startups meeting verified customer traction thresholds",
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
                      "All Deals",
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

          // 6. WATCHLIST CARDS
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= filteredValidations.length) return null;
                final v = filteredValidations[index];
                return _buildInvestorDealCard(context, colors, v);
              },
              childCount: filteredValidations.length,
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

  Widget _buildInvestorDealCard(
    BuildContext context,
    AppThemeColors colors,
    ValidationRequest v,
  ) {
    // Generate deterministic truth score
    final truthScore = 75 + (v.title.length % 20);

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
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      v.stage.value.toUpperCase(),
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        Text(
                          "$truthScore% TRUTH",
                          style: AppTypography.labelSmall.copyWith(
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.bookmark_border_rounded, size: 20, color: colors.textSecondary),
                    onPressed: () {
                      HapticManager.shared.selection();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Added ${v.title} to your Deal Radar"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
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

              // Evidence signals row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSignalPill(
                      colors,
                      Icons.people_alt_outlined,
                      "${v.responsesCount} Interviews",
                    ),
                    _buildSignalPill(
                      colors,
                      Icons.payments_outlined,
                      "WTP \$${(v.title.length * 3 + 15)}/mo",
                    ),
                    _buildSignalPill(
                      colors,
                      Icons.speed_rounded,
                      "Stage: ${v.stage.value}",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Action row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticManager.shared.impactLight();
                        context.push('/validation-detail/${v.id}');
                      },
                      icon: const Icon(Icons.folder_shared_outlined, size: 16),
                      label: const Text("Evidence Dossier"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticManager.shared.impactLight();
                        context.push('/chat/new');
                      },
                      icon: const Icon(Icons.send_rounded, size: 14),
                      label: const Text("Connect"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildSignalPill(AppThemeColors colors, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: colors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.caption.copyWith(
            color: colors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
