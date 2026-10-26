import '../data/models/career_field.dart';
import '../data/models/line_score.dart';
import '../data/models/mos.dart';
import '../data/models/score.dart';
import 'unlock_path.dart';

/// A recruiter-ready summary of one candidate's results (ROADMAP Phase 4:
/// "walk into the office prepared").
///
/// One page of plain text a candidate can hand over: the AFQT composite and
/// percentile, every aptitude-area score, every job the scores currently clear
/// grouped by career field, and - separately - the jobs they are close to with
/// the exact raise that would open them.
///
/// The rules this file keeps, because a sheet a candidate hands to a recruiter
/// is a claim about their record:
///
///  * **It is pure.** It takes a [ScoreReport], a job list and the date to
///    print. It reads no clock, no storage and no network, imports nothing from
///    Flutter, and never calls `DateTime.now()`, so a test can pin the date
///    and compare the whole page character for character.
///  * **It invents no number.** A line score that was never taken prints as
///    [unknownValue]. A job whose gate the app cannot trust goes into its own
///    section and is counted as neither met nor missed - it is never silently
///    dropped and never assumed met.
///  * **It defers the arithmetic.** "Which line score, how many points" comes
///    from [UnlockPathEngine], so this sheet and the jobs screen cannot tell two
///    different stories about the same gate.
///  * **Every line fits.** Output is wrapped to [defaultWidth] characters, so
///    the sheet is valid plain text and a valid monospace layout at the same
///    time - on screen, in a share sheet, or printed.
abstract final class RecruiterSheet {
  /// The readable wrap width, in characters. Narrow enough for a phone in a
  /// monospace font, wide enough for a job title beside its code.
  static const int defaultWidth = 46;

  /// How many points a raise may cost and still count as "close" - the same
  /// idea as `GateEvaluation.nearMiss`, stated here so the sheet can explain
  /// itself to a reader who has never seen the app.
  static const int defaultClosePoints = 8;

  /// What the sheet prints where a value is not known. Never a zero, because
  /// zero is a score the candidate might really have.
  static const String unknownValue = 'unknown';

  /// The one thing the page must never let a reader forget, exposed so a screen
  /// can quote it without rewriting the wording.
  static const String estimateDisclaimer =
      'The scores below are estimates calculated on this device by the ASVAB '
      'Guard Coach app from the practice questions you answered. They are not '
      'an official ASVAB record and carry no official standing with the Army. '
      'Only the test you take at a Military Entrance Processing Station or an '
      'approved test site produces official ASVAB scores.';

