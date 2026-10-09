import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/shared_top_nav_bar.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../models/role_provider.dart';
import '../../repositories/app_providers.dart';
import '../../utils/haptic_manager.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final currentRole = ref.watch(roleProvider);
    final validationsAsync = ref.watch(validationsProvider);

    return Scaffold(
      appBar: const SharedTopNavBar(isHome: true),
      backgroundColor: colors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (DragEndDetails details) {
          // Swipe left-to-right on HOME opens [new validation]
          if ((details.primaryVelocity ?? 0) > 250) {
            HapticManager.shared.impactMedium();
            context.push('/validation-wizard');
          }
        },
        child: RefreshIndicator(
          color: AppPalette.orange,
          onRefresh: () async {
            ref.invalidate(currentUserProvider);
            ref.invalidate(validationsProvider);
          },
          child: switch (currentRole) {
            UserRole.founder => _FounderHomeView(validationsAsync: validationsAsync),
            UserRole.investor => _InvestorHomeView(validationsAsync: validationsAsync),
            UserRole.professional => _ProfessionalHomeView(validationsAsync: validationsAsync),
            UserRole.creator || UserRole.student => _CreatorHomeView(validationsAsync: validationsAsync),
          },
        ),
      ),
    );
  }
}

// ==========================================
// FOUNDER OPERATING SURFACE
// ==========================================
class _FounderHomeView extends ConsumerWidget {
  final AsyncValue<List<ValidationRequest>> validationsAsync;

  const _FounderHomeView({required this.validationsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return validationsAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (validations) {
        // Empty State
        if (validations.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.xxl,
            ),
            children: [
              const SizedBox(height: 60),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppPalette.orange.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppPalette.orange,
                  size: 26,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "Nothing is being\ntested yet.",
                style: AppTypography.h2.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "State the assumption that would be expensive to get wrong. Test it with real people and turn responses into hard evidence.",
                style: AppTypography.subheadline.copyWith(
                  color: colors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 40),
              _PrimaryActionButton(
                label: "Create Validation",
                icon: Icons.add_rounded,
                onTap: () {
                  HapticManager.shared.impactMedium();
                  context.push('/validation-wizard');
                },
              ),
              const SizedBox(height: 12),
              _SecondaryActionButton(
                label: "Explore Validations",
                onTap: () {
                  HapticManager.shared.impactLight();
                  context.go('/explore');
                },
              ),
            ],
          );
        }

        // Active Operating Surface
        final activeValidation = validations.first;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            // CURRENT FOCUS
            const _SectionHeader(
              title: "CURRENT FOCUS",
              trailing: "SPRINT 1",
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppPalette.orange.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            activeValidation.tags.isNotEmpty ? activeValidation.tags.first.toUpperCase() : "HYPOTHESIS",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppPalette.orange,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${activeValidation.responsesCount} RESPONSES",
                        style: AppTypography.labelSmall.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    activeValidation.title,
                    style: AppTypography.title2.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeValidation.problem,
                    style: AppTypography.subheadline.copyWith(
                      color: colors.textSecondary,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 22),
                  _PrimaryActionButton(
                    label: "Review Evidence",
                    icon: Icons.analytics_outlined,
                    onTap: () {
                      HapticManager.shared.impactLight();
                      context.push('/evidence-locker');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sectionGap),

            // LATEST SIGNAL
            const _SectionHeader(title: "LATEST SIGNAL"),
            const SizedBox(height: 12),
            const _SignalRow(
              icon: Icons.trending_up_rounded,
              title: "3 new enterprise validator responses",
              subtitle: "Willingness to pay validated at \$49/seat/mo tier.",
              timeAgo: "2h ago",
            ),
            const SizedBox(height: 8),
            _SignalRow(
              icon: Icons.warning_amber_rounded,
              title: "Contradiction detected in onboarding",
              subtitle: "2 respondents flagged compliance requirements before signup.",
              timeAgo: "5h ago",
              isAlert: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: colors.surface,
                    title: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: colors.warning),
                        const SizedBox(width: 8),
                        Text("Contradiction Signal", style: TextStyle(color: colors.text)),
                      ],
                    ),
                    content: Text(
                      "A contradiction occurs when validator evidence conflicts directly with a core assumption.\n\n"
                      "Why this matters:\n"
                      "Founders often proceed with flawed premises without empirical disproof. This signal highlights where market reality diverges from your thesis so you can investigate before building.",
                      style: AppTypography.body.copyWith(color: colors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Got It"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/evidence-locker');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                        child: const Text("Inspect Evidence"),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.sectionGap),

            // DECISION REQUIRED
            const _SectionHeader(title: "DECISION REQUIRED"),
            const SizedBox(height: 12),
            _ActionRow(
              icon: Icons.psychology_outlined,
              iconColor: colors.warning,
              title: "Pricing Tier Pivot vs Self-Serve",
              subtitle: "Evidence suggests target customers expect annual billing.",
              onTap: () {
                HapticManager.shared.impactLight();
                context.push('/validation-detail/val_auto_inventory');
              },
            ),

            const SizedBox(height: AppSpacing.sectionGap),

            // NEXT EXPERIMENT
            const _SectionHeader(title: "NEXT EXPERIMENT"),
            const SizedBox(height: 12),
            const _ActionRow(
              icon: Icons.science_outlined,
              iconColor: AppPalette.orange,
              title: "Test 5 Enterprise Compliance Objections",
              subtitle: "Run 15-min interview questions on SOC2 readiness.",
            ),
            const SizedBox(height: 40),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppPalette.orange, strokeWidth: 2.5),
      ),
      error: (err, stack) => Center(
        child: Text("Unable to load focus: $err", style: AppTypography.subheadline),
      ),
    );
  }
}

