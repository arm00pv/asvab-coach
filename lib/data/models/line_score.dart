import 'catalog.dart';

/// Army aptitude areas (line scores).
///
/// These numbers are NOT a naive sum of the four subtests named in the popular
/// prep-book formulas. Every Army composite except GT is an optimally-weighted
/// regression composite over the seven reported standard scores, rescaled so an
/// average applicant scores exactly 100 on a scale with a standard deviation of
/// 20 in the PAY97 youth reference population.
///
/// Sources: Segall, D. O. (2004) *Development and Evaluation of the 1997 ASVAB
/// Score Scale*, DMDC, section 2.5.3 and Table 2.7 (Army Composite Weights,
/// '97 metric); ASVAB Technical Bulletin No. 4, Table C.1.
///
/// The legacy nominal definitions printed in most study guides ("CL = VE + AR +
/// MK", "MM = NO + AS + MC + EI") reference subtests such as NO and CS that were
/// removed from the battery in 2002 and cannot be computed at all today. The app
/// shows the nominal definition for recognition but scores with the operational
/// weights below.
enum LineScore {
  gt(
    'GT',
    'General Technical',
    'Officer candidate school, warrant officer and most technical MOS. '
        'The single most-referenced Army line score.',
    nominalFormula: 'VE + AR',
    isLiteralSum: true,
  ),
  st(
    'ST',
    'Skilled Technical',
    'The most common MOS gate. Weighted heavily toward verbal and arithmetic.',
    nominalFormula: 'GS + VE + MK + MC',
    weights: _st,
    constant: -19.65219,
    veWeight: 0.62177,
  ),
  cl(
    'CL',
    'Clerical',
    'Administrative, legal and personnel MOS.',
    nominalFormula: 'VE + AR + MK',
    weights: _cl,
    constant: -14.32772,
    veWeight: 0.67976,
  ),
  co(
    'CO',
    'Combat',
    'Infantry, armor and combat arms MOS.',
    nominalFormula: 'VE + AR + AS + MC',
    weights: _co,
    constant: -23.17105,
    veWeight: 0.30347,
  ),
  el(
    'EL',
    'Electronics',
    'Electronics, avionics and missile maintenance.',
    nominalFormula: 'GS + AR + MK + EI',
    weights: _el,
    constant: -22.46667,
    veWeight: 0.49906,
  ),
  fa(
    'FA',
    'Field Artillery',
    'Cannon crew and fire support.',
    nominalFormula: 'AR + CS + MK + MC (CS removed from the battery in 2002)',
    weights: _fa,
    constant: -22.32119,
    veWeight: 0.31958,
  ),
  gm(
    'GM',
    'General Maintenance',
    'Wheeled vehicle and equipment repair.',
    nominalFormula: 'GS + AS + MK + EI',
    weights: _gm,
    constant: -23.36174,
    veWeight: 0.21527,
  ),
  mm(
    'MM',
    'Mechanical Maintenance',
    'Mechanical repair and machining.',
    nominalFormula: 'NO + AS + MC + EI (NO removed from the battery in 2002)',
    weights: _mm,
    constant: -23.08481,
    veWeight: 0.21150,
  ),
  of(
    'OF',
    'Operators and Food',
    'Operators, cooks and supply.',
    nominalFormula: 'VE + NO + AS + MC (NO removed from the battery in 2002)',
    weights: _of,
    constant: -22.84882,
    veWeight: 0.36757,
  ),
  sc(
    'SC',
    'Surveillance and Communications',
    'Intel, signal and surveillance systems.',
    nominalFormula: 'VE + AR + AS + MC',
    weights: _sc,
    constant: -21.18951,
    veWeight: 0.52770,
  ),
  ve(
    'VE',
    'Verbal Expression',
    'Optimal WK/PC composite on the subtest scale. Feeds GT and the AFQT.',
    nominalFormula:
        'WK + PC (PC weighted at 0.619 of WK) - subtest scale, mean 50',
    isVe: true,
  );