  /// The date line the sheet prints, in a fixed, locale-independent form
  /// (2026-03-04). Deliberately not `DateTime.now()`: the caller supplies it.
  static String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year.toString().padLeft(4, '0')}-$month-$day';
  }

  /// The whole sheet as one [String] - what a share sheet or a print handler
  /// wants.
  static String render({
    required ScoreReport report,
    required List<Mos> jobs,
    required DateTime generatedOn,
    String? candidateName,
    int width = defaultWidth,
    int closePoints = defaultClosePoints,
  }) {
    return toText(
      sections(
        report: report,
        jobs: jobs,
        generatedOn: generatedOn,
        candidateName: candidateName,
        width: width,
        closePoints: closePoints,
      ),
    );
  }

  /// The same page as a short list of [RecruiterSheetSection]s, so a screen can
  /// render headings as headings and body lines as body lines instead of
  /// parsing text back apart.
  static List<RecruiterSheetSection> sections({
    required ScoreReport report,
    required List<Mos> jobs,
    required DateTime generatedOn,
    String? candidateName,
    int width = defaultWidth,
    int closePoints = defaultClosePoints,
  }) {
    return sectionsFor(
      build(
        report: report,
        jobs: jobs,
        generatedOn: generatedOn,
        candidateName: candidateName,
        closePoints: closePoints,
      ),
      width: width,
    );
  }

  /// Lays [RecruiterSheetContent] out into sections. Split from [build] so a
  /// screen can build the content once and render it at more than one width.
  static List<RecruiterSheetSection> sectionsFor(
    RecruiterSheetContent content, {
    int width = defaultWidth,
  }) {
    return <RecruiterSheetSection>[
      _header(content, width),
      _disclaimer(width),
      _afqt(content.report, width),
      _lineScores(content.report, width),
      _metJobs(content, width),
      _closeJobs(content, width),
      if (content.unknownGate.isNotEmpty) _unknownGateJobs(content, width),
      if (content.otherComponentJobs.isNotEmpty)
        _otherComponentJobs(content, width),
      _closingNote(content, width),
    ];
  }

  /// Joins sections into the page. Sections are separated by one blank line.
  static String toText(List<RecruiterSheetSection> sections) {
    return sections
        .where((section) => !section.isEmpty)
        .map((section) => section.text)
        .join('\n\n');
  }

  /// Classifies every job against the report. Pure: the same report, jobs and
  /// threshold always produce the same buckets, whatever order the jobs arrive
  /// in.
  static RecruiterSheetContent build({
    required ScoreReport report,
    required List<Mos> jobs,
    required DateTime generatedOn,
    String? candidateName,
    int closePoints = defaultClosePoints,
  }) {
    // Sorted by code so a shuffled catalogue cannot reorder the sheet, and
    // de-duplicated so one job cannot be counted twice.
    final ordered = <Mos>[];
    final seenCodes = <String>{};
    for (final mos in jobs) {
      if (seenCodes.add(mos.code)) ordered.add(mos);
    }
    ordered.sort((a, b) => a.code.compareTo(b.code));

    final met = <Mos>[];
    final close = <RecruiterCloseJob>[];
    final unknown = <Mos>[];
    final restricted = <Mos>[];
    final far = <Mos>[];

    for (final mos in ordered) {
      // A gate the app has not verified may never be read as met, so the engine
      // is not consulted for it at all: its answer would be a guess about data
      // nobody checked.
      if (!mos.gateIsKnown) {
        unknown.add(mos);
        continue;
      }
      // The catalogue can state outright that a job publishes no aptitude-area
      // requirement. That is a fact about the entry, not a route calculation, so
      // it is read here instead of inferred from an empty gate: the engine has
      // to guess at that shape, and its guess errs towards "unknown", which
      // would hide a job the candidate really does fit.
      if (mos.gateStatus == MosGateStatus.noRequirement && !mos.hasGate) {
        if (mos.guardFielded) {
          met.add(mos);
        } else {
          restricted.add(mos);
        }
        continue;
      }
      final path = UnlockPathEngine.forMos(mos, report.lineScores);
      switch (path.status) {
        case UnlockStatus.alreadyQualified:
        case UnlockStatus.noRequirement:
          if (mos.guardFielded) {
            met.add(mos);
          } else {
            restricted.add(mos);
          }
        case UnlockStatus.gateUnknown:
        case UnlockStatus.gateMalformed:
          unknown.add(mos);
        case UnlockStatus.routesAvailable:
          final job = _closeJob(mos, path);
          if (job == null || job.pointsNeeded > closePoints) {
            far.add(mos);
          } else if (mos.guardFielded) {
            close.add(job);
          } else {
            restricted.add(mos);
          }
      }
    }

    close.sort((a, b) {
      final byPoints = a.pointsNeeded.compareTo(b.pointsNeeded);
      return byPoints != 0 ? byPoints : a.mos.code.compareTo(b.mos.code);
    });

    // Career fields in the catalogue's own declaration order, so the sheet
    // reads the same way twice, then anything with no field at all.
    final byField = <String, List<Mos>>{};
    for (final mos in met) {
      final key = CareerField.of(mos)?.prefix ?? '';
      (byField[key] ??= <Mos>[]).add(mos);
    }
    final groups = <RecruiterFieldGroup>[];
    for (final field in CareerField.all) {
      final fieldJobs = byField.remove(field.prefix);
      if (fieldJobs != null && fieldJobs.isNotEmpty) {
        groups.add(RecruiterFieldGroup(field: field, jobs: fieldJobs));
      }
    }
    final leftovers = byField.keys.toList()..sort();
    for (final key in leftovers) {
      final fieldJobs = byField[key]!;
      if (fieldJobs.isEmpty) continue;
      groups.add(RecruiterFieldGroup(field: null, jobs: fieldJobs));
    }

    return RecruiterSheetContent(
      report: report,
      generatedOn: generatedOn,
      candidateName: candidateName,
      groups: groups,
      closeJobs: close,
      unknownGate: unknown,
      otherComponentJobs: restricted,
      outOfReach: far,
      closePoints: closePoints,
    );
  }

  /// Word-wraps [text] to [width] characters.
  ///
  /// Never splits a word that fits, never emits a line longer than [width]
  /// unless a single character cannot fit at all, and honours the paragraph
  /// breaks in [text]. [indent] is repeated at the start of every continuation
  /// line, which is what keeps a wrapped job row readable.
  static List<String> wrap(
    String text, {
    int width = defaultWidth,
    String indent = '',
  }) {
    final limit = width < 1 ? 1 : width;
    final out = <String>[];
    for (final paragraph in text.split('\n')) {
      final words = <String>[
        for (final word in paragraph.trim().split(RegExp(r'\s+')))
          if (word.isNotEmpty) word,
      ];
      if (words.isEmpty) continue;
      var prefix = '';
      var line = '';
      for (var i = 0; i < words.length; i++) {
        var available = limit - prefix.length;
        if (available < 1) available = 1;
        var word = words[i];
        // A word longer than the line cannot be kept whole: a line that
        // overflows is not a valid monospace layout, so it is broken instead.
        while (word.length > available) {
          if (line.isNotEmpty) {
            out.add('$prefix$line');
            line = '';
            prefix = indent;
            available = limit - prefix.length;
            if (available < 1) available = 1;
            continue;
          }
          out.add('$prefix${word.substring(0, available)}');
          word = word.substring(available);
          prefix = indent;
          available = limit - prefix.length;
          if (available < 1) available = 1;
        }
        if (line.isEmpty) {
          line = word;
          continue;
        }
        if (line.length + 1 + word.length <= available) {
          line = '$line $word';
          continue;
        }
        out.add('$prefix$line');
        prefix = indent;
        line = word;
      }
      if (line.isNotEmpty) out.add('$prefix$line');
    }
    return out;
  }

  /// One wrapped, hanging-indented paragraph: every line is prefixed with
  /// [indent], and every line stays inside [width].
  static List<String> hanging(
    String text, {
    int width = defaultWidth,
    String indent = '  ',
  }) {
    final wrapped = wrap(
      text,
      width: width - indent.length < 1 ? 1 : width - indent.length,
      indent: indent,
    );
    if (wrapped.isEmpty) return wrapped;
    return <String>['$indent${wrapped.first}', ...wrapped.skip(1)];
  }

  /// A table-style row: kept exactly as built, column padding and all, unless it
  /// is wider than the page - in which case it wraps and the alignment is
  /// conceded rather than the line overflowing.
  ///
  /// [wrap] normalises runs of spaces, which is right for prose and wrong for a
  /// code/title column, so anything laid out as a table goes through here.
  static List<String> row(
    String text, {
    int width = defaultWidth,
    String indent = '     ',
  }) {
    if (text.length <= width) return <String>[text];
    return wrap(text, width: width, indent: indent);
  }

  /// The raise that would open [mos], or null when the engine names no route.
  ///
  /// When one raise finishes the gate the engine's own summary is used verbatim;
  /// when none does, the points needed are the rows of the closest published
  /// alternative added up, which is stated as a total rather than as a promise.
  static RecruiterCloseJob? _closeJob(Mos mos, UnlockPath path) {
    final unlock = path.cheapestUnlock;
    if (unlock != null) {
      return RecruiterCloseJob(
        mos: mos,
        pointsNeeded: unlock.pointsNeeded,
        detail: unlock.summary,
      );
    }
    final rows = path.shortfalls;
    if (rows.isEmpty) return null;
    final total = rows.fold<int>(
      0,
      (sum, row) => sum + (row.minimum - row.actual),
    );
    final listed = rows.map((row) => row.readable).join(' and ');
    return RecruiterCloseJob(
      mos: mos,
      pointsNeeded: total,
      detail:
          'Short by $total ${pointsWord(total)} in total across $listed. '
          'No single line score unlocks it.',
    );
  }

  static RecruiterSheetSection _header(
    RecruiterSheetContent content,
    int width,
  ) {
    return RecruiterSheetSection(
      lines: <String>[
        ...wrap('ASVAB GUARD COACH', width: width),
        ...wrap('Candidate score summary - for your recruiter', width: width),
        if (content.candidateName != null)
          ...wrap('Candidate: ${content.candidateName}', width: width),
        ...wrap('Prepared ${formatDate(content.generatedOn)}', width: width),
      ],
    );
  }

  static RecruiterSheetSection _disclaimer(int width) {
    return RecruiterSheetSection(
      lines: <String>[
        ...wrap('ESTIMATE ONLY - NOT AN OFFICIAL ASVAB RECORD.', width: width),
        ...wrap(estimateDisclaimer, width: width),
      ],
    );
  }

  static RecruiterSheetSection _afqt(ScoreReport report, int width) {
    final floor = report.meetsArmyFloor
        ? 'Percentile ${report.afqtPercentile} is at or above the Army '
              'National Guard enlistment floor for a high school diploma '
              'graduate.'
        : 'Percentile ${report.afqtPercentile} is below the Army National '
              'Guard enlistment floor for a high school diploma graduate.';
    return RecruiterSheetSection(
      heading: 'AFQT',
      lines: <String>[
        ...wrap('Composite ${report.afqtComposite}.', width: width),
        ...wrap(
          'Percentile ${report.afqtPercentile}, category ${report.category}.',
          width: width,
        ),
        ...wrap(floor, width: width),
      ],
    );
  }

  static RecruiterSheetSection _lineScores(ScoreReport report, int width) {
    final lines = <String>[];
    var anyUnknown = false;
    for (final score in LineScore.values) {
      final value = report.lineScores[score];
      if (value == null) anyUnknown = true;
      final cell = value == null ? unknownValue : '$value';
      lines.addAll(
        row(
          '${score.abbr.padRight(3)}${cell.padLeft(4)} ${score.label}',
          width: width,
        ),
      );
    }
    lines.add('');
    lines.addAll(
      wrap(
        'Aptitude areas are on the Army scale where the average applicant '
        'scores 100.',
        width: width,
      ),
    );
    if (anyUnknown) {
      lines.addAll(
        wrap(
          'An area marked $unknownValue was not scored on this attempt, so no '
          'figure is printed for it.',
          width: width,
        ),
      );
    }
    return RecruiterSheetSection(heading: 'LINE SCORES', lines: lines);
  }

  static RecruiterSheetSection _metJobs(
    RecruiterSheetContent content,
    int width,
  ) {
    final lines = <String>[];
    if (content.meetsNone) {
      lines.addAll(
        wrap(
          'No job in the catalogue is met on these scores yet. The sections '
          'below show what is closest.',
          width: width,
        ),
      );
    } else {
      for (var i = 0; i < content.groups.length; i++) {
        if (i > 0) lines.add('');
        lines.addAll(wrap(content.groups[i].label.toUpperCase(), width: width));
        for (final mos in content.groups[i].jobs) {
          lines.addAll(row(_metRow(mos), width: width));
        }
      }
    }
    return RecruiterSheetSection(
      heading: 'JOBS YOU MEET (${content.metCount})',
      lines: lines,
    );
  }

  /// One met job: code, title, and every published condition the scores do not
  /// cover, so the sheet cannot read as an unconditional yes.
  ///
  /// These notes come straight off the catalogue entry - they are printed, not
  /// judged, and nothing is added for a job whose entry says nothing.
  static String _metRow(Mos mos) {
    final notes = <String>[];
    if (mos.gateStatus == MosGateStatus.noRequirement || !mos.hasGate) {
      notes.add('no aptitude gate published');
    }
    if (mos.asvabMinimum != null) {
      notes.add('also needs an AFQT percentile of ${mos.asvabMinimum}');
    }
    if (mos.securityClearance) {
      notes.add('also needs a security clearance');
    }
    if (mos.extraTest != null) {
      notes.add('also needs ${mos.extraTest}');
    }
    final suffix = notes.isEmpty ? '' : ' (${notes.join('; ')})';
    return '${mos.code}  ${mos.title}$suffix';
  }

  static RecruiterSheetSection _closeJobs(
    RecruiterSheetContent content,
    int width,
  ) {
    final lines = <String>[];
    if (content.closeJobs.isEmpty) {
      lines.addAll(
        wrap(
          'Nothing in the catalogue is within ${content.closePoints} points '
          'right now.',
          width: width,
        ),
      );
    } else {
      lines.addAll(
        wrap(
          'Jobs missed by ${content.closePoints} points or less, with the '
          'raise that would clear the published gate.',
          width: width,
        ),
      );
      for (final job in content.closeJobs) {
        lines.add('');
        lines.addAll(row('${job.mos.code}  ${job.mos.title}', width: width));
        lines.addAll(hanging(job.detail, width: width));
      }
    }
    return RecruiterSheetSection(
      heading: 'JOBS YOU ARE CLOSE TO (${content.closeJobs.length})',
      lines: lines,
    );
  }

  static RecruiterSheetSection _unknownGateJobs(
    RecruiterSheetContent content,
    int width,
  ) {
    final lines = <String>[
      ...wrap(
        'The app holds no gate it can trust for these, so it says nothing '
        'about them either way. They are counted as neither met nor missed.',
        width: width,
      ),
    ];
    for (final mos in content.unknownGate) {
      lines.add('');
      lines.addAll(row('${mos.code}  ${mos.title}', width: width));
      final why = mos.gateStatus == MosGateStatus.unverified
          ? 'the requirement has not been checked against a primary source'
          : 'the catalogue entry carries no requirement on record';
      lines.addAll(
        hanging(
          'Gate $unknownValue: $why, so the app cannot say whether you meet '
          'it.',
          width: width,
        ),
      );
    }
    return RecruiterSheetSection(
      heading: 'JOBS WITH AN UNKNOWN GATE (${content.unknownGate.length})',
      lines: lines,
    );
  }

  static RecruiterSheetSection _otherComponentJobs(
    RecruiterSheetContent content,
    int width,
  ) {
    final lines = <String>[
      ...wrap(
        'Your scores clear these, but they are restricted to a component the '
        'Army National Guard cannot access you into.',
        width: width,
      ),
    ];
    for (final mos in content.otherComponentJobs) {
      lines.add('');
      lines.addAll(row('${mos.code}  ${mos.title}', width: width));
      final limit = mos.componentLimit;
      if (limit != null) {
        lines.addAll(hanging('Restricted to: $limit.', width: width));
      }
    }
    return RecruiterSheetSection(
      heading:
          'NOT OPEN TO THE ARMY NATIONAL GUARD '
          '(${content.otherComponentJobs.length})',
      lines: lines,
    );
  }

  static RecruiterSheetSection _closingNote(
    RecruiterSheetContent content,
    int width,
  ) {
    final lines = <String>[
      ...wrap(
        'Not close at this time: ${content.outOfReach.length} other '
        '${content.outOfReach.length == 1 ? 'job' : 'jobs'}. Ask the app for '
        'the full list whenever you want it.',
        width: width,
      ),
      ...wrap(
        'Produced on this device from practice scores. Nothing on this sheet '
        'was uploaded anywhere.',
        width: width,
      ),
    ];
    return RecruiterSheetSection(lines: lines);
  }
}

