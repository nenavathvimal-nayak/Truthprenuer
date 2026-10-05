import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/brand_logo.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/auth_provider.dart';
import '../../design_system/responsive_layout.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _errorMessage;

  String _sanitizeRedirect(String? raw) {
    if (raw == null || raw.isEmpty) return '/';
    final decoded = Uri.decodeComponent(raw).trim();
    // Enforce internal path starting with single slash, prevent external / schema / protocol-relative
    if (decoded.startsWith('/') && !decoded.startsWith('//') && !decoded.contains('://')) {
      return decoded;
    }
    return '/';
  }

  void _handleSignIn() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Enter a valid email address');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).login(email, password);
      if (!mounted) return;
      final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
      context.go(_sanitizeRedirect(rawRedirect));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e is AuthException
            ? e.message
            : (ref.read(authProvider).errorMessage ?? 'Invalid email or password. Please try again.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.xl),
        const BrandLogo.mark(size: 56, asEmblem: true),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Welcome Back",
          style: AppTypography.hero.copyWith(color: colors.text),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          "Sign in to continue your validation journey.",
          style: AppTypography.body.copyWith(
            color: colors.textSecondary,
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.destructive.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: colors.destructive, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: AppTypography.footnote.copyWith(color: colors.destructive),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        CustomTextField(
          placeholder: "Email",
          controller: _emailController,
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          placeholder: "Password",
          controller: _passwordController,
          icon: Icons.lock_outline,
          isSecure: true,
          textInputAction: TextInputAction.done,
          onSubmitted: _handleSignIn,
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              context.push('/forgot-password');
            },
            child: Text(
              "Forgot Password?",
              style: AppTypography.footnote.copyWith(
                color: colors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          title: "Sign In",
          isLoading: _isLoading,
          action: _handleSignIn,
        ),
      ],
    );

    final bottomAction = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTypography.callout.copyWith(
            color: colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push('/signup');
          },
          child: Text(
            "Sign Up",
            style: AppTypography.callout.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    return AdaptiveAuthLayout(
      form: form,
      bottomAction: bottomAction,
    );
  }
}
