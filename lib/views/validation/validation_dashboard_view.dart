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

class ValidationDashboardView extends ConsumerStatefulWidget {
  const ValidationDashboardView({super.key});

  @override
  ConsumerState<ValidationDashboardView> createState() => _ValidationDashboardViewState();
}

class _ValidationDashboardViewState extends ConsumerState<ValidationDashboardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final validationsAsync = ref.watch(validationsProvider);

    return Scaffold(
      appBar: const SharedTopNavBar(title: "Validate"),
      backgroundColor: colors.background,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Workspaces",
                  style: AppTypography.h2.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                Semantics(
                  button: true,
                  label: "Create New Validation",
                  child: Material(
                    color: AppPalette.orange,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        HapticManager.shared.impactMedium();
                        context.push('/validation-wizard');
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, size: 17, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              "New Validation",
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Segmented Tab Control — pill-style, borderless
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppPalette.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: colors.textTertiary,
              labelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.4),
              unselectedLabelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: "ACTIVE"),
                Tab(text: "DRAFTS"),
                Tab(text: "COMPLETED"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ActiveValidationsTab(validationsAsync: validationsAsync),
                _DraftsTab(),
                _CompletedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveValidationsTab extends ConsumerWidget {
  final AsyncValue<List<ValidationRequest>> validationsAsync;

  const _ActiveValidationsTab({required this.validationsAsync});

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
        if (validations.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.18),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_outlined, size: 44, color: colors.textTertiary),
                      const SizedBox(height: 16),
                      Text(
                        "No active validations",
                        style: AppTypography.title3.copyWith(color: colors.text, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create your first validation sprint to test assumptions with real market evidence.",
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            if (isWide) {
              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 175,
                ),
                itemCount: validations.length,
                itemBuilder: (context, index) {
                  final v = validations[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticManager.shared.impactLight();
                          context.push('/validation-detail/${v.id}', extra: v);
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                        v.tags.isNotEmpty ? v.tags.first.toUpperCase() : "SPRINT",
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
                                    "${v.responsesCount} Responses",
                                    style: AppTypography.labelSmall.copyWith(color: colors.textTertiary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                v.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.subheadline.copyWith(
                                  color: colors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                v.problem,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Active • Testing Problem Fit",
                                    style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 11),
                                  ),
                                  Icon(Icons.chevron_right_rounded, size: 16, color: colors.textTertiary),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
              itemCount: validations.length,
              itemBuilder: (context, index) {
                final v = validations[index];
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
                        context.push('/validation-detail/${v.id}', extra: v);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      v.tags.isNotEmpty ? v.tags.first.toUpperCase() : "SPRINT",
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
                                  "${v.responsesCount} Responses",
                                  style: AppTypography.labelSmall.copyWith(color: colors.textTertiary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              v.title,
                              style: AppTypography.subheadline.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              v.problem,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Active • Testing Problem Fit",
                                  style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 11),
                                ),
                                Icon(Icons.chevron_right_rounded, size: 16, color: colors.textTertiary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
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

class _DraftsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_note_rounded, size: 44, color: colors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  "No unfinished drafts",
                  style: AppTypography.title3.copyWith(color: colors.text, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  "Validations you start creating will be saved here automatically.",
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
}

class _CompletedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt_rounded, size: 44, color: colors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  "No completed sprints yet",
                  style: AppTypography.title3.copyWith(color: colors.text, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  "Completed validation cycles with resolved founder decisions will appear here.",
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
}
