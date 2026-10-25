import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/exam.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/screens/exam_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The test runner is the one screen a candidate cannot avoid, and it carries
/// the tallest content in the app: a reading passage, a diagram, or a grid of
/// assembly figures above four answer targets. These tests exist because the
/// question card once laid out a Spacer inside a scroll view, which Flutter
/// rejects outright, and nothing in the suite ever pumped the screen to notice.
Future<void> pumpExam(
  WidgetTester tester,
  Question question, {
  Size size = const Size(1280, 1100),
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

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: ExamScreen(exam: exam),
      ),
    ),
  );
  await tester.pump();
  await tester.tap(find.text('Begin section'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
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
      final tool = QuestionBank.byId('as-t06')!;
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
}
