import 'package:flutter_test/flutter_test.dart';

import 'package:asvab_guard_coach/engines/narration.dart';

void main() {
  group('every script', () {
    test('is written, bounded and free of placeholders', () {
      for (final doc in Narration.all) {
        expect(doc.title.trim(), isNotEmpty, reason: doc.screenId);
        expect(doc.paragraphs, isNotEmpty, reason: doc.screenId);
        final text = doc.text;
        // A stray brace is a script that was never spoken in a test:
        // interpolation that reached the string instead of a number.
        expect(
          RegExp(r'[{}]').hasMatch(text),
          isFalse,
          reason: 'template braces survived into ${doc.screenId}: $text',
        );
        expect(
          RegExp(r'null|NaN|Infinity').hasMatch(text),
          isFalse,
          reason: 'a missing value was spoken aloud in ${doc.screenId}',
        );
        // Long enough to explain, short enough that nobody is held hostage by
        // a screen that will not stop talking.
        expect(
          doc.spokenLength.inSeconds,
          inInclusiveRange(10, 95),
          reason: '${doc.screenId} takes ${doc.spokenLength.inSeconds}s to say',
        );
        for (final paragraph in doc.paragraphs) {
          expect(paragraph.trim(), isNotEmpty, reason: doc.screenId);
          expect(
            paragraph,
            matches(RegExp(r'[.!?:]$')),
            reason:
                'a paragraph of ${doc.screenId} does not end in a stop: '
                '$paragraph',
          );
        }
      }
    });

    test('is spoken, not shouted', () {
      for (final doc in Narration.all) {
        expect(
          doc.text.contains('!'),
          isFalse,
          reason: '${doc.screenId} exclaims at the candidate',
        );
        for (final paragraph in doc.paragraphs) {
          // Paragraph breaks are newlines, not doubled spaces: two spaces in a
          // row are a copy slip a voice reads as a pause that is not there.
          expect(
            paragraph.contains('  '),
            isFalse,
            reason: '${doc.screenId} has a run of spaces a voice would swallow',
          );
        }
      }
    });

    test('expands each abbreviation before it is used alone', () {
      // The first time one of these is said it is spelled out in full. A
      // candidate hearing "AFQT" with no expansion has been told nothing.
      const expansions = <String, String>{
        'Armed Forces Qualification Test': 'AFQT',
        'Arithmetic Reasoning': 'AR',
        'General Technical': 'GT',
        'Military Occupational Specialty': 'MOS',
      };
      for (final doc in Narration.all) {
        final text = doc.text;
        for (final entry in expansions.entries) {
          final short = RegExp('\\b${entry.value}\\b').firstMatch(text);
          if (short == null) continue;
          expect(
            text.indexOf(entry.key),
            greaterThanOrEqualTo(0),
            reason:
                '${doc.screenId} says "${entry.value}" without ever saying '
                '"${entry.key}"',
          );
        }
      }
    });

    test('gives every screen its own id', () {
      final ids = <String>{};
      for (final doc in Narration.all) {
        expect(
          ids.add(doc.screenId),
          isTrue,
          reason: 'two screens share the id ${doc.screenId}',
        );
      }
      // Every screen the app can speak for, so a new screen cannot arrive
      // without a script and a script cannot arrive without a screen.
      expect(ids, <String>{
        'home',
        'plan',
        'test-centre',
        'jobs',
        'progress',
        'lesson',
        'review',
        'results',
        'glossary',
        'settings',
        'recruiter-sheet',
      });
    });

    test('is written in a language the app claims to speak', () {
      // One script per written language is the invariant; today that is
      // English. The settings page offers voices for exactly these languages,
      // so a voice can never read words it cannot pronounce.
      expect(writtenLanguages, <String>['en']);
    });
  });

  group('the numbers said are the numbers given', () {
    test('home speaks the percentile and the days left', () {
      final doc = Narration.home(
        name: 'Rivera',
        afqt: 71,
        attempts: 4,
        dueReviews: 2,
        daysToTest: 14,
        hasPendingAttempt: false,
      );
      expect(doc.text, contains('Rivera'));
      expect(doc.text, contains('percentile is 71'));
      expect(doc.text, contains('14 days out'));
      expect(doc.text, contains('2 questions are due'));
    });

    test('home says a single day in the singular', () {
      final doc = Narration.home(
        name: 'Rivera',
        afqt: 71,
        attempts: 4,
        dueReviews: 1,
        daysToTest: 1,
        hasPendingAttempt: false,
      );
      expect(doc.text, contains('test is 1 day out'));
      expect(doc.text, contains('1 question is due'));
    });

    test('home says there is no score when there is none', () {
      final doc = Narration.home(
        name: 'Rivera',
        afqt: null,
        attempts: 0,
        dueReviews: 0,
        daysToTest: null,
        hasPendingAttempt: false,
      );
      expect(doc.text, contains('there is no score to show'));
      expect(doc.text, isNot(contains('percentile is')));
    });

    test('an interrupted attempt is mentioned only when it exists', () {
      NarrationDoc build(bool pending) => Narration.home(
        name: 'Rivera',
        afqt: 50,
        attempts: 1,
        dueReviews: 0,
        daysToTest: 9,
        hasPendingAttempt: pending,
      );
      expect(build(true).text, contains('was interrupted'));
      expect(build(false).text, isNot(contains('was interrupted')));
    });

    test('the plan speaks the day count and the pace it was given', () {
      final doc = Narration.plan(
        hasPlan: true,
        daysRemaining: 22,
        requiredDailyMinutes: 41,
        isBehind: false,
        missedMinutes: 0,
        reflowNote: null,
      );
      expect(doc.text, contains('22 days'));
      expect(doc.text, contains('41 minutes a day'));
      expect(doc.text, isNot(contains('behind by')));
    });

    test('a plan that slipped says so and explains the reflow', () {
      final doc = Narration.plan(
        hasPlan: true,
        daysRemaining: 6,
        requiredDailyMinutes: 63,
        isBehind: true,
        missedMinutes: 35,
        reflowNote: 'Two days were missed, so the work moved forward.',
      );
      expect(doc.text, contains('behind by 35 minutes'));
      expect(doc.text, contains('reflowed'));
      expect(doc.text, contains('Two days were missed'));
    });

    test('a screen with no plan does not pretend to have one', () {
      final doc = Narration.plan(
        hasPlan: false,
        daysRemaining: null,
        requiredDailyMinutes: null,
        isBehind: false,
        missedMinutes: 0,
        reflowNote: null,
      );
      expect(doc.text, contains('no plan yet'));
      expect(doc.text, isNot(contains('minutes a day')));
    });

    test('review counts add up to the questions served', () {
      final doc = Narration.review(total: 27, correct: 19, blank: 2, missed: 6);
      expect(doc.text, contains('19 of 27'));
      expect(doc.text, contains('missed 6'));
      expect(doc.text, contains('left 2 blank'));
    });

    test('a report that cannot be scored says so instead of a percentile', () {
      final doc = Narration.results(
        afqt: 44,
        supported: false,
        totalCorrect: 9,
        totalAnswered: 12,
      );
      expect(doc.text, contains('cannot be scored'));
      expect(doc.text, isNot(contains('percentile is 44')));
    });

    test('a report that can be scored states the estimate out loud', () {
      final doc = Narration.results(
        afqt: 63,
        supported: true,
        totalCorrect: 21,
        totalAnswered: 24,
      );
      expect(doc.text, contains('percentile is 63'));
      expect(doc.text, contains('not an official score'));
    });

    test('the recruiter brief dates itself the way a person says a date', () {
      final doc = Narration.recruiterSheet(
        candidate: 'Rivera',
        generatedOn: DateTime(2026, 3, 9),
        sections: 5,
      );
      expect(doc.text, contains('9 March 2026'));
      expect(doc.text, contains('5 short sections'));
    });

    test('a lesson says how many parts and examples it has', () {
      final doc = Narration.lesson(
        title: 'Ratios',
        subtest: 'Mathematics Knowledge',
        headings: <String>['One way', 'The other way'],
        exampleCount: 1,
      );
      expect(doc.text, contains('Ratios, a lesson in Mathematics Knowledge'));
      expect(doc.text, contains('2 parts: One way and The other way.'));
      expect(doc.text, contains('1 worked example'));
    });

    test('spokenDate never prints a fraction of a date', () {
      expect(Narration.spokenDate(DateTime(2026, 1, 1)), '1 January 2026');
      expect(Narration.spokenDate(DateTime(2027, 12, 31)), '31 December 2027');
    });
  });
}
