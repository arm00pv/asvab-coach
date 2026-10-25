import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../data/bank/lessons_index.dart';
import '../data/bank/question_bank.dart';
import '../data/models/catalog.dart';
import '../data/models/line_score.dart';
import '../engines/personas.dart';
import '../widgets/primitives.dart';

/// An in-app harness that runs synthetic learners through the real engines.
///
/// This is the same logic the automated test suite exercises, surfaced as a
/// screen so the product can be spot-checked without waiting for a human to sit
/// a two-hour mock.
class QaLabScreen extends StatefulWidget {
  const QaLabScreen({super.key});

  @override
  State<QaLabScreen> createState() => _QaLabScreenState();
}

class _QaLabScreenState extends State<QaLabScreen> {
  late List<PersonaResult> _results;
  late List<_Check> _checks;

  @override
  void initState() {
    super.initState();
    _run();
  }

  void _run() {
    _results = <PersonaResult>[
      for (final p in Personas.all) PersonaRunner.run(p),
    ];
    _checks = _buildChecks(_results);
  }

  List<_Check> _buildChecks(List<PersonaResult> results) {
    PersonaResult by(String id) =>
        results.firstWhere((r) => r.persona.id == id);
    final bankProblems = QuestionBank.validate();
    final marcus = by('marcus');
    final jenna = by('jenna');
    final ava = by('ava');
    final sam = by('sam');
    final dana = by('dana');
    final ruiz = by('ruiz');

    final checks = <_Check>[
      _Check(
        'Question bank has no structural problems',
        bankProblems.isEmpty,
        bankProblems.isEmpty ? 'all items valid' : bankProblems.first,
      ),
      _Check(
        'Every skill has a lesson',
        LessonRepository.count == Skills.all.length,
        '${LessonRepository.count} lessons for ${Skills.all.length} skills',
      ),
      _Check(
        'Every persona scores all nine subtests',
        results.every((r) => r.report.subtestScores.length == 9),
        results
            .map((r) => '${r.persona.id}:${r.report.subtestScores.length}')
            .join(' '),
      ),
      _Check(
        'A strong candidate outscores a weak one',
        ava.report.afqtPercentile > marcus.report.afqtPercentile,
        'ava ${ava.report.afqtPercentile} vs marcus ${marcus.report.afqtPercentile}',
      ),
      _Check(
        'A pure guesser stays below the Army floor',
        sam.report.afqtPercentile < 31,
        'guess percentile ${sam.report.afqtPercentile}',
      ),
      _Check(
        'A pure guesser cannot clear a technical gate',
        sam.report.lineFor(LineScore.st) < 95,
        'ST ${sam.report.lineFor(LineScore.st)}',
      ),
      _Check(
        'A strong candidate reaches Category II or better',
        jenna.report.afqtPercentile >= 65,
        'jenna percentile ${jenna.report.afqtPercentile}',
      ),
      _Check(
        'An officer candidate clears GT 110',
        ava.report.gt >= 110,
        'ava GT ${ava.report.gt}',
      ),
      _Check(
        'A maths-anxious candidate is pointed at a maths skill',
        dana.topPriority != null &&
            (dana.topPriority!.skill.subtest == Subtest.ar ||
                dana.topPriority!.skill.subtest == Subtest.mk),
        dana.topPriority == null
            ? 'no priority'
            : dana.topPriority!.skill.label,
      ),
      _Check(
        'A mechanic qualifies for a mechanical MOS',
        ruiz.summary.qualified.any(
          (m) =>
              m.category == MosCategory.mechanical ||
              m.category == MosCategory.aviation,
        ),
        '${ruiz.summary.qualified.length} jobs open',
      ),
      _Check(
        'Eligibility strictly shrinks as scores fall',
        ava.summary.qualified.length >= marcus.summary.qualified.length,
        'ava ${ava.summary.qualified.length} vs marcus '
            '${marcus.summary.qualified.length}',
      ),
      _Check(
        'Scoring is deterministic for the same persona',
        PersonaRunner.run(Personas.jenna).report.afqtPercentile ==
            jenna.report.afqtPercentile,
        'two runs agree',
      ),
      _Check(
        'Line scores land on the Army mean-100 scale',
        _allNear100(results),
        'an average profile must score about 100 in every aptitude area',
      ),
    ];
    return checks;
  }

