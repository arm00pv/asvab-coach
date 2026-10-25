import 'catalog.dart';
import 'line_score.dart';

/// A military occupational specialty with its Army aptitude gate.
class Mos {
  const Mos({
    required this.code,
    required this.title,
    required this.category,
    required this.gate,
    this.securityClearance = false,
    this.extraTest,
    this.note,
    this.physicalDemand,
    this.asvabMinimum,
    this.source,
  });

  final String code;
  final String title;
  final String category;
  final AptitudeGate gate;

  /// Requires eligibility for a SECRET or TOP SECRET clearance.
  final bool securityClearance;

  /// Additional selection test beyond the ASVAB (DLAB for linguists, SIFT for
  /// aviation, flight physical, etc).
  final String? extraTest;

  final String? note;

  /// Rough physical demand rating used only for display.
  final String? physicalDemand;

  /// Some MOS also publish a hard AFQT floor separate from the line score.
  final int? asvabMinimum;

  /// Where the requirement was transcribed from, so the app can show its
  /// working instead of asking to be trusted.
  final String? source;

  String get id => code;
}

/// One officer / "official" pathway and the aptitude bar it sets.
class OfficerPathway {
  const OfficerPathway({
    required this.id,
    required this.title,
    required this.summary,
    this.gtMinimum,
    this.afqtMinimum,
    this.otherRequirements = const <String>[],
    this.whyNote,
    this.source,
  });

  final String id;
  final String title;
  final String summary;

  /// GT floor, or null where the route does not gate on GT.
  final int? gtMinimum;

  /// AFQT floor, or null where the route does not publish one.
  final int? afqtMinimum;

  final List<String> otherRequirements;
  final String? whyNote;
  final String? source;

  String get gtLabel => gtMinimum == null ? 'GT not gated' : 'GT $gtMinimum';
}

/// Outcome of evaluating a score report against a gate.
class GateEvaluation {
  const GateEvaluation({
    required this.qualified,
    required this.results,
    required this.bestShortfall,
  });

  final bool qualified;

  /// Per-alternative evaluation, for drill-down UI.
  final List<GateAlternativeResult> results;

  /// How far short the *closest* alternative falls, in points. Null when
  /// qualified.
  final int? bestShortfall;

  bool get nearMiss => !qualified && (bestShortfall ?? 999) <= 8;
}

class GateAlternativeResult {
  const GateAlternativeResult({
    required this.parts,
    required this.satisfied,
    required this.shortfall,
  });

  final List<GatePartResult> parts;
  final bool satisfied;
  final int shortfall;

  String get description => parts.map((p) => p.readable).join(' and ');
}

class GatePartResult {
  const GatePartResult({
    required this.score,
    required this.minimum,
    required this.actual,
  });

  final LineScore score;
  final int minimum;
  final int actual;

  bool get met => actual >= minimum;
  int get gap => actual - minimum;
  String get readable => '${score.abbr} $actual/$minimum';
}

/// The user's stated goal, which drives recommendations.
class GoalProfile {
  const GoalProfile({
    required this.displayName,
    required this.targetAfqt,
    required this.targetGt,
    required this.targetMosCodes,
    required this.targetDate,
    required this.officerTrack,
    required this.dailyMinutes,
  });

  final String displayName;
  final int targetAfqt;
  final int targetGt;
  final List<String> targetMosCodes;
  final DateTime? targetDate;
  final bool officerTrack;
  final int dailyMinutes;

  GoalProfile copyWith({
    String? displayName,
    int? targetAfqt,
    int? targetGt,
    List<String>? targetMosCodes,
    DateTime? targetDate,
    bool? officerTrack,
    int? dailyMinutes,
  }) {
    return GoalProfile(
      displayName: displayName ?? this.displayName,
      targetAfqt: targetAfqt ?? this.targetAfqt,
      targetGt: targetGt ?? this.targetGt,
      targetMosCodes: targetMosCodes ?? this.targetMosCodes,
      targetDate: targetDate ?? this.targetDate,
      officerTrack: officerTrack ?? this.officerTrack,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'displayName': displayName,
    'targetAfqt': targetAfqt,
    'targetGt': targetGt,
    'targetMosCodes': targetMosCodes,
    'targetDate': targetDate?.toIso8601String(),
    'officerTrack': officerTrack,
    'dailyMinutes': dailyMinutes,
  };

  static GoalProfile fromJson(Map<String, dynamic> j) => GoalProfile(
    displayName: (j['displayName'] as String?) ?? 'Candidate',
    targetAfqt: (j['targetAfqt'] as num?)?.toInt() ?? 60,
    targetGt: (j['targetGt'] as num?)?.toInt() ?? 110,
    targetMosCodes:
        (j['targetMosCodes'] as List?)?.cast<String>() ?? const <String>[],
    targetDate: j['targetDate'] == null
        ? null
        : DateTime.tryParse(j['targetDate'] as String),
    officerTrack: (j['officerTrack'] as bool?) ?? false,
    dailyMinutes: (j['dailyMinutes'] as num?)?.toInt() ?? 20,
  );

  static const defaults = GoalProfile(
    displayName: 'Candidate',
    targetAfqt: 60,
    targetGt: 110,
    targetMosCodes: <String>['11B'],
    targetDate: null,
    officerTrack: false,
    dailyMinutes: 20,
  );
}

/// Convenience so screens can talk about categories without importing catalog.
String mosCategoryLabel(Mos m) => m.category;

/// Exposed for the jobs screen filter chips.
const List<String> allMosCategories = MosCategory.ordered;
