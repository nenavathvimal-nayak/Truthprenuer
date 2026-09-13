import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import 'ai_validation_view.dart';
import 'evidence_locker_view.dart';
import 'startup_health_dashboard_view.dart';

class ValidationDashboardView extends ConsumerStatefulWidget {
  const ValidationDashboardView({super.key});

  @override
  ConsumerState<ValidationDashboardView> createState() => _ValidationDashboardViewState();
}

class _ValidationDashboardViewState extends ConsumerState<ValidationDashboardView> {
  String _selectedSection = "Startup Health";
  final List<String> _sections = ["Startup Health", "AI Validation", "Evidence Locker"];
  
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSectionChanged(String? newValue) {
    if (newValue != null && newValue != _selectedSection) {
      setState(() {
        _selectedSection = newValue;
      });
      final index = _sections.indexOf(newValue);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final report = dataStore.aiReports.isNotEmpty ? dataStore.aiReports.first : null;

    // Use CupertinoSegmentedControl for iOS-like segmented picker
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Title Header
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Validation Hub",
                    style: AppTypography.h1.copyWith(color: colors.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Track health, AI insights, and evidence",
                    style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            // Segmented Picker
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: _selectedSection,
                children: {
                  for (final section in _sections)
                    section: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        section,
                        style: AppTypography.footnote.copyWith(
                          color: _selectedSection == section ? colors.text : colors.textSecondary,
                          fontWeight: _selectedSection == section ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    )
                },
                onValueChanged: _onSectionChanged,
                backgroundColor: colors.cardBackgroundLight,
                thumbColor: colors.cardBackground,
              ),
            ),
            
            Divider(color: colors.divider, height: 1, thickness: 1),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedSection = _sections[index];
                  });
                },
                children: [
                  const StartupHealthDashboardView(),
                  if (report != null)
                    AIValidationView(report: report)
                  else
                    _EmptyAIValidationView(),
                  const EvidenceLockerView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAIValidationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 40, color: colors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              "No AI Validation Yet",
              style: AppTypography.title3.copyWith(color: colors.text),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Create a validation request to generate an AI report.",
              style: AppTypography.body.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
