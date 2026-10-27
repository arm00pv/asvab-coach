import 'dart:io';

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/exam.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The test runner is the one screen a candidate cannot avoid, and it carries
/// the tallest content in the app: a reading passage, a diagram, or a grid of
/// assembly figures above four answer targets. These tests exist because the
/// question card once laid out a Spacer inside a scroll view, which Flutter
/// rejects outright, and nothing in the suite ever pumped the screen to notice.
///
/// The second group is the fix for the dead band above the pinned bar. On a
/// 360x800 phone a one-line stem and four short options used to leave 333 of
/// the screen's 800 dp blank between the last option and the action bar - 42%,
/// close to the two-fifths the audit measured. Nothing in the suite measured
/// that, so nothing stopped it from coming back.
Future<void> loadRealFonts() async {
  final marker = Platform.resolvedExecutable.indexOf('bin');
  if (marker < 0) return;
  final sep = Platform.pathSeparator;
  final root = Platform.resolvedExecutable.substring(0, marker);
  final dir = '${root}bin${sep}cache${sep}artifacts${sep}material_fonts$sep';
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

Future<void> pumpExam(
  WidgetTester tester,
  Question question, {
  Size size = const Size(1280, 1100),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();

  final exam = Exam(
    id: 'layout-${question.id}',
    kind: ExamKind.section,
    title: question.subtest.label,
    sections: <ExamSection>[
      ExamSection(
        subtest: question.subtest,
        questions: <ServedQuestion>[ServedQuestion.identity(question)],
        minutes: 6,
      ),
    ],
  );

  // A key per pump: two pumps in one test would otherwise reuse the screen's
  // State, which is already past the section introduction.
  final screen = ExamScreen(
    key: ValueKey<String>(
      'exam-${question.id}-${size.width}x${size.height}-$textScale',
    ),
    exam: exam,
  );
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
  // The introduction scrolls when a small phone also has enlarged text, so the
  // begin action can start below the fold.
  final begin = find.text('Begin section');
  await tester.ensureVisible(begin);
  await tester.pump();
  await tester.tap(begin);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

/// The painted box of the answer target carrying [text].
///
/// The tile itself is private to the screen, so it is reached through the text
/// it holds: the nearest [InkWell] above a choice is that choice's target.
Rect optionRect(WidgetTester tester, String text) => tester.getRect(
  find.ancestor(of: find.text(text), matching: find.byType(InkWell)).first,
);

/// The top of the pinned action bar, which is the progress strip that opens it.
double barTop(WidgetTester tester) =>
    tester.getRect(find.byType(LinearProgressIndicator).first).top;

/// Blank vertical space between the last option and the pinned action bar.
double emptyGap(WidgetTester tester, Question question) =>
    barTop(tester) - optionRect(tester, question.choices.last).bottom;

/// Blank vertical space below the last thing the item itself put on screen.
///
/// The "Clear answer" control sits in the item's flow now, under the options,
/// so this is the real hole: the band between the item and the action bar.
double emptyBand(WidgetTester tester) =>
    barTop(tester) -
    tester
        .getRect(
          find
              .ancestor(
                of: find.text('Clear answer'),
                matching: find.byType(TextButton),
              )
              .first,
        )
        .bottom;

/// The bank's shortest item: no passage, drawing or puzzle, four short
/// options. It is the worst case for empty space, because it is the item that
/// puts the least on screen.
Question get shortestItem => QuestionBank.all
    .where(
      (q) =>
          q.passage == null &&
          q.figure == null &&
          q.puzzle == null &&
          q.choices.every((c) => c.length <= 24) &&
          q.choices.toSet().length == q.choices.length,
    )
    .reduce((a, b) => a.stem.length <= b.stem.length ? a : b);

void main() {
  // Real metrics, because the harness font measures every glyph as a square:
  // with it, options wrap onto lines no phone shows, the item looks taller than
  // it is, and a gap measurement would be flattered.
  setUpAll(loadRealFonts);

  group('the question card lays out', () {
    testWidgets('with a reading passage', (tester) async {
      final pc = QuestionBank.bySubtest(Subtest.pc).first;
      await pumpExam(tester, pc);
      expect(tester.takeException(), isNull);
      expect(find.text(pc.stem), findsOneWidget);
      expect(find.text(pc.choices.first), findsOneWidget);
    });

    testWidgets('with a shop tool drawing', (tester) async {
      final tool = QuestionBank.byId('as-t03')!;
      await pumpExam(tester, tool);
      expect(tester.takeException(), isNull);
      expect(find.text(tool.stem), findsOneWidget);
      for (final choice in tool.choices) {
        expect(find.text(choice), findsOneWidget);
      }
    });

    testWidgets('with an assembly puzzle', (tester) async {
      final ao = QuestionBank.bySubtest(Subtest.ao).first;
      await pumpExam(tester, ao);
      expect(tester.takeException(), isNull);
      for (final label in <String>['A', 'B', 'C', 'D']) {
        expect(find.text(label), findsWidgets);
      }
    });

    testWidgets('on a phone, and the options are still reachable', (
      tester,
    ) async {
      final tool = QuestionBank.byId('as-t03')!;
      await pumpExam(tester, tool, size: const Size(390, 760));
      expect(tester.takeException(), isNull);
      // The question scrolls; the answer targets must exist in the tree even
      // when they start below the fold.
      expect(find.text(tool.choices.last), findsOneWidget);
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -260),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('answering records the response', (tester) async {
      final tool = QuestionBank.byId('as-t01')!;
      await pumpExam(tester, tool);
      await tester.tap(find.text(tool.choices[1]));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('Clear answer'), findsOneWidget);
    });
  });

  // The audit finding this group exists for: "roughly the bottom 38% of every
  // question screen is empty". The space belongs to the item - taller answer
  // targets, even gaps between them, and the answer controls in the flow - not
  // to a band above the bar.
  group('the space between the last option and the pinned bar is spent', () {
    testWidgets('a short item on a 360x800 phone leaves under a third blank', (
      tester,
    ) async {
      final q = shortestItem;
      await pumpExam(tester, q, size: const Size(360, 800));
      expect(tester.takeException(), isNull);

      final gap = emptyGap(tester, q);
      expect(
        gap,
        lessThan(800 / 3),
        reason:
            'the band between the last option and the action bar is '
            '${gap.toStringAsFixed(0)} dp of 800 - it was 333 dp before the '
            'options were given room',
      );
      expect(
        gap,
        greaterThanOrEqualTo(0),
        reason: 'the last option is hidden behind the pinned bar',
      );

      // And the band under the item's own controls - "Clear answer" now sits in
      // the flow - is not a hole either.
      final band = emptyBand(tester);
      expect(
        band,
        lessThan(800 / 3),
        reason:
            'the band between the item and the action bar is '
            '${band.toStringAsFixed(0)} dp of 800',
      );

      // The space was spent on the item: every option is a full-size target,
      // and they are evenly spaced rather than stacked tight.
      final first = optionRect(tester, q.choices.first);
      final second = optionRect(tester, q.choices[1]);
      expect(
        first.height,
        greaterThanOrEqualTo(72),
        reason: 'an answer target shrank to ${first.height} dp',
      );
      expect(
        second.top - first.bottom,
        closeTo(optionRect(tester, q.choices[2]).top - second.bottom, 0.5),
        reason: 'the gaps between options are not even',
      );
    });

    testWidgets('a short option does not stretch to fill the box', (
      tester,
    ) async {
      // The fix must not answer the audit by inflating a one-word option: a
      // short option and a long one are the same height on the same screen, and
      // a taller screen does not stretch either of them.
      final q = shortestItem;
      await pumpExam(tester, q, size: const Size(360, 800));
      final onPhone = optionRect(tester, q.choices.first).height;
      await pumpExam(tester, q, size: const Size(360, 1200));
      final onTall = optionRect(tester, q.choices.first).height;
      expect(tester.takeException(), isNull);
      expect(
        onTall,
        onPhone,
        reason:
            'the option grew from $onPhone dp to $onTall dp on a taller '
            'screen, which is the padding problem the audit named',
      );
    });

    testWidgets('a tall screen with a short item still passes', (tester) async {
      // A 1200 dp column cannot be filled by four short options without
      // stretching them, and stretching them is the thing this fix refuses to
      // do. What a tall screen must still do is lay the item out, keep the
      // controls in the flow under the options, and keep the bar pinned.
      final q = shortestItem;
      await pumpExam(tester, q, size: const Size(360, 1200));
      expect(tester.takeException(), isNull);
      expect(find.text(q.stem), findsOneWidget);
      for (final choice in q.choices) {
        expect(find.text(choice), findsOneWidget);
      }
      expect(find.text('Clear answer'), findsOneWidget);
      expect(
        barTop(tester),
        greaterThan(1200 - 120),
        reason: 'the action bar is not pinned to the bottom of a tall screen',
      );
    });

    testWidgets('a long item leaves no band at all', (tester) async {
      final pc = QuestionBank.bySubtest(Subtest.pc).first;
      await pumpExam(tester, pc, size: const Size(360, 800));
      expect(tester.takeException(), isNull);
      // At rest the item already runs past the bar: there is no band.
      expect(emptyGap(tester, pc), lessThan(800 / 3));

      // Scrolled to the end, the tail of the item sits just under the bar.
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -900),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        emptyGap(tester, pc),
        lessThan(800 / 3),
        reason: 'a band opened up at the end of a long item',
      );
    });

    testWidgets('and the bar is still there, with its controls', (
      tester,
    ) async {
      // The band was spent on the item; the action bar was not traded away for
      // it. It keeps its progress strip, its navigator and its primary action,
      // and it stays pinned to the bottom of the screen.
      final q = shortestItem;
      await pumpExam(tester, q, size: const Size(360, 800));
      final bar = tester.getRect(find.byType(LinearProgressIndicator).first);
      expect(
        bar.top,
        greaterThan(800 - 120),
        reason: 'the action bar left the bottom of the screen',
      );
      expect(find.byTooltip('Already at the first question'), findsOneWidget);
      expect(find.byTooltip('Flag for review'), findsOneWidget);
      expect(find.text('Submit exam'), findsOneWidget);
    });
  });

  // The two hard conditions: the cheapest handset this app supports, held
  // either way, with the largest text Android offers. A 360 dp wide footer with
  // 2x labels overflowed its row by 11 pixels before this group existed.
  group('the runner fits a small phone', () {
    for (final entry in <String, Size>{
      'portrait': const Size(360, 640),
      'landscape': const Size(640, 360),
    }.entries) {
      testWidgets('${entry.key} at 2x text', (tester) async {
        final q = shortestItem;
        await pumpExam(tester, q, size: entry.value, textScale: 2);
        expect(tester.takeException(), isNull);
        expect(find.text(q.stem), findsOneWidget);
        expect(find.text('Clear answer'), findsOneWidget);
      });

      testWidgets('${entry.key} at 1x text with a long item', (tester) async {
        final pc = QuestionBank.bySubtest(Subtest.pc).first;
        await pumpExam(tester, pc, size: entry.value);
        expect(tester.takeException(), isNull);
        expect(find.text(pc.stem), findsOneWidget);
      });
    }
  });
}