  const LineScore(
    this.abbr,
    this.label,
    this.blurb, {
    required this.nominalFormula,
    this.weights = const <Subtest, double>{},
    this.constant = 0,
    this.veWeight = 0,
    this.isLiteralSum = false,
    this.isVe = false,
  });

  final String abbr;
  final String label;
  final String blurb;

  /// The textbook definition, shown for recognition only.
  final String nominalFormula;

  /// Operational regression weights over the reported standard scores.
  final Map<Subtest, double> weights;

  /// Intercept of the weighted sum; chosen so every subtest at 50 yields 100.
  final double constant;

  /// Weight applied to the verbal composite inside this aptitude area.
  final double veWeight;

  final bool isLiteralSum;
  final bool isVe;

  /// The '97 metric slope for GT: 20 / 18.6169, i.e. pure SD rescaling.
  static const double gtSlope = 1.074292;
  static const double gtIntercept = -7.443781;

  /// WK/PC weight ratio used to build VE (b_PC / b_WK).
  static const double pcToWkWeight = 0.61934;

  /// Computes the reported value. [ss] resolves a subtest standard score and
  /// [ve] is the already-resolved verbal composite.
  int compute(int Function(Subtest) ss, int ve) {
    if (isVe) return ve;
    if (isLiteralSum) {
      final raw = gtSlope * (ve + ss(Subtest.ar)) + gtIntercept;
      return raw.round().clamp(1, 220);
    }
    var sum = 0.0;
    for (final entry in weights.entries) {
      sum += entry.value * ss(entry.key);
    }
    sum += veWeight * ve;
    return (sum + constant).round().clamp(1, 220);
  }

  /// Every subtest whose standard score moves this area, read straight off the
  /// terms [compute] applies: the weighted rows of a regression composite, the
  /// VE composite where this area carries a verbal weight, and Arithmetic
  /// Reasoning for GT, whose published definition is the literal VE + AR sum.
  ///
  /// This is the composition itself, not a second copy of it. Anything that
  /// needs to send a candidate to practise what feeds one line score reads the
  /// list here, so changing a weight changes the practice set with it. VE is
  /// listed as the two subtests it is built from, because those are the sections
  /// a candidate can actually sit, and the one literal sum in the model - GT,
  /// whose published definition is VE + AR - contributes both VE's halves and
  /// AR. Assembling Objects appears in no area and so appears in no list here.
  Set<Subtest> get feedingSubtests => <Subtest>{
    if (isVe) ...Subtest.veSubtests,
    if (isLiteralSum) ...<Subtest>[Subtest.ar, ...Subtest.veSubtests],
    ...weights.keys,
    if (veWeight != 0) ...Subtest.veSubtests,
  };

  /// Builds the verbal composite from WK and PC standard scores.
  static int verbalComposite(int wk, int pc) {
    final wWk = 1 / (1 + pcToWkWeight);
    final wPc = 1 - wWk;
    final raw = wWk * wk + wPc * pc;
    // The weighted pair has an observed SD near 9.0; rescale back onto the
    // standard score scale so VE keeps mean 50 and SD 10.
    final rescaled = 50 + (raw - 50) * 1.1104;
    return rescaled.round().clamp(1, 99);
  }

  /// AFQT composite = AR + MK + 2 x VE (mean 202, SD ~36 in PAY97).
  static int afqtComposite(int ve, int ar, int mk) => ar + mk + 2 * ve;

  /// The AFQT subtest mapping used for display only.
  static const Map<Subtest, int> afqtWeights = <Subtest, int>{
    Subtest.wk: 2,
    Subtest.pc: 2,
    Subtest.ar: 1,
    Subtest.mk: 1,
  };
}

