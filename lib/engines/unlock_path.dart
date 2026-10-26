import '../data/models/line_score.dart';
import '../data/models/mos.dart';

/// The way in to a job the candidate currently misses (ROADMAP Phase 3).
///
/// "Eligibility is a wall until you show its lowest stone." Every other part of
/// the app answers eligibility with yes or no. This engine answers it with
/// arithmetic: for one MOS gate it names, against the candidate's real line
/// scores, which aptitude area is short, by how many points, and which single
/// raise unlocks the job - or which raise gets closest when no single one
/// finishes it.
///
/// It is pure logic: no widgets, no storage, no dependency on the catalogue
/// *data* (only on the schema in 'data/models'), so it can be unit-tested
/// without an app and called from any screen.
///
/// The gate model is the Army's own: an [AptitudeGate] is a list of OR
/// alternatives, each a list of ANDed [LineScoreRequirement] rows. Three shapes
/// have to survive that model:
///
///  * a published gate, possibly demanding several areas at once;
///  * no requirement at all - the MOS publishes no line-score gate, which is a
///    different fact from "we do not know";
///  * a gate the app cannot trust - absent from the data, or structurally
///    broken. Those are the only two cases with no path, and they say so.
abstract final class UnlockPathEngine {
  /// The ceiling of the Army reporting scale ([LineScore.compute] clamps to it).
  static const int lineScoreCeiling = 220;

  /// The engine's convenience entry point: a catalogue MOS plus the candidate's
  /// line scores. Everything the result's caveats need (clearance, extra test,
  /// AFQT floor) is read off the same [Mos].
  static UnlockPath forMos(Mos mos, Map<LineScore, int> lineScores) {
    return forGate(
      mosCode: mos.code,
      mosTitle: mos.title,
      gate: mos.gate,
      lineScores: lineScores,
      note: mos.note,
      extraTest: mos.extraTest,
      securityClearance: mos.securityClearance,
      afqtFloor: mos.asvabMinimum,
    );
  }

