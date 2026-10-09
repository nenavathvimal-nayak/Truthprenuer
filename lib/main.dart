import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/app_router.dart';
import 'design_system/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'design_system/theme_mode_provider.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

/// Configuration constants injected at build time via --dart-define-from-file.
/// Usage: flutter run --dart-define-from-file=.env.json
class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ledjnqvcyzqledcibjpd.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlZGpucXZjeXpxbGVkY2lianBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTExMDIyNjUsImV4cCI6MjEwNjY3ODI2NX0.42aIIeQexSnm-dRnUE7vICv882jwl5tw70wyL3OSbhw',
  );
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const backendUrl = String.fromEnvironment('BACKEND_URL', defaultValue: '');
  static const appPublicUrl = String.fromEnvironment(
    'APP_PUBLIC_URL',
    defaultValue: 'https://truthprenuer.pages.dev',
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseUrl != 'your_project_url_here' &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'your_anon_key_here';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Initialize Supabase only if real keys are provided at build time
  if (AppConfig.isSupabaseConfigured) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
    );
  }

  runApp(
    const ProviderScope(
      child: TruthprenuerApp(),
    ),
  );
}

class TruthprenuerApp extends ConsumerWidget {
  const TruthprenuerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final darkColors = AppThemeColors.dark;
    final lightColors = AppThemeColors.light;

    return MaterialApp.router(
      title: 'TRUTHPRENUER',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      themeMode: themeMode,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkColors.background,
        primaryColor: darkColors.primary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.dark(
          primary: darkColors.primary,
          surface: darkColors.cardBackground,
          onSurface: darkColors.text,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        extensions: <ThemeExtension<dynamic>>[darkColors],
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightColors.background,
        primaryColor: lightColors.primary,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.light(
          primary: lightColors.primary,
          surface: lightColors.cardBackground,
          onSurface: lightColors.text,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        extensions: <ThemeExtension<dynamic>>[lightColors],
      ),
    );
  }
}
