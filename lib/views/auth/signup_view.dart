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

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _errorMessage;

  String _sanitizeRedirect(String? raw) {
    if (raw == null || raw.isEmpty) return '/';
    final decoded = Uri.decodeComponent(raw).trim();
    if (decoded.startsWith('/') && !decoded.startsWith('//') && !decoded.contains('://')) {
      return decoded;
    }
    return '/';
  }

  void _handleSignUp() async {
    if (_isLoading) return;

    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your name');
      return;
    }
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
      await ref.read(authProvider.notifier).signup(email, password, name);
      if (!mounted) return;
      final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
      context.go(_sanitizeRedirect(rawRedirect));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e is AuthException
            ? e.message
            : (ref.read(authProvider).errorMessage ?? 'Failed to create account. Please check your details and try again.');
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
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/auth');
            }
          },
          child: Icon(
            Icons.arrow_back,
            size: 26,
            color: colors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const BrandLogo.mark(size: 56, asEmblem: true),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Create Account",
          style: AppTypography.hero.copyWith(color: colors.text),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          "Join a decentralized community of empirical builders.",
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
          placeholder: "Full Name",
          controller: _fullNameController,
          icon: Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
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
          onSubmitted: _handleSignUp,
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          title: "Sign Up",
          isLoading: _isLoading,
          action: _handleSignUp,
        ),
      ],
    );

    final bottomAction = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppTypography.callout.copyWith(
            color: colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/auth');
          },
          child: Text(
            "Sign In",
            style: AppTypography.callout.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    return AdaptiveAuthLayout(
      heroTitle: "Build With Hard Evidence,\nNot Opinions",
      heroSubtitle: "Validate customer demand, test pricing thresholds, and calculate genuine PMF with truth-seeking peers.",
      form: form,
      bottomAction: bottomAction,
    );
  }
}
