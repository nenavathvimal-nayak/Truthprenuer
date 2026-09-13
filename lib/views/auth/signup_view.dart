import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/brand_logo.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/auth_provider.dart';

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

  void _handleSignUp() async {
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

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (!mounted) return;
    
    await ref.read(authProvider.notifier).signup();
    
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/auth'); // fallback
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 28, // .title2
                  color: colors.text,
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              const BrandLogo.mark(size: 60, asEmblem: true),
              
              const SizedBox(height: AppSpacing.md),
              
              Text(
                "Create Account",
                style: AppTypography.hero.copyWith(color: colors.text),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Join a community of builders.",
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
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                placeholder: "Email",
                controller: _emailController,
                icon: Icons.mail_outline, // envelope
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                placeholder: "Password",
                controller: _passwordController,
                icon: Icons.lock_outline,
                isSecure: true,
              ),
              
              const Spacer(),
              
              PrimaryButton(
                title: "Sign Up",
                isLoading: _isLoading,
                action: _handleSignUp,
              ),
              
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
