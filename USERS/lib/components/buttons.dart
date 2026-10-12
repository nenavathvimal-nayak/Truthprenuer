import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../utils/haptic_manager.dart';

class ScaleButtonStyle extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool disabled;
  final String? semanticLabel;

  const ScaleButtonStyle({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
    this.semanticLabel,
  });

  @override
  State<ScaleButtonStyle> createState() => _ScaleButtonStyleState();
}

class _ScaleButtonStyleState extends State<ScaleButtonStyle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.disabled) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.disabled) return;
    _controller.reverse();
    HapticManager.shared.impactLight();
    widget.onTap();
  }

  void _onTapCancel() {
    if (widget.disabled) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Semantics(
      button: true,
      enabled: !widget.disabled,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        enabled: !widget.disabled,
        onShowFocusHighlight: (show) => setState(() => _isFocused = show),
        child: MouseRegion(
          cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg + 2),
                border: _isFocused
                    ? Border.all(color: colors.focusRing, width: 2)
                    : Border.all(color: Colors.transparent, width: 2),
              ),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Opacity(
                  opacity: widget.disabled ? 0.5 : 1.0,
                  child: widget.child,
                ),
              ),
            ),
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
  final bool disabled;

  const PrimaryButton({
    super.key,
    required this.title,
    this.icon,
    required this.action,
    this.isLoading = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDisabled = disabled || isLoading;

    return ScaleButtonStyle(
      disabled: isDisabled,
      onTap: action,
      semanticLabel: title,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppTouchTarget.minTarget,
          minWidth: AppTouchTarget.minTarget,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm + 2,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                Flexible(
                  child: Text(
                    title,
                    style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
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
  final bool disabled;

  const SecondaryButton({
    super.key,
    required this.title,
    this.icon,
    required this.action,
    this.isLoading = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDisabled = disabled || isLoading;

    return ScaleButtonStyle(
      disabled: isDisabled,
      onTap: action,
      semanticLabel: title,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppTouchTarget.minTarget,
          minWidth: AppTouchTarget.minTarget,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm + 2,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: colors.border,
              width: 1.2,
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
                Flexible(
                  child: Text(
                    title,
                    style: AppTypography.buttonLabel.copyWith(color: colors.text),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
