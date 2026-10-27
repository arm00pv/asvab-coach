import 'dart:io';
import 'dart:math' as math;

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/core/theme/tokens.dart';
import 'package:asvab_guard_coach/data/models/mos.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:asvab_guard_coach/widgets/primitives.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One job row at 360 dp with 2x system text.
///
/// A render of this list on the cheapest handset Android runs, with the largest
/// font size Android offers, used to break words in half: "11B" came out as
/// "11 / B", "Infantryman" as "Infan / tryman" and 11C read "Indirect / Fire
/// Infan / tryman". The cause was arithmetic in the row itself - a fixed 46 dp
/// code column and a pill given an equal share of a Row's free space - so the
/// title column was handed the leftovers and Flutter did the only thing left to
/// it and split the words. An MOS code split over two lines is a code a
/// candidate mistypes, and a job title split mid-word reads as broken.
///
/// So what is asserted here is the shape of the row and the integrity of its
/// runs, never the wording:
///
///  * the list lays out without a layout exception (a) ;
///  * every code is one unsplit run on one line, in the roster's own spelling,
///    including the long-titled MOS whose rows reported the defect (b) ;
///  * no paragraph inside any row had to drop text (c) ;
///  * every title is its own intact string, is given a column at least as wide
///    as its widest unbreakable word, and is never broken inside a word - and
///    sits on at most two lines wherever two lines are enough (d) ;
///  * the retired and retiring pills still say what they said, on that same
///    screen.
///
/// The real Roboto face is registered because the harness otherwise measures in
/// Ahem, where every glyph is a square as wide as the font is tall - roughly
/// twice real width - which would report breaks no phone shows and hide the ones
/// only real metrics produce.
const Size cheapPhone = Size(360, 800);
const double largeText = 2;

/// The codes whose rows the defect report photographed, plus 35L, whose title
/// holds the widest word in the roster ("Counterintelligence", 244 of the 294 dp
/// the card can give it at 2x text).
const List<String> longTitled = <String>['11B', '11C', '68W', '35L'];

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

Future<AppState> emptyState() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  return state;
}

