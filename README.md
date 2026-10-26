# ASVAB Coach - Army National Guard

A Flutter Web study application that places you with a diagnostic, runs practice
and full-length mock ASVABs under official timing, scores you the way the Army
scores you, and then teaches back the specific skills that cost you points.

Built for one mission: enlisting in - or commissioning into - the Army National
Guard.

---

## What it does

**Places you before it teaches you.** A 27-question diagnostic across all nine
subtests produces a subtest profile, an AFQT percentile and all ten line scores.
Everything after that is chosen from your results rather than from a generic
syllabus.

**Tests you under real conditions.** The mock exam is 135 items over 197 minutes
in the order MEPS administers them, with the official per-section clocks.
Assembling Objects items are real spatial puzzles in both programme item
families, fit-together and labeled-connection, rendered from geometry with
the answer computed rather than hand-keyed. Mechanical Comprehension items
carry rendered diagrams, because every officially published MC sample does.

**Scores you honestly.** Subtest standard scores (mean 50, SD 10), the Verbal
Expression composite with its true WK/PC weighting, the AFQT percentile, and all
ten Army line scores on the Army's average-100 reporting scale using the
published '97-metric composite weights. Fidelity to the real item formats is documented in [docs/REAL-TEST-FIDELITY.md](docs/REAL-TEST-FIDELITY.md), and the method in
[docs/SCORING.md](docs/SCORING.md) and enforced by tests.

**Tells you which jobs that opens.** All 156 enlisted MOS that DA Pam 611-21
chapter 10 section C specifies - every one of them, each carrying its aptitude
gate (including every either/or alternative the pamphlet prints), a per-MOS
source reference, and a note when the pamphlet publishes no aptitude requirement
at all. Nine officer and warrant officer pathways carry the GT 110 requirement
behind them. Eligibility is computed against your real score, with a near-miss
list and the arithmetic for closing each gap. The roster was diffed against the
whole of section C on 26 October 2026: the diff, the counts and everything the
app deliberately does not claim are in [docs/MOS_GAP.md](docs/MOS_GAP.md), and
that date is shown on the jobs screen, in Settings and in the glossary.

**Revisits what you missed.** Every question you miss or flag enters a spaced-repetition queue and comes back after one day, then three, then seven, then twenty-one, and graduates after four clean retrievals. A backlog outranks every other recommendation on the dashboard, because coming back to a missed question is worth more than new material.

**Then teaches.** 48 reinforcement lessons, one per skill, selected by weakest
skill and finished with a mastery check. Every question in the bank carries a
worked explanation that is reused inside the lesson flow.

**Paces you.** The target date and daily minutes you set at onboarding become a
week-by-week schedule: how many skill cycles fit, how many full mocks fit, and a
straight answer on whether the budget is enough.

**Survives an interruption.** A three-hour mock on a phone can be interrupted by
a call, a dead battery or the operating system reclaiming memory. The attempt in
progress is written to disk after every answer, and the next launch offers it
back at the exact question it stopped on, with the same options in the same order
and the clock where it left off. The clock itself counts real seconds, not
ticker ticks, so a backgrounded app never quietly gains time.

**Explains itself.** Every abbreviation in the app - AFQT, VE, SS, GT and the ten
line scores, the nine subtests, MOS gates, PiCAT and Vtest - is spelled out in a
glossary reachable from the dashboard, the report and Settings. No label is
allowed to be cut off: a test walks the render tree of every screen at phone,
small-phone and tablet widths and fails if any text had to drop words.

**Updates itself.** The app can check GitHub for a newer build, download it and
hand it to Android's own installer, so a phone or tablet running an old copy can
be brought up to date without a cable. It is the only reason the app uses the
network, it can be switched off, and the download and install still go through
Android's confirmation.

**Shows you the trend.** Attempt history, per-subtest sparklines, a skill mastery
grid and streaks, all persisted locally on the device.

---

## Quick start

