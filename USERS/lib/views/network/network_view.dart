import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/shared_top_nav_bar.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../repositories/app_providers.dart';
import '../../utils/haptic_manager.dart';

class NetworkView extends ConsumerStatefulWidget {
  const NetworkView({super.key});

  @override
  ConsumerState<NetworkView> createState() => _NetworkViewState();
}

class _NetworkViewState extends ConsumerState<NetworkView> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedRole = "All";
  final List<String> _roles = ["All", "Founder", "Investor", "Professional", "Creator"];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final allUsers = ref.watch(communityUsersProvider);
    final query = _searchCtrl.text.trim().toLowerCase();

    var filtered = allUsers;
    if (_selectedRole != "All") {
      filtered = filtered.where((u) => u.role.toLowerCase() == _selectedRole.toLowerCase()).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((u) =>
        u.name.toLowerCase().contains(query) ||
        u.skills.any((s) => s.toLowerCase().contains(query)) ||
        u.bio.toLowerCase().contains(query)
      ).toList();
    }

    return Scaffold(
      appBar: const SharedTopNavBar(title: "Network"),
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar — borderless
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 0),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                style: AppTypography.body.copyWith(color: colors.text, fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Search people by name, role, or expertise...",
                  hintStyle: AppTypography.subheadline.copyWith(color: colors.textTertiary),
                  prefixIcon: Icon(Icons.search, size: 20, color: colors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),

          // Role Filter Pills — borderless
          Container(
            height: 34,
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              scrollDirection: Axis.horizontal,
              itemCount: _roles.length,
              itemBuilder: (context, index) {
                final role = _roles[index];
                final isSelected = _selectedRole == role;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticManager.shared.selection();
                      setState(() => _selectedRole = role);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? AppPalette.orange.withValues(alpha: 0.12) : colors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        role,
                        style: AppTypography.caption.copyWith(
                          color: isSelected ? AppPalette.orange : colors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Person List
          Expanded(
            child: RefreshIndicator(
              color: AppPalette.orange,
              onRefresh: () async {
                ref.invalidate(realCommunityUsersProvider);
                ref.invalidate(communityUsersProvider);
                await Future.delayed(const Duration(milliseconds: 50));
              },
              child: filtered.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline_rounded, size: 40, color: colors.textTertiary),
                                const SizedBox(height: 16),
                                Text(
                                  "No people found",
                                  style: AppTypography.title3.copyWith(color: colors.text, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Try adjusting your search query or role filter.",
                                  style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 600;
                        if (isWide) {
                          return GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xs),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 165,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final person = filtered[index];
                              return _PersonCard(person: person);
                            },
                          );
                        }
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xs),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final person = filtered[index];
                            return _PersonCard(person: person);
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonCard extends StatefulWidget {
  final User person;

  const _PersonCard({required this.person});

  @override
  State<_PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<_PersonCard> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final person = widget.person;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticManager.shared.impactLight();
            context.push('/user-profile', extra: person);
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppPalette.orange.withValues(alpha: 0.10),
                child: Text(
                  person.name[0],
                  style: const TextStyle(color: AppPalette.orange, fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            person.name,
                            style: AppTypography.subheadline.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (person.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: AppPalette.orange),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      person.role,
                      style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // Connect button — filled or outlined based on state
              Material(
                color: _isConnected ? Colors.transparent : AppPalette.orange,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    HapticManager.shared.impactLight();
                    setState(() => _isConnected = !_isConnected);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: _isConnected
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.textTertiary.withValues(alpha: 0.4)),
                          )
                        : null,
                    child: Text(
                      _isConnected ? "Requested" : "Connect",
                      style: AppTypography.caption.copyWith(
                        color: _isConnected ? colors.textTertiary : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            person.bio,
            style: AppTypography.footnote.copyWith(color: colors.textSecondary, height: 1.35),
          ),
          if (person.skills.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: person.skills.take(3).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    skill,
                    style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 10),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    ),
  ),
),
);
  }
}