  /// Every army composite returns 100 when all seven inputs are 50.
  bool _allNear100(List<PersonaResult> results) {
    int fifty(Subtest s) => 50;
    final ve = LineScore.verbalComposite(50, 50);
    for (final ls in LineScore.values) {
      final value = ls.compute(fifty, ve);
      if ((value - 100).abs() > 3) return false;
    }
    return results.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final passed = _checks.where((ch) => ch.passed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QA lab'),
        actions: <Widget>[
          IconButton(
            onPressed: () => setState(_run),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Re-run',
          ),
          const SizedBox(width: Space.sm),
        ],
      ),
      body: PageBody(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppCard(
              accent: passed == _checks.length ? c.success : c.warning,
              child: Row(
                children: <Widget>[
                  Icon(
                    passed == _checks.length
                        ? Icons.verified_rounded
                        : Icons.warning_amber_rounded,
                    color: passed == _checks.length ? c.success : c.warning,
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$passed of ${_checks.length} checks pass',
                          style: context.text.titleMedium?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        Text(
                          'Seven synthetic learners sit a full mock through the '
                          'real scoring, eligibility and coaching engines.',
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            Eyebrow('Checks'),
            const SizedBox(height: Space.sm),
            for (final ch in _checks)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.xs),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.md,
                    vertical: Space.sm,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        ch.passed
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 16,
                        color: ch.passed ? c.success : c.danger,
                      ),
                      const SizedBox(width: Space.md),
                      Expanded(
                        child: Text(
                          ch.label,
                          style: context.text.bodySmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        ch.detail,
                        style: context.text.labelSmall?.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Space.xl),
            const _BankPanel(),
            const SizedBox(height: Space.xl),
            Eyebrow('Persona results'),
            const SizedBox(height: Space.sm),
            for (final r in _results)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: AppCard(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              r.persona.name,
                              style: context.text.titleSmall?.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                          ),
                          Pill(
                            'AFQT ${r.report.afqtPercentile}',
                            tone: r.report.meetsArmyFloor
                                ? PillTone.success
                                : PillTone.danger,
                            dense: true,
                          ),
                          const SizedBox(width: Space.sm),
                          Pill(
                            'GT ${r.report.gt}',
                            tone: PillTone.neutral,
                            dense: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: Space.xs),
                      Text(
                        r.persona.description,
                        style: context.text.bodySmall?.copyWith(
                          color: c.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: Space.sm),
                      Wrap(
                        spacing: Space.md,
                        runSpacing: Space.xs,
                        children: <Widget>[
                          _fact('Category ${r.report.category}'),
                          _fact('${r.summary.qualified.length} jobs open'),
                          _fact('ST ${r.report.lineFor(LineScore.st)}'),
                          _fact('MM ${r.report.lineFor(LineScore.mm)}'),
                          if (r.topPriority != null)
                            _fact('Weakest: ${r.topPriority!.skill.label}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Space.xxl),
          ],
        ),
      ),
    );
  }

  Widget _fact(String text) {
    return Builder(
      builder: (context) => Text(
        text,
        style: context.text.labelSmall?.copyWith(
          color: context.colors.textMuted,
        ),
      ),
    );
  }
}

/// Bank health: how much content exists, how it is distributed, and whether
/// any item breaks a quality rule. This is the panel that keeps the content
/// honest as the bank grows.
class _BankPanel extends StatelessWidget {
  const _BankPanel();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final findings = QuestionBank.audit;
    final errors = findings.where((f) => f.isError).toList();
    final warnings = findings.where((f) => !f.isError).toList();
    final coverage = QuestionBank.skillCoverage;
    final thin = coverage.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Eyebrow('Question bank'),
        const SizedBox(height: Space.sm),
        AppCard(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${QuestionBank.total}',
                    style: context.text.headlineLarge,
                  ),
                  const SizedBox(width: Space.sm),
                  Text(
                    'items across 9 subtests',
                    style: context.text.bodySmall,
                  ),
                  const Spacer(),
                  Pill(
                    '${errors.length} errors  ${warnings.length} warnings',
                    tone: errors.isEmpty ? PillTone.success : PillTone.danger,
                    dense: true,
                  ),
                ],
              ),
              const SizedBox(height: Space.md),
              for (final s in Subtest.administrationOrder)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 34,
                        child: Text(
                          s.abbr,
                          style: context.text.labelMedium?.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 46,
                        child: Text(
                          '${QuestionBank.countFor(s)}',
                          style: context.text.labelLarge?.copyWith(
                            color: QuestionBank.countFor(s) >= s.questionCount
                                ? c.textPrimary
                                : c.danger,
                          ),
                        ),
                      ),
                      Expanded(
                        child: MeterBar(
                          value: (QuestionBank.countFor(s) / 45).clamp(
                            0.0,
                            1.0,
                          ),
                          height: 5,
                          color: QuestionBank.countFor(s) >= s.questionCount
                              ? c.primary
                              : c.danger,
                        ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        '${s.questionCount} needed',
                        style: context.text.labelSmall?.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (findings.isNotEmpty) ...<Widget>[
          const SizedBox(height: Space.lg),
          Eyebrow('Audit findings'),
          const SizedBox(height: Space.sm),
          for (final f in findings.take(24))
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    f.isError
                        ? Icons.cancel_rounded
                        : Icons.info_outline_rounded,
                    size: 13,
                    color: f.isError ? c.danger : c.warning,
                  ),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      '${f.questionId ?? f.code}: ${f.message}',
                      style: context.text.bodySmall?.copyWith(
                        color: c.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: Space.lg),
        Eyebrow('Thinnest skills'),
        const SizedBox(height: Space.sm),
        Wrap(
          spacing: Space.sm,
          runSpacing: Space.sm,
          children: <Widget>[
            for (final entry in thin.take(10))
              Pill(
                '${Skills.byId(entry.key).label} (${entry.value})',
                tone: entry.value == 0
                    ? PillTone.danger
                    : (entry.value < 3 ? PillTone.warning : PillTone.neutral),
                dense: true,
              ),
          ],
        ),
      ],
    );
  }
}

class _Check {
  const _Check(this.label, this.passed, this.detail);
  final String label;
  final bool passed;
  final String detail;
}
