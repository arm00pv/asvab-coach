import 'catalog.dart';
import 'line_score.dart';

/// What the entry's aptitude gate actually is, and how far it can be trusted.
///
/// These three states exist because two of them look identical in the data and
/// saying the wrong one harms the candidate:
///
///  * [published] - the gate was transcribed from the authority, so an empty
///    gate on a published entry is a data defect.
///  * [noRequirement] - the authority itself states the MOS has no aptitude-area
///    requirement (musician audition, 18F). An empty gate here is the true
///    answer, not a hole.
///  * [unverified] - the MOS exists but its gate has not been checked against a
///    primary source. An empty gate means "not known", and the app must never
///    report either qualification or disqualification from it.
enum MosGateStatus { published, noRequirement, unverified }

/// The component restrictions the authority prints for a MOS.
///
/// Verbatim from DA Pam 611-21 chapter 10 section C: the pamphlet says
/// "(National Guard Only)", "(USAR only)", "(Active Component Only)" and so on,
/// and a job the National Guard does not field is not a job this app may tell a
/// Guard candidate they qualify for.
abstract final class MosComponent {
  static const nationalGuardOnly = 'National Guard only';
  static const armyNationalGuard = 'Army National Guard';
  static const reserveComponents = 'Reserve Components';
  static const usarOnly = 'USAR only';
  static const activeComponentOnly = 'Active Component only';
  static const activeComponentAndUsar = 'Active Component and USAR';
  static const activeComponent = 'Active Component';
  static const armyReserve = 'Army Reserve';
  static const activeComponentAndNationalGuard =
      'Active Component and National Guard';

  /// Every value [Mos.componentLimit] is allowed to hold.
  static const List<String> all = <String>[
    nationalGuardOnly,
    armyNationalGuard,
    reserveComponents,
    usarOnly,
    activeComponentOnly,
    activeComponentAndUsar,
    activeComponent,
    armyReserve,
    activeComponentAndNationalGuard,
  ];

  /// The components an enlisted candidate can be accessed into through the
  /// Army National Guard.
  static const List<String> guardFielded = <String>[
    nationalGuardOnly,
    armyNationalGuard,
    reserveComponents,
    activeComponentAndNationalGuard,
  ];
}

/// Where a plain-language sentence about an MOS was read from.
///
/// The kind is recorded separately from the URL because the five answers carry
/// different weight: the pamphlet states what the job is, a training publication
/// states what the soldier does all day, and COOL, O*NET and a recruiting site
/// state where the job leads afterwards. A candidate is entitled to know which
/// of those is talking, and a description that cannot say is not shown.
enum MosSourceKind {
  /// DA Pam 611-21 chapter 10 section C - the authority the gates come from.
  pamphlet,

  /// A Soldier Training Publication: the MOS's own manual and task list.
  stp,

  /// Army Credentialing Opportunities On-Line, which maps a MOS to civilian
  /// certifications.
  cool,

  /// O*NET or the Occupational Outlook Handbook: civilian occupational data.
  onet,

  /// An official service site (GoArmy, nationalguard.com, a proponent page).
  serviceSite,
}

/// A short piece of prose about an MOS together with where it came from.
///
/// Every field is required and non-nullable on purpose, and there is no
/// text-only constructor to fall into by accident: an unsourced sentence about a
/// job is indistinguishable from an invention, and an invention read by someone
/// planning an enlistment is the expensive mistake this app exists to prevent.
///
/// [retrievedOn] is a *date*, so anything comparing it to "now" should compare
/// at day granularity. A time component is not a claim about when it was read.
class SourcedText {
  const SourcedText({
    required this.text,
    required this.sourceUrl,
    required this.retrievedOn,
    required this.sourceKind,
  });

  /// The sentence or two a candidate reads, in plain language.
  final String text;

  /// The page it was read from, as an `https://` URL so the citation can be
  /// opened and checked rather than trusted.
  final String sourceUrl;

  /// The day the page was read, not the day the job or pamphlet changed.
  final DateTime retrievedOn;

  /// Which kind of source [sourceUrl] points at.
  final MosSourceKind sourceKind;
}

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
    this.gateStatus = MosGateStatus.published,
    this.componentLimit,
    this.description,
    this.civilianNote,
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

  /// Whether [gate] is the Army's published gate, an explicit "no requirement",
  /// or something this app has not verified. Defaults to [MosGateStatus.published]
  /// so a new entry cannot arrive claiming a gate it does not carry.
  final MosGateStatus gateStatus;

  /// The component restriction the authority prints, verbatim, or null when it
  /// prints none. See [MosComponent] for the accepted values.
  final String? componentLimit;

  /// What the job actually is, in plain language, with the source it came from.
  /// Null until someone transcribes one from a cited page: the space is left
  /// empty rather than filled with a plausible-sounding sentence, and
  /// `test/mos_provenance_test.dart` holds any value that does arrive to its
  /// provenance.
  final SourcedText? description;

  /// Where the job leads in civilian life, with the source it came from. Same
  /// rule as [description]: nothing is invented to fill it.
  final SourcedText? civilianNote;

  String get id => code;

  /// True when the entry carries at least one gate alternative.
  bool get hasGate => gate.alternatives.isNotEmpty;

  /// False only when the gate is a genuine unknown: the app must then report
  /// neither qualification nor disqualification.
  bool get gateIsKnown => gateStatus != MosGateStatus.unverified;

  /// True when the Army National Guard fields this MOS, as far as the authority
  /// states. A job restricted to the Active Component or the USAR is not one a
  /// Guard candidate can be told they qualify for.
  bool get guardFielded =>
      componentLimit == null ||
      MosComponent.guardFielded.contains(componentLimit);

  /// How the gate reads in a sentence, including the honest cases.
  String get gateSummary => switch (gateStatus) {
    MosGateStatus.published =>
      hasGate ? gate.label : 'Gate missing - data defect',
    MosGateStatus.noRequirement => 'No aptitude gate published',
    MosGateStatus.unverified => 'Gate not verified',
  };
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