  /// The engine's whole surface, for callers that hold a gate but not a [Mos].
  ///
  /// [lineScores] may be empty - a candidate who has never sat the diagnostic -
  /// in which case every area reads 0 and the result says so. A missing entry is
  /// never treated as "probably fine".
  static UnlockPath forGate({
    required String mosCode,
    required AptitudeGate gate,
    required Map<LineScore, int> lineScores,
    String? mosTitle,
    String? note,
    String? extraTest,
    bool securityClearance = false,
    int? afqtFloor,
  }) {
    final caveats = <String>[
      if (securityClearance)
        'Eligibility for a security clearance is also required.',
      if (extraTest != null)
        'An additional selection test is required: $extraTest.',
      if (afqtFloor != null)
        'Also requires an AFQT percentile of $afqtFloor. AFQT is not a line '
            'score, so no route here reaches it.',
    ];
    final hasScores = lineScores.isNotEmpty;

    int actual(LineScore score) => lineScores[score] ?? 0;

    final malformed = _malformation(gate);
    if (malformed != null) {
      return UnlockPath(
        mosCode: mosCode,
        mosTitle: mosTitle,
        status: UnlockStatus.gateMalformed,
        routes: const <UnlockRoute>[],
        shortfalls: const <GatePartResult>[],
        caveats: caveats,
        hasScores: hasScores,
        message:
            'The $mosCode gate in the catalogue is malformed ($malformed), so '
            'the app will not guess a route into it. Which line score is short '
            'cannot be named until the gate record is fixed.',
      );
    }

    if (gate.isEmpty) {
      if (extraTest != null || _saysNoLineScoreGate(note)) {
        return UnlockPath(
          mosCode: mosCode,
          mosTitle: mosTitle,
          status: UnlockStatus.noRequirement,
          routes: const <UnlockRoute>[],
          shortfalls: const <GatePartResult>[],
          caveats: caveats,
          hasScores: hasScores,
          message:
              '$mosCode publishes no line-score gate, so there is no line score '
              'to raise. ${extraTest == null ? 'Selection is on other criteria.' : 'Selection is by $extraTest.'}',
        );
      }
      return UnlockPath(
        mosCode: mosCode,
        mosTitle: mosTitle,
        status: UnlockStatus.gateUnknown,
        routes: const <UnlockRoute>[],
        shortfalls: const <GatePartResult>[],
        caveats: caveats,
        hasScores: hasScores,
        message:
            'The app has no line-score gate on record for $mosCode, so it cannot '
            'say which score is short or by how much. No route is claimed rather '
            'than guessed.',
      );
    }

    final alternatives = gate.alternatives;

    for (var i = 0; i < alternatives.length; i++) {
      if (_satisfied(alternatives[i], actual)) {
        return UnlockPath(
          mosCode: mosCode,
          mosTitle: mosTitle,
          status: UnlockStatus.alreadyQualified,
          routes: const <UnlockRoute>[],
          shortfalls: const <GatePartResult>[],
          caveats: caveats,
          hasScores: hasScores,
          message:
              'You already clear the $mosCode gate '
              '(${describeAlternative(alternatives[i])}). Nothing is short.',
        );
      }
    }

    // Why the candidate misses it today: the closest published alternative's
    // unmet rows. Fewest rows first, then fewest points, then catalogue order,
    // so the same inputs always nominate the same alternative.
    var closestIndex = 0;
    var closest = _unmetRows(alternatives.first, actual);
    for (var i = 1; i < alternatives.length; i++) {
      final rows = _unmetRows(alternatives[i], actual);
      if (rows.length < closest.length ||
          (rows.length == closest.length &&
              _sumPoints(rows) < _sumPoints(closest))) {
        closest = rows;
        closestIndex = i;
      }
    }

    // Every raise worth naming: one per distinct (line score, published minimum)
    // pair the candidate currently misses. Raising an area past a higher floor it
    // misses can satisfy several rows or alternatives at once, so each boundary
    // is its own route rather than only the cheapest one.
    final seen = <String>{};
    final routes = <UnlockRoute>[];
    for (var i = 0; i < alternatives.length; i++) {
      for (final req in alternatives[i]) {
        final current = actual(req.score);
        if (current >= req.min) continue;
        if (!seen.add('${req.score.abbr}:${req.min}')) continue;
        int raised(LineScore score) =>
            score == req.score ? req.min : actual(score);
        int? via;
        for (var j = 0; j < alternatives.length; j++) {
          if (_satisfied(alternatives[j], raised)) {
            via = j;
            break;
          }
        }
        routes.add(
          UnlockRoute(
            score: req.score,
            actual: current,
            minimum: req.min,
            alternativeIndex: i,
            unlocksAlone: via != null,
            viaAlternativeIndex: via,
            remaining: List<GatePartResult>.unmodifiable(
              _unmetRows(alternatives[i], raised),
            ),
          ),
        );
      }
    }
    routes.sort(_cheapestFirst);

    return UnlockPath(
      mosCode: mosCode,
      mosTitle: mosTitle,
      status: UnlockStatus.routesAvailable,
      routes: List<UnlockRoute>.unmodifiable(routes),
      shortfalls: List<GatePartResult>.unmodifiable(closest),
      shortfallAlternativeIndex: closestIndex,
      caveats: caveats,
      hasScores: hasScores,
      message: _routeMessage(mosCode, routes, hasScores),
    );
  }

  /// The rows of one alternative the given values fail: every line score that is
  /// short, and by how much.
  static List<GatePartResult> _unmetRows(
    List<LineScoreRequirement> rows,
    int Function(LineScore) value,
  ) {
    return <GatePartResult>[
      for (final req in rows)
        if (value(req.score) < req.min)
          GatePartResult(
            score: req.score,
            minimum: req.min,
            actual: value(req.score),
          ),
    ];
  }

  static bool _satisfied(
    List<LineScoreRequirement> rows,
    int Function(LineScore) value,
  ) {
    for (final req in rows) {
      if (value(req.score) < req.min) return false;
    }
    return true;
  }

  static int _sumPoints(List<GatePartResult> rows) =>
      rows.fold<int>(0, (sum, row) => sum + (row.minimum - row.actual));

  /// Cheapest first. A tie goes to the route that finishes the job, then to the
  /// line score's declaration order in [LineScore], then to the lower published
  /// minimum, then to the earlier catalogue alternative - so a given score sheet
  /// always produces the same list, in the same order.
  static int _cheapestFirst(UnlockRoute a, UnlockRoute b) {
    var order = a.pointsNeeded.compareTo(b.pointsNeeded);
    if (order != 0) return order;
    if (a.unlocksAlone != b.unlocksAlone) return a.unlocksAlone ? -1 : 1;
    order = a.score.index.compareTo(b.score.index);
    if (order != 0) return order;
    order = a.minimum.compareTo(b.minimum);
    if (order != 0) return order;
    return a.alternativeIndex.compareTo(b.alternativeIndex);
  }

