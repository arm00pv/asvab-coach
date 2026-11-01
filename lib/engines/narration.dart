/// The spoken guide: what each screen is for, said out loud.
///
/// Every script here is authored, not generated. That is the whole point. A
/// model that explains a picture of a screen can be wrong in ways a candidate
/// cannot check; a script that is part of the source can be read, reviewed and
/// pinned by a test, and it says exactly what the screen underneath it says
/// because both are written by the same hand from the same numbers.
///
/// The numbers arrive as arguments rather than being read from state here, so
/// the sentences cannot drift from the screen: the screen computes the fact
/// once, shows it, and hands the same value to the script.
///
/// Style, enforced by test/narration_test.dart:
///   * second person, present tense, no exclamation marks;
///   * every abbreviation is expanded the first time it is spoken;
///   * short paragraphs, because they are read aloud, not scanned;
///   * nothing that promises a score, a job or an outcome.
library;

/// One screen's spoken script.
class NarrationDoc {
  const NarrationDoc({
    required this.screenId,
    required this.title,
    required this.paragraphs,
  });

  /// Stable identifier, used to stop a script that belongs to a screen the
  /// candidate has already left, and to keep auto-read from repeating itself.
  final String screenId;

  /// What the screen is called, spoken first so a listener knows where the
  /// guide has taken them.
  final String title;

  /// The script, spoken in order with a short pause between paragraphs.
  final List<String> paragraphs;

  /// The whole thing as one string, which is what a speech engine wants.
  String get text => <String>[title, ...paragraphs].join('\n\n');

  /// Roughly how long this takes to say, for the button's tooltip. Counted at
  /// about 165 spoken words a minute, which is ordinary conversational pace.
  Duration get spokenLength {
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    return Duration(seconds: (words / 165 * 60).ceil().clamp(1, 900));
  }
}

/// The languages the guide has been *written* in.
///
/// A voice is not enough: a phone that can pronounce Spanish will read an
/// English sentence with Spanish sounds and make it useless. What a screen says
/// has to exist in the language before any voice can speak it, so this list is
/// the one that governs what the speaker offers - not the list of voices the
/// device happens to have.
///
/// English is the only written language today. The scripts are here, in
/// source, so a translation is a data change reviewed like any other copy
/// rather than a model's output nobody can check.
const List<String> writtenLanguages = <String>['en'];

