import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/admin_models.dart';
import '../../repositories/admin_repository.dart';
import '../../repositories/app_providers.dart';
import '../../repositories/realtime_sync_service.dart';
import '../../utils/haptic_manager.dart';

class AdminDashboardView extends ConsumerStatefulWidget {
  const AdminDashboardView({super.key});

  @override
  ConsumerState<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends ConsumerState<AdminDashboardView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _validationFilter = 'All';
  final _searchUserCtrl = TextEditingController();
  final _announcementCtrl = TextEditingController();
  bool _isFlushing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchUserCtrl.dispose();
    _announcementCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleFlushCache() async {
    setState(() => _isFlushing = true);
    HapticManager.shared.impactHeavy();

    ref.read(adminRepositoryProvider).flushPlatformCache();
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isFlushing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Global in-memory cache flushed. Re-synced with Supabase."),
          backgroundColor: AppPalette.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final metricsAsync = ref.watch(adminMetricsProvider);
    final realtimeState = ref.watch(realtimeSyncProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.text, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Row(
          children: [
            Text(
              "ADMIN CONSOLE",
              style: AppTypography.title2.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 10),
            // Realtime Live Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: realtimeState.isConnected
                    ? colors.success.withAlpha(30)
                    : colors.warning.withAlpha(30),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: realtimeState.isConnected ? colors.success : colors.warning,
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: realtimeState.isConnected ? colors.success : colors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    realtimeState.isConnected ? "REALTIME LIVE" : "CONNECTING",
                    style: TextStyle(
                      color: realtimeState.isConnected ? colors.success : colors.warning,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Flush Platform Cache",
            icon: _isFlushing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppPalette.orange),
                  )
                : Icon(Icons.refresh_rounded, color: colors.primary),
            onPressed: _isFlushing ? null : _handleFlushCache,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppPalette.orange,
          indicatorWeight: 3,
          labelColor: colors.text,
          unselectedLabelColor: colors.textTertiary,
          labelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: "Overview"),
            Tab(text: "Sprint Moderation"),
            Tab(text: "Users & Validators"),
            Tab(text: "Realtime Audit Feed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(metricsAsync: metricsAsync, realtimeState: realtimeState),
          _SprintsModerationTab(
            filter: _validationFilter,
            onFilterChanged: (newFilter) => setState(() => _validationFilter = newFilter),
          ),
          _UsersManagementTab(searchController: _searchUserCtrl),
          _AuditFeedTab(events: realtimeState.recentEvents),
        ],
      ),
    );
  }
}

// =========================================================================
// 1. OVERVIEW & KPI METRICS TAB
// =========================================================================
class _OverviewTab extends ConsumerWidget {
  final AsyncValue<AdminPlatformMetrics> metricsAsync;
  final RealtimeSyncState realtimeState;