  static String _routeMessage(
    String mosCode,
    List<UnlockRoute> routes,
    bool hasScores,
  ) {
    final cheapest = routes.first;
    UnlockRoute? unlock;
    for (final route in routes) {
      if (route.unlocksAlone) {
        unlock = route;
        break;
      }
    }
    final buffer = StringBuffer();
    if (unlock != null) {
      buffer.write(
        'The cheapest single improvement that unlocks $mosCode is raising '
        '${unlock.score.abbr} by ${unlock.pointsNeeded} '
        '${pointsWord(unlock.pointsNeeded)} '
        '(${unlock.actual} -> ${unlock.minimum}).',
      );
      if (!identical(unlock, cheapest)) {
        buffer.write(
          ' The cheapest raise of any kind is ${cheapest.score.abbr} by '
          '${cheapest.pointsNeeded} ${pointsWord(cheapest.pointsNeeded)}, '
          'which still leaves ${_describeRows(cheapest.remaining)} short.',
        );
      }
    } else {
      buffer.write(
        'No single line score unlocks $mosCode on its own. The cheapest is '
        '${cheapest.score.abbr} by ${cheapest.pointsNeeded} '
        '${pointsWord(cheapest.pointsNeeded)}, which still leaves '
        '${_describeRows(cheapest.remaining)} short.',
      );
    }
    if (!hasScores) {
      buffer.write(
        ' No line scores are on record yet, so every gate reads 0 and these '
        'figures are the gates themselves.',
      );
    }
    return buffer.toString();
  }

  /// Why a gate record cannot be trusted, or null when it can be. The catalogue
  /// parser cannot emit these shapes, so meeting one means the data is broken and
  /// any route computed from it would be fiction.
  static String? _malformation(AptitudeGate gate) {
    if (gate.isEmpty) return null;
    for (var i = 0; i < gate.alternatives.length; i++) {
      final rows = gate.alternatives[i];
      if (rows.isEmpty) {
        return 'alternative ${i + 1} lists no requirement at all';
      }
      for (final req in rows) {
        if (req.min < 1) {
          return '${req.score.abbr} has a minimum of ${req.min}, which is not '
              'a score floor';
        }
        if (req.min > lineScoreCeiling) {
          return '${req.score.abbr} demands ${req.min} on a scale that stops at '
              '$lineScoreCeiling';
        }
      }
    }
    return null;
  }

  /// True when an MOS note states outright that no line-score gate applies.
  ///
  /// The current schema has no "unknown gate" flag, so an empty gate plus a note
  /// saying the requirement does not exist is read as *no requirement*, while an
  /// empty gate with nothing to explain it is read as *unknown*. That is the
  /// derivation this engine makes because the model cannot express it, and it
  /// errs towards "we do not know", never towards a made-up number.
  static bool _saysNoLineScoreGate(String? note) =>
      note != null && _noGateNote.hasMatch(note);

  static final RegExp _noGateNote = RegExp(
    r'no\s+(line[- ]?score|aptitude[- ]?area)[^.;]{0,40}requirement',
    caseSensitive: false,
  );

  /// Renders one alternative the way the app already prints a gate:
  /// "ST 107 and EL 107 and GT 110".
  static String describeAlternative(List<LineScoreRequirement> rows) =>
      rows.map((req) => req.label).join(' and ');
}

/// What the engine can say about one MOS.
enum UnlockStatus {
  /// The candidate clears a published alternative; nothing is short.
  alreadyQualified,

  /// One or more concrete raises exist and are listed, cheapest first.
  routesAvailable,

  /// The MOS publishes no line-score gate, so there is no score to raise.
  /// Qualification happens on other criteria; nothing is short here either.
  noRequirement,

  /// The app holds no gate for this MOS, so no route may be named.
  gateUnknown,

  /// The gate record is structurally broken, so no route may be named.
  gateMalformed,
}

/// The result of asking "what would get me into this MOS?".
class UnlockPath {
  const UnlockPath({
    required this.mosCode,
    required this.status,
    required this.routes,
    required this.shortfalls,
    required this.caveats,
    this.shortfallAlternativeIndex,
    required this.message,
    required this.hasScores,
    this.mosTitle,
  });

  final String mosCode;
  final String? mosTitle;
  final UnlockStatus status;

  /// Every single-raise route, cheapest first. Empty unless [status] is
  /// [UnlockStatus.routesAvailable].
  final List<UnlockRoute> routes;

  /// The rows of the closest published alternative that the candidate misses
  /// today: each line score that is short, with the score and the floor. Empty
  /// when nothing is short or when no trustworthy gate exists.
  final List<GatePartResult> shortfalls;

