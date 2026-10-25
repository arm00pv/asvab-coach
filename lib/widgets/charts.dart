import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';

/// Readiness ring: an AFQT percentile drawn as a 270-degree arc.
class ReadinessGauge extends StatelessWidget {
  const ReadinessGauge({
    super.key,
    required this.value,
    required this.max,
    required this.label,
    required this.sublabel,
    this.size = 168,
    this.color,
    this.target,
    this.bandLabel,
  });

  /// 0..max
  final int value;
  final int max;
  final String label;
  final String sublabel;
  final double size;
  final Color? color;

  /// Optional dashed target marker, also 0..max.
  final int? target;
  final String? bandLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final frac = (value / max).clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(
          fraction: frac,
          targetFraction: target == null
              ? null
              : (target! / max).clamp(0.0, 1.0),
          track: c.surfaceSunken,
          progress: color ?? c.primary,
          marker: c.textPrimary,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (bandLabel != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    bandLabel!,
                    style: context.text.labelSmall?.copyWith(
                      color: color ?? c.primary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              Text(
                '$value',
                style: context.text.displayMedium?.copyWith(
                  fontSize: size * 0.28,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: context.text.labelMedium?.copyWith(color: c.textMuted),
              ),
              const SizedBox(height: 1),
              Text(
                sublabel,
                style: context.text.bodySmall?.copyWith(
                  color: c.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.fraction,
    required this.targetFraction,
    required this.track,
    required this.progress,
    required this.marker,
  });

  final double fraction;
  final double? targetFraction;
  final Color track;
  final Color progress;
  final Color marker;

  static const double startAngle = math.pi * 0.75;
  static const double sweep = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.075;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width - stroke) / 2,
    );

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(rect, startAngle, sweep, false, trackPaint);

    if (fraction > 0.001) {
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweep,
          colors: <Color>[progress.withValues(alpha: 0.75), progress],
          transform: GradientRotation(startAngle),
        ).createShader(rect);
      canvas.drawArc(rect, startAngle, sweep * fraction, false, progressPaint);
    }

    if (targetFraction != null) {
      final angle = startAngle + sweep * targetFraction!;
      final center = Offset(size.width / 2, size.height / 2);
      final outer = (size.width - stroke) / 2 - stroke * 0.9;
      final inner = (size.width - stroke) / 2 + stroke * 0.9;
      final p1 = center + Offset(math.cos(angle), math.sin(angle)) * inner;
      final p2 = center + Offset(math.cos(angle), math.sin(angle)) * outer;
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..color = marker.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.fraction != fraction ||
      old.targetFraction != targetFraction ||
      old.progress != progress;
}

/// Nine-axis radar of subtest standard scores.
class SubtestRadar extends StatelessWidget {
  const SubtestRadar({
    super.key,
    required this.labels,
    required this.values,
    this.size = 260,
    this.minValue = 20,
    this.maxValue = 80,
    this.reference,
  });

  final List<String> labels;

  /// Standard scores aligned with [labels].
  final List<int> values;

  final double size;
  final num minValue;
  final num maxValue;

  /// An optional earlier profile drawn as a faint outline for comparison.
  final List<int>? reference;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarPainter(
          labels: labels,
          values: values,
          reference: reference,
          minValue: minValue.toDouble(),
          maxValue: maxValue.toDouble(),
          grid: c.border,
          fill: c.primary,
          labelColor: c.textMuted,
          referenceColor: c.textMuted,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.labels,
    required this.values,
    required this.reference,
    required this.minValue,
    required this.maxValue,
    required this.grid,
    required this.fill,
    required this.labelColor,
    required this.referenceColor,
  });

  final List<String> labels;
  final List<int> values;
  final List<int>? reference;
  final double minValue;
  final double maxValue;
  final Color grid;
  final Color fill;
  final Color labelColor;
  final Color referenceColor;

  @override
  void paint(Canvas canvas, Size size) {
    final n = labels.length;
    if (n < 3) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 26;

    Offset point(int i, double frac) {
      final angle = -math.pi / 2 + (2 * math.pi * i) / n;
      return center +
          Offset(math.cos(angle), math.sin(angle)) * (radius * frac);
    }

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = grid;

    for (var ring = 1; ring <= 3; ring++) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final p = point(i, ring / 3);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    for (var i = 0; i < n; i++) {
      canvas.drawLine(center, point(i, 1), gridPaint);
    }

    double fracFor(int v) =>
        ((v - minValue) / (maxValue - minValue)).clamp(0.06, 1.0);

    if (reference != null && reference!.length == n) {
      final path = Path();
      for (var i = 0; i < n; i++) {
        final p = point(i, fracFor(reference![i]));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = referenceColor.withValues(alpha: 0.45),
      );
    }

    final path = Path();
    for (var i = 0; i < n; i++) {
      final p = point(i, fracFor(values[i]));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = fill.withValues(alpha: 0.16));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..color = fill,
    );

    for (var i = 0; i < n; i++) {
      canvas.drawCircle(
        point(i, fracFor(values[i])),
        2.6,
        Paint()..color = fill,
      );
      final labelPoint = point(i, 1.16);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: labelColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, labelPoint - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_RadarPainter old) =>
      old.values != values || old.reference != reference;
}

/// Compact line chart for a score trend.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.height = 44,
    this.color,
    this.showArea = true,
  });

  final List<int> values;
  final double height;
  final Color? color;
  final bool showArea;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (values.length < 2) {
      return SizedBox(
        height: height,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Needs two attempts to plot a trend',
            style: context.text.bodySmall?.copyWith(color: c.textMuted),
          ),
        ),
      );
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparkPainter(
          values: values,
          color: color ?? c.primary,
          showArea: showArea,
        ),
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({
    required this.values,
    required this.color,
    required this.showArea,
  });

  final List<int> values;
  final Color color;
  final bool showArea;

  @override
  void paint(Canvas canvas, Size size) {
    final lo = values.reduce(math.min).toDouble();
    final hi = values.reduce(math.max).toDouble();
    final span = (hi - lo).abs() < 1 ? 1.0 : hi - lo;
    final dx = size.width / (values.length - 1);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - 4 - ((values[i] - lo) / span) * (size.height - 8);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (showArea) {
      final area = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              color.withValues(alpha: 0.22),
              color.withValues(alpha: 0.0),
            ],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );

    final lastX = dx * (values.length - 1);
    final lastY =
        size.height - 4 - ((values.last - lo) / span) * (size.height - 8);
    canvas.drawCircle(Offset(lastX, lastY), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparkPainter old) => old.values != values;
}

/// Circular countdown used by the exam runner.
class TimeRing extends StatelessWidget {
  const TimeRing({
    super.key,
    required this.label,
    required this.fraction,
    required this.critical,
    this.size = 46,
  });

  final String label;

  /// 1.0 = full time remaining.
  final double fraction;
  final bool critical;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = critical ? c.danger : c.textSecondary;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: fraction.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 320),
            builder: (context, value, _) => CustomPaint(
              size: Size(size, size),
              painter: _RingPainter(
                fraction: value,
                track: c.surfaceSunken,
                progress: color,
                stroke: 3.5,
              ),
            ),
          ),
          Text(
            label,
            style: context.text.labelMedium?.copyWith(
              color: color,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.track,
    required this.progress,
    required this.stroke,
  });

  final double fraction;
  final Color track;
  final Color progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width - stroke) / 2,
    );
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = progress,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction;
}
