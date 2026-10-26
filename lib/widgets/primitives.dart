import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';

/// A neutral surface used for nearly every block in the app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Space.lg),
    this.onTap,
    this.accent,
    this.radius = Radii.lg,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? accent;
  final double radius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radiusGeom = BorderRadius.circular(radius);
    final content = Container(
      decoration: BoxDecoration(
        color: elevated ? c.surfaceRaised : c.surface,
        borderRadius: radiusGeom,
        border: Border.all(color: accent?.withValues(alpha: 0.35) ?? c.border),
        boxShadow: elevated
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: radiusGeom,
      child: InkWell(
        onTap: onTap,
        borderRadius: radiusGeom,
        splashColor: c.primary.withValues(alpha: 0.06),
        highlightColor: c.primary.withValues(alpha: 0.04),
        child: content,
      ),
    );
  }
}

/// Small uppercase label above a value.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.text.labelSmall?.copyWith(
        color: color ?? context.colors.textMuted,
        letterSpacing: 0.9,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

enum PillTone { neutral, primary, success, warning, danger, accent, info }

class Pill extends StatelessWidget {
  const Pill(
    this.label, {
    super.key,
    this.tone = PillTone.neutral,
    this.icon,
    this.dense = false,
  });

  final String label;
  final PillTone tone;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg) = switch (tone) {
      PillTone.neutral => (c.surfaceSunken, c.textSecondary),
      PillTone.primary => (c.primarySoft, c.primary),
      PillTone.success => (c.successSoft, c.success),
      PillTone.warning => (c.warningSoft, c.warning),
      PillTone.danger => (c.dangerSoft, c.danger),
      PillTone.accent => (c.accentSoft, c.accent),
      PillTone.info => (c.infoSoft, c.info),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? Space.sm : Space.md,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      // A pill appears both inside a bounded card and inside an unbounded
      // strip, and a Flexible child in an unbounded Row is a layout error. So
      // the label only flexes when there is a width to flex into.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final text = Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          );
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: dense ? 11 : 13, color: fg),
                const SizedBox(width: Space.xs),
              ],
              if (constraints.maxWidth.isFinite)
                Flexible(child: text)
              else
                text,
            ],
          );
        },
      ),
    );
  }
}

/// A large number with a caption, used across the score report.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.caption,
    this.tone,
    this.compact = false,
  });

  final String label;
  final String value;
  final String? suffix;
  final String? caption;
  final Color? tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Eyebrow(label),
        const SizedBox(height: Space.xs),
        LayoutBuilder(
          builder: (context, constraints) {
            final number = Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  (compact
                          ? context.text.headlineMedium
                          : context.text.displaySmall)
                      ?.copyWith(color: tone ?? c.textPrimary),
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (constraints.maxWidth.isFinite)
                  Flexible(child: number)
                else
                  number,
                if (suffix != null) ...<Widget>[
                  const SizedBox(width: 2),
                  // The suffix is text too, so it grows with the system font
                  // size; it has to be allowed to give way rather than push the
                  // row past its edge.
                  Flexible(
                    child: Text(
                      suffix!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleMedium?.copyWith(
                        color: c.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        if (caption != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(
            caption!,
            style: context.text.bodySmall?.copyWith(color: c.textMuted),
          ),
        ],
      ],
    );
  }
}

/// Horizontal progress meter with an optional target marker.
class MeterBar extends StatelessWidget {
  const MeterBar({
    super.key,
    required this.value,
    this.target,
    this.height = 8,
    this.color,
    this.trackColor,
  });

  /// 0..1
  final double value;
  final double? target;
  final double height;
  final Color? color;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: trackColor ?? c.surfaceSunken,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? c.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              if (target != null)
                Positioned(
                  left: (width * target!.clamp(0.0, 1.0)) - 1,
                  top: -3,
                  bottom: -3,
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      color: c.textPrimary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Empty-state block used when a screen has no data yet.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.primarySoft,
                borderRadius: BorderRadius.circular(Radii.lg),
              ),
              child: Icon(icon, color: c.primary, size: 26),
            ),
            const SizedBox(height: Space.lg),
            Text(
              title,
              style: context.text.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.sm),
            Text(
              body,
              style: context.text.bodyMedium?.copyWith(color: c.textMuted),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: Space.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Applies a maximum content width and standard page padding.
class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.child,
    this.maxWidth = 1060,
    this.padding,
    this.scrollable = true,
    this.centerVertically = false,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  /// Vertically centres short content (onboarding steps) while still scrolling
  /// when the viewport is too short to fit it.
  final bool centerVertically;

  @override
  Widget build(BuildContext context) {
    final pad =
        padding ??
        EdgeInsets.symmetric(
          horizontal: context.isCompact ? Space.lg : Space.xxl,
          vertical: context.isCompact ? Space.lg : Space.xl,
        );
    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: pad, child: child),
    );
    if (centerVertically) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        ),
      );
    }
    final inner = Align(alignment: Alignment.topCenter, child: content);
    return scrollable ? SingleChildScrollView(child: inner) : inner;
  }
}

/// One-line callout used for caveats and teaching moments.
class Callout extends StatelessWidget {
  const Callout({
    super.key,
    required this.text,
    this.tone = PillTone.info,
    this.icon = Icons.info_outline_rounded,
    this.title,
  });

  final String text;
  final PillTone tone;
  final IconData icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg) = switch (tone) {
      PillTone.neutral => (c.surfaceSunken, c.textSecondary),
      PillTone.primary => (c.primarySoft, c.primary),
      PillTone.success => (c.successSoft, c.success),
      PillTone.warning => (c.warningSoft, c.warning),
      PillTone.danger => (c.dangerSoft, c.danger),
      PillTone.accent => (c.accentSoft, c.accent),
      PillTone.info => (c.infoSoft, c.info),
    };
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null) ...<Widget>[
                  Text(
                    title!,
                    style: context.text.labelLarge?.copyWith(color: fg),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  text,
                  style: context.text.bodySmall?.copyWith(
                    color: fg.withValues(alpha: 0.92),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