// ==========================================
// INVESTOR OPERATING SURFACE
// ==========================================
class _InvestorHomeView extends StatelessWidget {
  final AsyncValue<List<ValidationRequest>> validationsAsync;

  const _InvestorHomeView({required this.validationsAsync});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        const SizedBox(height: 4),
        Text(
          "What deserves\nyour attention?",
          style: AppTypography.h2.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "High-conviction market signals and real evidence from early-stage founders.",
          style: AppTypography.subheadline.copyWith(color: colors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 28),

        const _SectionHeader(title: "HIGH EVIDENCE CONVICTION"),
        const SizedBox(height: 12),

        validationsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          data: (validations) {
            if (validations.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    "No published validations matching thesis yet.",
                    style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                  ),
                ),
              );
            }

            return Column(
              children: validations.take(3).map((v) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticManager.shared.impactLight();
                        context.push('/validation-detail/${v.id}', extra: v);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  v.tags.isNotEmpty ? v.tags.first.toUpperCase() : "TECH",
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppPalette.orange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "${v.responsesCount} Validators",
                                  style: AppTypography.labelSmall.copyWith(color: colors.textTertiary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              v.title,
                              style: AppTypography.subheadline.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              v.problem,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.footnote.copyWith(
                                color: colors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Inspect Evidence →",
                                style: AppTypography.caption.copyWith(
                                  color: AppPalette.orange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppPalette.orange, strokeWidth: 2.5)),
          error: (_, __) => const SizedBox(),
        ),

        const SizedBox(height: AppSpacing.sectionGap),
        const _SectionHeader(title: "WATCHLIST SIGNALS"),
        const SizedBox(height: 12),
        const _SignalRow(
          icon: Icons.check_circle_outline_rounded,
          title: "SaaS Workflow Tool",
          subtitle: "Completed 20 structured interviews. 85% problem validation rate.",
          timeAgo: "Today",
        ),
      ],
    );
  }
}