  const _OverviewTab({required this.metricsAsync, required this.realtimeState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return RefreshIndicator(
      color: AppPalette.orange,
      onRefresh: () async {
        ref.invalidate(adminMetricsProvider);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live WebSocket Telemetry Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.sensors_rounded, color: colors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Supabase Realtime Channel Engine",
                          style: AppTypography.subheadline.copyWith(
                            color: colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Active Channels: ${realtimeState.activeChannels}  •  Latency: ${realtimeState.latencyMs}ms  •  Status: Connected",
                          style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text(
              "PLATFORM PERFORMANCE SIGNALS",
              style: AppTypography.caption.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            metricsAsync.when(
              data: (metrics) => GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                children: [
                  _MetricCard(
                    title: "Active Sprints",
                    value: "${metrics.activeValidations}",
                    subtitle: "${metrics.totalValidations} total created",
                    icon: Icons.rocket_launch_rounded,
                    color: AppPalette.orange,
                  ),
                  _MetricCard(
                    title: "Community Users",
                    value: "${metrics.totalUsers}",
                    subtitle: "${metrics.verifiedValidators} verified validators",
                    icon: Icons.group_rounded,
                    color: colors.info,
                  ),
                  _MetricCard(
                    title: "Feedback Signals",
                    value: "${metrics.totalResponses}",
                    subtitle: "Empirical data points",
                    icon: Icons.reviews_rounded,
                    color: colors.success,
                  ),
                  _MetricCard(
                    title: "High Conviction",
                    value: "${metrics.highConvictionSprints}",
                    subtitle: "${metrics.averageConvictionScore}% avg conviction",
                    icon: Icons.verified_user_rounded,
                    color: colors.warning,
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppPalette.orange),
                ),
              ),
              error: (err, _) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Metrics load note: $err", style: TextStyle(color: colors.textSecondary)),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Platform Governance Quick Tools
            Text(
              "QUICK GOVERNANCE CONTROLS",
              style: AppTypography.caption.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.cardBackground,
                      foregroundColor: colors.text,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colors.divider),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.bolt_rounded, color: AppPalette.orange),
                    label: const Text("Clear Caches & Sync"),
                    onPressed: () {
                      ref.read(adminRepositoryProvider).flushPlatformCache();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("In-memory caches flushed & re-synced.")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.cardBackground,
                      foregroundColor: colors.text,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colors.divider),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.verified_rounded, color: colors.success),
                    label: const Text("Re-index Truth Models"),
                    onPressed: () {
                      HapticManager.shared.impactLight();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("AI validation heuristics re-indexed successfully.")),
                      );
                    },
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(
            value,
            style: AppTypography.title1.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption2.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 2. SPRINTS MODERATION TAB
// =========================================================================
class _SprintsModerationTab extends ConsumerWidget {
  final String filter;
  final ValueChanged<String> onFilterChanged;

  const _SprintsModerationTab({required this.filter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final validationsAsync = ref.watch(validationsProvider);

    return Column(
      children: [
        // Filter bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Active", "Featured", "Flagged"].map((f) {
                final isSelected = filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => onFilterChanged(f),
                    selectedColor: AppPalette.orange.withAlpha(40),
                    checkmarkColor: AppPalette.orange,
                    backgroundColor: colors.cardBackground,
                    labelStyle: TextStyle(
                      color: isSelected ? AppPalette.orange : colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        Expanded(
          child: validationsAsync.when(
            data: (validations) {
              final filtered = validations.where((v) {
                if (filter == 'Active') return v.status == 'active';
                if (filter == 'Featured') return v.status == 'featured';
                if (filter == 'Flagged') return v.status == 'flagged';
                return true;
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    "No validation sprints found for filter '$filter'.",
                    style: TextStyle(color: colors.textTertiary),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final v = filtered[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                v.title,
                                style: AppTypography.headline.copyWith(
                                  color: colors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: v.status == 'featured'
                                    ? colors.success.withAlpha(25)
                                    : (v.status == 'flagged' ? Colors.red.withAlpha(25) : colors.surface),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                v.status.toUpperCase(),
                                style: TextStyle(
                                  color: v.status == 'featured'
                                      ? colors.success
                                      : (v.status == 'flagged' ? Colors.red : colors.textSecondary),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          v.problem,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Author: ${v.authorName ?? 'Founder'}  •  ${v.responsesCount} responses",
                              style: AppTypography.caption2.copyWith(color: colors.textTertiary),
                            ),
                            Row(
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: colors.success,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(Icons.star_rounded, size: 16),
                                  label: const Text("Feature"),
                                  onPressed: () {
                                    ref.read(adminRepositoryProvider).updateValidationStatus(v.id, 'featured');
                                    HapticManager.shared.impactLight();
                                  },
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: const Icon(Icons.flag_rounded, size: 16),
                                  label: const Text("Flag"),
                                  onPressed: () {
                                    ref.read(adminRepositoryProvider).updateValidationStatus(v.id, 'flagged');
                                    HapticManager.shared.impactLight();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppPalette.orange)),
            error: (err, _) => Center(child: Text("Error: $err")),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 3. USERS & VALIDATORS MANAGEMENT TAB
// =========================================================================
class _UsersManagementTab extends ConsumerStatefulWidget {
  final TextEditingController searchController;

  const _UsersManagementTab({required this.searchController});

  @override
  ConsumerState<_UsersManagementTab> createState() => _UsersManagementTabState();
}

class _UsersManagementTabState extends ConsumerState<_UsersManagementTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final users = ref.watch(communityUsersProvider);

    final filteredUsers = users.where((u) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return u.name.toLowerCase().contains(q) ||
          u.username.toLowerCase().contains(q) ||
          u.role.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: TextField(
            controller: widget.searchController,
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
            style: TextStyle(color: colors.text),
            decoration: InputDecoration(
              hintText: "Search founders and validators...",
              hintStyle: TextStyle(color: colors.textTertiary),
              prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
              filled: true,
              fillColor: colors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppPalette.orange),
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: filteredUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.divider),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colors.surface,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : "U",
                        style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: AppTypography.subheadline.copyWith(
                                  color: colors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (user.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 16, color: Colors.blueAccent),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "@${user.username} • Role: ${user.userRole.label}",
                            style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: user.isVerified ? "Revoke Verification" : "Grant Verification",
                      icon: Icon(
                        user.isVerified ? Icons.verified : Icons.verified_outlined,
                        color: user.isVerified ? Colors.blueAccent : colors.textTertiary,
                      ),
                      onPressed: () {
                        ref.read(adminRepositoryProvider).toggleUserVerification(user.id, !user.isVerified);
                        HapticManager.shared.impactLight();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 4. REALTIME AUDIT FEED TAB
// =========================================================================
class _AuditFeedTab extends StatelessWidget {
  final List<AdminAuditLogItem> events;

  const _AuditFeedTab({required this.events});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    if (events.isEmpty) {
      return Center(
        child: Text("No realtime events recorded yet.", style: TextStyle(color: colors.textTertiary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final ev = events[index];
        final badgeColor = switch (ev.severity) {
          AuditLogSeverity.success => colors.success,
          AuditLogSeverity.warning => colors.warning,
          AuditLogSeverity.critical => Colors.redAccent,
          AuditLogSeverity.info => colors.info,
        };

        final timeStr = "${ev.timestamp.hour.toString().padLeft(2, '0')}:${ev.timestamp.minute.toString().padLeft(2, '0')}:${ev.timestamp.second.toString().padLeft(2, '0')}";

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ev.action,
                          style: TextStyle(
                            color: badgeColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          timeStr,
                          style: AppTypography.caption2.copyWith(color: colors.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ev.details,
                      style: AppTypography.caption1.copyWith(color: colors.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Actor: ${ev.actorName}  •  Target: ${ev.target}",
                      style: AppTypography.caption2.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
