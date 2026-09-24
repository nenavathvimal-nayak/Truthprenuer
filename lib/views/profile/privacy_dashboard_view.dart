import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';

class PrivacyDashboardView extends StatefulWidget {
  const PrivacyDashboardView({super.key});

  @override
  State<PrivacyDashboardView> createState() => _PrivacyDashboardViewState();
}

class _PrivacyDashboardViewState extends State<PrivacyDashboardView> {
  // Mock states for MVP
  bool _consentAnalytics = true;
  bool _consentAI = true;

  void _requestData() {
    HapticManager.shared.impactMedium();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Request Data"),
        content: const Text("Your personal data export request has been submitted. You will receive an email within 72 hours with a download link."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    HapticManager.shared.impactHeavy();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
        content: const Text("This action will initiate a 7-day cooling-off period, followed by a 30-day soft deletion. After that, your data will be permanently deleted. Are you sure you want to proceed?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Initiate hard delete workflow via repository
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account deletion initiated. Logging out...")),
              );
            },
            child: const Text("Initiate Deletion", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentRow(String title, String description, bool value, ValueChanged<bool> onChanged) {
    final colors = Theme.of(context).appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headline.copyWith(color: colors.text)),
                const SizedBox(height: 4),
                Text(description, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          CupertinoSwitch(
            value: value,
            activeTrackColor: colors.primary,
            onChanged: (val) {
              HapticManager.shared.selection();
              onChanged(val);
              // Call API to update Consent Ledger
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Privacy & Data", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Consents", style: AppTypography.title2.copyWith(color: colors.text)),
            const SizedBox(height: AppSpacing.sm),
            Text("Manage how TAEED processes your personal data in accordance with DPDP.", style: AppTypography.body.copyWith(color: colors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),

            _buildConsentRow(
              "Analytics & Tracking",
              "Help us improve TAEED by sharing pseudonymous usage data. Turning this off restricts PostHog tracking.",
              _consentAnalytics,
              (v) => setState(() => _consentAnalytics = v),
            ),
            _buildConsentRow(
              "AI Processing",
              "Allow third-party LLMs (e.g. OpenAI) to process your ideas for sharpening and scoring. Revoking this disables AI features.",
              _consentAI,
              (v) => setState(() => _consentAI = v),
            ),

            const SizedBox(height: AppSpacing.xxl),
            Text("Data Rights", style: AppTypography.title2.copyWith(color: colors.text)),
            const SizedBox(height: AppSpacing.sm),
            Text("Exercise your rights under the DPDP Act.", style: AppTypography.body.copyWith(color: colors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.download, color: colors.primary),
              title: Text("Request Data Export", style: AppTypography.headline.copyWith(color: colors.text)),
              subtitle: Text("Get a copy of all your personal data.", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              trailing: Icon(Icons.chevron_right, color: colors.textTertiary),
              onTap: _requestData,
            ),
            
            const Divider(height: 30),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text("Delete Account", style: AppTypography.headline.copyWith(color: Colors.red)),
              subtitle: Text("Permanently delete your account and data.", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: _deleteAccount,
            ),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
