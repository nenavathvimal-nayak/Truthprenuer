import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../utils/haptic_manager.dart';

class ScaleButtonStyle extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool disabled;

  const ScaleButtonStyle({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
  });

  @override
  State<ScaleButtonStyle> createState() => _ScaleButtonStyleState();
}

class _ScaleButtonStyleState extends State<ScaleButtonStyle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerEvent details) {
    if (widget.disabled) return;
    _controller.forward();
  }

  void _onPointerUp(PointerEvent details) {
    if (widget.disabled) return;
    _controller.reverse();
    HapticManager.shared.impactLight();
    widget.onTap();
  }

  void _onPointerCancel(PointerEvent details) {
    if (widget.disabled) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Opacity(
            opacity: widget.disabled ? 0.6 : 1.0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback action;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.title,
    this.icon,
    required this.action,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return ScaleButtonStyle(
      disabled: isLoading,
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                title,
                style: AppTypography.buttonLabel.copyWith(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback action;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.title,
    this.icon,
    required this.action,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return ScaleButtonStyle(
      disabled: isLoading,
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: colors.divider,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
               SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.text),
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, color: colors.text, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                title,
                style: AppTypography.buttonLabel.copyWith(color: colors.text),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