const Map<Subtest, double> _st = <Subtest, double>{
  Subtest.gs: 0.12865,
  Subtest.ar: 0.49010,
  Subtest.mk: 0.47825,
  Subtest.mc: 0.31207,
  Subtest.ei: 0.14493,
  Subtest.as: 0.21736,
};

const Map<Subtest, double> _cl = <Subtest, double>{
  Subtest.ar: 0.75179,
  Subtest.mk: 0.58715,
  Subtest.mc: 0.11541,
  Subtest.ei: 0.07756,
  Subtest.as: 0.07489,
};

const Map<Subtest, double> _co = <Subtest, double>{
  Subtest.gs: 0.19868,
  Subtest.ar: 0.33090,
  Subtest.mk: 0.63397,
  Subtest.mc: 0.38486,
  Subtest.ei: 0.19979,
  Subtest.as: 0.41161,
};

const Map<Subtest, double> _el = <Subtest, double>{
  Subtest.gs: 0.08324,
  Subtest.ar: 0.44254,
  Subtest.mk: 0.49064,
  Subtest.mc: 0.26341,
  Subtest.ei: 0.30258,
  Subtest.as: 0.36786,
};

const Map<Subtest, double> _fa = <Subtest, double>{
  Subtest.gs: 0.15031,
  Subtest.ar: 0.42263,
  Subtest.mk: 0.60172,
  Subtest.mc: 0.42966,
  Subtest.ei: 0.16389,
  Subtest.as: 0.35866,
};

const Map<Subtest, double> _gm = <Subtest, double>{
  Subtest.gs: 0.23521,
  Subtest.ar: 0.46357,
  Subtest.mk: 0.45285,
  Subtest.mc: 0.29280,
  Subtest.ei: 0.30216,
  Subtest.as: 0.50542,
};

const Map<Subtest, double> _mm = <Subtest, double>{
  Subtest.gs: 0.05942,
  Subtest.ar: 0.32829,
  Subtest.mk: 0.28517,
  Subtest.mc: 0.39607,
  Subtest.ei: 0.30796,
  Subtest.as: 0.87309,
};

const Map<Subtest, double> _of = <Subtest, double>{
  Subtest.gs: 0.14306,
  Subtest.ar: 0.53676,
  Subtest.mk: 0.34092,
  Subtest.mc: 0.36843,
  Subtest.ei: 0.19683,
  Subtest.as: 0.50334,
};

const Map<Subtest, double> _sc = <Subtest, double>{
  Subtest.gs: 0.01235,
  Subtest.ar: 0.42812,
  Subtest.mk: 0.63650,
  Subtest.mc: 0.25070,
  Subtest.ei: 0.32194,
  Subtest.as: 0.24636,
};

/// One requirement row: "this aptitude area must be at least this value".
class LineScoreRequirement {
  const LineScoreRequirement(this.score, this.min);
  final LineScore score;
  final int min;

  String get label => '${score.abbr} $min';
}

/// A MOS gate. The Army publishes requirements as a set of OR alternatives,
/// each of which may itself be a set of ANDed line scores.
class AptitudeGate {
  const AptitudeGate(this.alternatives);

  /// A gate with nothing in it, for an entry whose requirement is not an
  /// aptitude line score at all.
  ///
  /// A warrant officer occupation is the case: the authority publishes a grade
  /// band, a feeder MOS, a course, a clearance and a physical, and prints a line
  /// score for exactly two of them. Written down rather than left to
  /// `const AptitudeGate(<List<LineScoreRequirement>>[])` at each call site,
  /// because an empty gate is a claim ("nothing to clear") and a claim with a
  /// name beside it is easier to audit than an empty list literal.
  static const AptitudeGate none = AptitudeGate(<List<LineScoreRequirement>>[]);

  /// Outer list = OR, inner list = AND.
  final List<List<LineScoreRequirement>> alternatives;

  bool get isEmpty => alternatives.isEmpty;

  String get label => alternatives
      .map((alt) => alt.map((r) => r.label).join(' + '))
      .join('  or  ');
}
