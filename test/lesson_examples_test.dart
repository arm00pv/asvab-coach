import 'dart:io';

import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/bank/lessons_index.dart';
import 'package:asvab_guard_coach/data/models/catalog.dart';
import 'package:asvab_guard_coach/data/models/lesson.dart';
import 'package:asvab_guard_coach/screens/lesson_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Every reinforcement lesson is hand written, one per skill, so nothing in
/// the compiler stops a lesson from shipping with a single example, an empty
/// common mistake, or a field somebody trimmed down to whitespace.
///
/// These tests are that guard rail. They are deliberately about the content
/// rather than about the screen: a lesson that renders beautifully while saying
/// nothing is still a lesson that teaches nothing.
bool blank(String value) => value.trim().isEmpty;

/// Registers the real Roboto faces.
///
/// Without them the harness measures text in the test font, where every glyph
/// is a square as wide as the font is tall. That is roughly twice real width,
/// so a screen would be reported as overflowing when no phone shows it.
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

/// Placeholder text that must never reach a learner.
const List<String> placeholders = <String>[
  'todo',
  'tbd',
  'lorem ipsum',
  'example 2',
  'fixme',
  'xxx',
];

String describe(Lesson lesson) => '${lesson.skillId} (${lesson.title})';

void main() {
  setUpAll(loadRealFonts);

  final List<Lesson> lessons = allLessons;

  test('there is one lesson for every skill, with unique ids', () {
    final List<String> ids = lessons.map((Lesson l) => l.skillId).toList();
    expect(
      ids.toSet().length,
      ids.length,
      reason: 'two lessons share a skill id, so one of them is unreachable',
    );
    for (final Skill skill in Skills.all) {
      expect(
        ids,
        contains(skill.id),
        reason: 'the ${skill.id} skill has no reinforcement lesson',
      );
    }
  });

  group('every lesson is complete', () {
    for (final Lesson lesson in lessons) {
      test(describe(lesson), () {
        final String where = describe(lesson);

        for (final (String field, String value) in <(String, String)>[
          ('title', lesson.title),
          ('hook', lesson.hook),
          ('whyItMatters', lesson.whyItMatters),
        ]) {
          expect(blank(value), isFalse, reason: '$where has an empty $field');
        }
        expect(
          lesson.minutes,
          greaterThan(0),
          reason: '$where has no read time',
        );

        expect(
          lesson.sections,
          isNotEmpty,
          reason: '$where has no explanation',
        );
        for (final LessonSection section in lesson.sections) {
          expect(
            blank(section.heading),
            isFalse,
            reason: '$where has a section with no heading',
          );
          expect(
            blank(section.body),
            isFalse,
            reason: '$where has an empty section: ${section.heading}',
          );
          for (final String bullet in section.bullets) {
            expect(
              blank(bullet),
              isFalse,
              reason: '$where has a blank bullet in ${section.heading}',
            );
          }
        }

        // The point of this file: a lesson is not finished until a learner who
        // did not follow the first route has a second one to try.
        expect(
          lesson.examples.length,
          greaterThanOrEqualTo(2),
          reason: '$where needs at least two worked examples',
        );
        final Set<String> prompts = <String>{};
        for (final WorkedExample example in lesson.examples) {
          expect(
            blank(example.prompt),
            isFalse,
            reason: '$where has a worked example with no prompt',
          );
          expect(
            prompts.add(example.prompt.trim()),
            isTrue,
            reason: '$where repeats a worked example prompt',
          );
          expect(
            example.steps,
            isNotEmpty,
            reason: '$where has a worked example with no steps',
          );
          for (final String step in example.steps) {
            expect(
              blank(step),
              isFalse,
              reason: '$where has a blank step in: ${example.prompt}',
            );
          }
          expect(
            blank(example.answer),
            isFalse,
            reason: '$where has a worked example with no answer',
          );
        }

        expect(
          lesson.commonMistakes,
          isNotEmpty,
          reason: '$where has no common mistake section',
        );
        for (final CommonMistake mistake in lesson.commonMistakes) {
          expect(
            blank(mistake.answer),
            isFalse,
            reason: '$where has a common mistake with no wrong answer',
          );
          expect(
            blank(mistake.why),
            isFalse,
            reason:
                '$where has a common mistake with no reason: '
                '${mistake.answer}',
          );
        }

        expect(
          lesson.quickRules,
          isNotEmpty,
          reason: '$where has no rules worth memorising',
        );
        for (final String rule in lesson.quickRules) {
          expect(blank(rule), isFalse, reason: '$where has a blank rule');
        }

        expect(lesson.pitfalls, isNotEmpty, reason: '$where has no pitfalls');
        for (final String pitfall in lesson.pitfalls) {
          expect(blank(pitfall), isFalse, reason: '$where has a blank pitfall');
        }
      });
    }
  });

  test('no lesson text is a placeholder', () {
    final StringBuffer all = StringBuffer();
    for (final Lesson lesson in lessons) {
      all
        ..writeln(lesson.title)
        ..writeln(lesson.hook)
        ..writeln(lesson.whyItMatters);
      for (final LessonSection section in lesson.sections) {
        all
          ..writeln(section.heading)
          ..writeln(section.body)
          ..writeln(section.bullets.join(' '));
      }
      for (final WorkedExample example in lesson.examples) {
        all
          ..writeln(example.prompt)
          ..writeln(example.steps.join(' '))
          ..writeln(example.answer);
      }
      for (final CommonMistake mistake in lesson.commonMistakes) {
        all
          ..writeln(mistake.answer)
          ..writeln(mistake.why);
      }
      all
        ..writeln(lesson.quickRules.join(' '))
        ..writeln(lesson.pitfalls.join(' '));
    }
    final String text = all.toString().toLowerCase();
    for (final String placeholder in placeholders) {
      expect(
        text,
        isNot(contains(placeholder)),
        reason: 'the lesson content still contains "$placeholder"',
      );
    }
  });
  testWidgets('the lesson screen shows the second example and the common '
      'mistake, even at double system text', (tester) async {
    // The content is worthless if the screen never paints it, and the section
    // is worthless if it is cut off or overflows once the candidate enlarges
    // their system font, which Android allows up to 2x.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final AppState state = AppState();
    await state.init();
    final Lesson lesson = allLessons.firstWhere(
      (Lesson l) => l.examples.length > 1 && l.commonMistakes.isNotEmpty,
    );

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          theme: AppTheme.build(Brightness.light),
          home: Builder(
            builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: LessonScreen(skillId: lesson.skillId),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text(lesson.examples[1].prompt), findsOneWidget);
    expect(find.text(lesson.commonMistakes.first.answer), findsOneWidget);
    expect(find.text(lesson.commonMistakes.first.why), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
