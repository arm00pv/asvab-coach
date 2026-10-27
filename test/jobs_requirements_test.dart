import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The enlistment requirements block, read on a phone.
///
/// The phone audit (docs/PHONE_AUDIT.md, M6) found the block keeping a
/// three-column desktop table at 411 dp: the explanation column was ~40% wide,
/// so every sentence wrapped to four or five lines while the label column
/// idled, and on the *Computer test* row the value "Answer everything" filled
/// its 108 dp column exactly and ran straight into the explanation with no
/// gutter - one run-on string, "Answer everything On the CAT-ASVAB a blank
/// item...".
///
/// So what is asserted here is not the wording but the shape: on a phone every
/// requirement is its own block, the explanation sits *under* its own value
/// rather than beside the next column, and no single text run ever holds a
/// value and its explanation together. The worst case this codebase keeps
/// rediscovering is the cheap handset with the largest font Android offers, so
/// 360x800 at 2x text is one of the two viewports under test.
///
/// Every requirement as the card prints it: label, value, explanation. Written
/// out here rather than read back off the screen, so a value silently losing
/// its own sentence is a failing test and not a passing one.
const List<(String, String, String)> requirements = <(String, String, String)>[
  (
    'Minimum AFQT',
    '31',
    'Category IIIB. The lowest accepted test score category in AR 601-210.',
  ),
  (
    'Age',
    '17 to 42',
    'Non-prior service. Older applicants need an age waiver.',
  ),
  (
    'Officer gate',
    'GT 110',
    'OCS, warrant officer and WOFT. Explicitly not waiverable for WOCS.',
  ),
  (
    'Score waivers',
    'None',
    'There is no score waiver. Only a retest after the waiting period.',
  ),
  (
    'Retest spacing',
    '30 / 30 / 180 days',
    'Then every six months. A Cat IV retest may need an AFQT gain of 20 points.',
  ),
  (
    'Computer test',
    'Answer everything',
    'On the CAT-ASVAB a blank item scores as though you guessed at random.',
  ),
];

/// The two runs of the row the audit caught.
const String computerValue = 'Answer everything';
const String computerExplanation =
    'On the CAT-ASVAB a blank item scores as though you guessed at random.';

Future<AppState> emptyState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  return state;
}

