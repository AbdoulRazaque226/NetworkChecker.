import 'package:flutter/material.dart';

/// Design tokens for NetworkChecker — an "engineering mesh" identity.
///
/// Two palettes (light/dark) share the same accents and the same circuit
/// background texture, only the base tones switch.
class AppColors {
  const AppColors._();

  // Shared accents.
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentSky = Color(0xFF38BDF8);

  // Dark mode.
  static const Color darkBg = Color(0xFF0A0F1E);
  static const Color darkSurface = Color(0xFF131A2C);
  static const Color darkSurfaceAlt = Color(0xFF18213A);
  static const Color darkTextPrimary = Color(0xFFE6EDF7);
  static const Color darkTextMuted = Color(0xFF8CA0BC);
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkDanger = Color(0xFFF87171);

  // Light mode.
  static const Color lightBg = Color(0xFFE9EDF3);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF3F6FA);
  static const Color lightTextPrimary = Color(0xFF16202E);
  static const Color lightTextMuted = Color(0xFF5B6B82);
  static const Color lightSuccess = Color(0xFF15803D);
  static const Color lightDanger = Color(0xFFDC2626);
}

/// The light [ThemeData] for the app.
final ThemeData lightTheme = _buildTheme(Brightness.light);

/// The dark [ThemeData] for the app.
final ThemeData darkTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;

  final Color bg = isDark ? AppColors.darkBg : AppColors.lightBg;
  final Color surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
  final Color surfaceAlt = isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt;
  final Color primary = isDark ? AppColors.accentTeal : const Color(0xFF0F766E);
  final Color onPrimary = isDark ? AppColors.darkBg : Colors.white;
  final Color secondary = isDark ? AppColors.accentSky : const Color(0xFF0369A1);
  final Color textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  final Color textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
  final Color danger = isDark ? AppColors.darkDanger : AppColors.lightDanger;

  final ColorScheme colorScheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: isDark ? AppColors.darkBg : Colors.white,
    error: danger,
    onError: isDark ? AppColors.darkBg : Colors.white,
    surface: surface,
    onSurface: textPrimary,
    surfaceContainerHighest: surfaceAlt,
    onSurfaceVariant: textMuted,
    outline: textMuted.withValues(alpha: 0.4),
  );

  const String fontFamily = 'Roboto';

  final TextTheme textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: textPrimary,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.4,
      color: textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      height: 1.35,
      color: textMuted,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: bg,
    canvasColor: surface,
    cardColor: surface,
    dividerColor: textMuted.withValues(alpha: 0.2),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: textMuted.withValues(alpha: 0.16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: textMuted.withValues(alpha: 0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primary, width: 1.6),
      ),
      labelStyle: TextStyle(color: textMuted),
      hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.7)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: primary.withValues(alpha: 0.6), width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: textTheme.labelLarge,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? AppColors.darkSurfaceAlt : AppColors.lightTextPrimary,
      contentTextStyle: TextStyle(color: isDark ? AppColors.darkTextPrimary : Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}