import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/question_bank.dart';
import 'package:asvab_guard_coach/data/models/exam.dart';
import 'package:asvab_guard_coach/data/models/question.dart';
import 'package:asvab_guard_coach/data/models/score.dart';
import 'package:asvab_guard_coach/screens/review_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/state/exam_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The review card must explain the options the candidate rejected.
///
/// It is easy to render the notes in bank order and look correct on a
/// screenshot while labelling the wrong letters, so this builds a non-identity
/// attempt permutation and checks that each note is painted against the option
/// the candidate saw it as, and that the line they picked is the one marked as
/// theirs.
///
/// Coordinate convention, read off the production code rather than guessed:
///
///  * the runner hands what the candidate tapped - a DISPLAY index - to
///    [ExamSession.answer] (lib/screens/exam_screen.dart);
///  * [ExamSession.answer] stores [ServedQuestion.toBankIndex] of that tap, and
///    lib/data/repos/serialization.dart states the rule outright:
///    [QuestionResponse.selectedIndex] is always in BANK coordinates, with the
///    permutation kept separately so an attempt replays as it was sat;
///  * the review screen resolves it back with 'order.indexOf(selected)' to know
///    which letter was chosen, so its failure notes are painted in DISPLAY
///    order.
///
/// Because the fixture below is produced by that same recording path - an
/// [ExamSession] answering a tapped slot, then 'toAttempt' - the test cannot be
/// wrong about the convention, which is exactly what went wrong when the
/// selection was hand-written as a display index.
void main() {
  testWidgets('review pairs each note with the option the candidate saw', (
    WidgetTester tester,
  ) async {
    final annotated = QuestionBank.all.where(
      (Question q) => q.choiceNotes.isNotEmpty && q.puzzle == null,
    );
    if (annotated.isEmpty) {
      markTestSkipped(
        'No annotated item yet: the notes are still being written.',
      );
      return;
    }
    final Question q = annotated.first;

    // A permutation that actually moves the options, so bank order and display
    // order cannot be confused for one another.
    const List<int> order = <int>[2, 0, 3, 1];
    final ServedQuestion served = ServedQuestion(base: q, order: order);
    final int keyedSlot = served.displayAnswerIndex;
    expect(
      keyedSlot,
      order.indexOf(q.answerIndex),
      reason:
          'the keyed option is served in the slot the permutation put it in',
    );
    expect(
      keyedSlot,
      isNot(q.answerIndex),
      reason:
          'with an identity permutation the two coordinate systems agree and '
          'this test would prove nothing',
    );

    // The candidate picks the option in the slot after the keyed one, so the
    // answer is a miss and the card belongs in the default Missed view.
    final int pickedSlot = (keyedSlot + 1) % 4;
    final int pickedBank = served.toBankIndex(pickedSlot);
    expect(pickedBank, isNot(q.answerIndex));

    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues(<String, Object>{});
    final AppState state = AppState();
    await state.init();

    // Record the answer the way the app does it.
    final Exam exam = Exam(
      id: 'notes-review-check',
      kind: ExamKind.section,
      title: q.subtest.label,
      sections: <ExamSection>[
        ExamSection(
          subtest: q.subtest,
          questions: <ServedQuestion>[served],
          minutes: 6,
        ),
      ],
    );
    final ExamSession session = ExamSession(exam: exam, seed: 11);
    session.answer(pickedSlot);
    expect(
      session.selectedFor(q.id),
      pickedBank,
      reason:
          'the runner passes a display index and the session stores bank '
          'coordinates: that conversion is the convention under test',
    );
    expect(
      session.selectedFor(q.id),
      isNot(pickedSlot),
      reason:
          'for a non-identity permutation the stored index is not the slot the '
          'candidate tapped',
    );

    final Attempt attempt = session.toAttempt(session.finish());
    expect(attempt.responses, hasLength(1));
    expect(attempt.responses.single.selectedIndex, pickedBank);
    await state.addAttempt(attempt, session.orders);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          theme: AppTheme.build(Brightness.light),
          home: ReviewScreen(attempt: attempt),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);

    final List<String> painted = <String>[
      for (final Text text in tester.widgetList<Text>(find.byType(Text)))
        text.data ?? '',
    ];

    // The attempt was a miss, so the card is rendered and says so. This is the
    // assertion that catches the card grading the answer in the wrong
    // coordinate system: with the bank index compared against the display slot
    // the item is silently filed as correct and never painted at all.
    expect(
      painted,
      contains('Missed'),
      reason: 'a wrong answer must not be reported as correct',
    );
    expect(painted, isNot(contains('Correct')));

    /// The line the card should print for one display slot.
    String lineForSlot(int slot) {
      final String note = q.choiceNotes[order[slot]].trim();
      return slot == pickedSlot ? '$note (your answer)' : note;
    }

    // 1. Every wrong option is explained, exactly once, beside its own letter.
    final List<String> expectedLines = <String>[];
    for (var slot = 0; slot < 4; slot++) {
      if (slot == keyedSlot) continue;
      final String line = lineForSlot(slot);
      expectedLines.add(line);
      expect(
        painted.where((String s) => s == line).length,
        1,
        reason:
            'Option ${String.fromCharCode(65 + slot)} carries the note for bank '
            'option ${order[slot]} (slot $pickedSlot picked bank $pickedBank)',
      );

      final Finder row = find
          .ancestor(of: find.text(line), matching: find.byType(Row))
          .first;
      final List<String> letters = tester
          .widgetList<Text>(
            find.descendant(of: row, matching: find.byType(Text)),
          )
          .map((Text t) => t.data ?? '')
          .toList();
      expect(
        letters.first,
        String.fromCharCode(65 + slot),
        reason:
            'the note for display slot ${String.fromCharCode(65 + slot)} is '
            'labelled ${letters.first}',
      );
    }

    // 2. Exactly one option is marked as the one the candidate picked, and it
    //    is that option's line, not the line of the bank index they tapped.
    final List<String> marked = painted
        .where((String s) => s.endsWith(' (your answer)'))
        .toList();
    expect(marked, hasLength(1), reason: 'one option is marked as the answer');
    expect(
      marked.single,
      startsWith(q.choiceNotes[pickedBank].trim()),
      reason: 'the marker must sit on the option the candidate picked',
    );
    expect(
      marked.single,
      lineForSlot(pickedSlot),
      reason: 'and it must be the slot that option was served in',
    );

    // 3. The keyed option belongs to the Why box, not to the failure list.
    final String keyedNote = q.choiceNotes[q.answerIndex].trim();
    expect(
      painted.where((String s) => s.startsWith(keyedNote)),
      isEmpty,
      reason: 'the correct option belongs to the Why box, not the failure list',
    );

    // 4. The notes are painted in display order. Bank order is a different
    //    order here, so a card that ignored the permutation fails this.
    final List<String> paintedNotes = <String>[
      for (final String s in painted)
        if (expectedLines.contains(s)) s,
    ];
    expect(
      paintedNotes,
      expectedLines,
      reason: 'the notes are painted out of the order the options were served',
    );
    final List<String> bankOrderNotes = <String>[
      for (var i = 0; i < 4; i++)
        if (i != q.answerIndex) q.choiceNotes[i].trim(),
    ];
    final List<String> displayNotes = <String>[
      for (final String s in expectedLines)
        s.endsWith(' (your answer)')
            ? s.substring(0, s.length - ' (your answer)'.length)
            : s,
    ];
    expect(
      displayNotes,
      isNot(bankOrderNotes),
      reason:
          'the permutation has to change the painted order, or this test is '
          'not exercising it',
    );
  });
}