  /// Which alternative [shortfalls] describes - the closest one the candidate
  /// misses. Null when [shortfalls] is empty.
  final int? shortfallAlternativeIndex;

  /// Requirements a line score cannot satisfy - a clearance, an audition, an
  /// AFQT floor - stated rather than silently dropped.
  final List<String> caveats;

  /// One sentence a screen can show as-is.
  final String message;

  /// False when the candidate has no line scores at all yet.
  final bool hasScores;

  /// True when the candidate does not have to raise anything: either the gate is
  /// met, or the MOS publishes no line-score gate at all.
  bool get qualified =>
      status == UnlockStatus.alreadyQualified ||
      status == UnlockStatus.noRequirement;

  /// True when at least one concrete raise can be named.
  bool get hasRoute => routes.isNotEmpty;

  /// False only for the two states where the app must not claim a path: a gate it
  /// does not hold, and a gate record it cannot parse.
  bool get gateTrusted =>
      status != UnlockStatus.gateUnknown &&
      status != UnlockStatus.gateMalformed;

  /// The cheapest raise of any kind, whether or not it finishes the job.
  UnlockRoute? get cheapest => routes.isEmpty ? null : routes.first;

  /// The cheapest raise that unlocks the job by itself, or null when no single
  /// line score does - either because every route leaves another shortfall, or
  /// because no route exists at all.
  UnlockRoute? get cheapestUnlock {
    for (final route in routes) {
      if (route.unlocksAlone) return route;
    }
    return null;
  }

  /// Points to add on one line score for the cheapest single-step route, or null
  /// when no single step is enough.
  int? get pointsToUnlock => cheapestUnlock?.pointsNeeded;
}

/// One concrete way in: raise this line score to this published minimum.
class UnlockRoute {
  const UnlockRoute({
    required this.score,
    required this.actual,
    required this.minimum,
    required this.alternativeIndex,
    required this.unlocksAlone,
    required this.viaAlternativeIndex,
    required this.remaining,
  });

  /// The line score this route raises.
  final LineScore score;

  /// What the candidate scores on it today (0 when there is no score on record).
  final int actual;

  /// The published floor this route aims at.
  final int minimum;

  /// Which alternative of the gate this requirement belongs to, so a screen can
  /// show the requirement being climbed.
  final int alternativeIndex;

  /// True when raising this one score alone satisfies the whole gate.
  final bool unlocksAlone;

  /// The alternative the raise satisfies (the first one that becomes true), or
  /// null when the gate stays unmet.
  final int? viaAlternativeIndex;

  /// The targeted alternative's rows that are still unmet after the raise, with
  /// the values they would then read. Empty means this route finishes that
  /// alternative.
  final List<GatePartResult> remaining;

  /// Points the candidate must add to [score].
  int get pointsNeeded => minimum > actual ? minimum - actual : 0;

  /// Points still missing from the targeted alternative after the raise, across
  /// every row in [remaining].
  int get remainingPoints =>
      remaining.fold<int>(0, (sum, row) => sum + (row.minimum - row.actual));

  /// True when the raise clears its own alternative but only opens the job
  /// through a different, easier alternative elsewhere in the gate.
  bool get unlocksThroughOtherAlternative =>
      unlocksAlone && remaining.isNotEmpty;

  /// The concrete instruction: "Raise CO from 86 to 87 (+1 point)".
  String get action =>
      'Raise ${score.abbr} from $actual to $minimum '
      '(+$pointsNeeded ${pointsWord(pointsNeeded)})';

  /// One sentence naming what this raise would and would not achieve.
  String get summary {
    final head =
        'Raise ${score.abbr} by $pointsNeeded '
        '${pointsWord(pointsNeeded)} ($actual -> $minimum)';
    if (!unlocksAlone) {
      final verb = remaining.length == 1 ? 'is' : 'are';
      return '$head, but ${_describeRows(remaining)} $verb still short.';
    }
    return remaining.isEmpty
        ? '$head: that alone unlocks the job.'
        : '$head: that unlocks the job through another published alternative.';
  }

  @override
  String toString() => 'UnlockRoute($action)';
}

/// "point" for 1, "points" otherwise, so no sentence reads "1 points".
String pointsWord(int points) => points == 1 ? 'point' : 'points';

/// "ST 80/95" for one short row, "ST 80/95 and EL 100/105" for several.
String _describeRows(List<GatePartResult> rows) {
  if (rows.isEmpty) return 'nothing';
  return rows.map((row) => row.readable).join(' and ');
}
