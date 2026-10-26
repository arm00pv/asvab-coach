import '../models/catalog.dart';
import '../models/question.dart';

/// One finding from an audit run.
class AuditFinding {
  const AuditFinding({
    required this.severity,
    required this.code,
    required this.message,
    this.questionId,
  });

  /// 'error' blocks a release, 'warn' is authoring hygiene.
  final String severity;
  final String code;
  final String message;
  final String? questionId;

  bool get isError => severity == 'error';

  @override
  String toString() =>
      '${severity.toUpperCase()} [$code]${questionId == null ? '' : ' $questionId'}: $message';
}

/// How one item explains the options it did not key.
enum ExplanationSource {
  /// One hand-written line per option in [Question.choiceNotes].
  authored,

  /// Assembling Objects: the options are figures, so the reason each wrong
  /// figure fails is derived from the puzzle geometry at render time.
  computed,

  /// The item still has a wrong option it cannot explain.
  missing,
}

/// Per-choice explanation coverage over a bank.
///
/// Two sources count, and both are measured rather than assumed: a prose item
/// is covered when it carries a note for every wrong option, and an Assembling
/// Objects item is covered when every wrong figure actually yields a computed
/// reason. An item that explains only some of its wrong options is not covered.
class ExplanationCoverage {
  const ExplanationCoverage({
    required this.items,
    required this.authored,
    required this.computed,
    required this.missing,
  });

  factory ExplanationCoverage.of(List<Question> questions) {
    var authored = 0;
    var computed = 0;
    var missing = 0;
    for (final q in questions) {
      switch (BankAudit.explanationSource(q)) {
        case ExplanationSource.authored:
          authored++;
        case ExplanationSource.computed:
          computed++;
        case ExplanationSource.missing:
          missing++;
      }
    }
    return ExplanationCoverage(
      items: questions.length,
      authored: authored,
      computed: computed,
      missing: missing,
    );
  }

  final int items;

  /// Items carrying a hand-written note for every wrong option.
  final int authored;

  /// Assembling Objects items whose reasons are derived from their geometry.
  final int computed;

  /// Items that cannot explain all of their wrong options yet.
  final int missing;

  /// Items that explain every one of their wrong options.
  int get covered => authored + computed;

  int get percent => items == 0 ? 100 : (100 * covered / items).round();

  /// One line, for the audit tool.
  String get line =>
      'Per-choice explanations: $covered of $items items '
      '($percent%) - $authored authored, $computed computed from geometry, '
      '$missing not yet explained';
}

/// Item-quality rules for the question bank.
///
/// The point of this file is that a plausible-looking item can still be a bad
/// item. A question can be factually correct and still teach a candidate the
/// wrong lesson, because the answer is telegraphed by being the longest option,
/// or because the distractors are obviously absurd. These checks encode what
/// makes an item behave like a real ASVAB item, so the authoring pipeline cannot
/// quietly drift away from the real test.
abstract final class BankAudit {
  static const _bannedChoices = <String>[
    'all of the above',
    'none of the above',
    'all the above',
    'both a and b',
    'a and b',
    'cannot be determined',
  ];

  /// Choice-length spread above this ratio across a four-option item means the
  /// correct answer can be spotted by shape alone.
  static const double maxLengthRatio = 2.6;

  /// Stems that talk about a picture. If one of these appears the item had
  /// better carry a sketch, or the candidate is asked about something that is
  /// not on the screen.
  /// A bare mention of "diagram" is not enough: an item can be about diagrams
  /// ("on a schematic diagram, a capacitor is...") or about drawing marbles out
  /// of a bag. Only a pointer at *this* item's picture counts.
  static final RegExp _pictureWords = RegExp(
    r'\b(shown|pictured|illustrated)\b|\bthe (drawing|diagram|sketch|picture)\b',
    caseSensitive: false,
  );

  static List<String> _tokens(String text) => text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .split(' ')
      .where((token) => token.length >= 3)
      .toList();

