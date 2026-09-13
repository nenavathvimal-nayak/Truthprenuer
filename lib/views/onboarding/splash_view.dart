import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/brand_logo.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../models/auth_provider.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _wordmarkOpacity;
  late Animation<Offset> _wordmarkSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final scaleCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    final opacityCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(scaleCurve);
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(opacityCurve);

    final wordmarkCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    );

    _wordmarkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(wordmarkCurve);
    _wordmarkSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(wordmarkCurve);

    _controller.forward();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final authState = ref.read(authProvider);
    
    if (authState.status == AuthStatus.authenticated) {
      context.go('/');
    } else if (authState.isFirstLaunch) {
      context.go('/onboarding');
    } else {
      context.go('/auth');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Official Truthprenuer Brand Logo
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient glow behind the logo
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withAlpha(40),
                      ),
                    ),
                    const BrandLogo.mark(
                      size: 130,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Wordmark & Tagline
            SlideTransition(
              position: _wordmarkSlide,
              child: FadeTransition(
                opacity: _wordmarkOpacity,
                child: Column(
                  children: [
                    Text(
                      "TRUTHPRENUER",
                      style: AppTypography.editorialHeadline.copyWith(
                        color: colors.text,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "VALIDATION NETWORK",
                      style: AppTypography.label.copyWith(
                        color: colors.primary,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Evidence-Driven Startup Decisions",
                      style: AppTypography.footnote.copyWith(
                        color: colors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
