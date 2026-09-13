import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  double get _passwordStrength {
    final text = _newPasswordController.text;
    if (text.isEmpty) return 0.0;
    double score = 0.0;
    if (text.length >= 8) score += 0.35;
    if (RegExp(r'[0-9]').hasMatch(text)) score += 0.35;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) score += 0.30;
    return score;
  }

  String get _strengthLabel {
    final s = _passwordStrength;
    if (s <= 0.0) return "Enter password";
    if (s < 0.5) return "Weak";
    if (s < 0.8) return "Good";
    return "Strong";
  }

  Color _strengthColor(AppThemeColors colors) {
    final s = _passwordStrength;
    if (s < 0.5) return Colors.redAccent;
    if (s < 0.8) return Colors.amber;
    return const Color(0xFF10B981);
  }

  void _handleSavePassword() async {
    if (!_formKey.currentState!.validate()) {
      HapticManager.shared.error();
      return;
    }

    HapticManager.shared.impactMedium();
    setState(() => _isLoading = true);

    // Simulate secure network mutation
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    HapticManager.shared.success();

    showDialog(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(context).appColors;
        return AlertDialog(
          backgroundColor: colors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 32),
              ),
              const SizedBox(height: AppSpacing.md),
              Text("Password Updated", style: AppTypography.title2.copyWith(color: colors.text)),
              const SizedBox(height: 6),
              Text(
                "Your account security credentials have been successfully updated.",
                style: AppTypography.body.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        );
      },
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
        title: Text("Change Password", style: AppTypography.appBarTitle.copyWith(color: colors.text)),
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Keep your account secure",
                style: AppTypography.title2.copyWith(color: colors.text),
              ),
              const SizedBox(height: 6),
              Text(
                "Use at least 8 characters including numbers and symbols to ensure maximum startup account security.",
                style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Current Password
              _buildPasswordField(
                label: "Current Password",
                controller: _currentPasswordController,
                obscure: _obscureCurrent,
                onToggleObscure: () => setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Please enter your current password";
                  return null;
                },
                colors: colors,
              ),
              const SizedBox(height: AppSpacing.lg),

              // New Password
              _buildPasswordField(
                label: "New Password",
                controller: _newPasswordController,
                obscure: _obscureNew,
                onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
                onChanged: (_) => setState(() {}),
                validator: (val) {
                  if (val == null || val.length < 8) return "Password must be at least 8 characters";
                  return null;
                },
                colors: colors,
              ),
              const SizedBox(height: 8),

              // Strength Meter
              if (_newPasswordController.text.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Security Level", style: AppTypography.caption2.copyWith(color: colors.textSecondary)),
                    Text(
                      _strengthLabel,
                      style: AppTypography.caption2.copyWith(
                        color: _strengthColor(colors),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _passwordStrength,
                    minHeight: 5,
                    backgroundColor: colors.cardBackgroundLight,
                    valueColor: AlwaysStoppedAnimation<Color>(_strengthColor(colors)),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ] else
                const SizedBox(height: AppSpacing.sm),

              // Confirm New Password
              _buildPasswordField(
                label: "Confirm New Password",
                controller: _confirmPasswordController,
                obscure: _obscureConfirm,
                onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (val) {
                  if (val != _newPasswordController.text) return "Passwords do not match";
                  return null;
                },
                colors: colors,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSavePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: colors.primary.withAlpha(120),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(
                          "Update Password",
                          style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggleObscure,
    required String? Function(String?) validator,
    required AppThemeColors colors,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.headline.copyWith(color: colors.text)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            onChanged: onChanged,
            validator: validator,
            style: AppTypography.body.copyWith(color: colors.text),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter $label",
              hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: colors.textSecondary,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