  /// Runs every rule and returns findings.
  ///
  /// Set [bankLevel] to false when auditing a single authoring file: rules that
  /// compare one subtest against the whole bank (pool size, difficulty spread,
  /// skill coverage) would otherwise fire for every subtest the file does not
  /// cover.
  static List<AuditFinding> run(
    List<Question> questions, {
    bool bankLevel = true,
  }) {
    final findings = <AuditFinding>[];

    void error(String code, String message, [String? id]) => findings.add(
      AuditFinding(
        severity: 'error',
        code: code,
        message: message,
        questionId: id,
      ),
    );
    void warn(String code, String message, [String? id]) => findings.add(
      AuditFinding(
        severity: 'warn',
        code: code,
        message: message,
        questionId: id,
      ),
    );

    final seenIds = <String>{};
    final seenStems = <String, String>{};
    final seenChoiceSets = <String, String>{};

    for (final q in questions) {
      if (!seenIds.add(q.id)) {
        error('duplicate-id', 'Question id is used more than once', q.id);
      }

      // --- structure -------------------------------------------------------
      if (q.choices.length != 4) {
        error(
          'choice-count',
          'Real ASVAB items always have four options; found '
              '${q.choices.length}',
          q.id,
        );
      }
      if (q.answerIndex < 0 || q.answerIndex >= q.choices.length) {
        error('answer-range', 'answerIndex is outside the option list', q.id);
      }
      if (q.choices.toSet().length != q.choices.length) {
        error('choice-dup', 'Two options have identical text', q.id);
      }

      // --- per-choice notes ------------------------------------------------
      // An unannotated item is not yet a finding: the notes are being rolled
      // out across the bank. Once present they must line up exactly, because
      // a note attached to the wrong option is worse than no note at all.
      if (q.choiceNotes.isNotEmpty) {
        if (q.choiceNotes.length != q.choices.length) {
          error(
            'choice-note-count',
            'choiceNotes has ${q.choiceNotes.length} lines for '
                '${q.choices.length} options',
            q.id,
          );
        }
        for (var i = 0; i < q.choiceNotes.length; i++) {
          if (q.choiceNotes[i].trim().length > 160) {
            warn(
              'choice-note-long',
              'Note for option ${i + 1} is ${q.choiceNotes[i].trim().length} '
                  'characters; reviews read best under 160',
              q.id,
            );
          }
          if (q.choiceNotes[i].trim().isEmpty) {
            error(
              'choice-note-blank',
              'Note for option ${i + 1} is blank',
              q.id,
            );
          }
        }
        final trimmed = q.choiceNotes
            .map((n) => n.trim().toLowerCase())
            .toList();
        if (trimmed.toSet().length != trimmed.length) {
          error(
            'choice-note-dup',
            'Two options share the same note, so one is attached to the '
                'wrong option',
            q.id,
          );
        }
      }

      // --- distractors -----------------------------------------------------
      for (var i = 0; i < q.choices.length; i++) {
        final choice = q.choices[i].trim();
        if (choice.isEmpty) {
          error('choice-empty', 'Option ${i + 1} is blank', q.id);
        }
        final lower = choice.toLowerCase();
        for (final banned in _bannedChoices) {
          if (lower == banned || lower.startsWith('$banned ')) {
            error(
              'choice-banned',
              'Real ASVAB items never use "all/none of the above" style '
                  'options: "$choice"',
              q.id,
            );
          }
        }
      }
      if (q.choices.isNotEmpty) {
        final lengths = q.choices.map((c) => c.trim().length).toList()..sort();
        final shortest = lengths.first;
        final longest = lengths.last;
        // Only sentence-length options can telegraph an answer by length. A set
        // of technical terms ("Halogens" beside "Alkaline earth metals") or of
        // numeric answers is legitimately uneven, so require a high median
        // before applying the rule at all.
        final median = (lengths[1] + lengths[2]) / 2;
        final proseOptions = median >= 24 && longest >= 30;
        final ratio = q.subtest == Subtest.wk ? 3.4 : maxLengthRatio;
        if (proseOptions && shortest > 0 && longest / shortest > ratio) {
          warn(
            'choice-length-spread',
            'Option lengths range from $shortest to $longest characters, so '
                'the answer is telegraphed by shape',
            q.id,
          );
        }
      }

      // --- explanation -----------------------------------------------------
      if (q.explanation.trim().length < 70) {
        error(
          'explanation-thin',
          'An explanation must teach the idea, not restate the answer '
              '(${q.explanation.trim().length} characters)',
          q.id,
        );
      }

      // --- skill tags ------------------------------------------------------
      if (q.skills.isEmpty) {
        error('no-skills', 'Item carries no skill tags', q.id);
      }
      for (final sid in q.skills) {
        final skill = Skills.maybeById(sid);
        if (skill == null) {
          error('unknown-skill', 'Unknown skill tag "$sid"', q.id);
        } else if (skill.subtest != q.subtest) {
          error(
            'skill-subtest-mismatch',
            'Skill "$sid" belongs to ${skill.subtest.abbr}, not '
                '${q.subtest.abbr}',
            q.id,
          );
        }
      }

      // --- per-subtest presentation conventions ----------------------------
      switch (q.subtest) {
        case Subtest.pc:
          if (q.passage == null || q.passage!.trim().length < 180) {
            error(
              'pc-no-passage',
              'Paragraph Comprehension items need a real passage of at least '
                  '180 characters',
              q.id,
            );
          }
          // Test-taker evidence: on real PC items the attractive option is the
          // polished generalisation and the key is the plain literal detail. An
          // item whose correct option is the longest is usually pulling in the
          // wrong direction.
          if (q.answerIndex >= 0 && q.answerIndex < q.choices.length) {
            final correct = q.choices[q.answerIndex].trim().length;
            var longestOther = 0;
            for (var i = 0; i < q.choices.length; i++) {
              if (i == q.answerIndex) continue;
              final len = q.choices[i].trim().length;
              if (len > longestOther) longestOther = len;
            }
            if (longestOther > 0 && correct > longestOther * 1.1) {
              warn(
                'pc-correct-longest',
                'The correct option is the longest of the four, so it is the one '
                    'that sounds most considered. On real PC items the trap is the '
                    'sweeping summary and the key is the plain detail',
                q.id,
              );
            }
          }
        case Subtest.mk:
          if (q.stem.length > 260) {
            warn(
              'mk-word-problem',
              'Mathematics Knowledge tests computation and algebra, not word '
                  'problems; this stem is ${q.stem.length} characters',
              q.id,
            );
          }
        case Subtest.ar:
          // Verified against the official samples: AR options are bare numerals
          // or currency amounts, never explanatory words. Units printed beside
          // each option are a crutch the real test does not offer, because they
          // tell the candidate which quantity a distractor is before the
          // arithmetic is even attempted.
          for (var i = 0; i < q.choices.length; i++) {
            final choice = q.choices[i].trim();
            final hasLetters = RegExp(r'[A-Za-z]').hasMatch(choice);
            final hasDigit = RegExp(r'[0-9]').hasMatch(choice);
            if (hasLetters || !hasDigit) {
              error(
                'ar-option-units',
                'Option ${i + 1} reads "$choice". Arithmetic Reasoning options '
                    'are bare numerals or currency amounts on the real test, and '
                    'the stem is supposed to name the unit',
                q.id,
              );
            }
          }
          if (!RegExp(r'[0-9]').hasMatch(q.stem)) {
            error(
              'ar-no-numbers',
              'Arithmetic Reasoning items are numeric word problems and must '
                  'contain a number',
              q.id,
            );
          }
          if (q.stem.length < 24) {
            warn(
              'ar-too-short',
              'This reads too short to be a multi-step word problem',
              q.id,
            );
          }
        case Subtest.wk:
          if (q.skills.contains('wk.synonym')) {
            final long = q.choices.where((c) => c.trim().length > 32).length;
            if (long > 0) {
              warn(
                'wk-long-option',
                'A bare-synonym Word Knowledge item uses single words or very '
                    'short phrases; $long option(s) are long enough to be a '
                    'definition',
                q.id,
              );
            }
          }
        case Subtest.ao:
          if (q.puzzle == null) {
            error(
              'ao-no-puzzle',
              'Assembling Objects items need a rendered puzzle',
              q.id,
            );
          } else {
            final legal = q.puzzle!.legaltyCount;
            if (legal != 1) {
              error(
                'ao-ambiguous',
                'Puzzle has $legal legal assemblies; exactly one must be '
                    'buildable',
                q.id,
              );
            } else if (q.puzzle!.correctIndex != q.answerIndex) {
              error(
                'ao-key-mismatch',
                'answerIndex ${q.answerIndex} but the only legal assembly is '
                    '${q.puzzle!.correctIndex}',
                q.id,
              );
            }
            // Review explains an Assembling Objects option by computation, so
            // an item whose figures do not all yield a reason would show the
            // candidate a figure with nothing beside it. That is the same
            // defect as a prose item with a missing note.
            final reasons = q.puzzle!.optionReasons;
            final keyed = q.puzzle!.correctIndex;
            final silent = <int>[
              for (var i = 0; i < reasons.length; i++)
                if (i != keyed &&
                    (reasons[i] == null || reasons[i]!.trim().isEmpty))
                  i + 1,
            ];
            if (silent.isNotEmpty) {
              error(
                'ao-unexplained',
                'Figure(s) ${silent.join(', ')} yield no computed reason, so '
                    'review would print nothing beside them',
                q.id,
              );
            }
            if (q.puzzle!.isConnectionItem) {
              final keys = q.puzzle!.pieces.map((p) => p.canonicalKey).toList();
              if (keys.toSet().length != keys.length) {
                error(
                  'ao-labels-ambiguous',
                  'A labeled-connection item needs visually distinct pieces so '
                      'each letter identifies exactly one piece; two pieces here are '
                      'identical up to rotation',
                  q.id,
                );
              }
              final anchors = q.puzzle!.optionAnchors;
              if (anchors == null ||
                  anchors.length != q.puzzle!.options.length) {
                error(
                  'ao-anchors-missing',
                  'Every candidate assembly needs a marked point per piece',
                  q.id,
                );
              }
              if (q.puzzle!.connections == null ||
                  q.puzzle!.connections!.isEmpty) {
                error(
                  'ao-no-connections',
                  'A labeled-connection item must declare which letters meet',
                  q.id,
                );
              }
            }
          }
        case Subtest.gs:
        case Subtest.ei:
        case Subtest.as:
        case Subtest.mc:
          break;
      }

      // --- attached sketch -------------------------------------------------
      final sketch = q.figure;
      if (sketch != null) {
        if (sketch.prims.isEmpty) {
          error(
            'sketch-empty',
            'The item declares a sketch but carries no drawing instructions',
            q.id,
          );
        }
        if (sketch.caption.trim().length < 24) {
          error(
            'sketch-no-caption',
            'A sketch needs a real caption; it is the only description of the '
                'picture a screen reader can read out',
            q.id,
          );
        }
        if (sketch.aspect < 0.6 || sketch.aspect > 4.5) {
          warn(
            'sketch-aspect',
            'Aspect ${sketch.aspect} will not fit a question card',
            q.id,
          );
        }
        for (final prim in sketch.prims) {
          for (final point in <Pt?>[prim.a, prim.b, prim.c, ...prim.pts]) {
            if (point == null) continue;
            if (point.x < -0.02 ||
                point.x > 1.02 ||
                point.y < -0.02 ||
                point.y > 1.02) {
              error(
                'sketch-out-of-bounds',
                'A drawing instruction at $point falls outside the 0..1 sketch '
                    'box, so it will not be visible',
                q.id,
              );
            }
          }
          if (prim.kind == SketchPrimKind.poly && prim.pts.length < 3) {
            error(
              'sketch-bad-path',
              'A path needs at least three points to enclose an area',
              q.id,
            );
          }
          if ((prim.kind == SketchPrimKind.circle ||
                  prim.kind == SketchPrimKind.disc ||
                  prim.kind == SketchPrimKind.arc) &&
              prim.r <= 0) {
            error(
              'sketch-bad-radius',
              'A round primitive needs a positive radius',
              q.id,
            );
          }
        }
        // On a tool-identification item the picture is the question, so a
        // caption that names the tool prints the answer. Statements about
        // behaviour are exempt: their captions describe the setup on purpose.
        if (q.subtest == Subtest.as &&
            q.answerIndex >= 0 &&
            q.answerIndex < q.choices.length) {
          final correct = q.choices[q.answerIndex];
          if (correct.trim().split(RegExp(r'\s+')).length <= 4) {
            final otherTokens = <String>{};
            for (var i = 0; i < q.choices.length; i++) {
              if (i == q.answerIndex) continue;
              otherTokens.addAll(_tokens(q.choices[i]));
            }
            final captionTokens = _tokens(sketch.caption).toSet();
            final leaked = _tokens(correct)
                .where((t) => !otherTokens.contains(t))
                .where(captionTokens.contains)
                .toList();
            if (leaked.isNotEmpty) {
              error(
                'sketch-caption-key',
                'The caption contains $leaked, which is exactly what the drawing '
                    'is being used to test',
                q.id,
              );
            }
          }
        }
      }

      // A stem that points at a picture has to be showing one.
      if (q.figure == null &&
          q.subtest != Subtest.ao &&
          _pictureWords.hasMatch(q.stem)) {
        error(
          'stem-refers-to-missing-sketch',
          'The stem points at a picture that the item does not carry',
          q.id,
        );
      }

      // --- duplication -----------------------------------------------------
      // Assembling Objects items all share one stem and the option labels
      // "Figure A..D" by design, so those two checks do not apply to them.
      if (q.subtest != Subtest.ao) {
        final stemKey = q.stem.trim().toLowerCase();
        final prior = seenStems[stemKey];
        if (prior != null) {
          warn(
            'duplicate-stem',
            'Same stem as $prior; the bank is about to repeat itself',
            q.id,
          );
        } else {
          seenStems[stemKey] = q.id;
        }
        final setKey =
            (q.choices.map((c) => c.trim().toLowerCase()).toList()..sort())
                .join('|');
        final priorSet = seenChoiceSets[setKey];
        if (priorSet != null) {
          warn(
            'duplicate-options',
            'Same option set as $priorSet - probably a copy of one item',
            q.id,
          );
        } else {
          seenChoiceSets[setKey] = q.id;
        }
      }
    }

    if (!bankLevel) {
      return findings;
    }

    // --- bank-level distribution rules ------------------------------------
    for (final subtest in Subtest.administrationOrder) {
      final pool = questions.where((q) => q.subtest == subtest).toList();
      if (pool.isEmpty) {
        error('empty-subtest', '${subtest.abbr} has no questions');
        continue;
      }
      final byBand = <Difficulty, int>{
        for (final d in Difficulty.values)
          d: pool.where((q) => q.difficulty == d).length,
      };
      final floor = (pool.length * 0.08).ceil().clamp(1, 99);
      for (final entry in byBand.entries) {
        if (entry.value < floor) {
          warn(
            'difficulty-gap',
            '${subtest.abbr} has only ${entry.value} ${entry.key.label} '
                'item(s); the real pool is roughly a fifth easy, three fifths '
                'medium, a fifth hard',
          );
        }
      }
      if (pool.length < subtest.questionCount) {
        error(
          'pool-too-small',
          '${subtest.abbr} needs at least ${subtest.questionCount} items for '
              'a full mock without repeating',
        );
      }
    }

    // Answer position should not be learnable across the bank.
    final positions = List<int>.filled(4, 0);
    for (final q in questions) {
      if (q.answerIndex >= 0 && q.answerIndex < 4) positions[q.answerIndex]++;
    }
    for (var i = 0; i < positions.length; i++) {
      final share = questions.isEmpty ? 0 : positions[i] / questions.length;
      if (share > 0.45) {
        warn(
          'answer-position-bias',
          '${(share * 100).round()} percent of items have the answer at '
              'position ${i + 1}; options are shuffled at serve time, but authoring '
              'bias usually means sloppy distractors',
        );
      }
    }

    // Every declared skill must be exercisable.
    final covered = <String>{for (final q in questions) ...q.skills};
    for (final skill in Skills.all) {
      if (!covered.contains(skill.id)) {
        error(
          'skill-uncovered',
          'Skill ${skill.id} has no questions behind it',
        );
      }
    }

    return findings;
  }

