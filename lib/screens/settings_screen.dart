import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/routes.dart';
import '../core/speech.dart';
import '../core/tutor.dart';
import '../core/theme/tokens.dart';
import '../data/bank/question_bank.dart';
import '../data/repos/mos_repository.dart';
import '../engines/narration.dart';
import '../state/app_state.dart';
import '../widgets/listen_button.dart';
import '../widgets/primitives.dart';
import '../widgets/tutor_sheet.dart';
import 'qa_lab_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final speech = speechOf(context);
    final c = context.colors;
    final goal = app.goal;

    // One listenable for the page: the language shown in the row below, the
    // switch beside it and the script the speaker reads are three readings of
    // the same object and must never be a rebuild apart.
    return ListenableBuilder(
      listenable: speech,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: <Widget>[
            ListenButton(
              doc: Narration.settings(
                installedVersion: app.installedVersion,
                spokenLanguage: speech.localeLabel,
              ),
            ),
            const SizedBox(width: Space.sm),
          ],
        ),
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
                                Text(
                                  'Dark mode',
                                  style: context.text.titleSmall,
                                ),
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
              _SpokenGuideSection(speech: speech),
              const SizedBox(height: Space.lg),
              const _TutorSection(),
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
                                content: Text(
                                  'History copied to the clipboard.',
                                ),
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                  _kv(
                    context,
                    'Warrant occupations carried',
                    '${MosRepository.warrantCount}',
                  ),
                  const SizedBox(height: Space.md),
                  Text(
                    'The warrant officer occupations are transcribed from DA Pam '
                    '611-21 chapter 8 section B and verified on '
                    '${MosRepository.warrantVerifiedAsOf}. They are appointed '
                    'from the ranks, so they are listed separately from the '
                    'enlistment jobs and are never counted among them.',
                    style: context.text.bodySmall?.copyWith(height: 1.6),
                  ),
                ],
              ),
              const SizedBox(height: Space.xxl),
            ],
          ),
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

/// The spoken guide: the voice that reads a screen, how fast, and whether it
/// starts by itself.
///
/// Everything on this card is one reading of one object. The row that names the
/// language, the switch beside it and the script the speaker button reads are
/// all [SpeechService], so a change here is a change everywhere.
class _SpokenGuideSection extends StatelessWidget {
  const _SpokenGuideSection({required this.speech});

  final SpeechService speech;