// ==========================================
// PROFESSIONAL OPERATING SURFACE
// ==========================================
class _ProfessionalHomeView extends StatelessWidget {
  final AsyncValue<List<ValidationRequest>> validationsAsync;

  const _ProfessionalHomeView({required this.validationsAsync});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        const SizedBox(height: 4),
        Text(
          "Where can your\nexpertise help?",
          style: AppTypography.h2.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Review active founder assumptions and provide structured signal.",
          style: AppTypography.subheadline.copyWith(color: colors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 28),

        const _SectionHeader(title: "VALIDATIONS SEEKING YOUR INPUT"),
        const SizedBox(height: 12),

        validationsAsync.when(
          skipLoadingOnReload: true,
          skipLoadingOnRefresh: true,
          data: (validations) {
            if (validations.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    "No pending requests matching your skills right now.",
                    style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                  ),
                ),
              );
            }

            return Column(
              children: validations.take(3).map((v) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.title,
                        style: AppTypography.subheadline.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v.problem,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 14),
                      _PrimaryActionButton(
                        label: "Give Feedback (3 min)",
                        icon: Icons.rate_review_outlined,
                        onTap: () {
                          HapticManager.shared.impactLight();
                          context.push('/validation-detail/${v.id}', extra: v);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppPalette.orange, strokeWidth: 2.5)),
          error: (_, __) => const SizedBox(),
        ),

        const SizedBox(height: AppSpacing.sectionGap),
        const _SectionHeader(title: "YOUR IMPACT & KARMA"),
        const SizedBox(height: 12),
        const _SignalRow(
          icon: Icons.star_border_rounded,
          title: "Top Contributor in FinTech",
          subtitle: "Your feedback helped 3 founders pivot away from bad assumptions.",
          timeAgo: "This month",
        ),
      ],
    );
  }
}

// ==========================================
// CREATOR OPERATING SURFACE
// ==========================================
class _CreatorHomeView extends StatelessWidget {
  final AsyncValue<List<ValidationRequest>> validationsAsync;

  const _CreatorHomeView({required this.validationsAsync});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        const SizedBox(height: 4),
        Text(
          "Contribution\n& Insights",
          style: AppTypography.h2.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Discover startup patterns, share domain insights, and grow connections.",
          style: AppTypography.subheadline.copyWith(color: colors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 28),

        const _SectionHeader(title: "TRENDING VALIDATION THEMES"),
        const SizedBox(height: 12),
        const _SignalRow(
          icon: Icons.hub_outlined,
          title: "AI Workflows vs Legacy SaaS",
          subtitle: "14 founders testing human-in-the-loop interfaces this week.",
          timeAgo: "Active",
        ),
        const SizedBox(height: 8),
        const _SignalRow(
          icon: Icons.monetization_on_outlined,
          title: "Micro-SaaS Pricing Benchmarks",
          subtitle: "New signals show reluctance toward seat-based pricing.",
          timeAgo: "Active",
        ),
      ],
    );
  }
}

// ==========================================
// PREMIUM DESIGN SYSTEM ATOMS
// ==========================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            color: colors.textTertiary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            fontSize: 11,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTypography.labelSmall.copyWith(
              color: AppPalette.orange,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: AppPalette.orange,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTypography.buttonLabel.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Semantics(
      button: true,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.buttonLabel.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignalRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timeAgo;
  final bool isAlert;
  final VoidCallback? onTap;

  const _SignalRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.isAlert = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final rowContent = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isAlert ? colors.warning.withValues(alpha: 0.10) : AppPalette.orange.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: isAlert ? colors.warning : AppPalette.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.subheadline.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.footnote.copyWith(
                    color: colors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(Icons.info_outline, size: 16, color: colors.textTertiary),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: rowContent,
      );
    }
    return rowContent;
  }
}

/// Reusable action row used for Decision Required, Next Experiment, etc.
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Material(
      color: colors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.subheadline.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right_rounded, size: 18, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
