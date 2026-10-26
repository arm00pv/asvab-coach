import 'dart:io';

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/dashboard_screen.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/screens/plan_screen.dart';
import 'package:asvab_guard_coach/screens/progress_screen.dart';
import 'package:asvab_guard_coach/screens/results_screen.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/screens/test_center_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A UX audit driven by the seven synthetic learners.
///
/// The persona suite already proves the engines are right for a weak candidate,
/// a strong one, a guesser, an officer candidate and so on. This walks the
/// screens each of them actually sees, measures what a hand would have to hit and
/// what an eye would have to read, and prints one row per persona and screen.
///
/// It fails on the two things that are never acceptable - a layout exception and
/// a label cut off mid-word - and reports target and type sizes so a regression
/// in them is visible rather than felt. Only genuinely unusable controls (under
/// 24 dp) fail the run, because inventing a stricter bar would fail the app for
/// being dense rather than broken.
Future<void> loadRealFonts() async {
  final marker = Platform.resolvedExecutable.indexOf('bin');
  if (marker < 0) return;
  final sep = Platform.pathSeparator;
  final root = Platform.resolvedExecutable.substring(0, marker);
  final dir = '${root}bin${sep}cache${sep}artifacts${sep}material_fonts$sep';
  for (final name in <String>[
    'Roboto-Regular.ttf',
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

/// Every tappable thing and its painted size, in logical pixels.
List<Size> tapTargets(WidgetTester tester) {
  final out = <Size>[];
  for (final type in <Type>[
    InkWell,
    IconButton,
    TextButton,
    FilledButton,
    OutlinedButton,
    ListTile,
  ]) {
    for (final element in find.byType(type).evaluate()) {
      final box = element.renderObject;
      if (box is RenderBox && box.hasSize) out.add(box.size);
    }
  }
  return out;
}

double smallestText(WidgetTester tester) {
  var smallest = 99.0;
  for (final element in find.byType(RichText).evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph &&
        object.text.toPlainText().trim().isNotEmpty) {
      final size = object.text.style?.fontSize;
      if (size != null && size < smallest) smallest = size;
    }
  }
  return smallest;
}

List<String> clipped(WidgetTester tester) {
  final out = <String>[];
  for (final element in find.byType(RichText).evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph && object.didExceedMaxLines) {
      out.add(object.text.toPlainText());
    }
  }
  return out;
}

Future<AppState> seeded(PersonaResult run) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await state.setGoal(
    GoalProfile(
      displayName: 'Audit',
      targetAfqt: 60,
      targetGt: 110,
      targetMosCodes: const <String>['68W'],
      targetDate: DateTime.now().add(const Duration(days: 45)),
      officerTrack: false,
      dailyMinutes: 30,
    ),
  );
  await state.addAttempt(
    Attempt(
      id: 'audit-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime.now().subtract(const Duration(minutes: 120)),
      finishedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      report: run.report,
      responses: <QuestionResponse>[],
      questionIds: const <String>[],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

void main() {
  setUpAll(loadRealFonts);

  testWidgets('seven personas, every screen, one audit table', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final report = StringBuffer()
      ..writeln('persona            screen        targets  min  text  issues');
    var failures = 0;

    for (final persona in Personas.all) {
      final run = PersonaRunner.run(persona);
      final state = await seeded(run);
      final screens = <String, Widget>{
        'dashboard': DashboardScreen(onNavigate: (_) {}),
        'jobs': const JobsScreen(),
        'test centre': const TestCenterScreen(),
        'results': ResultsScreen(attempt: state.attempts.last),
        'review': ReviewScreen(attempt: state.attempts.last),
        'progress': const ProgressScreen(),
        'plan': const PlanScreen(),
      };

      for (final entry in screens.entries) {
        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: state,
            child: MaterialApp(
              theme: AppTheme.build(Brightness.light),
              home: entry.value,
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        final exception = tester.takeException();
        final targets = tapTargets(tester);
        final smallestTarget = targets.isEmpty
            ? 0.0
            : targets
                  .map((s) => s.width < s.height ? s.width : s.height)
                  .reduce((a, b) => a < b ? a : b);
        final tooSmall = targets
            .where((s) => s.width < 24 || s.height < 24)
            .length;
        final text = smallestText(tester);
        final cut = clipped(tester);

        final issues = <String>[];
        if (exception != null) issues.add('exception');
        if (cut.isNotEmpty) issues.add('clipped: ${cut.take(2).join(" / ")}');
        if (tooSmall > 0) issues.add('$tooSmall target(s) under 24dp');
        if (issues.isNotEmpty) failures++;

        report.writeln(
          '${persona.id.padRight(18)} ${entry.key.padRight(13)} '
          '${targets.length.toString().padLeft(7)}  '
          '${smallestTarget.toStringAsFixed(0).padLeft(3)}  '
          '${text.toStringAsFixed(0).padLeft(4)}  ${issues.join("; ")}',
        );
      }
    }

    // ignore: avoid_print
    print('\nUX AUDIT\n${report.toString()}');

    expect(
      failures,
      0,
      reason: 'the audit table above names the screen and the problem',
    );
  });
}
