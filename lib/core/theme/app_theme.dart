import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// Builds the Material 3 theme from the shared [AppColors] tokens.
abstract final class AppTheme {
  static ThemeData build(Brightness brightness) {
    final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: c.primary,
            brightness: brightness,
          ).copyWith(
            primary: c.primary,
            onPrimary: c.onPrimary,
            surface: c.surface,
            onSurface: c.textPrimary,
            error: c.danger,
          ),
    );

    final textTheme = _textTheme(c, brightness);

    return base.copyWith(
      scaffoldBackgroundColor: c.canvas,
      canvasColor: c.canvas,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[c],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: c.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: c.textSecondary, size: 20),
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
          side: BorderSide(color: c.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.textPrimary,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          side: BorderSide(color: c.borderStrong),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceSunken,
        side: BorderSide(color: c.border),
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: c.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.lg,
          vertical: Space.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BossBorder(c.primary),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.primary,
        inactiveTrackColor: c.surfaceSunken,
        thumbColor: c.primary,
        overlayColor: c.primary.withValues(alpha: 0.12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onPrimary : c.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.primary : c.surfaceSunken,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.primary : c.borderStrong,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.surfaceSunken,
        circularTrackColor: c.surfaceSunken,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? c.surfaceRaised
            : const Color(0xFF1B2A24),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        insetPadding: const EdgeInsets.all(Space.lg),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: brightness == Brightness.dark
              ? c.surfaceRaised
              : const Color(0xFF1B2A24),
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(c.borderStrong),
        radius: const Radius.circular(999),
        thickness: const WidgetStatePropertyAll(6),
      ),
    );
  }

  static TextTheme _textTheme(AppColors c, Brightness b) {
    const family = 'Roboto';
    TextStyle h(double size, FontWeight w, double ls, double lh) => TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: w,
      letterSpacing: ls,
      height: lh,
      color: c.textPrimary,
    );
    TextStyle body(double size, FontWeight w, double ls, double lh) =>
        TextStyle(
          fontFamily: family,
          fontSize: size,
          fontWeight: w,
          letterSpacing: ls,
          height: lh,
          color: c.textSecondary,
        );

    return TextTheme(
      displayLarge: h(44, FontWeight.w800, -1.2, 1.06),
      displayMedium: h(36, FontWeight.w800, -1.0, 1.08),
      displaySmall: h(30, FontWeight.w700, -0.8, 1.12),
      headlineLarge: h(26, FontWeight.w700, -0.6, 1.18),
      headlineMedium: h(22, FontWeight.w700, -0.4, 1.22),
      headlineSmall: h(19, FontWeight.w700, -0.3, 1.28),
      titleLarge: h(17, FontWeight.w700, -0.2, 1.3),
      titleMedium: h(15, FontWeight.w600, -0.1, 1.35),
      titleSmall: h(
        13.5,
        FontWeight.w600,
        0.0,
        1.35,
      ).copyWith(color: c.textSecondary),
      bodyLarge: body(15.5, FontWeight.w400, 0.0, 1.55),
      bodyMedium: body(14, FontWeight.w400, 0.0, 1.55),
      bodySmall: body(12.5, FontWeight.w400, 0.0, 1.5),
      labelLarge: h(14, FontWeight.w600, 0.1, 1.2),
      labelMedium: h(
        12,
        FontWeight.w600,
        0.2,
        1.2,
      ).copyWith(color: c.textSecondary),
      labelSmall: h(
        10.5,
        FontWeight.w700,
        0.6,
        1.2,
      ).copyWith(color: c.textMuted),
    );
  }
}

/// Small named alias so the input border reads clearly.
class BossBorder extends BorderSide {
  const BossBorder(Color color) : super(color: color, width: 1.6);
}
