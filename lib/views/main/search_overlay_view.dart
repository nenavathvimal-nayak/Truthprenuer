import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../utils/haptic_manager.dart';

class SearchOverlayView extends ConsumerStatefulWidget {
  const SearchOverlayView({super.key});

  @override
  ConsumerState<SearchOverlayView> createState() => _SearchOverlayViewState();
}

class _SearchOverlayViewState extends ConsumerState<SearchOverlayView> {
  final TextEditingController _searchCtrl = TextEditingController();
  int _selectedFilterIndex = 0; // 0: All, 1: Validations, 2: People
  final List<String> _filters = ["All", "Validations", "People"];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final query = _searchCtrl.text.trim().toLowerCase();

    // Filtered data
    final filteredValidations = dataStore.validations.where((v) {
      if (query.isEmpty) return true;
      return v.title.toLowerCase().contains(query) ||
          v.problem.toLowerCase().contains(query) ||
          v.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();

    final filteredUsers = dataStore.users.where((u) {
      if (query.isEmpty) return true;
      return u.name.toLowerCase().contains(query) ||
          u.username.toLowerCase().contains(query) ||
          u.role.toLowerCase().contains(query) ||
          u.skills.any((s) => s.toLowerCase().contains(query));
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.text, size: 20),
          onPressed: () {
            HapticManager.shared.impactLight();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          style: AppTypography.body.copyWith(color: colors.text),
          decoration: InputDecoration(
            hintText: "Search ideas, problems, founders...",
            hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
            border: InputBorder.none,
          ),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          if (_searchCtrl.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: colors.textSecondary),
              onPressed: () {
                _searchCtrl.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return ChoiceChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        HapticManager.shared.selection();
                        setState(() => _selectedFilterIndex = index);
                      }
                    },
                    selectedColor: colors.primary,
                    backgroundColor: colors.cardBackground,
                    labelStyle: AppTypography.caption.copyWith(
                      color: isSelected ? Colors.white : colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                        color: isSelected ? colors.primary : colors.border,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),

            // Search Results List
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Suggestions / History if query is empty
                  if (query.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        "POPULAR SEARCHES",
                        style: AppTypography.caption.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dataStore.searchHistory.map((term) {
                        return ActionChip(
                          avatar: Icon(Icons.trending_up, size: 14, color: colors.primary),
                          label: Text(term),
                          labelStyle: AppTypography.caption.copyWith(color: colors.text),
                          backgroundColor: colors.cardBackground,
                          side: BorderSide(color: colors.border),
                          onPressed: () {
                            HapticManager.shared.selection();
                            _searchCtrl.text = term;
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Validations section
                  if (_selectedFilterIndex == 0 || _selectedFilterIndex == 1) ...[
                    if (filteredValidations.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: Text(
                          "Validation Requests (${filteredValidations.length})",
                          style: AppTypography.headline.copyWith(color: colors.text),
                        ),
                      ),
                      ...filteredValidations.map((v) {
                        final author = dataStore.users.firstWhere(
                          (u) => u.id == v.authorId,
                          orElse: () => dataStore.users.first,
                        );
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: colors.cardBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.sm),
                            title: Text(
                              v.title,
                              style: AppTypography.headline.copyWith(color: colors.text),
                            ),
                            subtitle: Text(
                              v.problem,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(color: colors.textSecondary),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${v.upvotes} ▲",
                                style: AppTypography.caption.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              HapticManager.shared.selection();
                              context.push(
                                '/validation-detail',
                                extra: {'validation': v, 'author': author},
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],

                  // Users section
                  if (_selectedFilterIndex == 0 || _selectedFilterIndex == 2) ...[
                    if (filteredUsers.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: Text(
                          "Founders & Builders (${filteredUsers.length})",
                          style: AppTypography.headline.copyWith(color: colors.text),
                        ),
                      ),
                      ...filteredUsers.map((u) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: colors.cardBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            leading: AvatarView(name: u.name, imageURL: u.avatarURL, size: 44),
                            title: Row(
                              children: [
                                Text(u.name, style: AppTypography.headline.copyWith(color: colors.text)),
                                if (u.isVerified) ...[
                                  const SizedBox(width: 4),
                                  Icon(Icons.verified, size: 14, color: colors.info),
                                ],
                              ],
                            ),
                            subtitle: Text(
                              "${u.role} • @${u.username}",
                              style: AppTypography.caption.copyWith(color: colors.textSecondary),
                            ),
                            trailing: Icon(Icons.chevron_right, color: colors.textTertiary),
                            onTap: () {
                              HapticManager.shared.selection();
                              context.push(
                                '/user-profile',
                                extra: {'user': u},
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ],

                  if (filteredValidations.isEmpty && filteredUsers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 48, color: colors.textTertiary),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              "No matching results found",
                              style: AppTypography.headline.copyWith(color: colors.text),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Try searching with different keywords or browse popular tags.",
                              style: AppTypography.caption.copyWith(color: colors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