  /// Whether [q] explains every wrong option, and where those explanations
  /// come from.
  ///
  /// An Assembling Objects item counts as covered by computation only when the
  /// geometry really does produce a reason for every wrong figure; the count in
  /// the audit report is therefore read off the puzzles, never hard-coded.
  static ExplanationSource explanationSource(Question q) {
    final puzzle = q.puzzle;
    if (puzzle != null) {
      if (_everyWrongFigureExplained(puzzle)) return ExplanationSource.computed;
      if (q.choiceNotes.isNotEmpty) return ExplanationSource.authored;
      return ExplanationSource.missing;
    }
    if (q.choiceNotes.length == q.choices.length &&
        q.choices.isNotEmpty &&
        q.choiceNotes.every((note) => note.trim().isNotEmpty)) {
      return ExplanationSource.authored;
    }
    return ExplanationSource.missing;
  }

  /// True when the keyed figure explains itself through the "Why" box and every
  /// other figure yields a computed reason.
  static bool _everyWrongFigureExplained(AoPuzzle puzzle) {
    final keyed = puzzle.correctIndex;
    if (keyed == null) return false;
    final reasons = puzzle.optionReasons;
    for (var i = 0; i < reasons.length; i++) {
      final reason = reasons[i];
      if (i == keyed) {
        if (reason != null) return false;
        continue;
      }
      if (reason == null || reason.trim().isEmpty) return false;
    }
    return true;
  }

  /// Per-choice explanation coverage, the number the audit report prints.
  static ExplanationCoverage explanationCoverage(List<Question> questions) =>
      ExplanationCoverage.of(questions);

  static List<AuditFinding> get errors =>
      run(const <Question>[]).where((f) => f.isError).toList();

  /// Question count per skill, for targeting authoring gaps.
  static Map<String, int> coverage(List<Question> questions) {
    final counts = <String, int>{for (final s in Skills.all) s.id: 0};
    for (final q in questions) {
      for (final sid in q.skills) {
        counts[sid] = (counts[sid] ?? 0) + 1;
      }
    }
    return counts;
  }
}
