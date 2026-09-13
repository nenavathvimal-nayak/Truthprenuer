import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import 'builder_profile_view.dart'; // For ProfileStat

class UserProfileView extends ConsumerWidget {
  final User user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    
    final theirValidations = dataStore.validations.where((v) => v.authorId == user.id).toList();

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
          icon: Icon(Icons.chevron_left, color: colors.text, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                              Text(user.name, style: AppTypography.title3.copyWith(color: colors.text)),
                              if (user.isVerified) ...[
                                const SizedBox(width: 6),
                                Icon(Icons.verified, size: 16, color: colors.info),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text("@${user.username}", style: AppTypography.subheadline.copyWith(color: colors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                            user.bio,
                            style: AppTypography.editorialQuote.copyWith(color: colors.textSecondary),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Stats
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: ProfileStat(value: "${user.validationsCount}", label: "Validations")),
                            Container(width: 1, height: 30, color: colors.border),
                            Expanded(child: ProfileStat(value: "${user.validationsCompleted}", label: "Feedback Given")),
                            Container(width: 1, height: 30, color: colors.border),
                            Expanded(child: ProfileStat(value: "${(user.helpfulnessScore * 100).toStringAsFixed(0)}%", label: "Helpfulness")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

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
                      child: GestureDetector(
                        onTap: () {
                          context.push(
                            '/validation-detail',
                            extra: {
                              'validation': v,
                              'author': user,
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border, width: 1),
                          ),
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
                    );
                  }),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
