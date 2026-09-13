import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/avatar_picker_modal.dart';
import '../../components/tag_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';
import 'gamification_hub_view.dart';

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
          style: AppTypography.title3.copyWith(
            color: colors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class BuilderProfileView extends ConsumerStatefulWidget {
  const BuilderProfileView({super.key});

  @override
  ConsumerState<BuilderProfileView> createState() => _BuilderProfileViewState();
}

class _BuilderProfileViewState extends ConsumerState<BuilderProfileView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final user = dataStore.currentUser ??
        dataStore.users.firstWhere(
          (u) => u.id == "me",
          orElse: () => dataStore.users.isNotEmpty
              ? dataStore.users.first
              : User(
                  id: "me",
                  name: "Jane Designer",
                  username: "jane_ui",
                  bio: "UX Architect & Product Thinker",
                  role: "UX Architect",
                  skills: ["UX", "Research"],
                  location: "New York, NY",
                  joinedDate: DateTime.now(),
                ),
        );

    final myValidations =
        dataStore.validations.where((v) => v.authorId == user.id).toList();
    final myPosts =
        dataStore.posts.where((p) => p.authorId == user.id).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          "My Profile",
          style: AppTypography.appBarTitle.copyWith(color: colors.text),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.military_tech_outlined, color: colors.warning),
            tooltip: "Gamification & Badges",
            onPressed: () {
              HapticManager.shared.impactLight();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GamificationHubView(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.text),
            tooltip: "Settings",
            onPressed: () {
              HapticManager.shared.impactLight();
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            HapticManager.shared.impactLight();
                            AvatarPickerModal.show(context);
                          },
                          child: Stack(
                            children: [
                              AvatarView(
                                name: user.name,
                                imageURL: user.avatarURL,
                                size: 88,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colors.background,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: AppTypography.title2.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.verified, size: 18, color: colors.info),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "@${user.username} • ${user.role}",
                        style: AppTypography.subheadline.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      if (user.location.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: colors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              user.location,
                              style: AppTypography.caption.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (user.bio.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          user.bio,
                          style: AppTypography.body.copyWith(
                            color: colors.text,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ],
                      if (user.skills.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: user.skills.map<Widget>((skill) {
                            return TagView(title: skill);
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),

                      // Edit Profile & Share Row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                HapticManager.shared.impactLight();
                                context.push('/edit-profile');
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colors.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.sm,
                                ),
                              ),
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: colors.text,
                              ),
                              label: Text(
                                "Edit Profile",
                                style: AppTypography.headline.copyWith(
                                  color: colors.text,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          OutlinedButton(
                            onPressed: () {
                              HapticManager.shared.selection();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Profile link copied to clipboard!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(AppSpacing.sm),
                            ),
                            child: Icon(
                              Icons.share_outlined,
                              size: 18,
                              color: colors.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Stats Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                          horizontal: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ProfileStat(
                                value: "${user.validationsCount}",
                                label: "Validations",
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: colors.divider,
                            ),
                            Expanded(
                              child: ProfileStat(
                                value: "${user.validationsCompleted}",
                                label: "Feedback Given",
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: colors.divider,
                            ),
                            Expanded(
                              child: ProfileStat(
                                value:
                                    "${(user.helpfulnessScore * 100).toStringAsFixed(0)}%",
                                label: "Helpfulness",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Tabs
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      _TabItem(
                        title: "Validations (${myValidations.length})",
                        isSelected: _selectedTab == 0,
                        onTap: () {
                          setState(() => _selectedTab = 0);
                          HapticManager.shared.selection();
                        },
                      ),
                      _TabItem(
                        title: "Posts (${myPosts.length})",
                        isSelected: _selectedTab == 1,
                        onTap: () {
                          setState(() => _selectedTab = 1);
                          HapticManager.shared.selection();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  color: colors.divider,
                ),
                const SizedBox(height: AppSpacing.md),

                // Tab Content
                if (_selectedTab == 0) ...[
                  if (myValidations.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 48,
                              color: colors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              "No Validations Yet",
                              style: AppTypography.headline.copyWith(
                                color: colors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Create a new validation to get feedback from the community and AI.",
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...myValidations.map((v) {
                      final categoryText =
                          v.tags.isNotEmpty ? v.tags.first : "Validation";
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.sm,
                        ),
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
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colors.border.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primary.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        categoryText,
                                        style: AppTypography.caption.copyWith(
                                          color: colors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      v.createdAt.timeAgoDisplay,
                                      style: AppTypography.caption.copyWith(
                                        color: colors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  v.title,
                                  style: AppTypography.headline.copyWith(
                                    color: colors.text,
                                  ),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  v.problem,
                                  style: AppTypography.caption.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.thumb_up_alt_outlined,
                                      size: 14,
                                      color: colors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${v.upvotes}",
                                      style: AppTypography.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 14,
                                      color: colors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${v.commentsCount} comments",
                                      style: AppTypography.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ] else ...[
                  if (myPosts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 48,
                              color: colors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              "No Community Posts Yet",
                              style: AppTypography.headline.copyWith(
                                color: colors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Share your startup updates, lessons, and milestones.",
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...myPosts.map((p) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.sm,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.cardBackground,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colors.border.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                style: AppTypography.headline.copyWith(
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.body,
                                style: AppTypography.body.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    p.createdAt.timeAgoDisplay,
                                    style: AppTypography.caption.copyWith(
                                      color: colors.textTertiary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        size: 14,
                                        color: colors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${p.likes}",
                                        style: AppTypography.caption.copyWith(
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              Text(
                title,
                style: AppTypography.headline.copyWith(
                  color: isSelected ? colors.primary : colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                height: 2,
                color: isSelected ? colors.primary : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
