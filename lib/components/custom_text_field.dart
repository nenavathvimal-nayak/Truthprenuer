import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

class CustomTextField extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final IconData? icon;
  final bool isSecure;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.icon,
    this.isSecure = false,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isFocused ? colors.primary : colors.divider,
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              color: _isFocused ? colors.primary : colors.text.withValues(alpha: 0.5),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.isSecure,
              onChanged: widget.onChanged,
              style: AppTypography.body.copyWith(color: colors.text),
              cursorColor: colors.primary,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: AppTypography.body.copyWith(color: colors.text.withValues(alpha: 0.5)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