```bash
flutter pub get
flutter run -d chrome          # web
flutter run -d <device-id>     # Android phone or tablet
flutter test
flutter build web --release --base-href "/asvab-coach/"
flutter build apk --release    # installable Android app
```

Requires Flutter 3.47+ (Dart 3.13+). No native dependencies, no backend: all
state lives in the browser's local storage on web, and in the app's private
storage on Android.

### Android

The same codebase builds an installable APK, so the whole coach - 447 items, 48
lessons, the scoring engine and the personas - lives on the phone with no
connection, no account and no server.

- **No permissions at all**, not even `INTERNET`. The app never opens a socket,
  so it has nothing to ask for, and it does not ask.
- The APK lands at `build/app/outputs/flutter-apk/app-release.apk` (about 52 MB
  universal; use `--split-per-abi` for ~18 MB per architecture).
- Release signing uses a keystore kept out of version control; **back up
  `android/keystore.jks` and `android/key.properties`** or you will not be able
  to publish an update over an existing install.
- CI builds an APK on every push and uploads it as an artifact, so there is a
  downloadable build for any green commit.

Full details, including sideloading and the signing story, are in
[docs/ANDROID.md](docs/ANDROID.md).

---

## Architecture

```
lib/
  core/theme/          design tokens + Material 3 theme builder
  core/routes.dart     navigation helpers
  data/models/         catalog (subtests, skills), question, polyomino,
                       line_score, score, exam, mos, lesson
  data/bank/           447 questions, 48 lessons, 57 spatial puzzles,
                       plus line art for tool and mechanical items
  data/repos/          MOS catalogue, serialization, browser storage
  engines/             scoring, exam builder, adaptive coach,
                       eligibility, persona simulation
  state/               AppState (persistence), ExamSession (test runner)
  screens/             onboarding, dashboard, exam, results, review, jobs,
                       plan, lesson, progress, test centre, settings, QA lab
  widgets/             theme primitives, hand-rolled charts, puzzle renderer
```

No state-management framework beyond `ChangeNotifier` and `provider`, and no
charting package: the readiness gauge, radar, sparkline and timer ring are
hand-written painters, which keeps the bundle small and the visuals coherent.

### Design decisions worth knowing

- **Answer options are reshuffled every attempt.** The permutation is persisted
  with the attempt, so a finished test replays exactly as it was sat while answer
  position can never be learned as a shortcut.
- **Answers are stored in bank coordinates, never display coordinates.** This is
  the most bug-prone boundary in the app and it has a dedicated test.
- **Correctness for Assembling Objects is computed, not declared.** A candidate
  assembly is legal only if its pieces match as a rotation-invariant multiset, no
  two pieces overlap, and the result is one joined body. `bank_integrity_test`
  asserts every puzzle has exactly one legal option, so an authoring typo cannot
  ship a question with two right answers.
- **An interrupted attempt resumes with its questions pinned by id, not by seed.**
  The snapshot stores the question ids and the option permutation per item, so
  resuming replays exactly what was on screen even if the bank has been edited
  since; a snapshot the bank can no longer serve is refused outright rather than
  silently replaced with different questions.
- **The section clock does not run during the section introduction**, and it is
  derived from elapsed wall time, so it reads the same after the app has been away.
- **Every number in the score report is traceable** to a documented formula, and
  the app says plainly that it is not an official score.

---

## Testing

```bash
flutter test
```

