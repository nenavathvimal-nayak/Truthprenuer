import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/category_pill.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class NetworkView extends ConsumerStatefulWidget {
  const NetworkView({super.key});

  @override
  ConsumerState<NetworkView> createState() => _NetworkViewState();
}

class _NetworkViewState extends ConsumerState<NetworkView> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchText = "";
  String _selectedRole = "All";
  final List<String> _roles = ["All", "Founder", "Validator", "Mentor", "Investor", "Builder"];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final currentUser = dataStore.currentUser;
    
    var filteredUsers = dataStore.users.where((u) => u.id != currentUser?.id).toList();

    // Apply role filter
    if (_selectedRole != "All") {
      filteredUsers = filteredUsers.where((u) {
        return u.role.toLowerCase().contains(_selectedRole.toLowerCase());
      }).toList();
    }

    // Apply search filter
    if (_searchText.isNotEmpty) {
      final query = _searchText.toLowerCase();
      filteredUsers = filteredUsers.where((u) {
        return u.name.toLowerCase().contains(query) ||
            u.role.toLowerCase().contains(query) ||
            u.skills.any((s) => s.toLowerCase().contains(query));
      }).toList();
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Founder Network",
                      style: AppTypography.h1.copyWith(color: colors.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Connect with builders, validators, and mentors",
                      style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                child: CustomTextField(
                  controller: _searchCtrl,
                  placeholder: "Search by name, role, or skill...",
                  icon: Icons.search,
                  onChanged: (val) {
                    setState(() => _searchText = val);
                  },
                ),
              ),
            ),

            // Role filter chips
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                child: Row(
                  children: _roles.map((role) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryPill(
                      label: role,
                      isSelected: _selectedRole == role,
                      onTap: () {
                        setState(() => _selectedRole = role);
                        HapticManager.shared.selection();
                      },
                    ),
                  )).toList(),
                ),
              ),
            ),

            // Results count
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
                child: Text(
                  "${filteredUsers.length} founders",
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
              ),
            ),

            // User list or empty state
            if (filteredUsers.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Column(
                    children: [
                      Icon(Icons.group_off, size: 40, color: colors.textTertiary),
                      const SizedBox(height: AppSpacing.sm),
                      Text("No founders found", style: AppTypography.title3.copyWith(color: colors.text)),
                      const SizedBox(height: 4),
                      Text("Try a different search or filter.", style: AppTypography.body.copyWith(color: colors.textSecondary)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final user = filteredUsers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _UserCard(
                          user: user,
                          onTap: () {
                            context.push('/user-profile', extra: {'user': user});
                          },
                          onMessage: () {
                            HapticManager.shared.impactLight();
                            final conv = ref.read(mockDataStoreProvider).getOrCreateConversation(user.id);
                            context.push('/chat-room', extra: {
                              'conversation': conv,
                              'otherUser': user,
                            });
                          },
                          onConnect: () {
                            HapticManager.shared.impactLight();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Connection request sent to ${user.name}"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: colors.cardBackground,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
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

class _UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onMessage;
  final VoidCallback onConnect;

  const _UserCard({
    required this.user,
    required this.onTap,
    required this.onMessage,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              children: [
                AvatarView(name: user.name, imageURL: user.avatarURL, size: 48),
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: AppTypography.bodyMedium.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
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
                      if (user.skills.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.skills.take(3).join(" · "),
                          style: AppTypography.caption.copyWith(
                            color: colors.primary,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Stats
                _StatChip(
                  label: "${user.validationsCompleted} validated",
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: "${(user.helpfulnessScore * 100).toStringAsFixed(0)}% helpful",
                  color: colors.primary,
                ),
                const Spacer(),
                // Action buttons
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  onTap: onMessage,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onConnect,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Connect",
                      style: AppTypography.caption.copyWith(
                        color: colors.textInverted,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.divider.withAlpha(80),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colors.divider.withAlpha(80),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
