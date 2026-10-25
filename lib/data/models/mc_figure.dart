/// A point in normalised figure space: 0..1 on both axes, y pointing down.
///
/// Deliberately Flutter-free so `dart run tool/audit.dart` can load the bank
/// without a rendering engine.
class Pt {
  const Pt(this.x, this.y);
  final double x;
  final double y;

  @override
  String toString() => '($x, $y)';
}

enum McPrimKind { line, dashed, circle, disc, box, triangle, arrow, text, arc }

/// One drawing instruction in a Mechanical Comprehension figure.
class McPrim {
  const McPrim.line(this.a, this.b, {this.weight = 2})
    : kind = McPrimKind.line,
      text = '',
      r = 0,
      solid = true,
      c = null;

  const McPrim.dashed(this.a, this.b)
    : kind = McPrimKind.dashed,
      weight = 1,
      text = '',
      r = 0,
      solid = true,
      c = null;

  const McPrim.circle(this.c, this.r, {this.solid = false, this.weight = 2})
    : kind = McPrimKind.circle,
      a = null,
      b = null,
      text = '';

  const McPrim.disc(this.c, this.r)
    : kind = McPrimKind.disc,
      solid = true,
      weight = 1,
      a = null,
      b = null,
      text = '';

  const McPrim.box(this.a, this.b)
    : kind = McPrimKind.box,
      weight = 2,
      text = '',
      r = 0,
      solid = true,
      c = null;

  const McPrim.triangle(this.a, this.b, this.c)
    : kind = McPrimKind.triangle,
      weight = 2,
      text = '',
      r = 0,
      solid = true;

  const McPrim.arrow(this.a, this.b)
    : kind = McPrimKind.arrow,
      weight = 2,
      text = '',
      r = 0,
      solid = true,
      c = null;

  const McPrim.text(this.text, this.a)
    : kind = McPrimKind.text,
      weight = 1,
      r = 0,
      solid = true,
      b = null,
      c = null;

  const McPrim.arc(this.c, this.r, this.a, this.b)
    : kind = McPrimKind.arc,
      weight = 1.5,
      text = '',
      solid = true;

  final McPrimKind kind;
  final Pt? a;
  final Pt? b;
  final Pt? c;
  final double r;
  final double weight;
  final String text;
  final bool solid;
}

/// A Mechanical Comprehension diagram.
///
/// The real subtest is figure-led: every officially published sample item shows
/// a diagram, and the answer options are frequently the bare labels printed on
/// it. Verbal-only MC items therefore teach the wrong shape of thinking, so
/// items may carry one of these.
class McFigure {
  const McFigure({
    required this.caption,
    required this.prims,
    this.aspect = 1.7,
  });

  /// Short accessible description, also read by the review screen.
  final String caption;

  final List<McPrim> prims;

  /// Width divided by height.
  final double aspect;
}
