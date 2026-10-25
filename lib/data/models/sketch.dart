/// A point in normalised sketch space: 0..1 on both axes, y pointing down.
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

enum SketchPrimKind {
  line,
  dashed,
  circle,
  disc,
  box,
  triangle,
  arrow,
  text,
  arc,
  poly,
}

/// One drawing instruction in a [Sketch].
///
/// The vocabulary is small on purpose. Every primitive is a stroked line-art
/// mark, which is what the real test prints: Mechanical Comprehension setups
/// are line diagrams, and Auto & Shop tool identification uses outline
/// drawings rather than photographs.
class SketchPrim {
  const SketchPrim.line(this.a, this.b, {this.weight = 2})
    : kind = SketchPrimKind.line,
      text = '',
      r = 0,
      solid = true,
      c = null,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.dashed(this.a, this.b)
    : kind = SketchPrimKind.dashed,
      weight = 1,
      text = '',
      r = 0,
      solid = true,
      c = null,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.circle(this.c, this.r, {this.solid = false, this.weight = 2})
    : kind = SketchPrimKind.circle,
      a = null,
      b = null,
      text = '',
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.disc(this.c, this.r)
    : kind = SketchPrimKind.disc,
      solid = true,
      weight = 1,
      a = null,
      b = null,
      text = '',
      pts = const <Pt>[],
      closed = true,
      fill = true;

  const SketchPrim.box(this.a, this.b)
    : kind = SketchPrimKind.box,
      weight = 2,
      text = '',
      r = 0,
      solid = true,
      c = null,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.triangle(this.a, this.b, this.c)
    : kind = SketchPrimKind.triangle,
      weight = 2,
      text = '',
      r = 0,
      solid = true,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.arrow(this.a, this.b)
    : kind = SketchPrimKind.arrow,
      weight = 2,
      text = '',
      r = 0,
      solid = true,
      c = null,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.text(this.text, this.a)
    : kind = SketchPrimKind.text,
      weight = 1,
      r = 0,
      solid = true,
      b = null,
      c = null,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  const SketchPrim.arc(this.c, this.r, this.a, this.b)
    : kind = SketchPrimKind.arc,
      weight = 1.5,
      text = '',
      solid = true,
      pts = const <Pt>[],
      closed = true,
      fill = false;

  /// An arbitrary connected path. Set [closed] false for an open polyline and
  /// [fill] true to shade the enclosed area.
  const SketchPrim.poly(
    this.pts, {
    this.closed = true,
    this.fill = false,
    this.weight = 2,
  }) : kind = SketchPrimKind.poly,
       text = '',
       r = 0,
       solid = true,
       a = null,
       b = null,
       c = null;

  final SketchPrimKind kind;
  final Pt? a;
  final Pt? b;
  final Pt? c;
  final List<Pt> pts;
  final double r;
  final double weight;
  final String text;
  final bool solid;
  final bool closed;
  final bool fill;
}

/// A line-art picture shown alongside an item.
///
/// Two subtests are picture-led and need this. Mechanical Comprehension prints
/// a diagram on every officially published sample item, and the Auto & Shop
/// half of the real subtest identifies hand tools from outline drawings.
/// Verbal-only items in either subtest therefore teach the wrong shape of
/// thinking, so items may carry one of these.
class Sketch {
  const Sketch({required this.caption, required this.prims, this.aspect = 1.7});

  /// Short accessible description, also read by the review screen.
  ///
  /// For a tool-identification item this must describe the *shape* of the
  /// drawing and never name the tool, or it prints the answer.
  final String caption;

  final List<SketchPrim> prims;

  /// Width divided by height.
  final double aspect;
}
