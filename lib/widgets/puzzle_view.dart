import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../data/models/polyomino.dart';

/// Draws one polyomino as a grid of filled cells.
///
/// Assembling Objects cannot be tested with prose alone - the subtest is purely
/// spatial - so the app renders real geometry with a painter and derives
/// correctness from the geometry, not from a hand-written answer key.
class PolyView extends StatelessWidget {
  const PolyView({
    super.key,
    required this.poly,
    required this.cell,
    required this.fill,
    required this.stroke,
    this.strokeWidth = 1.6,
    this.radius = 4,
  });

  final Poly poly;
  final double cell;
  final Color fill;
  final Color stroke;
  final double strokeWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: poly.width * cell,
      height: poly.height * cell,
      child: CustomPaint(
        painter: _PolyPainter(
          poly: poly,
          cell: cell,
          fill: fill,
          stroke: stroke,
          strokeWidth: strokeWidth,
          radius: radius,
        ),
      ),
    );
  }
}

class _PolyPainter extends CustomPainter {
  _PolyPainter({
    required this.poly,
    required this.cell,
    required this.fill,
    required this.stroke,
    required this.strokeWidth,
    required this.radius,
  });

  final Poly poly;
  final double cell;
  final Color fill;
  final Color stroke;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final minX = poly.minX;
    final minY = poly.minY;
    final fillPaint = Paint()..color = fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = stroke;

    for (final c in poly.cells) {
      final rect = Rect.fromLTWH(
        (c.x - minX) * cell + strokeWidth / 2,
        (c.y - minY) * cell + strokeWidth / 2,
        cell - strokeWidth,
        cell - strokeWidth,
      );
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rrect, fillPaint);
      canvas.drawRRect(rrect, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_PolyPainter old) => old.poly != poly || old.cell != cell;
}

/// Lays the loose pieces of a puzzle out in a centred row.
class LoosePieces extends StatelessWidget {
  const LoosePieces({
    super.key,
    required this.pieces,
    this.cell = 22,
    this.gap = Space.lg,
  });

  final List<Poly> pieces;
  final double cell;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.lg,
      ),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: c.border),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: gap,
        runSpacing: gap,
        children: <Widget>[
          for (final p in pieces)
            PolyView(
              poly: p,
              cell: cell,
              fill: c.primary.withValues(alpha: 0.16),
              stroke: c.primary,
            ),
        ],
      ),
    );
  }
}

/// One selectable candidate assembly.
class AssemblyOption extends StatelessWidget {
  const AssemblyOption({
    super.key,
    required this.label,
    required this.poly,
    required this.selected,
    required this.onTap,
    this.state,
    this.cell = 16,
  });

  final String label;
  final Poly poly;
  final bool selected;
  final VoidCallback onTap;

  /// null = unanswered, correct/wrong used by the review screen.
  final OptionState? state;

  final double cell;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (border, bg) = switch (state) {
      OptionState.correct => (c.success, c.successSoft),
      OptionState.wrong => (c.danger, c.dangerSoft),
      OptionState.missed => (c.success.withValues(alpha: 0.5), c.successSoft),
      null => selected ? (c.primary, c.primarySoft) : (c.border, c.surface),
    };
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.md),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Radii.md),
            border: Border.all(
              color: border,
              width: selected || state != null ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.lg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 72,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: PolyView(
                      poly: poly,
                      cell: cell,
                      fill: c.textPrimary.withValues(alpha: 0.10),
                      stroke: state == null ? c.textSecondary : border,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.sm),
              Text(
                label,
                style: context.text.labelMedium?.copyWith(
                  color: selected || state != null ? border : c.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum OptionState { correct, wrong, missed }

/// Small glyph representing a subtest, used in lists and headers.
class SubtestGlyph extends StatelessWidget {
  const SubtestGlyph({
    super.key,
    required this.abbr,
    this.size = 34,
    this.tone,
  });

  final String abbr;
  final double size;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = tone ?? c.primary;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        abbr,
        style: context.text.labelSmall?.copyWith(
          color: color,
          fontSize: size * 0.33,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Draws a tiny distribution bar for a subtest (correct vs total).
class MiniBars extends StatelessWidget {
  const MiniBars({
    super.key,
    required this.values,
    this.color,
    this.height = 3,
    this.maxValue = 99,
  });

  final List<int> values;
  final Color? color;
  final double height;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (var i = 0; i < values.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 2),
          Container(
            width: 4,
            height: math.max(
              3,
              (values[i].clamp(0, maxValue) / maxValue) * height * 8,
            ),
            decoration: BoxDecoration(
              color: (color ?? c.primary).withValues(
                alpha: 0.35 + 0.65 * (i + 1) / values.length,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }
}