/// What the sheet found, before any of it is laid out as text.
class RecruiterSheetContent {
  const RecruiterSheetContent({
    required this.report,
    required this.generatedOn,
    required this.groups,
    required this.closeJobs,
    required this.unknownGate,
    required this.otherComponentJobs,
    required this.outOfReach,
    this.candidateName,
    this.closePoints = RecruiterSheet.defaultClosePoints,
  });

  final ScoreReport report;

  /// The date printed on the sheet. Supplied by the caller so the page never
  /// depends on when it was rendered.
  final DateTime generatedOn;

  final String? candidateName;

  /// Jobs currently met, grouped by career field, groups in catalogue order.
  final List<RecruiterFieldGroup> groups;

  /// Jobs missed by [closePoints] points or less, cheapest first.
  final List<RecruiterCloseJob> closeJobs;

  /// Jobs whose gate the app cannot trust - neither met nor missed.
  final List<Mos> unknownGate;

  /// Jobs the scores clear, but which the Army National Guard does not field.
  final List<Mos> otherComponentJobs;

  /// Jobs missed by more than [closePoints] points. Counted, never listed.
  final List<Mos> outOfReach;

  final int closePoints;

  int get metCount =>
      groups.fold<int>(0, (sum, group) => sum + group.jobs.length);

  bool get meetsNone => metCount == 0;
}

/// The met jobs of one career field.
class RecruiterFieldGroup {
  const RecruiterFieldGroup({required this.field, required this.jobs});

  /// Null for a code whose prefix is not a numbered specialty.
  final CareerField? field;

  final List<Mos> jobs;

  String get label => field?.label ?? 'Other';
}

/// A job the candidate misses, with the arithmetic of what is missing.
class RecruiterCloseJob {
  const RecruiterCloseJob({
    required this.mos,
    required this.pointsNeeded,
    required this.detail,
  });

  final Mos mos;

  /// Points to add, taken from the unlock engine rather than recomputed here.
  final int pointsNeeded;

  /// One sentence naming the raise, from the engine.
  final String detail;
}

/// One block of the sheet: an optional heading and the body lines beneath it.
class RecruiterSheetSection {
  const RecruiterSheetSection({this.heading, this.lines = const <String>[]});

  final String? heading;

  /// Already wrapped to the sheet's width.
  final List<String> lines;

  bool get isEmpty => (heading == null || heading!.isEmpty) && lines.isEmpty;

  String get text => <String>[
    if (heading != null && heading!.isNotEmpty) heading!,
    ...lines,
  ].join('\n');

  @override
  String toString() => text;
}
