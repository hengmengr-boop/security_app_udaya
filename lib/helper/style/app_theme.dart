import 'package:flutter/material.dart';

/// Udaya Technology brand colors (navy + red, from the logo).
class AppColors {
  // Brand
  static const Color primary = Color(0xFF241F63); // brand navy
  static const Color primaryMid = Color(0xFF3A3490);
  static const Color accent = Color(0xFFC8202F); // brand red
  static const Color logoNavy = Color(0xFF232065);
  static const Color periwinkle = Color(0xFF8088FF); // selected language
  static const Color steel = Color(0xFFA7B4CA);
  static const Color chromeHi = Color(0xFFFAFBFC);

  // Light surfaces
  static const Color background = Color(0xFFF4F5FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD9DCE6);
  static const Color tabIdle = Color(0xFFDADAE4);
  static const Color avatarBg = Color(0xFF131B34);
  static const Color avatarText = Color(0xFF7E8599);
  static const Color qrButton = Color(0xFF666666);

  // Text (light mode)
  static const Color textMuted = Color(0xFF8A8FA8);
  static const Color textBody = Color(0xFF14142B);
  static const Color textSub = Color(0xFF4A4E69);

  // Status
  static const Color green600 = Color(0xFF10B981);
  static const Color amber = Color(0xFFB45309);
  static const Color amberBg = Color(0xFFFEF3C7);
  static const Color red = Color(0xFFDC2626);

  // Dark mode
  static const Color backgroundDark = Color(0xFF0B0A1F);
  static const Color surfaceDark = Color(0xFF15143A);
  static const Color hairlineDark = Color(0xFF2A2958);
  static const Color textBodyDark = Color(0xFFE8E9F5);
  static const Color textSubDark = Color(0xFF9EA2C0);

  static Color getGlassBase(bool isDark) => isDark
      ? surfaceDark.withValues(alpha: 0.7)
      : Colors.white.withValues(alpha: 0.7);

  static Color getGlassBorder(bool isDark) => isDark
      ? Colors.white.withValues(alpha: 0.2)
      : Colors.black.withValues(alpha: 0.1);
}

/// Soft lavender -> deep navy background used by every page.
const kBrandGradient = LinearGradient(
  begin: Alignment(-1, -0.7),
  end: Alignment(1, 0.7),
  colors: [Color(0xFFEEF0F9), Color(0xFFA7A8C6), Color(0xFF241F63)],
  stops: [0.0, 0.5, 1.0],
);

class AppTheme {
  static const _font = 'Inter';

  static ThemeData lightTheme(Color primaryColor) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          surface: AppColors.surface,
          primary: primaryColor,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: _font,
        useMaterial3: true,
        dividerColor: AppColors.border,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.textBody),
        ),
      );

  static ThemeData darkTheme(Color primaryColor) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          surface: AppColors.surfaceDark,
          primary: primaryColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        fontFamily: _font,
        useMaterial3: true,
        dividerColor: AppColors.hairlineDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.steel),
        ),
      );

  static ThemeData get theme => lightTheme(AppColors.primary);
}