| Suite | What it proves |
| --- | --- |
| `bank_integrity_test` | No duplicate ids, four distinct choices, every item has a teachable explanation, every skill has questions behind it, every AO puzzle has exactly one legal assembly in both item families, mirroring a piece is rejected while rotating it is accepted, and the item-quality audit is clean. |
| `mos_roster_test` | The job roster itself: unique codes, every entry carrying either a published gate or an explicit "no aptitude requirement", every gate structurally sound with no off-scale values, every career field and category resolvable, the filter-chip counts equal to the data behind them, the nine codes the pamphlet restricts to another component marked rather than advertised, the 97 legacy ids still resolving, and the verified-as-of date present and checkable. |
| `scoring_test` | Half-right lands on the national mean, the conversion is monotonic and clamped, every Army composite returns 100 for an average applicant, GT follows the published slope, AFQT is monotonic and clamped, category bands match the 1997 scale. |
| `exam_flow_test` | The mock has the official structure (10 sections over 9 subtests, because Auto and Shop are administered separately, 135 items, 197 minutes), shuffling never breaks the answer mapping, answering everything correctly maxes the report while answering nothing bottoms it out, a session advances through every section, and a finished attempt survives a JSON round trip. |
| `personas_test` | Seven synthetic learners scored through the real engines: a strong candidate outscores a weak one, a pure guesser stays below the AFQT 31 floor, an officer-minded candidate clears GT 110, a maths-anxious candidate is coached on maths, and eligibility grows with ability. |
| `review_queue_test` | A missed or flagged question enters the queue due tomorrow, a correct first answer does not, intervals widen 1 to 3 to 7 to 21 days, four clean retrievals graduate it, a wrong review resets it, and a review session contains exactly the questions that were due. |
| `widget_test` | Onboarding renders, advances through all four steps, and lands on the dashboard. |
| `journey_test` | The whole candidate path, driven the way a candidate drives it: onboarding, the placement diagnostic answered by keyboard, the score report arriving on its own, the review, back into the app, a reload, and the reinforcement lesson the coach recommends. A full mock runs all ten sections in the official order, including the separate Auto and Shop blocks. The header finish action, leaving mid-attempt, and the section clock running out all end correctly. The core loop is also driven at phone width. |
| `screen_layout_test` | Every screen paints without a framework exception at phone width, plus the first-run dashboard and an intermediate width. Overflow stripes are not a crash a candidate can read, so this is the guard for the whole class. |
| `exam_screen_layout_test` | The runner specifically: a reading passage, a diagram, an assembly puzzle, a phone, and an answer being recorded. |
| `storage_recovery_test` | A corrupt or partially evicted store never bricks the boot and never costs more than the records that were actually unreadable: one bad attempt leaves the goal, the theme and the streak intact, a bad key does not discard the others, and the dashboard says what could not be read instead of quietly presenting an empty history. |
| `settings_and_review_test` | Dark mode persists, the history export reaches the clipboard, erase-all really clears the store, and a due review session advances the spaced-repetition schedule. |
| `truncation_test` | Every screen at phone, small-phone and tablet width is walked for text that actually dropped words. Real font metrics, so a label that fits on a phone is not reported and one that does not is. |
| `update_test` | Version arithmetic ("1.10.0" beats "1.9.9"), a release payload, an empty answer, a failing server that is reported only when the candidate asked, and the remembered preference. |
| `exam_resume_test` | An interrupted attempt comes back exactly as it was left: the snapshot survives JSON, rebuilt questions keep their option order, a snapshot naming a retired item or a scrambled permutation is refused, the clock charges the real interval after the ticker is suspended, the section introduction costs no time, the dashboard offers the attempt back, and submitting clears it. |
| `screen_layout_test` (large text and small screens) | Every screen also paints at 1.3x and 2.0x system font size and on a 360x640 phone, portrait and landscape. Enlarged text and a sideways phone are the two states a desk-bound test never visits. |

The persona harness is also available in-app under **Settings > QA lab**, so the
whole pipeline can be spot-checked without sitting a two-hour mock. See
[docs/QA-PERSONAS.md](docs/QA-PERSONAS.md).

---

## Data sources and honesty

Nothing here invents a number, and where sources disagree the app says so rather
than quietly picking one. The research trail is committed under
`docs/research/`, including the reports, the machine-readable extracts and the
flagged discrepancies. `docs/research/mos-roster-2025-12.json` is the roster
extract: for each of the 156 enlisted codes, the pamphlet's own qualifying-score
sentence beside the gate the app carries, plus the codes deliberately left out
and the reason.

