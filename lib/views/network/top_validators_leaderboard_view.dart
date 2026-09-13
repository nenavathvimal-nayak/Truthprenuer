import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class TopValidatorsLeaderboardView extends ConsumerStatefulWidget {
  const TopValidatorsLeaderboardView({super.key});

  @override
  ConsumerState<TopValidatorsLeaderboardView> createState() => _TopValidatorsLeaderboardViewState();
}

class _TopValidatorsLeaderboardViewState extends ConsumerState<TopValidatorsLeaderboardView> {
  String _selectedDiscipline = "All";
  final List<String> _disciplines = ["All", "Product", "GTM & Growth", "Engineering", "Fundraising"];

  void _requestAudit(BuildContext context, User validator, AppThemeColors colors) {
    HapticManager.shared.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _RequestAuditModal(validator: validator),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);

    // Sort users by validations completed and helpfulness
    final sortedUsers = List<User>.from(dataStore.users)
      ..sort((a, b) {
        final scoreA = a.validationsCompleted * 10 + (a.helpfulnessScore * 10).toInt();
        final scoreB = b.validationsCompleted * 10 + (b.helpfulnessScore * 10).toInt();
        return scoreB.compareTo(scoreA);
      });

    final filteredUsers = sortedUsers.where((u) {
      if (_selectedDiscipline == "All") return true;
      final skills = u.skills.map((s) => s.toLowerCase()).toList();
      if (_selectedDiscipline == "Product") return skills.any((s) => s.contains("product") || s.contains("ux") || s.contains("vision"));
      if (_selectedDiscipline == "GTM & Growth") return skills.any((s) => s.contains("growth") || s.contains("gtm") || s.contains("marketing"));
      if (_selectedDiscipline == "Engineering") return skills.any((s) => s.contains("tech") || s.contains("engineering") || s.contains("ai"));
      if (_selectedDiscipline == "Fundraising") return skills.any((s) => s.contains("fundraising") || s.contains("investing") || s.contains("venture"));
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.text, size: 20),
          onPressed: () {
            HapticManager.shared.lightImpact();
            context.pop();
          },
        ),
        title: Text(
          "Validator Leaderboard",
          style: AppTypography.appBarTitle.copyWith(color: colors.text),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.gold.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.workspace_premium, color: colors.gold, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Truth Score™ Rankings",
                              style: AppTypography.headline.copyWith(color: colors.text),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Top peer builders and operators offering high-signal validation reviews.",
                              style: AppTypography.footnote.copyWith(color: colors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Discipline Filter Pills
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                child: Row(
                  children: _disciplines.map((disc) {
                    final isSelected = _selectedDiscipline == disc;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: GestureDetector(
                        onTap: () {
                          HapticManager.shared.selection();
                          setState(() => _selectedDiscipline = disc);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.cardBackground,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            disc,
                            style: AppTypography.caption.copyWith(
                              color: isSelected ? Colors.white : colors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Leaderboard List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final user = filteredUsers[index];
                    final rank = index + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _LeaderboardCard(
                        rank: rank,
                        user: user,
                        onRequestAudit: () => _requestAudit(context, user, colors),
                      ),
                    );
                  },
                  childCount: filteredUsers.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final int rank;
  final User user;
  final VoidCallback onRequestAudit;

  const _LeaderboardCard({
    required this.rank,
    required this.user,
    required this.onRequestAudit,
  });

  Color _rankColor(int rank, AppThemeColors colors) {
    if (rank == 1) return colors.gold;
    if (rank == 2) return const Color(0xFFC0C0C0); // Silver
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return colors.textTertiary;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final rColor = _rankColor(rank, colors);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: rank <= 3 ? rColor.withAlpha(30) : colors.cardBackgroundLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "#$rank",
                  style: AppTypography.caption.copyWith(
                    color: rank <= 3 ? rColor : colors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AvatarView(name: user.name, imageURL: user.avatarURL, size: 44),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.name,
                            style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified, size: 14, color: colors.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.role,
                      style: AppTypography.caption.copyWith(color: colors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Trust Score Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.evidenceGreen.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 12, color: colors.evidenceGreen),
                    const SizedBox(width: 3),
                    Text(
                      "${(user.helpfulnessScore * 100).toInt()}%",
                      style: AppTypography.caption.copyWith(
                        color: colors.evidenceGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: colors.divider, height: 1, thickness: 0.5),
          const SizedBox(height: AppSpacing.sm),
          // Skills & Action Row
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: user.skills.take(2).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.cardBackgroundLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        skill,
                        style: AppTypography.caption.copyWith(color: colors.textSecondary, fontSize: 10),
                      ),
                    );
                  }).toList(),
                ),
              ),
              GestureDetector(
                onTap: onRequestAudit,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 13, color: colors.primary),
                      const SizedBox(width: 4),
                      Text(
                        "Request Review",
                        style: AppTypography.caption.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestAuditModal extends StatefulWidget {
  final User validator;

  const _RequestAuditModal({required this.validator});

  @override
  State<_RequestAuditModal> createState() => _RequestAuditModalState();
}

class _RequestAuditModalState extends State<_RequestAuditModal> {
  final _messageController = TextEditingController();
  bool _isSending = false;
  bool _sent = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendRequest() async {
    setState(() => _isSending = true);
    HapticManager.shared.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _sent = true;
    });
    HapticManager.shared.success();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                AvatarView(name: widget.validator.name, imageURL: widget.validator.avatarURL, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Request Review from ${widget.validator.name}",
                        style: AppTypography.title3.copyWith(color: colors.text, fontSize: 16),
                      ),
                      Text(
                        widget.validator.role,
                        style: AppTypography.caption.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "SPECIFIC FEEDBACK QUESTIONS",
              style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 3,
              style: TextStyle(color: colors.text),
              decoration: InputDecoration(
                hintText: "What critical assumptions or risks would you like ${widget.validator.name.split(' ').first} to stress-test?",
                hintStyle: TextStyle(color: colors.textTertiary),
                filled: true,
                fillColor: colors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_sent)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.evidenceGreen.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: colors.evidenceGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Request sent! ${widget.validator.name} typically responds within 24 hours.",
                        style: AppTypography.caption.copyWith(color: colors.evidenceGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            else
              GestureDetector(
                onTap: _isSending ? null : _sendRequest,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : Text(
                          "Send Review Request",
                          style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
