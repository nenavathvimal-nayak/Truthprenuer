import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../utils/haptic_manager.dart';

class CustomTextField extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final String? label;
  final String? helperText;
  final String? errorText;
  final IconData? icon;
  final bool isSecure;
  final bool enabled;
  final bool showClearButton;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.label,
    this.helperText,
    this.errorText,
    this.icon,
    this.isSecure = false,
    this.enabled = true,
    this.showClearButton = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isSecure;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    final borderColor = hasError
        ? colors.destructive
        : _isFocused
            ? colors.primary
            : colors.border;

    final borderWidth = (hasError || _isFocused) ? 1.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 6),
            child: Text(
              widget.label!,
              style: AppTypography.inputLabel.copyWith(
                color: hasError ? colors.destructive : colors.text,
              ),
            ),
          ),
        ],
        Semantics(
          textField: true,
          label: widget.label ?? widget.placeholder,
          hint: widget.placeholder,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(
              minHeight: AppTouchTarget.minTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: hasError ? colors.errorSurface : colors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 20,
                    color: hasError
                        ? colors.destructive
                        : _isFocused
                            ? colors.primary
                            : colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: _obscureText,
                    enabled: widget.enabled,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    onChanged: (val) {
                      setState(() {});
                      widget.onChanged?.call(val);
                    },
                    onSubmitted: (_) => widget.onSubmitted?.call(),
                    style: AppTypography.body.copyWith(
                      color: widget.enabled ? colors.text : colors.textTertiary,
                    ),
                    cursorColor: colors.primary,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: AppTypography.body.copyWith(
                        color: colors.textTertiary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (widget.isSecure) ...[
                  IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    splashRadius: 16,
                    icon: Icon(
                      _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: colors.textSecondary,
                    ),
                    tooltip: _obscureText ? "Show password" : "Hide password",
                    onPressed: () {
                      HapticManager.shared.selection();
                      setState(() => _obscureText = !_obscureText);
                    },
                  ),
                ] else if (widget.showClearButton && widget.controller.text.isNotEmpty) ...[
                  IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    splashRadius: 16,
                    icon: Icon(
                      Icons.cancel,
                      color: colors.textTertiary,
                    ),
                    tooltip: "Clear text",
                    onPressed: () {
                      HapticManager.shared.impactLight();
                      widget.controller.clear();
                      widget.onChanged?.call("");
                      setState(() {});
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, size: 14, color: colors.destructive),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: AppTypography.inputError.copyWith(color: colors.destructive),
                  ),
                ),
              ],
            ),
          ),
        ] else if (widget.helperText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              widget.helperText!,
              style: AppTypography.inputHelper.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }
}