  static const _speeds = <({double rate, String label})>[
    (rate: 0.8, label: 'Slower'),
    (rate: 1.0, label: 'Normal'),
    (rate: 1.2, label: 'Quicker'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasVoice = speech.voices.isNotEmpty;
    final sameLanguage = speech.voicesFor(writtenLanguages.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Eyebrow('Spoken study guide'),
        const SizedBox(height: Space.sm),
        AppCard(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Every screen has a speaker beside its title. Tap it to hear that '
                'screen explained in words, in the language you pick here.',
                style: context.text.bodySmall,
              ),
              const SizedBox(height: Space.md),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: hasVoice ? () => _pickVoice(context) : null,
                  borderRadius: BorderRadius.circular(Radii.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.sm),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.record_voice_over_outlined,
                          size: 19,
                          color: hasVoice ? c.primary : c.textMuted,
                        ),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Language and voice',
                                style: context.text.titleSmall,
                              ),
                              Text(
                                hasVoice
                                    ? speech.localeLabel
                                    : 'no voice installed on this device',
                                style: context.text.bodySmall?.copyWith(
                                  color: hasVoice ? c.textPrimary : c.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasVoice)
                          const Icon(Icons.chevron_right_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              if (sameLanguage.length > 1) ...<Widget>[
                const SizedBox(height: Space.xs),
                // Counted, not listed. Google's engine installs dozens of
                // English voices called things like "en-au-x-auc-local";
                // printing them turned this card into a wall of identifiers and
                // pushed the switch that matters off the screen. The sheet is
                // where a voice is chosen, one row per language and region.
                Text(
                  '${sameLanguage.length} English voices are installed on this '
                  'device. Tap the row above to choose which one reads to you.',
                  style: context.text.bodySmall?.copyWith(color: c.textMuted),
                ),
              ],
              const Divider(height: Space.xl),
              // Speed. Three stops, because a person choosing how fast an
              // explanation is read wants slower, as it is, or quicker - not a
              // slider to fine-tune.
              Text('Speaking speed', style: context.text.titleSmall),
              const SizedBox(height: Space.sm),
              Wrap(
                spacing: Space.md,
                runSpacing: Space.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  for (final speed in _speeds)
                    TextButton(
                      onPressed: hasVoice
                          ? () => speech.setRate(speed.rate)
                          : null,
                      child: Text(speed.label),
                    ),
                  OutlinedButton.icon(
                    onPressed: hasVoice ? () => speech.preview() : null,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Hear it'),
                  ),
                ],
              ),
              const Divider(height: Space.xl),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: hasVoice
                      ? () => speech.setAutoRead(!speech.autoRead)
                      : null,
                  borderRadius: BorderRadius.circular(Radii.sm),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Read each screen as it opens',
                              style: context.text.titleSmall,
                            ),
                            Text(
                              'Switched off, the guide waits for the speaker '
                              'button. Switched on, a screen starts talking as soon '
                              'as it is the one in front, hands free.',
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Space.md),
                      Switch.adaptive(
                        value: speech.autoRead,
                        onChanged: hasVoice ? speech.setAutoRead : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Space.md),
              Text(
                'The voice belongs to the phone, not to the app: no download, no '
                'connection needed, and nothing you listen to is recorded or sent '
                'anywhere. The words are written into the app itself rather than '
                'generated, so the guide can only say what the screen already says.',
                style: context.text.bodySmall?.copyWith(color: c.textMuted),
              ),
              if (speech.lastError != null) ...<Widget>[
                const SizedBox(height: Space.sm),
                Text(
                  speech.lastError!,
                  style: context.text.bodySmall?.copyWith(color: c.warning),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _pickVoice(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final written = writtenLanguages;
        // Only voices for languages the guide is actually written in. A voice
        // with nothing in its language to say is not a choice, it is a trap.
        final offered = speech.voices
            .where((v) => written.contains(v.language))
            .toList(growable: false);
        final others = speech.voices
            .where((v) => !written.contains(v.language))
            .toList(growable: false);
        // One row per language and region, not per engine voice: twelve rows
        // that all read "English" with a different machine name are not a choice
        // a person can make, and "English (Australia)" is.
        final byRegion = <String, List<SpeechVoice>>{};
        for (final voice in offered) {
          byRegion.putIfAbsent(voice.label, () => <SpeechVoice>[]).add(voice);
        }
        final regions = byRegion.keys.toList()..sort();
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.sm,
                    Space.lg,
                    Space.md,
                  ),
                  child: Text(
                    'Which voice reads to you',
                    style: context.text.titleMedium,
                  ),
                ),
                for (final region in regions)
                  Builder(
                    builder: (tileContext) {
                      final group = byRegion[region]!;
                      final local = group.where((v) => v.isLocal).toList();
                      final chosen = group.any(
                        (v) =>
                            v.locale.toLowerCase() ==
                            speech.locale.toLowerCase(),
                      );
                      return ListTile(
                        title: Text(region),
                        subtitle: Text(
                          local.isEmpty
                              ? 'needs a connection'
                              : 'on this device',
                        ),
                        trailing: chosen
                            ? const Icon(Icons.check_rounded)
                            : null,
                        onTap: () {
                          speech.setLanguage(group.first.locale);
                          Navigator.of(sheetContext).pop();
                        },
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.lg,
                    Space.md,
                    Space.lg,
                    Space.sm,
                  ),
                  child: Text(
                    others.isEmpty
                        ? 'The guide is written in English. Every language it is '
                              'written in will appear here, so a voice and the '
                              'words it reads always match.'
                        : 'This device also has ${others.length} voices in other '
                              'languages. They are not offered: reading English '
                              'words in the sounds of another language produces '
                              'noise, not an explanation.',
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The tutor: what it is, whether this device can run it, and the one download.
///
/// The download is the only time this app touches the network for anything
/// other than its own update, and the model is checked against a published
/// size and SHA-256 before it is allowed to load: a truncated model does not
/// fail loudly, it answers nonsense with confidence.
class _TutorSection extends StatelessWidget {
  const _TutorSection();

  @override
  Widget build(BuildContext context) {
    final tutor = tutorOf(context);
    return ListenableBuilder(
      listenable: tutor,
      builder: (context, _) {
        final c = context.colors;
        final status = tutor.status;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Eyebrow('AI tutor'),
            const SizedBox(height: Space.sm),
            AppCard(
              padding: const EdgeInsets.all(Space.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.auto_awesome_outlined,
                        size: 18,
                        color: status.installed ? c.primary : c.textMuted,
                      ),
                      const SizedBox(width: Space.sm),
                      Expanded(
                        child: Text(
                          status.installed ? 'On this device' : 'Not installed',
                          style: context.text.titleSmall,
                        ),
                      ),
                      Pill(
                        status.installed ? 'Ready' : 'Optional',
                        tone: status.installed
                            ? PillTone.primary
                            : PillTone.neutral,
                        dense: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.sm),
                  if (!status.supported) ...<Widget>[
                    Text(
                      'This build cannot run the tutor. It needs an arm64 '
                      'Android phone: this device reports ${status.abi}, and the '
                      'engine library is only packaged for arm64.',
                      style: context.text.bodySmall?.copyWith(height: 1.5),
                    ),
                    if (status.error != null) ...<Widget>[
                      const SizedBox(height: Space.xs),
                      Text(
                        status.error!,
                        style: context.text.bodySmall?.copyWith(
                          color: c.warning,
                        ),
                      ),
                    ],
                  ] else ...<Widget>[
                    Text(
                      _description(status),
                      style: context.text.bodySmall?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: Space.md),
                    _controls(context, tutor),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _description(TutorStatus status) {
    if (status.installed) {
      return 'LFM3-Omni runs on this phone: 2.17 billion parameters, kept in '
          'the app\'s own storage, loaded into memory when you ask a question. '
          '“Explain another way” appears under every answer in Review. It '
          'works with the phone in aeroplane mode - nothing is sent anywhere, '
          'ever.';
    }
    return 'A 2.17 billion parameter model that works a question through with '
        'you, in your own words, on the phone itself. It is a '
        '${status.sizeLabel} download, done once over Wi-Fi, and after that it '
        'runs with no connection at all.';
  }

  Widget _controls(BuildContext context, TutorService tutor) {
    final c = context.colors;
    final status = tutor.status;
    if (status.downloading || tutor.downloading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: tutor.downloadProgress == 0
                  ? null
                  : tutor.downloadProgress,
              minHeight: 4,
              backgroundColor: c.surfaceSunken,
              color: c.primary,
            ),
          ),
          const SizedBox(height: Space.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Downloading ${_percent(tutor.downloadProgress)} - keep the '
                  'app open until it finishes.',
                  style: context.text.bodySmall?.copyWith(color: c.textMuted),
                ),
              ),
              TextButton(
                onPressed: tutor.cancelInstall,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      );
    }
    if (status.installed) {
      return Wrap(
        spacing: Space.md,
        runSpacing: Space.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          // The number that decides whether the tutor feels usable is measured
          // here, on this phone, rather than quoted from a laptop.
          FilledButton.tonalIcon(
            onPressed: tutor.generating
                ? null
                : () => _benchmark(context, tutor),
            icon: tutor.generating
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.speed_rounded, size: 16),
            label: Text(tutor.generating ? 'Measuring...' : 'Benchmark it'),
          ),
          OutlinedButton.icon(
            onPressed: () => _confirmRemove(context, tutor),
            icon: const Icon(Icons.delete_outline_rounded, size: 16),
            label: const Text('Remove the model'),
          ),
          Text(
            '${(status.bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB on '
            'this device',
            style: context.text.bodySmall?.copyWith(color: c.textMuted),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FilledButton.tonalIcon(
          onPressed: tutor.install,
          icon: const Icon(Icons.download_rounded, size: 16),
          label: Text('Download the tutor (${status.sizeLabel})'),
        ),
        if (tutor.error != null) ...<Widget>[
          const SizedBox(height: Space.sm),
          Text(
            tutor.error!,
            style: context.text.bodySmall?.copyWith(color: c.warning),
          ),
        ],
      ],
    );
  }

  /// One fixed question, timed on this device, so the settings page can report
  /// what the phone actually does instead of what a benchmark from somewhere
  /// else claims.
  Future<void> _benchmark(BuildContext context, TutorService tutor) async {
    await tutor.ask(
      '<|im_start|>system\nYou are an ASVAB study coach.\n<|im_end|>\n'
      '<|im_start|>user\nIn two short sentences, explain why multiplying two '
      'negative numbers gives a positive one.\n<|im_end|>\n'
      '<|im_start|>assistant',
      maxTokens: 120,
    );
    if (!context.mounted) return;
    final speed = tutor.tokensPerSecond;
    final millis = tutor.lastMillis;
    final tokens = tutor.lastTokens;
    final load = tutor.lastLoadMillis;
    final message = speed == null || millis == null
        ? 'The tutor did not finish. ${tutor.error ?? ''}'
        : '${tokens ?? 0} tokens in ${(millis / 1000).toStringAsFixed(1)} s '
              '(${speed.toStringAsFixed(1)} tokens/s)'
              '${load == null ? '' : ', loaded in ${(load / 1000).toStringAsFixed(1)} s'}';
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _percent(double value) =>
      '${(value * 100).clamp(0, 100).toStringAsFixed(0)} percent';

  void _confirmRemove(BuildContext context, TutorService tutor) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove the tutor?'),
        content: const Text(
          'The model file is deleted from this device. Your history, your plan '
          'and the spoken guide are untouched, and you can download it again.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () {
              tutor.remove();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