/// The jobs screen on its "Every job" tab, because the list opens on "Qualified"
/// and a row the candidate misses would not be there to measure.
///
/// [now] is passed in so the rescission pills are a fixed question rather than a
/// function of the day the suite runs.
Future<void> pumpJobsList(
  WidgetTester tester, {
  Size size = cheapPhone,
  double textScale = largeText,
  DateTime? now,
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
            child: JobsScreen(now: now),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await showEveryJob(tester);
}

Future<void> showEveryJob(WidgetTester tester) async {
  final everyJob = find.textContaining('Every job (');
  expect(everyJob, findsOneWidget);
  await tester.ensureVisible(everyJob);
  await tester.pumpAndSettle();
  await tester.tap(everyJob);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

/// How many lines a laid-out paragraph actually used. [RenderParagraph] exposes
/// no line count, but the box is the sum of its line heights and
/// [RenderParagraph.preferredLineHeight] is one of them.
int linesOf(RenderParagraph paragraph) =>
    (paragraph.size.height / paragraph.preferredLineHeight).round();

/// The card one row is drawn on: the nearest [AppCard] above the code.
Finder rowOf(String code) =>
    find.ancestor(of: find.text(code), matching: find.byType(AppCard));

/// The paragraph of one run of text inside a row.
RenderParagraph paragraphOf(WidgetTester tester, Finder within, String text) =>
    tester.renderObject<RenderParagraph>(
      find.descendant(of: within, matching: find.text(text)),
    );

/// Any paragraph inside one row that had to drop text.
///
/// [RenderParagraph.didExceedMaxLines] is true only when text was laid out and
/// something was cut, so a label with an ellipsis that happens to fit is not
/// reported. The chips and the caveat elsewhere on the screen are scoped out:
/// this is about the row.
List<String> clippedTextIn(WidgetTester tester, Finder row) {
  final out = <String>[];
  for (final element
      in find.descendant(of: row, matching: find.byType(RichText)).evaluate()) {
    final object = element.renderObject;
    if (object is RenderParagraph && object.didExceedMaxLines) {
      out.add(object.text.toPlainText());
    }
  }
  return out;
}

bool isWordCharacter(String character) =>
    RegExp(r'[A-Za-z0-9]').hasMatch(character);

/// The text offsets at which a laid-out paragraph ended its lines.
///
/// [RenderParagraph.getPositionForOffset] maps a point back into the string, so
/// asking for a point just past the right edge of a line returns the offset it
/// broke at - which is exactly the question "did this break inside a word?".
List<int> lineEnds(RenderParagraph paragraph) {
  final plain = paragraph.text.toPlainText();
  final lines = linesOf(paragraph);
  final lineHeight = paragraph.size.height / lines;
  final out = <int>[];
  for (var line = 0; line < lines - 1; line++) {
    final y = (line + 0.5) * lineHeight;
    final position = paragraph.getPositionForOffset(
      Offset(paragraph.size.width + 1, y),
    );
    out.add(position.offset.clamp(1, plain.length - 1));
  }
  return out;
}

/// The width of the widest run of [text] a line breaker cannot break: the
/// longest stretch between whitespace and the slashes and hyphens it may break
/// after. Measured in the paragraph's own style at [textScale], so it is the
/// width that text is really drawn at.
double widestUnbreakableRun(String text, TextStyle style, double textScale) {
  var widest = 0.0;
  for (final run in text.split(RegExp(r'[/\-\s]+'))) {
    if (run.isEmpty) continue;
    final painter = TextPainter(
      text: TextSpan(text: run, style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.linear(textScale),
      maxLines: 1,
    )..layout();
    widest = math.max(widest, painter.width);
    painter.dispose();
  }
  return widest;
}

/// The fewest lines [text] can occupy in [width]: what the same string costs
/// when the column is as wide as the row says it is.
int naturalLines(String text, TextStyle style, double textScale, double width) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaler: TextScaler.linear(textScale),
  )..layout(maxWidth: width);
  final lines = (painter.height / painter.preferredLineHeight).round();
  painter.dispose();
  return lines;
}

/// The width inside a row card: the card, less its own horizontal padding and
/// the 1 dp border down either side.
double contentWidthOf(WidgetTester tester, Finder row) =>
    tester.getSize(row).width - Space.lg * 2 - 2;

/// The width the title's column was given, read off the row rather than assumed.
///
/// Where the row is stacked the title is a child of the card's own column and
/// gets every pixel of it. Where the code sits beside the title it is the card
/// less the code column, the gutter and the pill - the three things that are
/// laid out before the title is.
double titleColumnWidthOf(
  WidgetTester tester,
  Finder row,
  RenderParagraph code,
  RenderParagraph title,
) {
  final codeRect = tester.getRect(
    find.descendant(of: row, matching: find.text(code.text.toPlainText())),
  );
  final titleRect = tester.getRect(
    find.descendant(of: row, matching: find.text(title.text.toPlainText())),
  );
  final contentWidth = contentWidthOf(tester, row);
  final stacked = titleRect.top >= codeRect.bottom - 0.5;
  if (stacked) return contentWidth;
  final pillWidth = tester
      .getSize(find.descendant(of: row, matching: find.byType(Pill)))
      .width;
  return contentWidth - code.size.width - Space.sm - pillWidth;
}

/// Every row's code, title and pill, checked against the shape the row promises.
List<String> rowFailures(WidgetTester tester, {double textScale = largeText}) {
  final failures = <String>[];
  for (final mos in MosRepository.all) {
    final codeFinder = find.text(mos.code);
    if (codeFinder.evaluate().isEmpty) continue;
    final row = rowOf(mos.code);
    expect(
      row,
      findsOneWidget,
      reason: '${mos.code} is not a code on exactly one row',
    );

    // (b) The code is the roster's own string, and it is on one line. An MOS
    // code split across two lines is a code a candidate mistypes.
    final code = paragraphOf(tester, row, mos.code);
    if (code.text.toPlainText() != mos.code) {
      failures.add(
        '${mos.code}: the code run reads "${code.text.toPlainText()}"',
      );
    }
    final codeLines = linesOf(code);
    if (codeLines != 1) {
      failures.add('${mos.code}: the code is split over $codeLines lines');
    }

    // (c) Nothing in the row was cut off.
    failures.addAll(
      clippedTextIn(
        tester,
        row,
      ).map((text) => '${mos.code}: "$text" was cut off'),
    );

    // (d) The title is its own intact string, given a column as wide as its
    // widest unbreakable word, and broken at word boundaries only.
    if (find
        .descendant(of: row, matching: find.text(mos.title))
        .evaluate()
        .isEmpty) {
      failures.add('${mos.code}: the title is not on the row as a single run');
      continue;
    }
    final title = paragraphOf(tester, row, mos.title);
    final plain = title.text.toPlainText();
    if (plain != mos.title) {
      failures.add('${mos.code}: the title run reads "$plain"');
    }
    final style = title.text.style;
    if (style == null) {
      failures.add(
        '${mos.code}: the title has no style, so nothing measures it',
      );
      continue;
    }
    final column = titleColumnWidthOf(tester, row, code, title);
    final widestWord = widestUnbreakableRun(plain, style, textScale);
    if (widestWord > column + 0.5) {
      failures.add(
        '${mos.code}: the title column is ${column.toStringAsFixed(1)} dp but '
        'its widest word needs ${widestWord.toStringAsFixed(1)} dp',
      );
    }
    for (final offset in lineEnds(title)) {
      final before = plain.substring(offset - 1, offset);
      final after = plain.substring(offset, offset + 1);
      if (isWordCharacter(before) && isWordCharacter(after)) {
        final from = math.max(0, offset - 5);
        final to = math.min(plain.length, offset + 5);
        failures.add(
          '${mos.code}: the title breaks inside a word - '
          '"${plain.substring(from, offset)} | ${plain.substring(offset, to)}"',
        );
      }
    }
    // Two lines is the ceiling a phone row is designed for. A title that simply
    // needs more than two lines at this width is allowed its own count instead
    // of being cut - but never a line more than its width genuinely needs.
    final ceiling = math.max(2, naturalLines(plain, style, textScale, column));
    final lines = linesOf(title);
    if (lines > ceiling) {
      failures.add(
        '${mos.code}: the title used $lines lines where $ceiling is the most '
        'its ${column.toStringAsFixed(1)} dp column needs',
      );
    }
  }
  return failures;
}

void main() {
  setUpAll(loadRealFonts);

  group('a job row at 360 dp with 2x text', () {
    testWidgets('lays out without a layout exception', (tester) async {
      await pumpJobsList(tester);
      expect(tester.takeException(), isNull);
      // The rows the defect was reported on are on this screen, with their
      // titles as single strings.
      for (final code in longTitled) {
        final mos = MosRepository.byCode(code);
        expect(mos, isNotNull, reason: '$code should be in the roster');
        expect(find.text(mos!.title), findsOneWidget);
      }
    });

    testWidgets('keeps every code on one line and every title in whole words', (
      tester,
    ) async {
      await pumpJobsList(tester);
      final failures = rowFailures(tester);
      expect(
        failures,
        isEmpty,
        reason:
            'the job rows at 360 dp with 2x text broke their own promise:'
            '${failures.map((f) => "\n  - $f").join()}',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('puts the code above the title instead of beside it', (
      tester,
    ) async {
      // The shape, not just its outcome: at this width the columns cannot all
      // be columns, so the code takes its own line and the title gets the whole
      // card rather than the leftover sliver.
      await pumpJobsList(tester);
      for (final code in longTitled) {
        final row = rowOf(code);
        final codeRect = tester.getRect(
          find.descendant(of: row, matching: find.text(code)),
        );
        final title = MosRepository.byCode(code)!.title;
        final titleRect = tester.getRect(
          find.descendant(of: row, matching: find.text(title)),
        );
        expect(
          titleRect.top,
          greaterThanOrEqualTo(codeRect.bottom - 0.5),
          reason: '$code still shares its line with "$title"',
        );
        expect(
          titleRect.left,
          closeTo(codeRect.left, 0.5),
          reason: '$code is not flush with its title',
        );
      }
    });

    testWidgets('still fits one row of the list inside the card', (
      tester,
    ) async {
      // A guard against "fixed" by making every row enormous: the stacked row is
      // taller than a single-line row, not taller than the phone.
      await pumpJobsList(tester);
      final cardHeights = <double>[];
      for (final code in longTitled) {
        cardHeights.add(tester.getSize(rowOf(code)).height);
      }
      final tallest = cardHeights.reduce(math.max);
      expect(
        tallest,
        lessThan(cheapPhone.height / 4),
        reason:
            'a single job row is $tallest dp tall at 360 dp with 2x text, which '
            'is a quarter of the screen for one job',
      );
    });
  });

  group('a job row on a phone with normal text', () {
    testWidgets('keeps the code beside the title where that fits', (
      tester,
    ) async {
      // The fix is a condition, not a replacement: at 390 dp and 1x text the row
      // is still a row, and the pill takes only the width its own label needs.
      await pumpJobsList(tester, size: const Size(390, 844), textScale: 1);
      expect(tester.takeException(), isNull);
      for (final code in longTitled) {
        final row = rowOf(code);
        final codeRect = tester.getRect(
          find.descendant(of: row, matching: find.text(code)),
        );
        final titleRect = tester.getRect(
          find.descendant(
            of: row,
            matching: find.text(MosRepository.byCode(code)!.title),
          ),
        );
        expect(
          titleRect.top,
          lessThan(codeRect.bottom),
          reason: '$code lost its column at 390 dp with 1x text',
        );
        expect(titleRect.left, greaterThan(codeRect.right - 0.5));
      }
      expect(
        rowFailures(tester, textScale: 1),
        isEmpty,
        reason: 'the row broke a word at 390 dp with 1x text',
      );
    });
  });

  group('the rescission pills', () {
    // 12M was rescinded in October 2025 and stands retired at this date; 15E and
    // 15W carry (Rescind 202610), so they are retiring rather than retired.
    final DateTime now = DateTime(2026, 9, 15);

    testWidgets('still say Retired and Retiring at 360 dp with 2x text', (
      tester,
    ) async {
      await pumpJobsList(tester, now: now);
      final retired = MosRepository.retiredAsOf(now);
      final retiring = MosRepository.retiringAsOf(now);
      expect(retired, isNotEmpty, reason: 'the roster keeps a retired entry');
      expect(retiring, isNotEmpty, reason: 'the roster keeps a retiring entry');

      for (final mos in <Mos>[...retired, ...retiring]) {
        final row = rowOf(mos.code);
        expect(row, findsOneWidget);
        final label = mos.retiredAt(now) ? 'Retired' : 'Retiring';
        expect(
          find.descendant(of: row, matching: find.text(label)),
          findsOneWidget,
          reason: '${mos.code} does not carry its $label pill',
        );
        // The rescission is spelled out in its own line, and neither it nor the
        // pill was cut off on the way in.
        expect(
          find.descendant(
            of: row,
            matching: find.text(mos.rescindHeadline(now)!),
          ),
          findsOneWidget,
          reason: '${mos.code} lost the date its rescission carries',
        );
        expect(clippedTextIn(tester, row), isEmpty);
      }
      expect(tester.takeException(), isNull);
    });
  });
}
