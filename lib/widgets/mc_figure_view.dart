import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../data/models/mc_figure.dart';

/// Renders a Mechanical Comprehension diagram from its primitive list.
///
/// The model is plain data, which keeps the bank loadable outside a Flutter
/// binding; this widget is the only place that knows about Canvas.
class McFigureView extends StatelessWidget {
  const McFigureView({super.key, required this.figure, this.maxHeight = 210});

  final McFigure figure;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: c.border),
      ),
      padding: const EdgeInsets.all(Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: figure.aspect,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Semantics(
                label: figure.caption,
                child: CustomPaint(
                  painter: _FigurePainter(
                    figure: figure,
                    ink: c.textPrimary,
                    accent: c.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.xs),
          Text(
            figure.caption,
            style: context.text.bodySmall?.copyWith(
              color: c.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _FigurePainter extends CustomPainter {
  _FigurePainter({
    required this.figure,
    required this.ink,
    required this.accent,
  });

  final McFigure figure;
  final Color ink;
  final Color accent;

  Offset _p(Pt p, Size s) => Offset(p.x * s.width, p.y * s.height);

  double _unit(Size s) => math.min(s.width, s.height);

  @override
  void paint(Canvas canvas, Size size) {
    for (final prim in figure.prims) {
      final paint = Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = prim.weight
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      switch (prim.kind) {
        case McPrimKind.line:
          canvas.drawLine(_p(prim.a!, size), _p(prim.b!, size), paint);
        case McPrimKind.dashed:
          _dashed(canvas, _p(prim.a!, size), _p(prim.b!, size), paint);
        case McPrimKind.circle:
          canvas.drawCircle(_p(prim.c!, size), prim.r * _unit(size), paint);
        case McPrimKind.disc:
          canvas.drawCircle(
            _p(prim.c!, size),
            prim.r * _unit(size),
            Paint()..color = ink.withValues(alpha: 0.85),
          );
        case McPrimKind.box:
          canvas.drawRect(
            Rect.fromPoints(_p(prim.a!, size), _p(prim.b!, size)),
            paint,
          );
        case McPrimKind.triangle:
          final path = Path()
            ..moveTo(_p(prim.a!, size).dx, _p(prim.a!, size).dy)
            ..lineTo(_p(prim.b!, size).dx, _p(prim.b!, size).dy)
            ..lineTo(_p(prim.c!, size).dx, _p(prim.c!, size).dy)
            ..close();
          canvas.drawPath(path, paint);
        case McPrimKind.arrow:
          _arrow(canvas, _p(prim.a!, size), _p(prim.b!, size), paint);
        case McPrimKind.arc:
          canvas.drawArc(
            Rect.fromCircle(
              center: _p(prim.c!, size),
              radius: prim.r * _unit(size),
            ),
            _angle(prim.c!, prim.a!),
            _sweep(prim.c!, prim.a!, prim.b!),
            false,
            paint,
          );
        case McPrimKind.text:
          final tp = TextPainter(
            text: TextSpan(
              text: prim.text,
              style: TextStyle(
                // Name the family explicitly: a bare TextStyle inside a
                // TextPainter resolves to the platform default, which is a
                // block-glyph test font under flutter_test.
                fontFamily: 'Roboto',
                fontSize: math.max(10, size.width * 0.032),
                fontWeight: FontWeight.w700,
                color: accent,
                height: 1.1,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(
            canvas,
            _p(prim.a!, size) - Offset(tp.width / 2, tp.height / 2),
          );
      }
    }
  }

  double _angle(Pt from, Pt to) => math.atan2(to.y - from.y, to.x - from.x);

  double _sweep(Pt center, Pt start, Pt end) {
    var a = _angle(center, end) - _angle(center, start);
    while (a < 0) {
      a += 2 * math.pi;
    }
    return a;
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 6.0;
    const gap = 4.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    var t = 0.0;
    while (t < total) {
      final segEnd = math.min(t + dash, total);
      canvas.drawLine(a + dir * t, a + dir * segEnd, paint);
      t = segEnd + gap;
    }
  }

  void _arrow(Canvas canvas, Offset a, Offset b, Paint paint) {
    canvas.drawLine(a, b, paint);
    final dir = (b - a);
    final len = dir.distance;
    if (len < 1) return;
    final u = dir / len;
    final head = math.min(10.0, len * 0.4);
    final left = b - u * head + Offset(-u.dy, u.dx) * head * 0.5;
    final right = b - u * head + Offset(u.dy, -u.dx) * head * 0.5;
    canvas.drawLine(b, left, paint);
    canvas.drawLine(b, right, paint);
  }

  @override
  bool shouldRepaint(_FigurePainter old) =>
      old.figure != figure || old.ink != ink;
}