- **Score scale, AFQT and composite weights** - Segall, D. O. (2004),
  *Development and Evaluation of the 1997 ASVAB Score Scale*, DMDC: section 2.2
  (standard scores), 2.3 (VE), 2.4 and Table 2.5 (AFQT), 2.5.3 and Table 2.7
  (Army composite weights), Table 2.2 (categories). ASVAB Technical Bulletin
  No. 4, Table C.1.
- **Item counts and time limits** - official ASVAB fact sheet, 2025-04 edition.
- **MOS aptitude gates** - DA Pam 611-21 chapter 10 section C (04 December 2025
  build of the MOS Smartbook, fetched through the Internet Archive because
  api.army.mil refuses non-browser clients), with the exact per-MOS section
  recorded on every entry. The roster was last diffed against it on **26 October
  2026**: 194 section headings, 156 substantive enlisted MOS, all 156 carried.
  The working is in [docs/MOS_GAP.md](docs/MOS_GAP.md).
- **Commissioning requirements** - AR 601-210 (20 Mar 2026) paragraph 9-10.
- **Test-day mechanics** - PiCAT rules, retest intervals and the Vtest
  confirmation requirement, from the official fact sheets.

Two discrepancies are surfaced in the app rather than resolved silently:

1. **AFQT bands.** officialasvab.com publishes IVA 21-30, IVB 16-20, IVC 10-15;
   AR 601-210 groups them as IVA 16-30. The app shows the ASVAB reporting bands
   because that is the AFQT's own scale, and documents the Army grouping.
2. **The "GED needs AFQT 50" rule.** It appears in neither the current nor the
   2005 text of AR 601-210. The GED constraint is now a DoD accessions
   quality-mark cap rather than an individual score floor, so it is treated as
   legacy here.

**This is a study tool, not an official score.** Only a test administered at
MEPS - or a proctored Vtest confirming a PiCAT - produces a real ASVAB score, and
only a recruiter can confirm the current aptitude requirement for a given MOS
before you sign.

---

## Continuous integration and deployment

- `ci.yml` runs formatting checks, static analysis, the full test suite and a web
  release build on every push and pull request.
- `deploy-pages.yml` publishes the web build to GitHub Pages on `main`.

Set Pages to **Source: GitHub Actions** and the app is served from
`https://<owner>.github.io/asvab-coach/`.

---

## Known limitations

- Scores are an estimate. ETS item-response equating cannot be reproduced from a
  practice test; the model treats difficulty-weighted accuracy as a percentile of
  ability and says so.
- Saved history is per-device and per-browser. If part of it cannot be read - a
  browser evicting storage, an interrupted write - the app says so on the
  dashboard and keeps whatever was readable rather than silently starting over.
- An interrupted attempt is only kept until you finish it or discard it: there is
  one slot, so starting a new exam replaces the interrupted one.
- The bank is 447 items. A mock draws the official item count per subtest, so
  heavy repeat use will start to repeat questions across attempts.
- Assembling Objects uses polyomino puzzles. They enforce the real subtest's
  rules - rotation allowed, mirroring not, no overlap, one joined body - but real
  AO items are arbitrary line art.
- Everything is local: no sync, no account, no server. Clearing browser storage
  erases your history.
- The job roster is complete against the pamphlet but not against reality: it
  says what DA Pam 611-21 prints, on the date it was checked. Whether a given
  State's National Guard has a slot for a MOS is a live question for a recruiter,
  and the app does not guess at it. Physical demand, PULHES, OPAT, medical and
  clearance adjudication are not modelled at all.

---

## Licence and attribution

Independent study tool. Not affiliated with, endorsed by, or connected to the
Department of Defense, the Department of the Army, the Army National Guard or the
ASVAB Career Exploration Program.