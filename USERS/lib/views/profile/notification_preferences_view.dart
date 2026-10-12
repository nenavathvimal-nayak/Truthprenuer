import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';

class NotificationPreferencesView extends ConsumerStatefulWidget {
  const NotificationPreferencesView({super.key});

  @override
  ConsumerState<NotificationPreferencesView> createState() => _NotificationPreferencesViewState();
}

class _NotificationPreferencesViewState extends ConsumerState<NotificationPreferencesView> {
  bool _feedbackPush = true;
  bool _feedbackEmail = true;
  bool _healthMilestonePush = true;
  bool _messagesPush = true;
  bool _connectionPush = true;
  bool _weeklyDigestEmail = true;
  bool _investorAlerts = true;

  void _savePreferences() {
    HapticManager.shared.success();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notification preferences saved successfully"),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Notification Preferences", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.text, size: 28),
          onPressed: () {
            HapticManager.shared.impactLight();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg).copyWith(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "Validation & Evidence",
              colors: colors,
              items: [
                _buildToggle(
                  title: "Structured Feedback Alerts",
                  subtitle: "Instant push notification when a validator submits feedback",
                  value: _feedbackPush,
                  onChanged: (v) => setState(() => _feedbackPush = v),
                  colors: colors,
                ),
                _buildToggle(
                  title: "Feedback Email Reports",
                  subtitle: "Receive full score breakdown and comments in your inbox",
                  value: _feedbackEmail,
                  onChanged: (v) => setState(() => _feedbackEmail = v),
                  colors: colors,
                ),
                _buildToggle(
                  title: "Health Milestone Reached",
                  subtitle: "Notify when your startup reaches 80+ PMF readiness",
                  value: _healthMilestonePush,
                  onChanged: (v) => setState(() => _healthMilestonePush = v),
                  colors: colors,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _buildSection(
              title: "Messages & Network",
              colors: colors,
              items: [
                _buildToggle(
                  title: "Direct Messages",
                  subtitle: "Real-time alerts for incoming founder messages",
                  value: _messagesPush,
                  onChanged: (v) => setState(() => _messagesPush = v),
                  colors: colors,
                ),
                _buildToggle(
                  title: "Connection Requests",
                  subtitle: "Notify when investors or validators want to connect",
                  value: _connectionPush,
                  onChanged: (v) => setState(() => _connectionPush = v),
                  colors: colors,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _buildSection(
              title: "Founder Intelligence & Digests",
              colors: colors,
              items: [
                _buildToggle(
                  title: "Weekly Health Digest",
                  subtitle: "Comprehensive Monday analytics on views, responses & score",
                  value: _weeklyDigestEmail,
                  onChanged: (v) => setState(() => _weeklyDigestEmail = v),
                  colors: colors,
                ),
                _buildToggle(
                  title: "Investor Matching Alerts",
                  subtitle: "Notify when an angel/VC views your pitch deck",
                  value: _investorAlerts,
                  onChanged: (v) => setState(() => _investorAlerts = v),
                  colors: colors,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  "Save Preferences",
                  style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required AppThemeColors colors,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.label.copyWith(color: colors.primary, letterSpacing: 0.8),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppThemeColors colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headline.copyWith(color: colors.text)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.caption2.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: colors.primary,
            onChanged: (v) {
              HapticManager.shared.selection();
              onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
