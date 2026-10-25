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
        final meanLength = lengths.reduce((a, b) => a + b) / lengths.length;
        // Only prose-style options can telegraph the answer by length. Numeric
        // answers ("17", "-17") and bare synonyms are legitimately uneven.
        final proseOptions = meanLength >= 10 && longest >= 16;
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
          if (!RegExp(r'[0-9]').hasMatch(q.stem)) {
            error(
              'ar-no-numbers',
              'Arithmetic Reasoning items are numeric word problems and must '
                  'contain a number',
              q.id,
            );
          }
          if (q.stem.length < 34) {
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
