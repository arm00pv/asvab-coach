import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/theme/tokens.dart';
import '../data/bank/question_bank.dart';
import '../data/repos/mos_repository.dart';
import '../state/app_state.dart';
import '../widgets/primitives.dart';
import 'qa_lab_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final c = context.colors;
    final goal = app.goal;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: PageBody(
        maxWidth: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Group(
              title: 'Appearance',
              children: <Widget>[
                // A row, not a SwitchListTile. A two-line ListTile reserves the
                // Material height of 72 dp whatever its text needs, so on a card
                // that holds nothing else the label floated in a band of empty
                // space that no neighbouring card had - the other cards hold rows
                // tall enough to fill that minimum. The row below is the text at
                // its own height beside the switch, and the switch keeps its own
                // 48 dp tap target.
                //
                // It still has to own a Material: the group is a DecoratedBox with
                // a background colour, and ink paints on the nearest Material
                // ancestor, so without this the ripple is invisible and debug
                // builds assert. Tapping the label toggles the switch, which is
                // what the ListTile did.
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => app.setDarkMode(!app.darkMode),
                    borderRadius: BorderRadius.circular(Radii.sm),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Dark mode', style: context.text.titleSmall),
                              Text(
                                'Easier on the eyes for long evening sessions.',
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Space.md),
                        Switch.adaptive(
                          value: app.darkMode,
                          onChanged: app.setDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _Group(
              title: 'Understanding the app',
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.menu_book_outlined),
                    title: Text(
                      'What the terms mean',
                      style: context.text.titleSmall,
                    ),
                    subtitle: Text(
                      'AFQT, VE, standard scores, line scores, MOS gates - every '
                      'abbreviation in the app, in plain words.',
                      style: context.text.bodySmall,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => AppRoutes.glossary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _Group(
              title: 'Your goal',
              children: <Widget>[
                if (goal == null)
                  Text('No goal set.', style: context.text.bodySmall)
                else ...<Widget>[
                  _kv(context, 'Name', goal.displayName),
                  _kv(
                    context,
                    'Target date',
                    goal.targetDate == null
                        ? 'not set'
                        : '${goal.targetDate!.difference(DateTime.now()).inDays} days out',
                  ),
                  _kv(context, 'Daily minutes', '${goal.dailyMinutes}'),
                  _kv(
                    context,
                    'Officer track',
                    goal.officerTrack ? 'Yes' : 'No',
                  ),
                  _kv(
                    context,
                    'Tracked jobs',
                    goal.targetMosCodes.isEmpty
                        ? 'None yet'
                        : goal.targetMosCodes
                              .map((c) => MosRepository.byCode(c)?.code ?? c)
                              .join(', '),
                  ),
                ],
              ],
            ),
            const SizedBox(height: Space.lg),
            _Group(
              title: 'Your data',
              children: <Widget>[
                Text(
                  '${app.attempts.length} '
                  '${app.attempts.length == 1 ? 'attempt' : 'attempts'} and '
                  '${QuestionBank.total} practice questions. Everything is stored '
                  'on this device only - '
                  'no account, no server, and no attempt or score ever leaves it.',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: Space.md),
                Wrap(
                  spacing: Space.md,
                  runSpacing: Space.sm,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: () async {
                        final json = _export(app);
                        await Clipboard.setData(ClipboardData(text: json));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('History copied to the clipboard.'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy_rounded, size: 15),
                      // This is the one way to take the history off the
                      // device, so it should not read like a developer
                      // command sitting above the erase button. It copies a
                      // pasteable copy; nothing is uploaded anywhere.
                      label: const Text('Copy my history'),
                    ),
                  ],
                ),
                const SizedBox(height: Space.md),
                TextButton.icon(
                  onPressed: () => _confirmReset(context, app),
                  style: TextButton.styleFrom(foregroundColor: c.danger),
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Erase all data'),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _Group(
              title: 'Updates',
              children: <Widget>[
                _kv(
                  context,
                  'This build',
                  app.installedVersion ?? 'not reported on this platform',
                ),
                if (app.availableUpdate != null) ...<Widget>[
                  const SizedBox(height: Space.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Space.md),
                    decoration: BoxDecoration(
                      color: c.primarySoft,
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Version ${app.availableUpdate!.version} is available',
                          style: context.text.titleSmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Downloading it and handing it to Android costs about '
                          '${app.availableUpdate!.sizeLabel}. Android will ask you to '
                          'allow installs from ASVAB Coach the first time, then '
                          'confirm the update itself; Play Protect may offer to '
                          'scan the app on the way through, which is the normal '
                          'path for anything installed outside the Play Store. '
                          'Your history is kept.',
                          style: context.text.bodySmall,
                        ),
                        const SizedBox(height: Space.sm),
                        FilledButton.tonalIcon(
                          onPressed: () => app.installAvailableUpdate(),
                          icon: const Icon(
                            Icons.system_update_alt_rounded,
                            size: 16,
                          ),
                          label: const Text('Download and install'),
                        ),
                      ],
                    ),
                  ),
                ],
                if (app.updateError != null) ...<Widget>[
                  const SizedBox(height: Space.sm),
                  Text(
                    app.updateError!,
                    style: context.text.bodySmall?.copyWith(color: c.warning),
                  ),
                ],
                const SizedBox(height: Space.sm),
                Wrap(
                  spacing: Space.md,
                  runSpacing: Space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    FilledButton.tonalIcon(
                      onPressed: app.checkingUpdate
                          ? null
                          : () => app.checkForUpdates(),
                      icon: app.checkingUpdate
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(
                        app.checkingUpdate
                            ? 'Checking...'
                            : 'Check for updates',
                      ),
                    ),
                    if (app.availableUpdate == null &&
                        !app.checkingUpdate &&
                        app.updateError == null)
                      Text(
                        'You are up to date.',
                        style: context.text.bodySmall?.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Space.sm),
                Material(
                  type: MaterialType.transparency,
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: app.autoCheckUpdates,
                    onChanged: app.setAutoCheckUpdates,
                    title: Text(
                      'Check automatically at launch',
                      style: context.text.titleSmall,
                    ),
                    subtitle: Text(
                      'The update check is the only time the app uses the '
                      'internet: it asks GitHub for the newest public release and '
                      'sends nothing about you or your scores.',
                      style: context.text.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _Group(
              title: 'Quality assurance',
              children: <Widget>[
                Text(
                  'The app ships with synthetic learners that run through the real '
                  'scoring and coaching engines. Useful for spotting a regression in '
                  'scoring, eligibility or advice ordering.',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: Space.md),
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const QaLabScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.science_outlined, size: 16),
                  label: const Text('Open QA lab'),
                ),
              ],
            ),
            const SizedBox(height: Space.lg),
            _Group(
              title: 'About',
              children: <Widget>[
                Text(
                  'ASVAB Coach is an independent study tool. It is not affiliated '
                  'with the Department of Defense, the Army or the Army National '
                  'Guard, and it does not produce an official score.',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: Space.md),
                Text(
                  'Scoring model sources',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: Space.xs),
                Text(
                  'Segall, D. O. (2004), Development and Evaluation of the 1997 ASVAB '
                  'Score Scale, Defense Manpower Data Center: section 2.2 (standard '
                  'scores), 2.4 and Table 2.5 (AFQT), 2.5.3 and Table 2.7 (Army '
                  'composite weights), Table 2.2 (categories). ASVAB Technical '
                  'Bulletin No. 4, Table C.1. Official ASVAB programme fact sheets '
                  'for item counts and time limits.',
                  style: context.text.bodySmall?.copyWith(height: 1.6),
                ),
                const SizedBox(height: Space.md),
                Text(
                  'Aptitude requirements',
                  style: context.text.titleSmall?.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: Space.xs),
                Text(
                  'Transcribed from DA Pam 611-21, chapter 10, section C, and '
                  'last verified against it on '
                  '${MosRepository.rosterVerifiedAsOf}. That pamphlet is revised '
                  'regularly, and the Army re-issues single sections between '
                  'revisions, so confirm every requirement with a recruiter '
                  'before you sign anything.',
                  style: context.text.bodySmall?.copyWith(height: 1.6),
                ),
                const SizedBox(height: Space.md),
                _kv(
                  context,
                  'MOS roster verified',
                  MosRepository.rosterVerifiedAsOf,
                ),
                _kv(
                  context,
                  'Enlisted MOS carried',
                  '${MosRepository.enlistedCount}',
                ),
                _kv(
                  context,
                  'No aptitude gate',
                  '${MosRepository.noAptitudeRequirement.length}',
                ),
                _kv(
                  context,
                  'Not Guard jobs',
                  '${MosRepository.notGuardFielded.length}',
                ),
              ],
            ),
            const SizedBox(height: Space.xxl),
          ],
        ),
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 130,
            child: Text(
              k,
              style: context.text.bodySmall?.copyWith(color: c.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              v,
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

  String _export(AppState app) {
    final buffer = StringBuffer('{\n  "exportedAt": "')
      ..write(DateTime.now().toIso8601String())
      ..write('",\n  "attempts": [\n');
    for (var i = 0; i < app.attempts.length; i++) {
      final a = app.attempts[i];
      buffer
        ..write('    {"id":"')
        ..write(a.id)
        ..write('","kind":"')
        ..write(a.kind.name)
        ..write('","afqt":')
        ..write(a.report.afqtPercentile)
        ..write(',"gt":')
        ..write(a.report.gt)
        ..write(',"correct":')
        ..write(a.report.totalCorrect)
        ..write(',"answered":')
        ..write(a.report.totalAnswered)
        ..write(',"finishedAt":"')
        ..write(a.finishedAt.toIso8601String())
        ..write('"}')
        ..write(i == app.attempts.length - 1 ? '\n' : ',\n');
    }
    buffer.write('  ]\n}');
    return buffer.toString();
  }

  void _confirmReset(BuildContext context, AppState app) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Erase everything?'),
        content: const Text(
          'This deletes your goal and every attempt from this device. It cannot '
          'be undone.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await app.reset();
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                Navigator.of(dialogContext).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const SizedBox()),
                  (route) => false,
                );
              }
            },
            child: const Text('Erase'),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Eyebrow(title),
        const SizedBox(height: Space.sm),
        AppCard(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
