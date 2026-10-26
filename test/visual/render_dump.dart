// Manual visual verification harness. Not picked up by 'flutter test'
// because the filename does not end in _test.dart.
//
//   flutter test test/visual/render_dump.dart --update-goldens
//
// Writes PNG screenshots of the real screens, rendered by Skia with real
// fonts, into test/visual/goldens/. Those files are gitignored on purpose:
// text rasterisation differs between machines, so they are a local review
// tool rather than a CI assertion.
import 'dart:io';

import 'package:asvab_guard_coach/screens/onboarding_screen.dart';
import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/dashboard_screen.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/screens/plan_screen.dart';
import 'package:asvab_guard_coach/screens/progress_screen.dart';
import 'package:asvab_guard_coach/screens/results_screen.dart';
import 'package:asvab_guard_coach/screens/test_center_screen.dart';
import 'package:asvab_guard_coach/data/bank/auto_shop_tools.dart';
import 'package:asvab_guard_coach/data/bank/mechanical_figures.dart';
import 'package:asvab_guard_coach/data/bank/mechanical_figures_extra.dart';
import 'package:asvab_guard_coach/data/bank/shop_tool_sketches.dart';
import 'package:asvab_guard_coach/data/models/exam.dart';
import 'package:asvab_guard_coach/engines/exam_builder.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/sketch_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Registers the real Roboto face so screenshots show text instead of the
/// test harness block glyphs.
Future<void> _loadFonts() async {
  try {
    final exe = Platform.resolvedExecutable;
    final marker = exe.indexOf('bin');
    if (marker < 0) return;
    final cacheRoot = exe.substring(0, marker);
    final sep = Platform.pathSeparator;
    final base =
        '${cacheRoot}bin${sep}cache${sep}artifacts${sep}material_fonts$sep';
    final names = <String>[
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
      'MaterialIcons-Regular.otf',
    ];
    final loaded = <String>[];
    for (final name in names) {
      final file = File(base + name);
      if (!file.existsSync()) continue;
      final bytes = file.readAsBytesSync();
      final family = name.endsWith('.otf') ? 'MaterialIcons' : 'Roboto';
      final loader = FontLoader(family)
        ..addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
      await loader.load();
      loaded.add(name);
    }
    // ignore: avoid_print
    print('fonts loaded: ${loaded.join(', ')}');
  } catch (error) {
    // ignore: avoid_print
    print('font load skipped: $error');
  }
}

