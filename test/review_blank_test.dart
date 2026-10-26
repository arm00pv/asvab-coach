import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/engines/personas.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A blank is not a wrong answer.
///
/// The review card used to badge both the same way - "Missed" beside a red
/// cross - which told a candidate who ran out of time that they had chosen an
/// option and been marked down for it. Both are worth nothing, but only one of
/// them is a choice, and the card has exactly one place to say which happened.
///
/// The fixture holds all three states side by side so the difference has to be
/// visible in one render: an item answered wrongly, an item answered with
/// nothing (the runner recorded a response with no selection), and an item the
/// candidate never reached at all (no response object).
Future<AppState> seededReview() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();

  final annotated = QuestionBank.bySubtest(Subtest.wk)
      .where((q) => q.puzzle == null && q.noteFor(q.answerIndex) != null)
      .toList();
  expect(
    annotated.length,
    greaterThanOrEqualTo(3),
    reason: 'the fixture needs three annotated word knowledge items',
  );
  final wrong = annotated[0];
  final answeredNothing = annotated[1];
  final neverReached = annotated[2];

  // A wrong option that carries a note, so the card has a line to mark as the
  // candidate's own.
  final pickedBank = <int>[
    for (var i = 0; i < wrong.choices.length; i++)
      if (i != wrong.answerIndex && wrong.noteFor(i) != null) i,
  ].first;

  final result = PersonaRunner.run(Personas.byId('jenna'));
  await state.addAttempt(
    Attempt(
      id: 'blank-review',
      kind: ExamKind.fullMock,
      startedAt: DateTime(2026, 4, 1, 9),
      finishedAt: DateTime(2026, 4, 1, 12),
      report: result.report,
      responses: <QuestionResponse>[
        QuestionResponse(
          questionId: wrong.id,
          selectedIndex: pickedBank,
          secondsSpent: 22,
        ),
        // Skipped: the runner still writes a response, with nothing selected.
        QuestionResponse(
          questionId: answeredNothing.id,
          selectedIndex: null,
          secondsSpent: 0,
        ),
      ],
      questionIds: <String>[wrong.id, answeredNothing.id, neverReached.id],
      subtests: Subtest.administrationOrder,
    ),
    const <String, List<int>>{},
  );
  return state;
}

Future<void> pumpReview(
  WidgetTester tester,
  AppState state, {
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
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: ReviewScreen(attempt: state.attempts.last),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

/// The card that carries [badge], found through the badge it paints.
Finder cardWith(WidgetTester tester, Finder badge) =>
    find.ancestor(of: badge, matching: find.byType(AppCard)).first;

void main() {
  testWidgets('a blank item says it was left blank, not that it was missed', (
    tester,
  ) async {
    final state = await seededReview();
    await pumpReview(tester, state);
    expect(tester.takeException(), isNull);

    // Two blanks - one skipped, one never reached - and one real wrong answer.
    expect(
      find.text('Left blank'),
      findsNWidgets(2),
      reason: 'a blank item needs its own badge, not the wrong-answer one',
    );
    expect(find.text('Missed'), findsOneWidget);
    expect(find.text('Correct'), findsNothing);

    // The wrong answer keeps the vocabulary and the marker it always had.
    final missedCard = cardWith(tester, find.text('Missed'));
    expect(
      find.descendant(
        of: missedCard,
        matching: find.textContaining('(your answer)'),
      ),
      findsOneWidget,
      reason: 'the option they picked is still marked as theirs',
    );

    // A blank claims no option. Nothing on that card may say "your answer".
    for (final badge in <String>['Left blank']) {
      final blanks = find.text(badge);
      for (var i = 0; i < tester.widgetList(blanks).length; i++) {
        final card = cardWith(tester, blanks.at(i));
        expect(
          find.descendant(
            of: card,
            matching: find.textContaining('(your answer)'),
          ),
          findsNothing,
          reason: 'a blank item must not claim the candidate chose an option',
        );
      }
    }

    // Everything else about the card is unchanged: the notes for the options
    // they did not choose, and the keyed answer, both still there.
    final blankCard = cardWith(tester, find.text('Left blank').first);
    expect(
      find.descendant(
        of: blankCard,
        matching: find.text('Why the others fail'),
      ),
      findsOneWidget,
      reason: 'the per-option notes are the point of the card and must stay',
    );

    final questions = <Question>[
      for (final id in state.attempts.last.questionIds)
        QuestionBank.byId(id) ?? QuestionBank.bySubtest(Subtest.wk).first,
    ];
    final skipped = questions[1];
    expect(
      find.descendant(
        of: blankCard,
        matching: find.text(skipped.correctChoice),
      ),
      findsAtLeastNWidgets(1),
      reason: 'the keyed answer is still shown on a blank item',
    );
  });

  testWidgets('the blank badge holds up on a cheap phone at 2x text', (
    tester,
  ) async {
    // "Left blank" is wider than "Missed" before the system font is doubled,
    // and it carries an icon, so the narrowest phone at the largest text is
    // where it has to prove it fits.
    final state = await seededReview();
    await pumpReview(tester, state, size: const Size(360, 640), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('Left blank'), findsNWidgets(2));
  });
}
