import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xs = 4, sm = 8, md = 16, lg = 24, xl = 32;
}

abstract final class AppColors {
  static const primary = Color(0xff0F766E);
  static const primaryDark = Color(0xff115E59);
  static const primaryLight = Color(0xffCCFBF1);
  static const secondary = Color(0xff334155);
  static const background = Color(0xffF8FAFC);
  static const surface = Color(0xffFFFFFF);
  static const surfaceAlt = Color(0xffF1F5F9);
  static const textPrimary = Color(0xff0F172A);
  static const textSecondary = Color(0xff475569);
  static const success = Color(0xff15803D);
  static const warning = Color(0xffD97706);
  static const error = Color(0xffB91C1C);
  static const info = Color(0xff2563EB);

  static const darkBackground = Color(0xff0B1220);
  static const darkSurface = Color(0xff111827);
  static const darkSurfaceAlt = Color(0xff1F2937);
  static const darkTextPrimary = Color(0xffF8FAFC);
  static const darkTextSecondary = Color(0xffCBD5E1);
  static const darkPrimary = Color(0xff2DD4BF);
  static const darkSuccess = Color(0xff4ADE80);
  static const darkWarning = Color(0xffF59E0B);
  static const darkError = Color(0xffF87171);

  static Color backgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBackground : background;
  static Color surfaceFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurface : surface;
  static Color surfaceAltFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurfaceAlt : surfaceAlt;
  static Color textPrimaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextPrimary : textPrimary;
  static Color textSecondaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextSecondary : textSecondary;
  static Color primaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkPrimary : primary;
  static Color successFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSuccess : success;
  static Color warningFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkWarning : warning;
  static Color errorFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkError : error;
}

abstract final class AppTheme {
  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);
  static ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final primary = AppColors.primaryFor(brightness);
    final background = AppColors.backgroundFor(brightness);
    final surface = AppColors.surfaceFor(brightness);
    final surfaceAlt = AppColors.surfaceAltFor(brightness);
    final textPrimary = AppColors.textPrimaryFor(brightness);
    final textSecondary = AppColors.textSecondaryFor(brightness);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: dark ? AppColors.darkBackground : Colors.white,
          primaryContainer: dark
              ? AppColors.primaryDark
              : AppColors.primaryLight,
          onPrimaryContainer: dark
              ? AppColors.darkTextPrimary
              : AppColors.primaryDark,
          secondary: dark ? AppColors.darkTextSecondary : AppColors.secondary,
          onSecondary: dark ? AppColors.darkBackground : Colors.white,
          surface: surface,
          onSurface: textPrimary,
          surfaceContainer: surfaceAlt,
          onSurfaceVariant: textSecondary,
          error: AppColors.errorFor(brightness),
          onError: dark ? AppColors.darkBackground : Colors.white,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
        backgroundColor: surface,
        indicatorColor: dark ? surfaceAlt : AppColors.primaryLight,
        indicatorShape: const StadiumBorder(),
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected)
                ? primary
                : textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            height: 1.1,
            letterSpacing: 0,
            color: states.contains(WidgetState.selected)
                ? primary
                : textSecondary,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dark ? AppColors.darkSurfaceAlt : const Color(0xffE2E8F0),
        space: 1,
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