Future<AppState> _seededState(String personaId) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await state.setGoal(
    GoalProfile(
      displayName: 'Alex Rivera',
      targetAfqt: 65,
      targetGt: 110,
      targetMosCodes: const <String>['68W', '11B'],
      targetDate: DateTime.now().add(const Duration(days: 45)),
      officerTrack: true,
      dailyMinutes: 30,
    ),
  );
  final result = PersonaRunner.run(Personas.byId(personaId));
  await state.addAttempt(
    Attempt(
      id: 'visual-attempt',
      kind: ExamKind.fullMock,
      startedAt: DateTime.now().subtract(const Duration(minutes: 183)),
      finishedAt: DateTime.now().subtract(const Duration(minutes: 35)),
      report: result.report,
      responses: const <QuestionResponse>[],
      questionIds: const <String>[],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

Future<void> _shoot(
  WidgetTester tester,
  String name,
  Widget child, {
  Size size = const Size(1280, 1400),
  AppState? state,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  var resolved = state;
  if (resolved == null) {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    resolved = AppState();
    await resolved.init();
  }

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: resolved,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(Brightness.light),
        home: child,
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(milliseconds: 400));
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('dashboard', (tester) async {
    final state = await _seededState('jenna');
    await _shoot(
      tester,
      'dashboard',
      DashboardScreen(onNavigate: (_) {}),
      state: state,
      size: const Size(1280, 1500),
    );
  });

  // The same screen at the size it will actually be seen: a phone. The wide
  // shot above is for reviewing layout ideas; these are for judging it.
  testWidgets('dashboard_phone', (tester) async {
    final state = await _seededState('jenna');
    await _shoot(
      tester,
      'dashboard_phone',
      DashboardScreen(onNavigate: (_) {}),
      state: state,
      size: const Size(390, 1500),
    );
  });

  testWidgets('results_phone', (tester) async {
    final state = await _seededState('dana');
    await _shoot(
      tester,
      'results_phone',
      ResultsScreen(attempt: state.attempts.last),
      state: state,
      size: const Size(390, 2400),
    );
  });

  testWidgets('runner_phone', (tester) async {
    final state = await _seededState('jenna');
    await _shoot(
      tester,
      'runner_phone',
      ExamScreen(exam: ExamBuilder.section(Subtest.ar, seed: 8)),
      state: state,
      size: const Size(390, 844),
    );
  });

  testWidgets('jobs', (tester) async {
    final state = await _seededState('jenna');
    await _shoot(
      tester,
      'jobs',
      const JobsScreen(),
      state: state,
      size: const Size(1280, 1700),
    );
  });

  testWidgets('results', (tester) async {
    final state = await _seededState('dana');
    await _shoot(
      tester,
      'results',
      ResultsScreen(attempt: state.attempts.last),
      state: state,
      size: const Size(1280, 2200),
    );
  });

  testWidgets('plan', (tester) async {
    final state = await _seededState('marcus');
    await _shoot(
      tester,
      'plan',
      const PlanScreen(),
      state: state,
      size: const Size(1280, 1600),
    );
  });

  testWidgets('test_center', (tester) async {
    final state = await _seededState('jenna');
    await _shoot(
      tester,
      'test_center',
      const TestCenterScreen(),
      state: state,
      size: const Size(1280, 1700),
    );
  });

  testWidgets('progress', (tester) async {
    final state = await _seededState('ruiz');
    await _shoot(
      tester,
      'progress',
      const ProgressScreen(),
      state: state,
      size: const Size(1280, 1700),
    );
  });

  testWidgets('mc_figures', (tester) async {
    await _shoot(
      tester,
      'mc_figures',
      Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              for (final q in <Question>[
                ...mechanicalFigureBank,
                ...mechanicalFigureExtraBank,
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SketchView(figure: q.figure!),
                ),
            ],
          ),
        ),
      ),
      size: const Size(900, 1500),
    );
  });

  testWidgets('mc_figures_extra', (tester) async {
    await _shoot(
      tester,
      'mc_figures_extra',
      Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              for (final q in mechanicalFigureExtraBank)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SketchView(figure: q.figure!),
                ),
            ],
          ),
        ),
      ),
      size: const Size(900, 2400),
    );
  });

  testWidgets('shop_tools', (tester) async {
    await _shoot(
      tester,
      'shop_tools',
      Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              for (final sketch in shopToolSketches)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SketchView(figure: sketch),
                ),
            ],
          ),
        ),
      ),
      size: const Size(760, 2600),
    );
  });

  testWidgets('shop_tool_question', (tester) async {
    final tool = autoShopToolBank.firstWhere((q) => q.id == 'as-t03');
    final exam = Exam(
      id: 'visual-tool',
      kind: ExamKind.section,
      title: 'Auto & Shop Information',
      sections: <ExamSection>[
        ExamSection(
          subtest: Subtest.as,
          label: 'Shop Information',
          questions: <ServedQuestion>[ServedQuestion.identity(tool)],
          minutes: 6,
        ),
      ],
    );
    final state = await _seededState('sam');
    tester.view.physicalSize = const Size(1280, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(Brightness.light),
          home: ExamScreen(exam: exam),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Begin section'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/shop_tool_question.png'),
    );
  });

  testWidgets('onboarding', (tester) async {
    await _shoot(
      tester,
      'onboarding',
      const OnboardingScreen(),
      size: const Size(1280, 1000),
    );
  });
}