/// Pumps the jobs screen at one viewport and one system text size.
///
/// The requirements block is rendered whether or not an attempt exists - it is
/// the floor every candidate reads before any job matters - so the screen is
/// pumped without one.
Future<void> pumpJobs(
  WidgetTester tester, {
  required Size size,
  required double textScale,
}) async {
  final state = await emptyState();
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
            child: const JobsScreen(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

/// The card holding the requirements, so a value that also appears elsewhere
/// - "GT 110" is on every officer route's pill - is not counted twice.
Finder requirementsCard() => find.ancestor(
  of: find.text('Enlistment requirements'),
  matching: find.byType(AppCard),
);

/// The rectangle one run of text occupies. [RenderParagraph] sizes itself to
/// its longest line, so this is the text's own box and not the column it sits
/// in.
Rect rectOf(WidgetTester tester, Finder card, String text) =>
    tester.getRect(find.descendant(of: card, matching: find.text(text)));

/// Any paragraph inside the card that had to drop text.
List<String> clippedText(WidgetTester tester, Finder card) {
  final out = <String>[];
  final paragraphs = find.descendant(of: card, matching: find.byType(RichText));
  for (final element in paragraphs.evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph && object.didExceedMaxLines) {
      out.add(object.text.toPlainText());
    }
  }
  return out;
}

/// Every label, value and explanation is on screen, as its own text run.
void expectEveryRequirementPresent(WidgetTester tester, Finder card) {
  expect(card, findsOneWidget);
  for (final requirement in requirements) {
    expect(
      find.descendant(of: card, matching: find.text(requirement.$1)),
      findsOneWidget,
      reason: 'the label "${requirement.$1}" is not on the card',
    );
    expect(
      find.descendant(of: card, matching: find.text(requirement.$2)),
      findsOneWidget,
      reason: 'the value "${requirement.$2}" is not a run of its own',
    );
    expect(
      find.descendant(of: card, matching: find.text(requirement.$3)),
      findsOneWidget,
      reason: 'the explanation for "${requirement.$1}" is not a run of its own',
    );
    expect(
      find.descendant(
        of: card,
        matching: find.textContaining('${requirement.$2} ${requirement.$3}'),
      ),
      findsNothing,
      reason:
          'the value "${requirement.$2}" and its explanation are one '
          'concatenated string',
    );
  }
}

void main() {
  group('the enlistment requirements block', () {
    testWidgets('lays out on the cheapest handset at 2x text', (tester) async {
      // 360 dp at 2x is the combination that has caught five other defects in
      // this app; nothing here may paint an overflow stripe.
      await pumpJobs(tester, size: const Size(360, 800), textScale: 2);
      expect(tester.takeException(), isNull);
      final card = requirementsCard();
      expectEveryRequirementPresent(tester, card);
      expect(
        clippedText(tester, card),
        isEmpty,
        reason:
            'the requirements card cut text off at 360 dp with 2x text: '
            '${clippedText(tester, card).join(" / ")}',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('lays out on the audited phone at 411 dp', (tester) async {
      // The viewport the audit was taken on, where the table was three columns.
      await pumpJobs(tester, size: const Size(411, 900), textScale: 1);
      expect(tester.takeException(), isNull);
      final card = requirementsCard();
      expectEveryRequirementPresent(tester, card);
      expect(
        clippedText(tester, card),
        isEmpty,
        reason:
            'the requirements card cut text off at 411 dp: '
            '${clippedText(tester, card).join(" / ")}',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('puts each explanation under its own value, not beside it', (
      tester,
    ) async {
      for (final size in <Size>[const Size(411, 900), const Size(360, 800)]) {
        await pumpJobs(
          tester,
          size: size,
          textScale: size.width == 360 ? 2 : 1,
        );
        final card = requirementsCard();
        for (final requirement in requirements) {
          final value = rectOf(tester, card, requirement.$2);
          final explanation = rectOf(tester, card, requirement.$3);
          expect(
            explanation.top,
            greaterThanOrEqualTo(value.bottom),
            reason:
                'at ${size.width.toInt()} dp the explanation for '
                '"${requirement.$1}" starts level with its value instead of '
                'beneath it',
          );
          expect(
            explanation.left,
            closeTo(value.left, 0.5),
            reason:
                'at ${size.width.toInt()} dp the explanation for '
                '"${requirement.$1}" is pushed into another column',
          );
          expect(
            explanation.overlaps(value),
            isFalse,
            reason: 'the two runs for "${requirement.$1}" share pixels',
          );
        }
      }
    });

    testWidgets('keeps the Computer test value and its explanation distinct', (
      tester,
    ) async {
      // The row the audit photographed: "Answer everything" filled its column
      // and the sentence after it began in the next pixel, reading as one
      // string. On a phone they are now two blocks apart, with a gap between
      // them and a rule above the row.
      await pumpJobs(tester, size: const Size(411, 900), textScale: 1);
      final card = requirementsCard();
      final value = rectOf(tester, card, computerValue);
      final explanation = rectOf(tester, card, computerExplanation);

      expect(
        explanation.top - value.bottom,
        greaterThanOrEqualTo(3),
        reason:
            'there is no vertical gutter between "Answer everything" and the '
            'sentence explaining it',
      );
      expect(explanation.overlaps(value), isFalse);
      expect(
        find.descendant(
          of: card,
          matching: find.text('$computerValue $computerExplanation'),
        ),
        findsNothing,
      );
      // And at 2x text as well: the worst case must not merge the two runs.
      await pumpJobs(tester, size: const Size(360, 800), textScale: 2);
      final narrowCard = requirementsCard();
      final scaledValue = rectOf(tester, narrowCard, computerValue);
      final scaledExplanation = rectOf(tester, narrowCard, computerExplanation);
      expect(
        scaledExplanation.top,
        greaterThanOrEqualTo(scaledValue.bottom),
        reason: 'at 2x text the explanation starts on the value\'s own line',
      );
      expect(scaledExplanation.overlaps(scaledValue), isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a wide card keeps the table, with a gutter between columns', (
      tester,
    ) async {
      // The table is not gone, it is conditional: where the card can hold three
      // real columns the value still sits beside its explanation - a full
      // gutter's width away, so the two never touch.
      await pumpJobs(tester, size: const Size(800, 1280), textScale: 1);
      expect(tester.takeException(), isNull);
      final card = requirementsCard();
      expectEveryRequirementPresent(tester, card);
      final value = rectOf(tester, card, computerValue);
      final explanation = rectOf(tester, card, computerExplanation);
      expect(
        explanation.left,
        greaterThan(value.right + 8),
        reason:
            'the explanation column starts ${(explanation.left - value.right).toStringAsFixed(1)} '
            'dp after the value column, which reads as one run-on string',
      );
      expect(explanation.overlaps(value), isFalse);
      expect(rectOf(tester, card, '31').top, lessThan(explanation.top));
    });
  });
}
