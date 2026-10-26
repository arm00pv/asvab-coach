import 'dart:io';

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/dashboard_screen.dart';
import 'package:asvab_guard_coach/screens/glossary_screen.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/screens/lesson_screen.dart';
import 'package:asvab_guard_coach/screens/onboarding_screen.dart';
import 'package:asvab_guard_coach/screens/plan_screen.dart';
import 'package:asvab_guard_coach/screens/progress_screen.dart';
import 'package:asvab_guard_coach/screens/results_screen.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/screens/settings_screen.dart';
import 'package:asvab_guard_coach/screens/test_center_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// No screen may silently cut a label off.
///
/// A truncated label is not a cosmetic problem: "Vocabulary" becoming
/// "Vocabula…" is survivable, but a job title, an aptitude gate or a line score
/// that stops mid-word leaves the candidate guessing at the one number they came
/// for. This walks the render tree of every screen and reports any paragraph
/// that actually had to drop text, so the fix is a label that wraps or a layout
/// that gives it room - never an ellipsis nobody notices.
///
/// [didExceedMaxLines] is the precise signal: it is true only when the text was
/// laid out and something was dropped. A label with an ellipsis that happens to
/// fit is not an error and is not reported.
List<String> clippedText(WidgetTester tester) {
  final out = <String>[];
  for (final element in find.byType(RichText).evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph && object.didExceedMaxLines) {
      out.add(
        '${object.text.toPlainText()} [maxLines=${object.maxLines}, '
        'overflow=${object.overflow}, w=${object.size.width.toStringAsFixed(0)}]',
      );
    }
  }
  return out;
}

Future<AppState> seeded() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await state.setGoal(
    GoalProfile(
      displayName: 'Alex Rivera',
      targetAfqt: 65,
      targetGt: 110,
      targetMosCodes: const <String>['68W', '25U'],
      targetDate: DateTime.now().add(const Duration(days: 30)),
      officerTrack: true,
      dailyMinutes: 30,
    ),
  );
  final result = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'clip-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime.now().subtract(const Duration(minutes: 150)),
      finishedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      report: result.report,
      responses: <QuestionResponse>[
        for (final q in <Question>[
          QuestionBank.bySubtest(Subtest.pc).first,
          QuestionBank.bySubtest(Subtest.mc)
              .firstWhere((x) => x.figure != null),
          QuestionBank.bySubtest(Subtest.ao).first,
        ])
          QuestionResponse(
            questionId: q.id,
            selectedIndex: (q.answerIndex + 1) % q.choices.length,
            secondsSpent: 20,
          ),
      ],
      questionIds: <String>[
        QuestionBank.bySubtest(Subtest.pc).first.id,
        QuestionBank.bySubtest(Subtest.mc)
            .firstWhere((x) => x.figure != null)
            .id,
        QuestionBank.bySubtest(Subtest.ao).first.id,
      ],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required AppState state,
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: textScale == 1
            ? screen
            : Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: screen,
                ),
              ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

/// Registers the real Roboto face.
///
/// Without it the harness measures text in Ahem, where every glyph is a square
/// as wide as the font is tall - roughly twice real width - so the test would
/// report cuts no phone shows and miss the ones that only appear with real
/// metrics.
Future<void> loadRealFonts() async {
  final marker = Platform.resolvedExecutable.indexOf('bin');
  if (marker < 0) return;
  final sep = Platform.pathSeparator;
  final root = Platform.resolvedExecutable.substring(0, marker);
  final dir = '${root}bin${sep}cache${sep}artifacts${sep}material_fonts${sep}';
  for (final name in <String>[
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'MaterialIcons-Regular.otf',
  ]) {
    final file = File(dir + name);
    if (!file.existsSync()) continue;
    final family = name.endsWith('.otf') ? 'MaterialIcons' : 'Roboto';
    final loader = FontLoader(family)
      ..addFont(
        Future<ByteData>.value(ByteData.sublistView(file.readAsBytesSync())),
      );
    await loader.load();
  }
}

void main() {
  setUpAll(loadRealFonts);

  final screens = <String, Widget Function(AppState)>{
    'onboarding': (_) => const OnboardingScreen(),
    'dashboard': (_) => DashboardScreen(onNavigate: (_) {}),
    'jobs': (_) => const JobsScreen(),
    'plan': (_) => const PlanScreen(),
    'test centre': (_) => const TestCenterScreen(),
    'progress': (_) => const ProgressScreen(),
    'results': (s) => ResultsScreen(attempt: s.attempts.last),
    'review': (s) => ReviewScreen(attempt: s.attempts.last),
    'lesson': (_) => const LessonScreen(skillId: 'as.tools'),
    'settings': (_) => const SettingsScreen(),
    'glossary': (_) => const GlossaryScreen(),
    'runner': (_) => ExamScreen(exam: ExamBuilder.section(Subtest.ar, seed: 8)),
  };

  for (final size in <Size>[
    const Size(390, 844), // a current phone
    const Size(360, 640), // a cheap phone
    const Size(800, 1280), // a tablet
  ]) {
    group('no label is cut off at '
        '${size.width.toInt()}x${size.height.toInt()}', () {
      for (final entry in screens.entries) {
        testWidgets(entry.key, (tester) async {
          final state = await seeded();
          await pumpScreen(
            tester,
            entry.value(state),
            state: state,
            size: size,
          );
          expect(tester.takeException(), isNull);
          expect(
            clippedText(tester),
            isEmpty,
            reason:
                'these labels were cut off on the ${entry.key} screen: '
                '${clippedText(tester).join(" / ")}',
          );
        });
      }
    });
  }
}
