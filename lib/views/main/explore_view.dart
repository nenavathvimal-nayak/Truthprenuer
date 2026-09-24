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

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  late TabController _tabController;

  String _selectedTag = "All";
  final List<String> _tags = ["All", "AI", "SaaS", "FinTech", "HealthTech", "Pricing", "Security"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final validationsAsync = ref.watch(validationsProvider);

    return Scaffold(
      appBar: const SharedTopNavBar(title: "Explore"),
      backgroundColor: colors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input — borderless, fill-only
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
                  hintText: "Search validations, assumptions, or founders...",
                  hintStyle: AppTypography.subheadline.copyWith(color: colors.textTertiary),
                  prefixIcon: Icon(Icons.search, size: 20, color: colors.textTertiary),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 17, color: colors.textTertiary),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),

          // Tabs — clean underline style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppPalette.orange,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.5,
              labelColor: colors.text,
              unselectedLabelColor: colors.textTertiary,
              labelStyle: AppTypography.subheadline.copyWith(fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTypography.subheadline.copyWith(fontWeight: FontWeight.w500),
              dividerColor: colors.divider.withValues(alpha: 0.3),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: const [
                Tab(text: "Validations"),
                Tab(text: "People"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Filter Pills — borderless, fill-only
          SizedBox(
            height: 34,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                final tag = _tags[index];
                final isSelected = _selectedTag == tag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticManager.shared.selection();
                      setState(() => _selectedTag = tag);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? AppPalette.orange.withValues(alpha: 0.12) : colors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
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

          const SizedBox(height: 8),

          // Content Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ValidationsFeed(
                  validationsAsync: validationsAsync,
                  searchQuery: _searchCtrl.text.trim().toLowerCase(),
                  selectedTag: _selectedTag,
                ),
                _PeopleFeed(searchQuery: _searchCtrl.text.trim().toLowerCase()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationsFeed extends ConsumerWidget {
  final AsyncValue<List<ValidationRequest>> validationsAsync;
  final String searchQuery;
  final String selectedTag;

  const _ValidationsFeed({
    required this.validationsAsync,
    required this.searchQuery,
    required this.selectedTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return RefreshIndicator(
      color: AppPalette.orange,
      onRefresh: () async {
        ref.invalidate(validationsProvider);
      },
      child: validationsAsync.when(
        data: (validations) {
          var filtered = validations;

          if (selectedTag != "All") {
            filtered = filtered.where((v) => v.tags.any((t) => t.toLowerCase() == selectedTag.toLowerCase())).toList();
          }

          if (searchQuery.isNotEmpty) {
            filtered = filtered.where((v) =>
              v.title.toLowerCase().contains(searchQuery) ||
              v.problem.toLowerCase().contains(searchQuery)
            ).toList();
          }

          if (filtered.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 40, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty ? "Nothing matched \"$searchQuery\"" : "No validations in this category",
                          style: AppTypography.title3.copyWith(color: colors.text, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try broadening your search keywords or switching filters.",
                          textAlign: TextAlign.center,
                          style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xs),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final v = filtered[index];
              return _ValidationCard(validation: v);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppPalette.orange, strokeWidth: 2.5)),
        error: (err, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Center(child: Padding(padding: const EdgeInsets.all(32), child: Text("Error: $err"))),
          ],
        ),
      ),
    );
  }
}

class _ValidationCard extends StatelessWidget {
  final ValidationRequest validation;

  const _ValidationCard({required this.validation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

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
            context.push('/validation-detail/${validation.id}', extra: validation);
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppPalette.orange.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          validation.tags.isNotEmpty ? validation.tags.first.toUpperCase() : "VALIDATION",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppPalette.orange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${validation.responsesCount} Responses",
                      style: AppTypography.labelSmall.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  validation.title,
                  style: AppTypography.subheadline.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  validation.problem,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.footnote.copyWith(
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Audience: ${validation.targetAudience}",
                        style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Give Feedback →",
                      style: AppTypography.caption.copyWith(
                        color: AppPalette.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PeopleFeed extends ConsumerWidget {
  final String searchQuery;

  const _PeopleFeed({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    final dummyPeople = [
      User(
        id: "p_1",
        name: "Devina Rao",
        username: "devina",
        bio: "Enterprise B2B Product Designer & A11y Researcher.",
        role: "Professional",
        skills: ["Figma", "Design Systems", "Usability Testing"],
        isVerified: true,
      ),
      User(
        id: "p_2",
        name: "Marcus Vance",
        username: "mvance",
        bio: "Early-stage SaaS Angel Investor. Backed 12 seed rounds.",
        role: "Investor",
        skills: ["B2B SaaS", "FinTech", "Due Diligence"],
        isVerified: true,
      ),
    ];

    final filtered = dummyPeople.where((p) =>
      p.name.toLowerCase().contains(searchQuery) ||
      p.skills.any((s) => s.toLowerCase().contains(searchQuery))
    ).toList();

    return RefreshIndicator(
      color: AppPalette.orange,
      onRefresh: () async {
        ref.invalidate(communityUsersProvider);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.xs),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final person = filtered[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.subheadline.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              person.role,
                              style: AppTypography.caption.copyWith(fontSize: 10, color: colors.textTertiary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        person.bio,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              Material(
                color: AppPalette.orange,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => HapticManager.shared.impactLight(),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    child: Text(
                      "Connect",
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  }
}
