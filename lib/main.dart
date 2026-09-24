import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/app_router.dart';
import 'design_system/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'design_system/theme_mode_provider.dart';

/// Configuration constants injected at build time via --dart-define-from-file.
/// Usage: flutter run --dart-define-from-file=.env.json
class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseUrl != 'your_project_url_here' &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'your_anon_key_here';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkColors.background,
        primaryColor: darkColors.primary,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.dark(
          primary: darkColors.primary,
          surface: darkColors.cardBackground,
          onSurface: darkColors.text,
        ),
        extensions: <ThemeExtension<dynamic>>[darkColors],
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightColors.background,
        primaryColor: lightColors.primary,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.light(
          primary: lightColors.primary,
          surface: lightColors.cardBackground,
          onSurface: lightColors.text,
        ),
        extensions: <ThemeExtension<dynamic>>[lightColors],
      ),
    );
  }
}
