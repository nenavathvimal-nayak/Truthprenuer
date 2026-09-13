import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/category_pill.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedIndustry = "All Industries";
  final List<String> _filterOptions = [
    "All Industries",
    "SaaS",
    "HealthTech",
    "B2B",
    "FinTech",
    "AI",
    "Marketplace",
  ];

  String _selectedStage = "All Stages";
  String _selectedSort = "Trending";
  bool _onlyNeedsFeedback = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_selectedStage != "All Stages") count++;
    if (_selectedSort != "Trending") count++;
    if (_onlyNeedsFeedback) count++;
    return count;
  }

  void _openFilterModal(BuildContext context, AppThemeColors colors) {
    HapticManager.shared.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ExploreFilterModal(
        initialStage: _selectedStage,
        initialSort: _selectedSort,
        initialOnlyNeedsFeedback: _onlyNeedsFeedback,
        onApply: (stage, sort, onlyFeedback) {
          setState(() {
            _selectedStage = stage;
            _selectedSort = sort;
            _onlyNeedsFeedback = onlyFeedback;
          });
        },
      ),
    );
  }

  void _openValidatorQuickAction(BuildContext context, User validator, AppThemeColors colors) {
    HapticManager.shared.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ValidatorQuickSheet(validator: validator),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final query = _searchCtrl.text.trim().toLowerCase();

    List<ValidationRequest> filteredValidations = List<ValidationRequest>.from(dataStore.validations);

    // 1. Filter by Industry
    if (_selectedIndustry != "All Industries") {
      filteredValidations = filteredValidations.where((v) {
        final matchesTags = v.tags.any((t) => t.toLowerCase() == _selectedIndustry.toLowerCase());
        final matchesText = v.problem.toLowerCase().contains(_selectedIndustry.toLowerCase()) ||
            v.title.toLowerCase().contains(_selectedIndustry.toLowerCase());
        return matchesTags || matchesText;
      }).toList();
    }

    // 2. Filter by Stage
    if (_selectedStage != "All Stages") {
      filteredValidations = filteredValidations.where((v) {
        return v.stage.value.toLowerCase() == _selectedStage.toLowerCase();
      }).toList();
    }

    // 3. Needs Feedback Toggle
    if (_onlyNeedsFeedback) {
      filteredValidations = filteredValidations.where((v) => v.needsFeedback).toList();
    }

    // 4. Search Query
    if (query.isNotEmpty) {
      filteredValidations = filteredValidations.where((v) {
        return v.title.toLowerCase().contains(query) ||
            v.problem.toLowerCase().contains(query) ||
            v.tags.any((t) => t.toLowerCase().contains(query));
      }).toList();
    }

    // 5. Sort Order
    if (_selectedSort == "Most Recent") {
      filteredValidations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_selectedSort == "Most Upvoted") {
      filteredValidations.sort((a, b) => b.upvotes.compareTo(a.upvotes));
    } else if (_selectedSort == "Needs Feedback (Urgent)") {
      filteredValidations.sort((a, b) => (b.needsFeedback ? 1 : 0).compareTo(a.needsFeedback ? 1 : 0));
    }

    // Top 5 Validators for Discovery Rail
    final topValidators = List<User>.from(dataStore.users)
      ..sort((a, b) => b.validationsCompleted.compareTo(a.validationsCompleted));

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discovery Engine",
                          style: AppTypography.h1.copyWith(color: colors.text),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Explore verified assumptions and startup signals",
                          style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticManager.shared.lightImpact();
                        context.push('/top-validators');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.leaderboard_outlined, color: colors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. SEARCH BAR & MULTI-DIMENSIONAL FILTER TUNE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: colors.textSecondary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                onChanged: (_) => setState(() {}),
                                style: AppTypography.body.copyWith(
                                  color: colors.text,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search ideas, validations, people...",
                                  hintStyle: AppTypography.body.copyWith(
                                    color: colors.textTertiary,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            if (_searchCtrl.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchCtrl.clear();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.close, color: colors.textSecondary, size: 18),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => _openFilterModal(context, colors),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _activeFiltersCount > 0 ? colors.primary : colors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.tune,
                              color: _activeFiltersCount > 0 ? Colors.white : colors.textSecondary,
                              size: 20,
                            ),
                            if (_activeFiltersCount > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "$_activeFiltersCount",
                                    style: TextStyle(
                                      color: colors.primary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. TOP VALIDATORS DISCOVERY RAIL
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.workspace_premium, size: 16, color: colors.gold),
                              const SizedBox(width: 6),
                              Text(
                                "Top Validators",
                                style: AppTypography.headline.copyWith(color: colors.text, fontSize: 13),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticManager.shared.lightImpact();
                              context.push('/top-validators');
                            },
                            child: Text(
                              "Rankings →",
                              style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        children: topValidators.take(5).map((validator) {
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: GestureDetector(
                              onTap: () => _openValidatorQuickAction(context, validator, colors),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: colors.cardBackground,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    AvatarView(name: validator.name, imageURL: validator.avatarURL, size: 36),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              validator.name.split(' ').first,
                                              style: AppTypography.caption.copyWith(
                                                color: colors.text,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (validator.isVerified) ...[
                                              const SizedBox(width: 3),
                                              Icon(Icons.verified, size: 12, color: colors.primary),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "★ ${(validator.helpfulnessScore * 100).toInt()}% Helpful",
                                          style: AppTypography.caption.copyWith(
                                            color: colors.evidenceGreen,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. INDUSTRY CATEGORY PILLS
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: _filterOptions.map((option) {
                      final isSelected = _selectedIndustry == option;
                      return CategoryPill(
                        label: option,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedIndustry = option;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // 5. VALIDATIONS FEED
            if (filteredValidations.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 44, color: colors.textTertiary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        "No matching validations found",
                        style: AppTypography.title3.copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Try clearing filters or changing keywords.",
                        style: AppTypography.caption.copyWith(color: colors.textTertiary),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final validation = filteredValidations[index];
                      final author = dataStore.users.firstWhere(
                        (u) => u.id == validation.authorId,
                        orElse: () => dataStore.currentUser ?? dataStore.users.first,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: GestureDetector(
                          onTap: () {
                            HapticManager.shared.lightImpact();
                            context.push(
                              '/validation-detail',
                              extra: {
                                'validation': validation,
                                'author': author,
                              },
                            );
                          },
                          child: _PremiumCard(
                            validation: validation,
                            author: author,
                            onBookmarkToggle: () {
                              dataStore.toggleBookmark(validation.id);
                            },
                          ),
                        ),
                      );
                    },
                    childCount: filteredValidations.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final ValidationRequest validation;
  final User author;
  final VoidCallback onBookmarkToggle;

  const _PremiumCard({
    required this.validation,
    required this.author,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                AvatarView(name: author.name, imageURL: author.avatarURL, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              author.name,
                              style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (author.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.verified, size: 13, color: colors.primary),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        author.role,
                        style: AppTypography.caption.copyWith(color: colors.textSecondary, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Stage Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    validation.stage.value.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 9.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title & Problem
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  validation.title,
                  style: AppTypography.title3.copyWith(color: colors.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  validation.problem,
                  style: AppTypography.body.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Tags Row
          if (validation.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: validation.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.cardBackgroundLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "#$tag",
                      style: AppTypography.caption.copyWith(
                        color: colors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: AppSpacing.sm),

          // Bottom Action / Telemetry Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackgroundLight,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Row(
              children: [
                // Upvotes
                Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 15, color: colors.primary),
                    const SizedBox(width: 4),
                    Text(
                      "${validation.upvotes}",
                      style: AppTypography.caption.copyWith(color: colors.text, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                // Feedback count
                Row(
                  children: [
                    Icon(Icons.rate_review_outlined, size: 15, color: colors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      "${validation.feedbackCount} reviews",
                      style: AppTypography.caption.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
                const Spacer(),
                // Bookmark Toggle
                GestureDetector(
                  onTap: () {
                    HapticManager.shared.lightImpact();
                    onBookmarkToggle();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      validation.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      size: 20,
                      color: validation.isBookmarked ? colors.primary : colors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreFilterModal extends StatefulWidget {
  final String initialStage;
  final String initialSort;
  final bool initialOnlyNeedsFeedback;
  final Function(String stage, String sort, bool onlyFeedback) onApply;

  const _ExploreFilterModal({
    required this.initialStage,
    required this.initialSort,
    required this.initialOnlyNeedsFeedback,
    required this.onApply,
  });

  @override
  State<_ExploreFilterModal> createState() => _ExploreFilterModalState();
}

class _ExploreFilterModalState extends State<_ExploreFilterModal> {
  late String _stage;
  late String _sort;
  late bool _onlyFeedback;

  final List<String> _stages = ["All Stages", "Idea", "Prototype", "MVP", "Launched", "Growing"];
  final List<String> _sortOptions = ["Trending", "Most Recent", "Most Upvoted", "Needs Feedback (Urgent)"];

  @override
  void initState() {
    super.initState();
    _stage = widget.initialStage;
    _sort = widget.initialSort;
    _onlyFeedback = widget.initialOnlyNeedsFeedback;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discovery Filters", style: AppTypography.title3.copyWith(color: colors.text)),
                GestureDetector(
                  onTap: () {
                    HapticManager.shared.selection();
                    setState(() {
                      _stage = "All Stages";
                      _sort = "Trending";
                      _onlyFeedback = false;
                    });
                  },
                  child: Text("Reset", style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stage Filter
            Text("STARTUP STAGE", style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _stages.map((stage) {
                final isSelected = _stage == stage;
                return GestureDetector(
                  onTap: () {
                    HapticManager.shared.selection();
                    setState(() => _stage = stage);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primary : colors.cardBackground,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      stage,
                      style: AppTypography.caption.copyWith(
                        color: isSelected ? Colors.white : colors.text,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Sort Order
            Text("SORT ORDER", style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sortOptions.map((sort) {
                final isSelected = _sort == sort;
                return GestureDetector(
                  onTap: () {
                    HapticManager.shared.selection();
                    setState(() => _sort = sort);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primary : colors.cardBackground,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      sort,
                      style: AppTypography.caption.copyWith(
                        color: isSelected ? Colors.white : colors.text,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Urgent Feedback Switch
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text("Needs Feedback Only", style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14)),
              subtitle: Text("Prioritize projects urgently looking for validation reviews", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              value: _onlyFeedback,
              activeTrackColor: colors.primary,
              onChanged: (val) {
                HapticManager.shared.selection();
                setState(() => _onlyFeedback = val);
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // Apply Button
            GestureDetector(
              onTap: () {
                HapticManager.shared.success();
                widget.onApply(_stage, _sort, _onlyFeedback);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text("Apply Filters", style: AppTypography.buttonLabel.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidatorQuickSheet extends StatelessWidget {
  final User validator;

  const _ValidatorQuickSheet({required this.validator});

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
              AvatarView(name: validator.name, imageURL: validator.avatarURL, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(validator.name, style: AppTypography.title3.copyWith(color: colors.text)),
                        if (validator.isVerified) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified, size: 16, color: colors.primary),
                        ],
                      ],
                    ),
                    Text(validator.role, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(validator.bio, style: AppTypography.body.copyWith(color: colors.text, height: 1.4)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticManager.shared.lightImpact();
                    Navigator.pop(context);
                    context.push('/top-validators');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text("View Rankings", style: AppTypography.buttonLabel.copyWith(color: colors.text)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticManager.shared.mediumImpact();
                    Navigator.pop(context);
                    context.push('/chats');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text("Message", style: AppTypography.buttonLabel.copyWith(color: Colors.white)),
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
