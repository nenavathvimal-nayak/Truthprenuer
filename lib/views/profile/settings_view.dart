import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/theme_mode_provider.dart';
import '../../models/auth_provider.dart';
import '../../models/mock_data_store_provider.dart';
import '../../utils/haptic_manager.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _notificationsEnabled = true;
  bool _hapticsEnabled = true;
  bool _showOnlineStatus = true;
  bool _privateAccount = false;

  void _showLegalDialog(BuildContext context, String title, String body) {
    HapticManager.shared.impactLight();
    final colors = Theme.of(context).appColors;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: AppTypography.headline.copyWith(color: colors.text)),
        content: SingleChildScrollView(
          child: Text(
            body,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }

  void _showExportDataModal(BuildContext context) {
    HapticManager.shared.impactLight();
    final colors = Theme.of(context).appColors;
    bool isExporting = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.textTertiary.withAlpha(80),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text("Export Your Startup Data", style: AppTypography.title2.copyWith(color: colors.text)),
                    const SizedBox(height: 6),
                    Text(
                      "Download a portable, complete JSON archive of your startup validations, evidence logs, and feedback history.",
                      style: AppTypography.body.copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    _buildExportItem(Icons.rocket_launch_rounded, "Validation Projects", "2 Active Validations", colors),
                    _buildExportItem(Icons.rate_review_rounded, "Structured Feedback", "14 Validator Reviews", colors),
                    _buildExportItem(Icons.forum_rounded, "Founder Transcripts", "5 Conversations", colors),
                    _buildExportItem(Icons.badge_rounded, "Profile & Health Metrics", "Complete Scores", colors),

                    const SizedBox(height: AppSpacing.xl),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isExporting
                            ? null
                            : () async {
                                setModalState(() => isExporting = true);
                                HapticManager.shared.impactMedium();
                                await Future.delayed(const Duration(milliseconds: 1000));
                                if (!context.mounted) return;
                                Navigator.pop(ctx);
                                HapticManager.shared.success();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Archive created: truthprenuer_export.json saved to device"),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: isExporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text("Generate Archive (.json)"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExportItem(IconData icon, String title, String subtitle, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTypography.headline.copyWith(color: colors.text),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(subtitle, style: AppTypography.caption1.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text("Settings", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: colors.cardBackgroundLight, shape: BoxShape.circle),
            child: Icon(Icons.close, color: colors.textSecondary, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg).copyWith(bottom: 50),
        child: Column(
          children: [
            _SettingsSection(
              title: "Appearance",
              children: [
                _SettingsToggleRow(
                  icon: isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  iconColor: colors.primary,
                  title: "Dark Mode",
                  subtitle: isDark ? "OLED-optimized dark theme" : "High-clarity silver light theme",
                  isOn: isDark,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                    HapticManager.shared.selection();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _SettingsSection(
              title: "Notifications",
              children: [
                _SettingsToggleRow(
                  icon: Icons.notifications,
                  iconColor: colors.primary,
                  title: "Push Notifications",
                  subtitle: "Instant feedback & system alerts",
                  isOn: _notificationsEnabled,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                    HapticManager.shared.selection();
                  },
                ),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsNavRow(
                  icon: Icons.tune_rounded,
                  iconColor: colors.primary,
                  title: "Notification Preferences",
                  onTap: () {
                    HapticManager.shared.impactLight();
                    context.push('/notification-preferences');
                  },
                ),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsToggleRow(
                  icon: Icons.vibration,
                  iconColor: colors.info,
                  title: "Haptics",
                  subtitle: "Tactile feedback on interactions",
                  isOn: _hapticsEnabled,
                  onChanged: (val) {
                    setState(() => _hapticsEnabled = val);
                    HapticManager.shared.selection();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _SettingsSection(
              title: "Privacy",
              children: [
                _SettingsToggleRow(
                  icon: Icons.visibility,
                  iconColor: colors.success,
                  title: "Online Status",
                  subtitle: "Let others see when you're active",
                  isOn: _showOnlineStatus,
                  onChanged: (val) {
                    setState(() => _showOnlineStatus = val);
                    HapticManager.shared.selection();
                  },
                ),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsToggleRow(
                  icon: Icons.lock,
                  iconColor: colors.warning,
                  title: "Private Account",
                  subtitle: "Approve validators manually",
                  isOn: _privateAccount,
                  onChanged: (val) {
                    setState(() => _privateAccount = val);
                    HapticManager.shared.selection();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _SettingsSection(
              title: "Account & Security",
              children: [
                _SettingsNavRow(
                  icon: Icons.key_rounded,
                  iconColor: colors.info,
                  title: "Change Password",
                  onTap: () {
                    HapticManager.shared.impactLight();
                    context.push('/change-password');
                  },
                ),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsNavRow(
                  icon: Icons.file_download_rounded,
                  iconColor: colors.textSecondary,
                  title: "Export My Data",
                  onTap: () => _showExportDataModal(context),
                ),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsNavRow(
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  title: "Log Out",
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _SettingsSection(
              title: "Danger Zone",
              children: [
                GestureDetector(
                  onTap: () => _showDeleteDialog(context),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(38),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 18),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Delete Account", style: AppTypography.bodyMedium.copyWith(color: Colors.red)),
                              const SizedBox(height: 2),
                              Text("Permanently remove your startup data", style: AppTypography.caption2.copyWith(color: colors.textTertiary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            _SettingsSection(
              title: "About & Legal",
              children: [
                const _SettingsInfoRow(title: "App Version", value: "v1.0.0"),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                const _SettingsInfoRow(title: "Build", value: "Truthprenuer Launch MVP"),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsNavRow(
                  icon: Icons.description_outlined,
                  iconColor: colors.textSecondary,
                  title: "Privacy Policy",
                  onTap: () => _showLegalDialog(
                    context,
                    "Privacy Policy",
                    "Truthprenuer treats proprietary startup ideas with institutional rigor.\n\nAll validation pitches, customer discovery evidence, and health scores are encrypted. We never sell founder data or train public models on unvalidated startup intellectual property.",
                  ),
                ),
                Container(height: 1, color: colors.divider, margin: const EdgeInsets.only(left: 52)),
                _SettingsNavRow(
                  icon: Icons.article_outlined,
                  iconColor: colors.textSecondary,
                  title: "Terms of Service",
                  onTap: () => _showLegalDialog(
                    context,
                    "Terms of Service",
                    "Truthprenuer is a collaborative validation platform for serious founders and accredited validators.\n\nBy participating in the network, you agree to:\n1. Provide candid, evidence-based feedback\n2. Respect founder intellectual property\n3. Maintain professional conduct across community channels.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),

            Text("Truthprenuer • Built for Serious Founders", style: AppTypography.caption2.copyWith(color: colors.textTertiary)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Log Out?", style: AppTypography.headline.copyWith(color: Theme.of(context).appColors.text)),
        content: Text("You'll need to sign in again to access Truthprenuer.", style: AppTypography.body.copyWith(color: Theme.of(context).appColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              ref.read(mockDataStoreProvider).logout();
              await ref.read(authProvider.notifier).logout();
              if (!context.mounted) return;
              Navigator.pop(ctx);
              context.go('/auth');
            },
            child: Text("Log Out", style: AppTypography.buttonLabel.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Delete Account?", style: AppTypography.headline.copyWith(color: Theme.of(context).appColors.text)),
        content: Text(
          "This action is permanent and cannot be undone. All your validations, responses, and metrics will be erased.",
          style: AppTypography.body.copyWith(color: Theme.of(context).appColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              HapticManager.shared.heavyImpact();
              ref.read(mockDataStoreProvider).logout();
              await ref.read(authProvider.notifier).logout();
              if (!context.mounted) return;
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account successfully deleted")),
              );
              context.go('/auth');
            },
            child: Text("Delete", style: AppTypography.buttonLabel.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.label.copyWith(color: colors.textTertiary),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(color: colors.text)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.caption2.copyWith(color: colors.textTertiary)),
              ],
            ),
          ),
          Switch(
            value: isOn,
            onChanged: onChanged,
            activeTrackColor: colors.primary.withAlpha(128),
            activeThumbColor: colors.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsNavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _SettingsNavRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(38),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(title, style: AppTypography.bodyMedium.copyWith(color: colors.text)),
            ),
            Icon(Icons.chevron_right, color: colors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _SettingsInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium.copyWith(color: colors.text)),
          Text(value, style: AppTypography.body.copyWith(color: colors.textTertiary)),
        ],
      ),
    );
  }
}
