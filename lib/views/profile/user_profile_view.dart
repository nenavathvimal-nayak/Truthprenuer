import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../repositories/app_providers.dart';

class UserProfileView extends ConsumerWidget {
  final User user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final validations = ref.watch(validationsProvider).value ?? [];
    
    final theirValidations = validations.where((v) => v.authorId == user.id).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          user.name,
          style: AppTypography.appBarTitle.copyWith(color: colors.text),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: colors.text, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: colors.primary,
          backgroundColor: colors.cardBackground,
          onRefresh: () async {
            ref.invalidate(validationsProvider);
            await Future.delayed(const Duration(milliseconds: 300));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        AvatarView(name: user.name, imageURL: user.avatarURL, size: 80),
                        const SizedBox(height: AppSpacing.md),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    user.name,
                                    style: AppTypography.title3.copyWith(color: colors.text),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (user.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, size: 16, color: AppPalette.orange),
                                ],
                              ],
                            ),
                          const SizedBox(height: 4),
                          Text("@${user.username}", style: AppTypography.subheadline.copyWith(color: colors.textSecondary)),
                          if (user.bio.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              user.bio,
                              style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Stats — borderless surface
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: ProfileStat(value: "${user.validationsCount}", label: "Validations")),
                            Container(width: 1, height: 26, color: colors.divider),
                            Expanded(child: ProfileStat(value: "${user.validationsCompleted}", label: "Feedback Given")),
                            Container(width: 1, height: 26, color: colors.divider),
                            Expanded(child: ProfileStat(value: "${(user.helpfulnessScore * 100).toStringAsFixed(0)}%", label: "Helpfulness")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Validations
                if (theirValidations.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Validations", style: AppTypography.title4.copyWith(color: colors.text)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...theirValidations.map((v) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                      child: Material(
                        color: colors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            context.push(
                              '/validation-detail/${v.id}',
                              extra: v,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v.title, style: AppTypography.headline.copyWith(color: colors.text), maxLines: 2),
                                const SizedBox(height: 4),
                                Text(v.problem, style: AppTypography.caption.copyWith(color: colors.textSecondary), maxLines: 2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.headline.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: colors.textTertiary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
