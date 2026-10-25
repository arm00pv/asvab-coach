import 'package:flutter/material.dart';

/// Design tokens: a single source of truth for colour, spacing, radius and
/// motion. Every widget reads from here so the product stays visually
/// coherent as it grows.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.surfaceSunken,
    required this.surfaceRaised,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primarySoft,
    required this.onPrimary,
    required this.accent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceSunken;
  final Color surfaceRaised;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color primary;
  final Color primarySoft;
  final Color onPrimary;
  final Color accent;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;

  static const light = AppColors(
    canvas: Color(0xFFF6F7F4),
    surface: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEFF1EC),
    surfaceRaised: Color(0xFFFFFFFF),
    border: Color(0xFFE1E5DC),
    borderStrong: Color(0xFFC8CFC2),
    textPrimary: Color(0xFF12211B),
    textSecondary: Color(0xFF44544C),
    textMuted: Color(0xFF75847C),
    primary: Color(0xFF14503F),
    primarySoft: Color(0xFFE3EDE8),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF9C7418),
    accentSoft: Color(0xFFF7EEDC),
    success: Color(0xFF2B6E45),
    successSoft: Color(0xFFE2F0E6),
    warning: Color(0xFF8F5A06),
    warningSoft: Color(0xFFFBEED6),
    danger: Color(0xFFA62B24),
    dangerSoft: Color(0xFFFAE4E2),
    info: Color(0xFF1F4E79),
    infoSoft: Color(0xFFE3EDF6),
  );

  static const dark = AppColors(
    canvas: Color(0xFF0C1311),
    surface: Color(0xFF141E1B),
    surfaceSunken: Color(0xFF090F0D),
    surfaceRaised: Color(0xFF1C2925),
    border: Color(0xFF283731),
    borderStrong: Color(0xFF3B4E46),
    textPrimary: Color(0xFFEAF1ED),
    textSecondary: Color(0xFFA6B7AE),
    textMuted: Color(0xFF7A8C82),
    primary: Color(0xFF5FBF9B),
    primarySoft: Color(0xFF16322A),
    onPrimary: Color(0xFF04120D),
    accent: Color(0xFFE0B44E),
    accentSoft: Color(0xFF32280F),
    success: Color(0xFF62C08A),
    successSoft: Color(0xFF14301F),
    warning: Color(0xFFE3AC53),
    warningSoft: Color(0xFF31240C),
    danger: Color(0xFFEB8079),
    dangerSoft: Color(0xFF35201E),
    info: Color(0xFF7FB6E8),
    infoSoft: Color(0xFF122636),
  );

  @override
  AppColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceSunken,
    Color? surfaceRaised,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? primarySoft,
    Color? onPrimary,
    Color? accent,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? info,
    Color? infoSoft,
  }) {
    return AppColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      info: info ?? this.info,
      infoSoft: infoSoft ?? this.infoSoft,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      canvas: c(canvas, other.canvas),
      surface: c(surface, other.surface),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      surfaceRaised: c(surfaceRaised, other.surfaceRaised),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textMuted: c(textMuted, other.textMuted),
      primary: c(primary, other.primary),
      primarySoft: c(primarySoft, other.primarySoft),
      onPrimary: c(onPrimary, other.onPrimary),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      success: c(success, other.success),
      successSoft: c(successSoft, other.successSoft),
      warning: c(warning, other.warning),
      warningSoft: c(warningSoft, other.warningSoft),
      danger: c(danger, other.danger),
      dangerSoft: c(dangerSoft, other.dangerSoft),
      info: c(info, other.info),
      infoSoft: c(infoSoft, other.infoSoft),
    );
  }
}

/// 4pt spacing scale.
abstract final class Space {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;
}

abstract final class Radii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const Radius pill = Radius.circular(999);
}

abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration base = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 420);
  static const Curve ease = Curves.easeOutCubic;
}

/// Responsive breakpoints. Designed mobile-first, expands at >= 900dp.
abstract final class Breakpoints {
  static const double compact = 640;
  static const double medium = 900;
  static const double expanded = 1240;
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isCompact => MediaQuery.sizeOf(this).width < Breakpoints.compact;
  bool get isMediumUp => MediaQuery.sizeOf(this).width >= Breakpoints.medium;
  bool get isExpanded => MediaQuery.sizeOf(this).width >= Breakpoints.expanded;
}
