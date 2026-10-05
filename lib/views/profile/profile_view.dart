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

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final userAsync = ref.watch(currentUserProvider);
    final currentRole = ref.watch(roleProvider);
    final validationsAsync = ref.watch(validationsProvider);

    return Scaffold(
      appBar: const SharedTopNavBar(title: "Profile"),
      backgroundColor: colors.background,
      body: RefreshIndicator(
        color: AppPalette.orange,
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          ref.invalidate(validationsProvider);
        },
        child: userAsync.when(
          data: (user) {
            final displayUser = user ?? User(
              id: "dev_user",
              name: "Alex Vimal",
              username: "alexvimal",
              bio: "Building AI-driven B2B operating systems. Ex-FinTech product lead.",
              role: currentRole.label,
            );

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              // Header — borderless
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
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppPalette.orange.withValues(alpha: 0.12),
                          child: Text(
                            displayUser.name.isNotEmpty ? displayUser.name[0] : "U",
                            style: const TextStyle(
                              color: AppPalette.orange,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayUser.name,
                                      style: AppTypography.title2.copyWith(
                                        color: colors.text,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 16, color: AppPalette.orange),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "@${displayUser.username}",
                                style: AppTypography.footnote.copyWith(color: colors.textTertiary),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppPalette.orange.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  currentRole.label.toUpperCase(),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppPalette.orange,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayUser.bio,
                      style: AppTypography.subheadline.copyWith(
                        color: colors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: AppPalette.orange,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {
                                HapticManager.shared.impactLight();
                                context.push('/edit-profile');
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 42,
                                alignment: Alignment.center,
                                child: Text(
                                  "Edit Profile",
                                  style: AppTypography.buttonLabel.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Material(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              HapticManager.shared.impactLight();
                              context.push('/settings');
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Semantics(
                              label: "Settings",
                              button: true,
                              child: const SizedBox(
                                width: 42,
                                height: 42,
                                child: Icon(Icons.settings_outlined, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // Role Switcher — borderless segmented
              const _SectionLabel("ACTIVE ROLE PERSPECTIVE"),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    UserRole.founder,
                    UserRole.investor,
                    UserRole.professional,
                    UserRole.creator,
                  ].map((role) {
                    final isSelected = currentRole == role;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticManager.shared.selection();
                          ref.read(roleProvider.notifier).switchRole(role);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSelected ? AppPalette.orange : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              role.label,
                              style: TextStyle(
                                color: isSelected ? Colors.white : colors.textTertiary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // Expertise
              const _SectionLabel("DOMAIN EXPERTISE"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ["Product Strategy", "B2B SaaS", "User Research", "Market Validation", "Pricing Models"].map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      skill,
                      style: AppTypography.caption.copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // Validations
              const _SectionLabel("ACTIVE VALIDATION SPRINTS"),
              const SizedBox(height: 10),
              validationsAsync.when(
                data: (validations) {
                  if (validations.isEmpty) {
                    return Text(
                      "No active validations.",
                      style: AppTypography.subheadline.copyWith(color: colors.textTertiary),
                    );
                  }
                  return Column(
                    children: validations.take(2).map((v) {
                      return Material(
                        color: colors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            HapticManager.shared.impactLight();
                            context.push('/validation-detail/${v.id}', extra: v);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const Icon(Icons.verified, size: 20, color: AppPalette.orange),
                                const SizedBox(width: 12),
                                Expanded(
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
                                      const SizedBox(height: 2),
                                      Text(
                                        "${v.responsesCount} verified responses collected",
                                        style: AppTypography.caption.copyWith(color: colors.textTertiary),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, size: 18, color: colors.textTertiary),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppPalette.orange, strokeWidth: 2.5)),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    ),
  );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Text(
      label,
      style: AppTypography.labelSmall.copyWith(
        color: colors.textTertiary,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        fontSize: 11,
      ),
    );
  }
}
