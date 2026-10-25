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

**Tells you which jobs that opens.** 97 National Guard MOS transcribed from
DA Pam 611-21 chapter 10 section C, each carrying its aptitude gate and a
per-MOS source reference, plus nine officer and warrant officer pathways and the
GT 110 requirement behind them. Eligibility is computed against your real score,
with a near-miss list and the arithmetic for closing each gap.

**Revisits what you missed.** Every question you miss or flag enters a spaced-repetition queue and comes back after one day, then three, then seven, then twenty-one, and graduates after four clean retrievals. A backlog outranks every other recommendation on the dashboard, because coming back to a missed question is worth more than new material.

**Then teaches.** 48 reinforcement lessons, one per skill, selected by weakest
skill and finished with a mastery check. Every question in the bank carries a
worked explanation that is reused inside the lesson flow.

**Paces you.** The target date and daily minutes you set at onboarding become a
week-by-week schedule: how many skill cycles fit, how many full mocks fit, and a
straight answer on whether the budget is enough.

**Shows you the trend.** Attempt history, per-subtest sparklines, a skill mastery
grid and streaks, all persisted locally in the browser.

---

## Quick start

```bash
flutter pub get
flutter run -d chrome
flutter test
flutter build web --release --base-href "/asvab-coach/"
```

Requires Flutter 3.47+ (Dart 3.13+). No native dependencies, no backend: all
state lives in browser local storage.

---

## Architecture

```
lib/
  core/theme/          design tokens + Material 3 theme builder
  core/routes.dart     navigation helpers
  data/models/         catalog (subtests, skills), question, polyomino,
                       line_score, score, exam, mos, lesson
  data/bank/           372 questions, 48 lessons, 32 spatial puzzles,
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
| `scoring_test` | Half-right lands on the national mean, the conversion is monotonic and clamped, every Army composite returns 100 for an average applicant, GT follows the published slope, AFQT is monotonic and clamped, category bands match the 1997 scale. |
| `exam_flow_test` | The mock has the official structure (10 sections over 9 subtests, because Auto and Shop are administered separately, 135 items, 197 minutes), shuffling never breaks the answer mapping, answering everything correctly maxes the report while answering nothing bottoms it out, a session advances through every section, and a finished attempt survives a JSON round trip. |
| `personas_test` | Seven synthetic learners scored through the real engines: a strong candidate outscores a weak one, a pure guesser stays below the AFQT 31 floor, an officer-minded candidate clears GT 110, a maths-anxious candidate is coached on maths, and eligibility grows with ability. |
| `review_queue_test` | A missed or flagged question enters the queue due tomorrow, a correct first answer does not, intervals widen 1 to 3 to 7 to 21 days, four clean retrievals graduate it, a wrong review resets it, and a review session contains exactly the questions that were due. |
| `widget_test` | Onboarding renders, advances through all four steps, and lands on the dashboard. |

The persona harness is also available in-app under **Settings > QA lab**, so the
whole pipeline can be spot-checked without sitting a two-hour mock. See
[docs/QA-PERSONAS.md](docs/QA-PERSONAS.md).

---

## Data sources and honesty

Nothing here invents a number, and where sources disagree the app says so rather
than quietly picking one. The research trail is committed under
`docs/research/`, including the reports, the machine-readable extracts and the
flagged discrepancies.

- **Score scale, AFQT and composite weights** - Segall, D. O. (2004),
  *Development and Evaluation of the 1997 ASVAB Score Scale*, DMDC: section 2.2
  (standard scores), 2.3 (VE), 2.4 and Table 2.5 (AFQT), 2.5.3 and Table 2.7
  (Army composite weights), Table 2.2 (categories). ASVAB Technical Bulletin
  No. 4, Table C.1.
- **Item counts and time limits** - official ASVAB fact sheet, 2025-04 edition.
- **MOS aptitude gates** - DA Pam 611-21 chapter 10 section C, with the exact
  per-MOS section recorded on every entry.
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
- The bank is 372 items. A mock draws the official item count per subtest, so
  heavy repeat use will start to repeat questions across attempts.
- Assembling Objects uses polyomino puzzles. They enforce the real subtest's
  rules - rotation allowed, mirroring not, no overlap, one joined body - but real
  AO items are arbitrary line art.
- Everything is local: no sync, no account, no server. Clearing browser storage
  erases your history.

---

## Licence and attribution

Independent study tool. Not affiliated with, endorsed by, or connected to the
Department of Defense, the Department of the Army, the Army National Guard or the
ASVAB Career Exploration Program.