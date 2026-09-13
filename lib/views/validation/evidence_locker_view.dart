import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../models/startup_health_models.dart';
import '../../utils/haptic_manager.dart';

class EvidenceLockerView extends ConsumerStatefulWidget {
  const EvidenceLockerView({super.key});

  @override
  ConsumerState<EvidenceLockerView> createState() => _EvidenceLockerViewState();
}

class _EvidenceLockerViewState extends ConsumerState<EvidenceLockerView> {
  String _selectedFilter = "All Evidence";
  final List<String> _filters = ["All Evidence", "Raw Feedback", "AI Insights", "Decisions"];

  void _openAddEvidenceSheet(BuildContext context, AppThemeColors colors) {
    HapticManager.shared.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const _AddEvidenceSheet(),
    );
  }

  void _openDetailSheet(BuildContext context, EvidenceItem item, AppThemeColors colors) {
    HapticManager.shared.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _EvidenceDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);

    List<EvidenceItem> filteredEvidence;
    switch (_selectedFilter) {
      case "Raw Feedback":
        filteredEvidence = dataStore.evidenceItems
            .where((e) => e.type == EvidenceItemType.userInterview || e.type == EvidenceItemType.prototypeTest)
            .toList();
        break;
      case "AI Insights":
        filteredEvidence = dataStore.evidenceItems.where((e) => e.type == EvidenceItemType.aiCritique).toList();
        break;
      case "Decisions":
        filteredEvidence = dataStore.evidenceItems.where((e) => e.type == EvidenceItemType.expertReview).toList();
        break;
      default:
        filteredEvidence = dataStore.evidenceItems;
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Evidence Locker", style: AppTypography.title2.copyWith(color: colors.text)),
                        const SizedBox(height: 4),
                        Text(
                          "Your empirical repository of customer truth.",
                          style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openAddEvidenceSheet(context, colors),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            "Log Evidence",
                            style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: GestureDetector(
                        onTap: () {
                          HapticManager.shared.selection();
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : colors.cardBackground,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            filter,
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
          ),

          // Feed
          if (filteredEvidence.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 40, color: colors.textTertiary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      "No evidence items found",
                      style: AppTypography.headline.copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "Log user interviews or prototype test results above.",
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
                    final item = filteredEvidence[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _EvidenceItemCard(
                        item: item,
                        onTap: () => _openDetailSheet(context, item, colors),
                      ),
                    );
                  },
                  childCount: filteredEvidence.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EvidenceItemCard extends StatelessWidget {
  final EvidenceItem item;
  final VoidCallback onTap;

  const _EvidenceItemCard({required this.item, required this.onTap});

  IconData _iconForType(EvidenceItemType type) {
    switch (type) {
      case EvidenceItemType.userInterview:
      case EvidenceItemType.prototypeTest:
      case EvidenceItemType.marketData:
        return Icons.people_outline;
      case EvidenceItemType.aiCritique:
        return Icons.auto_awesome;
      case EvidenceItemType.expertReview:
        return Icons.verified_user_outlined;
    }
  }

  Color _colorForType(EvidenceItemType type, AppThemeColors colors) {
    switch (type) {
      case EvidenceItemType.userInterview:
      case EvidenceItemType.prototypeTest:
      case EvidenceItemType.marketData:
        return colors.evidenceGreen;
      case EvidenceItemType.aiCritique:
        return colors.primary;
      case EvidenceItemType.expertReview:
        return colors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final badgeColor = _colorForType(item.type, colors);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(_iconForType(item.type), color: badgeColor, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        item.type.value,
                        style: AppTypography.caption.copyWith(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  item.createdAt.timeAgoDisplay,
                  style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.title,
              style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              item.content,
              style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.confidenceLevel > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Text(
                    "Confidence: ",
                    style: AppTypography.caption.copyWith(color: colors.textTertiary, fontSize: 11),
                  ),
                  Text(
                    "${item.confidenceLevel}%",
                    style: AppTypography.caption.copyWith(
                      color: item.confidenceLevel > 70 ? colors.evidenceGreen : colors.warning,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, size: 16, color: colors.textTertiary),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EvidenceDetailSheet extends ConsumerWidget {
  final EvidenceItem item;

  const _EvidenceDetailSheet({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.read(mockDataStoreProvider);

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
              Expanded(
                child: Text(
                  item.title,
                  style: AppTypography.title3.copyWith(color: colors.text),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: colors.riskRed),
                onPressed: () {
                  HapticManager.shared.warning();
                  dataStore.deleteEvidenceItem(item.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "${item.type.value} • Logged ${item.createdAt.timeAgoDisplay}",
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.evidenceGreen.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${item.confidenceLevel}% Confidence",
                  style: AppTypography.caption.copyWith(color: colors.evidenceGreen, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EVIDENCE RECORD",
                  style: AppTypography.caption.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.content,
                  style: AppTypography.body.copyWith(color: colors.text, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: () {
              HapticManager.shared.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                "Close Record",
                style: AppTypography.buttonLabel.copyWith(color: colors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddEvidenceSheet extends ConsumerStatefulWidget {
  const _AddEvidenceSheet();

  @override
  ConsumerState<_AddEvidenceSheet> createState() => _AddEvidenceSheetState();
}

class _AddEvidenceSheetState extends ConsumerState<_AddEvidenceSheet> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  EvidenceItemType _selectedType = EvidenceItemType.userInterview;
  double _confidence = 85;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEvidence() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      HapticManager.shared.error();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out both title and content.")),
      );
      return;
    }

    final newItem = EvidenceItem(
      id: "ev_${DateTime.now().millisecondsSinceEpoch}",
      startupId: "mock_startup",
      type: _selectedType,
      title: title,
      content: content,
      confidenceLevel: _confidence.toInt(),
      createdAt: DateTime.now(),
    );

    ref.read(mockDataStoreProvider).addEvidenceItem(newItem);
    HapticManager.shared.success();
    Navigator.pop(context);
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
            Text("Log Empirical Evidence", style: AppTypography.title3.copyWith(color: colors.text)),
            const SizedBox(height: 4),
            Text(
              "Add customer interviews, prototype usability stats, or expert critiques.",
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text("TYPE", style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<EvidenceItemType>(
              initialValue: _selectedType,
              dropdownColor: colors.cardBackground,
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              items: EvidenceItemType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.value, style: AppTypography.body.copyWith(color: colors.text)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Text("TITLE", style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              style: TextStyle(color: colors.text),
              decoration: InputDecoration(
                hintText: "e.g., Interview with VP of Engineering",
                hintStyle: TextStyle(color: colors.textTertiary),
                filled: true,
                fillColor: colors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text("KEY FINDINGS & QUOTES", style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _contentController,
              maxLines: 4,
              style: TextStyle(color: colors.text),
              decoration: InputDecoration(
                hintText: "Document exact customer words, pain severity, and validation signals...",
                hintStyle: TextStyle(color: colors.textTertiary),
                filled: true,
                fillColor: colors.cardBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("CONFIDENCE LEVEL", style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.bold)),
                Text("${_confidence.toInt()}%", style: AppTypography.headline.copyWith(color: colors.primary, fontSize: 13)),
              ],
            ),
            Slider(
              value: _confidence,
              min: 10,
              max: 100,
              divisions: 18,
              activeColor: colors.primary,
              onChanged: (val) {
                setState(() => _confidence = val);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: _saveEvidence,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text("Save to Evidence Locker", style: AppTypography.buttonLabel.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
