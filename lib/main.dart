import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/app_router.dart';
import 'design_system/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'design_system/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  // Safely initialize Supabase if keys are provided
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (supabaseUrl != null && supabaseUrl.isNotEmpty && supabaseUrl != 'your_project_url_here' &&
      supabaseAnonKey != null && supabaseAnonKey.isNotEmpty && supabaseAnonKey != 'your_anon_key_here') {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }

  runApp(
    const ProviderScope(
      child: TAEEDApp(),
    ),
  );
}

class TAEEDApp extends ConsumerWidget {
  const TAEEDApp({super.key});

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
