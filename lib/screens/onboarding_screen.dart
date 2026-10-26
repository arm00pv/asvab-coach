import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/tokens.dart';
import '../data/models/mos.dart';
import '../data/repos/mos_repository.dart';
import '../state/app_state.dart';
import '../widgets/pill_selector.dart';
import '../widgets/primitives.dart';

/// Four short steps that establish the goal every recommendation is measured
/// against. Nothing here is busywork: the target MOS picks the line score to
/// optimise, and the target date drives the pacing advice.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _name = TextEditingController();
  int _daysUntilTest = 60;
  int _dailyMinutes = 20;
  bool _officerTrack = false;
  final Set<String> _mosCodes = <String>{'11B'};

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canAdvance {
    if (_step == 1) return _name.text.trim().isNotEmpty;
    return true;
  }

  Future<void> _finish() async {
    final target = DateTime.now().add(Duration(days: _daysUntilTest));
    await context.read<AppState>().setGoal(
      GoalProfile(
        displayName: _name.text.trim().isEmpty
            ? 'Candidate'
            : _name.text.trim(),
        targetAfqt: 60,
        targetGt: _officerTrack ? 110 : 100,
        targetMosCodes: _mosCodes.toList(),
        targetDate: target,
        officerTrack: _officerTrack,
        dailyMinutes: _dailyMinutes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.xl,
                Space.lg,
                Space.xl,
                0,
              ),
              child: Row(
                children: <Widget>[
                  for (var i = 0; i < 4; i++) ...<Widget>[
                    Expanded(
                      child: AnimatedContainer(
                        duration: Motion.base,
                        height: 4,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: i <= _step ? c.primary : c.surfaceSunken,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: PageBody(
                maxWidth: 560,
                centerVertically: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.xl,
                  vertical: Space.xxl,
                ),
                child: AnimatedSwitcher(
                  duration: Motion.base,
                  child: KeyedSubtree(
                    key: ValueKey<int>(_step),
                    child: _buildStep(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.xl,
                0,
                Space.xl,
                Space.xl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Row(
                  children: <Widget>[
                    if (_step > 0)
                      TextButton(
                        onPressed: () => setState(() => _step--),
                        child: const Text('Back'),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: !_canAdvance
                          ? null
                          : () {
                              if (_step == 3) {
                                _finish();
                              } else {
                                setState(() => _step++);
                              }
                            },
                      child: Text(_step == 3 ? 'Start training' : 'Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    final c = context.colors;
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(Radii.lg),
              ),
              child: Icon(Icons.shield_outlined, color: c.onPrimary, size: 28),
            ),
            const SizedBox(height: Space.xl),
            Text('Your ASVAB coach', style: context.text.displaySmall),
            const SizedBox(height: Space.md),
            Text(
              'This app does four things: it places you with a short diagnostic, '
              'it runs practice and full-length mock tests with official timing, it '
              'scores you the way the Army actually does, and it teaches back the '
              'specific skills that cost you points.',
              style: context.text.bodyLarge,
            ),
            const SizedBox(height: Space.xl),
            for (final row in <(IconData, String, String)>[
              (
                Icons.timer_outlined,
                'Real timing',
                '135 items over 197 minutes in the same order MEPS uses.',
              ),
              (
                Icons.insights_outlined,
                'Honest scoring',
                'AFQT percentile, all ten line scores and MOS eligibility.',
              ),
              (
                Icons.auto_stories_outlined,
                'Reinforcement lessons',
                'One lesson per skill, chosen from what you actually missed.',
              ),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(row.$1, size: 18, color: c.primary),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: context.text.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: '${row.$2}. ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: c.textPrimary,
                              ),
                            ),
                            TextSpan(text: row.$3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: Space.md),
            const Callout(
              tone: PillTone.warning,
              icon: Icons.gavel_rounded,
              title: 'What this is not',
              text:
                  'A study tool, not an official score. Scores here are '
                  'well-grounded estimates built from the published 1997 ASVAB '
                  'scale, but only the test at MEPS counts. Verify every '
                  'aptitude requirement with your recruiter before you sign.',
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('First, the basics', style: context.text.headlineLarge),
            const SizedBox(height: Space.sm),
            Text(
              'Your name is only used to address you in the app. Everything is '
              'stored on this device and never leaves it.',
              style: context.text.bodyMedium,
            ),
            const SizedBox(height: Space.xl),
            Text('What should I call you?', style: context.text.titleSmall),
            const SizedBox(height: Space.sm),
            TextField(
              controller: _name,
              autofocus: false,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Your name'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: Space.xl),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Days until your target test date',
                    style: context.text.titleSmall,
                  ),
                ),
                Text(
                  '$_daysUntilTest days',
                  style: context.text.titleMedium?.copyWith(color: c.primary),
                ),
              ],
            ),
            Slider(
              value: _daysUntilTest.toDouble(),
              min: 7,
              max: 180,
              divisions: 173,
              onChanged: (v) => setState(() => _daysUntilTest = v.round()),
            ),
            const SizedBox(height: Space.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Minutes you can study per day',
                    style: context.text.titleSmall,
                  ),
                ),
                Text(
                  '$_dailyMinutes min',
                  style: context.text.titleMedium?.copyWith(color: c.primary),
                ),
              ],
            ),
            Slider(
              value: _dailyMinutes.toDouble(),
              min: 10,
              max: 120,
              divisions: 22,
              onChanged: (v) => setState(() => _dailyMinutes = v.round()),
            ),
            const SizedBox(height: Space.sm),
            Text(
              'Be honest here. A plan built on twenty real minutes beats one built '
              'on ninety imaginary ones.',
              style: context.text.bodySmall?.copyWith(color: c.textMuted),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('What are you aiming for?', style: context.text.headlineLarge),
            const SizedBox(height: Space.sm),
            Text(
              'Pick up to three jobs. The coach will optimise your study plan for '
              'the line score those jobs actually read.',
              style: context.text.bodyMedium,
            ),
            const SizedBox(height: Space.lg),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _officerTrack,
              onChanged: (v) => setState(() => _officerTrack = v),
              title: Text(
                'I want to become an officer',
                style: context.text.titleSmall,
              ),
              subtitle: Text(
                'Adds the GT 110 requirement for OCS and warrant officer to your plan.',
                style: context.text.bodySmall,
              ),
            ),
            const Divider(height: Space.xl),
            SizedBox(
              height: 320,
              child: MosPicker(
                selected: _mosCodes,
                onToggle: (code) {
                  setState(() {
                    if (_mosCodes.contains(code)) {
                      _mosCodes.remove(code);
                    } else if (_mosCodes.length < 3) {
                      _mosCodes.add(code);
                    }
                  });
                },
              ),
            ),
          ],
        );

      default:
        final selected = MosRepository.all
            .where((m) => _mosCodes.contains(m.code))
            .toList(growable: false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Here is your starting line',
              style: context.text.headlineLarge,
            ),
            const SizedBox(height: Space.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Eyebrow('Goal'),
                  const SizedBox(height: Space.xs),
                  Text(
                    _officerTrack
                        ? 'Commission as an officer'
                        : (selected.isEmpty
                              ? 'Enlist in the Army National Guard'
                              : selected.first.title),
                    style: context.text.titleLarge,
                  ),
                  const SizedBox(height: Space.md),
                  _row(
                    context,
                    'Target date',
                    '$_daysUntilTest days from today',
                  ),
                  _row(context, 'Daily study time', '$_dailyMinutes minutes'),
                  _row(
                    context,
                    'Aptitude target',
                    _officerTrack
                        ? 'GT 110 or better'
                        : (selected.isEmpty
                              ? 'ST 90 or better'
                              : selected
                                    .map((m) => m.gate.label)
                                    .join('  |  ')),
                  ),
                  if (selected.isNotEmpty) ...<Widget>[
                    _row(
                      context,
                      'Jobs tracked',
                      selected.map((m) => m.code).join(', '),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            const Callout(
              icon: Icons.school_outlined,
              title: 'What happens next',
              text:
                  'The placement diagnostic is 27 questions across all nine '
                  'subtests, about half an hour. Everything after it is chosen '
                  'from your results, so resist the urge to skip it.',
            ),
          ],
        );
    }
  }

  Widget _row(BuildContext context, String label, String value) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: context.text.bodySmall?.copyWith(color: c.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.text.bodySmall?.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