/// Every script the app can speak.
///
/// Adding a screen means adding a factory here: the coverage test enumerates
/// them all and fails on a script that is empty, unbounded or full of
/// placeholders.
abstract final class Narration {
  /// Home. Says where the candidate stands and what the next tap should be.
  static NarrationDoc home({
    required String name,
    required int? afqt,
    required int attempts,
    required int dueReviews,
    required int? daysToTest,
    required bool hasPendingAttempt,
  }) {
    final paragraphs = <String>[
      'This is your study home, $name. Everything the app knows about your '
          'progress is gathered on this screen.',
      if (afqt == null)
        'You have not sat a test yet, so there is no score to show. The '
            'diagnostic is a short, unscored run across all nine subtests, and '
            'it is what turns the rest of the app on: the plan, the weak-spot '
            'drill and the job match all need a result to work from.'
      else
        'Your best Armed Forces Qualification Test percentile is $afqt. That '
            'is a percentile, not a percentage: it says what share of a '
            'national sample of test takers you scored above, so fifty is the '
            'middle and ninety-nine is the top one percent. It is an estimate '
            'from this app, not an official score.',
      if (attempts > 0)
        'You have finished $attempts '
            '${attempts == 1 ? 'attempt' : 'attempts'}. '
            '${daysToTest == null
                ? 'No test date is set, so the app is not pacing you.'
                : daysToTest < 0
                ? 'Your target date has passed, so set a new one in settings.'
                : 'Your test is $daysToTest ${daysToTest == 1 ? 'day' : 'days'} out.'}',
      if (dueReviews > 0)
        '$dueReviews ${dueReviews == 1 ? 'question is' : 'questions are'} due '
            'for review. Those are the ones you missed or flagged, and they '
            'come back on a schedule so they stick.',
      if (hasPendingAttempt)
        'You also have a test that was interrupted. The card at the top picks '
            'it up at the question you stopped on, with the clock where you '
            'left it.',
      'Tap the speaker beside this text at any time to hear this screen again, '
          'in the language you chose in settings. Nothing you say or hear '
          'leaves the phone.',
    ];
    return NarrationDoc(
      screenId: 'home',
      title: 'Home',
      paragraphs: paragraphs,
    );
  }

  /// The plan. Says how much time there is, what it demands and what today is.
  static NarrationDoc plan({
    required bool hasPlan,
    required int? daysRemaining,
    required int? requiredDailyMinutes,
    required bool isBehind,
    required int missedMinutes,
    required String? reflowNote,
  }) {
    return NarrationDoc(
      screenId: 'plan',
      title: 'Your plan',
      paragraphs: <String>[
        'This is your study plan. It is ordered by how many points each skill '
            'is worth to your score right now, so the first row is the cheapest '
            'improvement available to you.',
        if (!hasPlan)
          'There is no plan yet, because a plan is built from a scored attempt. '
              'Sit the diagnostic from the Test tab and this screen fills in.'
        else
          'You have ${daysRemaining ?? 0} '
              '${daysRemaining == 1 ? 'day' : 'days'} before your test date, and '
              'the work left needs about ${requiredDailyMinutes ?? 0} minutes a '
              'day to finish in time.',
        if (hasPlan && isBehind)
          'You are behind by $missedMinutes '
              '${missedMinutes == 1 ? 'minute' : 'minutes'}, so the schedule has '
              'been reflowed: the same work, spread over the days that are left '
              'rather than dropped.',
        ?reflowNote,
        if (hasPlan)
          'The Today card is the part to act on. Each row there opens the lesson '
              'itself, and a step counts as done when you finish the lesson, not '
              'when you open it.',
        'The lesson library below the plan is every skill the app can teach, for '
            'when you already know what you want to work on.',
      ],
    );
  }

  /// The test centre: what can be sat, and what each one is for.
  static NarrationDoc testCentre({
    required int questionCount,
    required bool hasReport,
  }) {
    return NarrationDoc(
      screenId: 'test-centre',
      title: 'Test centre',
      paragraphs: <String>[
        'This is the test centre. Three ways to sit a test, in the order most '
            'people want them.',
        'A full mock runs every subtest in the order the Army administers them, '
            'with the real clock on each section: one hundred and thirty-five '
            'questions over a hundred and ninety-seven minutes. It is the only '
            'rehearsal that tells you how you handle the pacing.',
        'The diagnostic is the short one, twenty-seven questions across all '
            'nine subtests. Sit it first: the plan, the drills and the job match '
            'are all built from a scored attempt.',
        hasReport
            ? 'The weak-spot drill is built from the five skills that are '
                  'costing you the most points in your most recent report.'
            : 'The weak-spot drill is switched off until you have a scored '
                  'attempt to build it from.',
        'The bank holds $questionCount practice questions written for this app. '
            'None of them is a real ASVAB question, and a score from here is an '
            'estimate against the official scale, not an official score.',
      ],
    );
  }

  /// The jobs explorer.
  static NarrationDoc jobs({
    required int enlistedShown,
    required int warrantShown,
    required bool hasReport,
  }) {
    return NarrationDoc(
      screenId: 'jobs',
      title: 'Jobs',
      paragraphs: <String>[
        'This is the job explorer. It answers one question honestly: which Army '
            'National Guard jobs your score opens, and what it would take to '
            'open the rest.',
        if (hasReport)
          'Your score is already applied. Each job is marked as one you qualify '
              'for now or one that is out of reach, and the out-of-reach ones '
              'say which line score is short and by how much. A line score is '
              'the Army\'s own weighted combination of subtests, scaled to a '
              'mean of one hundred.'
        else
          'There is no score to apply yet, so every job is listed with its '
              'requirements rather than a verdict. Sit the diagnostic to see '
              'which ones you already meet.',
        'There are $enlistedShown enlistment jobs on this list and '
            '$warrantShown warrant officer occupations. The warrant ones are '
            'kept at the end, filed separately on purpose: they are appointed '
            'from the ranks after you are already serving, so they are never '
            'counted as jobs you can enlist into.',
        'Tap any job for what it is, what it becomes on the civilian side, what '
            'it scores, and the shortest way to become eligible.',
      ],
    );
  }

  /// Progress.
  static NarrationDoc progress({
    required int attempts,
    required int bestAfqt,
    required int bestGt,
    required int streakDays,
  }) {
    return NarrationDoc(
      screenId: 'progress',
      title: 'Progress',
      paragraphs: <String>[
        'This screen answers one question: is the work actually moving the '
            'score.',
        if (attempts == 0)
          'There is no history yet. Sit the placement diagnostic and this page '
              'fills in with trends, streaks and per-skill mastery.'
        else
          'You have $attempts ${attempts == 1 ? 'attempt' : 'attempts'} '
              'recorded. Your best Armed Forces Qualification Test percentile is '
              '$bestAfqt and your best General Technical score is $bestGt. The '
              'General Technical score, GT for short, is the composite that most '
              'technical jobs read.',
        if (streakDays > 1)
          'You are on a $streakDays day streak. A streak counts consecutive '
              'calendar days with at least one finished attempt.',
        'The trend lines matter more than any single number. A score that moves '
            'two points is mostly noise; a line that has moved steadily over '
            'four attempts is real.',
      ],
    );
  }

  /// A lesson.
  static NarrationDoc lesson({
    required String title,
    required String subtest,
    required List<String> headings,
    required int exampleCount,
  }) {
    return NarrationDoc(
      screenId: 'lesson',
      title: title,
      paragraphs: <String>[
        '$title, a lesson in $subtest.',
        if (headings.isNotEmpty)
          'It covers ${headings.length} '
              '${headings.length == 1 ? 'part' : 'parts'}: '
              '${_spokenList(headings)}.',
        if (exampleCount > 0)
          'There are $exampleCount worked '
              '${exampleCount == 1 ? 'example' : 'examples'}, each broken down '
              'step by step. Read the working, not just the answer: the exam '
              'rewards the method.',
        'At the end there is a short check. Getting one wrong there is not a '
            'problem: the question joins your review queue and comes back on a '
            'schedule.',
      ],
    );
  }

  /// The review screen.
  static NarrationDoc review({
    required int total,
    required int correct,
    required int blank,
    required int missed,
  }) {
    return NarrationDoc(
      screenId: 'review',
      title: 'Review',
      paragraphs: <String>[
        'This is the review of the attempt you have just finished.',
        'You answered $correct of $total correctly, missed $missed and left '
            '$blank blank.',
        'Each question comes back as a card: the question, every answer option, '
            'and why that option is right or wrong. Your own answer is marked. '
            'The explanations are the part worth reading slowly, because the '
            'wrong options are written to catch a specific mistake.',
        'Anything you missed or flagged goes into the review queue, and the '
            'queue brings it back on a schedule rather than immediately, which '
            'is what makes it stick.',
      ],
    );
  }

  /// The score report.
  static NarrationDoc results({
    required int afqt,
    required bool supported,
    required int totalCorrect,
    required int totalAnswered,
  }) {
    return NarrationDoc(
      screenId: 'results',
      title: 'Your score report',
      paragraphs: <String>[
        if (supported)
          'Your Armed Forces Qualification Test percentile is $afqt, from '
              '$totalAnswered questions answered across the four subtests that '
              'feed that score.'
        else
          'This attempt cannot be scored on the Armed Forces Qualification Test '
              'scale: only $totalAnswered of the four subtests that make it up '
              'were answered, which is not enough to stand behind a percentile. '
              'The subtest results below are still yours, and they are correct.',
        'Percentile means what share of a national sample you scored above, so '
            'fifty is the middle. Every line score below is scaled the Army\'s '
            'way, to a mean of one hundred.',
        'Line scores are what the jobs actually read. A job does not ask for '
            'your percentile; it asks for a combination of your subtest scores, '
            'which is why the same percentile can open one job and not another.',
        'This is an estimate from a practice test, not an official score, and '
            'the requirements the app prints should be confirmed with a '
            'recruiter before you sign anything.',
      ],
    );
  }

  /// The glossary.
  static NarrationDoc glossary() => const NarrationDoc(
    screenId: 'glossary',
    title: 'What the terms mean',
    paragraphs: <String>[
      'Every abbreviation the app prints, in plain words: Armed Forces '
          'Qualification Test, or AFQT; Verbal Expression and Arithmetic '
          'Reasoning, the two composites the Armed Forces Qualification Test is '
          'built from; standard score; line score; and Military Occupational '
          'Specialty, the code the Army files a job under.',
      'Scores in this app appear on two different scales and they are easy to '
          'confuse. A percentile runs from one to ninety-nine and says how you '
          'compare with other people. A standard score has a mean of fifty, and '
          'a line score has a mean of one hundred. They are not interchangeable.',
      'If a term you meet here is missing, that is a fault worth reporting, not '
          'a word you were expected to know.',
    ],
  );

  /// Settings.
  static NarrationDoc settings({
    required String? installedVersion,
    required String spokenLanguage,
  }) => NarrationDoc(
    screenId: 'settings',
    title: 'Settings',
    paragraphs: <String>[
      'Settings. Nothing here is required; every default is already the one '
          'most people keep.',
      'Spoken study guide is the section that governs this voice. It names the '
          'language you will hear, currently ${spokenLanguage.toLowerCase()}, and '
          'holds the switch that makes a screen read itself when it opens. The '
          'voice is the phone\'s own, so it works with no connection and no '
          'download, and nothing you listen to is sent anywhere.',
      if (installedVersion != null)
        'This build reports itself as version $installedVersion. Updates are '
            'checked against the project\'s public releases, and that check is '
            'the only time the app uses the internet.'
      else
        'On this platform the app cannot report its own version, which is '
            'expected when it is not an installed build.',
      'Erase all data removes your goal and every attempt from this device. It '
          'cannot be undone, and there is no copy anywhere else.',
    ],
  );

  /// The recruiter sheet.
  static NarrationDoc recruiterSheet({
    required String candidate,
    required DateTime generatedOn,
    required int sections,
  }) => NarrationDoc(
    screenId: 'recruiter-sheet',
    title: 'Recruiter brief',
    paragraphs: <String>[
      'This is the one page to take to a recruiter, for $candidate, generated '
          'on ${spokenDate(generatedOn)}.',
      'It is laid out as $sections short sections: where you stand, what your '
          'line scores are, which jobs those scores meet, what the ones they do '
          'not meet would need, and what to ask about next.',
      'It prints the estimate disclaimer beside the numbers, because a recruiter '
          'should see at a glance that these come from a practice app rather '
          'than an official test.',
      'Copy puts the whole page on the clipboard as plain text, which pastes '
          'cleanly into a message or an email. Nothing is uploaded anywhere.',
    ],
  );

  /// Every script, for the coverage test.
  static List<NarrationDoc> get all => <NarrationDoc>[
    home(
      name: 'Candidate',
      afqt: 62,
      attempts: 3,
      dueReviews: 4,
      daysToTest: 21,
      hasPendingAttempt: false,
    ),
    plan(
      hasPlan: true,
      daysRemaining: 21,
      requiredDailyMinutes: 34,
      isBehind: false,
      missedMinutes: 0,
      reflowNote: null,
    ),
    testCentre(questionCount: 447, hasReport: true),
    jobs(enlistedShown: 156, warrantShown: 71, hasReport: true),
    progress(attempts: 3, bestAfqt: 62, bestGt: 108, streakDays: 5),
    lesson(
      title: 'Percent change',
      subtest: 'Mathematics Knowledge',
      headings: <String>['The one formula', 'Worked examples'],
      exampleCount: 3,
    ),
    review(total: 27, correct: 19, blank: 1, missed: 8),
    results(afqt: 62, supported: true, totalCorrect: 19, totalAnswered: 22),
    glossary(),
    settings(
      installedVersion: '1.7.0',
      spokenLanguage: 'English (United States)',
    ),
    recruiterSheet(
      candidate: 'Candidate',
      generatedOn: DateTime(2026, 11, 7),
      sections: 5,
    ),
  ];

  static const _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// A date as it is said: "7 November 2026" rather than "7/11/2026", which a
  /// voice reads as a fraction.
  static String spokenDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';

  /// "a, b and c" - a list a person can follow with their ears.
  static String _spokenList(List<String> items) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    return '${items.sublist(0, items.length - 1).join(', ')} and ${items.last}';
  }
}
