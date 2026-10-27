# Roadmap: from a good coach to a trustworthy one

Each phase is a goal with an acceptance test, not a wish. A phase ships only
when `flutter test`, `dart run tool/audit.dart --strict` and
`flutter analyze --no-fatal-infos` are all green and the commit is pushed.

## Phase 1 â€” The roster must not lie (MOS completeness)

**Goal.** Every enlisted MOS and officer/warrant route the Army National Guard
fields is in the app, carries its line-score gates, and says when those gates
were last verified.

**Why first.** The app is the only place these numbers come from. Telling
someone they do not qualify for a job they do qualify for is worse than telling
them nothing.

**Acceptance.** The roster is diffed against DA Pam 611-21 chapter 10; the gap
list is closed or explicitly deferred with a reason; a test asserts unique codes
and a gate or an explicit "unknown" on every entry; Settings and the jobs screen
carry a verified-as-of date.

**Status (26 October 2026).** Diffed against the whole of chapter 10 section C
(04 December 2025 build). 194 section headings: 156 substantive enlisted MOS, 13
position-reporting or unqualified codes, 25 senior-sergeant/supervisory codes.
The app carried 97, all of them real; 59 were missing and are now in, so the
catalogue holds 156 of 156. Six gates were missing an OR alternative the pamphlet
prints (91B, 91E, 91S, 89B, 94E, 12D) - each of those made a reachable job look
unreachable - and six entries carried a bogus `extraTest: 'Y'/'N'`. Three entries
(18F, 42R, 42S) now say "no aptitude requirement published" instead of reading as
an empty pass, and the nine MOS the pamphlet restricts to another component say
so. `mosRosterVerifiedAsOf` is surfaced in the jobs screen, Settings and the
glossary, and `test/mos_roster_test.dart` enforces all of it. Full report:
[docs/MOS_GAP.md](MOS_GAP.md).

Still open, and deliberately not papered over: per-MOS availability *inside* the
Guard (jobs.nationalguard.com is not machine-readable - a 4.8 KB JS shell and an
HTTP 403), State-level slot availability, and warrant officer MOS as first-class
entries, which needs a schema that can state "service prerequisite, not a score"
before it can be added honestly.

## Phase 2 â€” Explain the wrong answers (per-distractor reasoning)

**Goal.** Every practice item says why each *wrong* option is wrong, not only
why the right one is right.

**Why.** A candidate who picked B and is told only that A is correct learns
nothing. The distractor reason is where the teaching actually happens.

**Acceptance.** The question model carries per-option reasons in bank
coordinates; the review screen renders them; the audit fails an item whose
reasons do not line up with its options; the whole bank is populated and the
audit is clean.

## Phase 3 â€” Tell them the way out (what-if unlock path)

**Goal.** From any job they currently miss, the app names the cheapest concrete
route: which line score, how many points, roughly how many questions, and a
drill aimed at exactly that.

**Why.** Eligibility is a wall until you show its lowest stone.

**Acceptance.** For a chosen MOS the app computes the minimum-point path over
eligible line-score formulas, orders it by points, and starts a targeted drill
in one tap. The maths is unit-tested, including the case where no path exists.

## Phase 4 â€” Walk into the office prepared (recruiter export)

**Goal.** A single on-device page: scores, line scores, AFQT percentile, and
every job currently qualified for, ready to hand over.

**Acceptance.** Generated locally with no upload, readable, dated, and honest
about being an estimate rather than an official ASVAB record.

## Phase 5 â€” Fix what the hardware found

**Goal.** Every defect the phone and tablet audits reported is fixed and the
fix is covered by a test that would have caught it.

Carried in from the audits so far: Android copy saying "this browser" where it
means this device; a stray scroll thumb at the tablet edge; wide layouts that
are plain rather than designed; chart captions at 7-8 sp.

## Deliberately out of scope

Accounts, sync, any server of ours, and any claim to be the real exam. Nothing
about the candidate leaves the device. Only two Android permissions, each
documented with its reason.
## Status

**Phase 1 - complete** (commits 586e2d7, 76ba483). 97 -> 156 enlisted MOS
after the diff against DA Pam 611-21 ch.10 sec.C, zero of the original 97
found invented or retired, three entries marked "no aptitude requirement
published" rather than guessed, no entry left unverified, the normalised
dataset committed next to the diff so the count is reproducible, tests
asserting codes and gates, and the verified-as-of date surfaced in the
glossary. Limitation recorded in docs/MOS_GAP.md: the diff covers
enlisted MOS, not warrant-officer MOS or Guard-only entries the pamphlet
does not list.

**Phase 2 - complete** (commits c34b6d9, ae2b40f, 56f6b02). 447 of 447
items explain every wrong option: 390 written, 57 computed from the
Assembling Objects geometry. The strict audit fails an item whose notes do
not line up with its options. The review card was also grading a bank
coordinate as a display slot, which marked right answers wrong under any
reshuffled attempt; fixed, with a test that records the answer through the
real session path.

**Phase 3 - in progress.** The engine is tested in isolation (22 tests);
wiring it into the job sheet is in flight.

**Phase 4 - in progress.** The formatter is in flight; it was held until
the roster settled so it renders real data.

**Phase 5 - partly done.** Browser copy, the dead Submit control and the
Settings stutter are fixed with guards. The results overflow at enlarged
text, the blank-versus-wrong review badge and the jobs table collision at
411 dp are open.

## Closing status (end of this phase)

**Phase 3 - complete** (69944d4). Engine plus the job sheet: a missed job
names the cheapest raise and whether it alone opens the job; a met job is
told so and gets no route card; with no scored attempt the sheet asks for
one instead of reading every gate as zero. Not built: the one-tap drill
aimed at the short line score.

**Phase 4 - complete** (d1e8bb7, 9250964). Recruiter sheet engine and the
screen that shows it, with a copy action and honest empty states.

**Phase 5 - five of six fixed.** Browser copy, dead Submit, Settings
stutter, the results overflow (18 px, measured) and blank-versus-wrong are
done with guards. Still open: the jobs requirements table kept at three
columns on a 411 dp phone, where the value column collides with the
explanation.

**Deferred on purpose:** job descriptions. `Mos` has no description field
and none was invented. Writing what 156 jobs actually are needs sourced
prose, and a guess in that field is worse than a gap, so it is recorded as
unbuilt rather than half-filled.

Verified at the end of the phase: `flutter test` 460 passing,
`flutter analyze` clean, `dart run tool/audit.dart --strict` clean with
447 of 447 items explained.

## Phase 5 status after the reversion (round 33)

The remaining audit fixes were attempted by three workers in parallel across
seven screens. One quiet full-suite run showed they did not compose: two
RenderFlex overflows of 1174 px and 1692 px in the results/practice screens,
and the recruiter-sheet entry control had been dropped from the report. Those
in-flight edits were reverted rather than repaired blind, their orphaned
tests removed, and the tree re-verified at 608 passing tests.

CLOSED in Phase 5: browser copy, dead Submit, Settings stutter, the results
18 px overflow, blank-versus-wrong review badges, the enlistment requirements
table at 411 dp, the MOS row word-breaks, and every mid-word or clipped
string the row and requirements work uncovered (38 truncated paragraphs went
with it).

OPEN in Phase 5, each needing its own focused pass rather than a shared one:
M5 - results still states a qualification and a percentile from a thin
attempt; M7 - line-score bars have no legend and VE is drawn on the 100-mean
scale; M2 - the previous arrow looks identical enabled and disabled; M4 - one
action still wears four names; M3 - roughly 38% of each item screen is empty;
and the L1-L15 polish items.

Lesson recorded: seven screens in three parallel workers does not compose.
One screen, one worker, verified before the next.

## Phase 5 scoreboard (after round 42)

Closed, with the guard that pins each: browser copy and its test; the dead
Submit control; the Settings privacy stutter and a test that fails on any
repeated sentence; the results 18 px overflow, diagnosed by measurement;
blank-versus-wrong review badges; the enlistment requirements table at
411 dp, stacked below 480 dp with geometry assertions; the MOS row word
breaks, which uncovered 38 truncated paragraphs; M5, the claim of
qualification on two answered items, gated on a documented evidence rule
with three tests including one per required AFQT subtest; M2, the dead back
arrow; M7, the line-score scale collision, fixed with a legend that states
both means.

Open: M4 (one action still wears four names - renaming it touches the
journey, resume and flow tests, which is a coordinated change, not a
rename), M3 (roughly 38% of each item screen is empty), and the L1-L15
polish items, of which none is a correctness defect.

Verified on a quiet tree with no other process running: flutter test 611
passing, flutter analyze clean, dart run tool/audit.dart --strict clean at
447 of 447 items explained.

## Where this stands at round 61

Closed in Phase 5, each with a guard or a verified suite: browser copy;
dead Submit; Settings stutter; results 18 px overflow; blank-vs-wrong
badges; requirements table at 411 dp; MOS row word breaks (38 truncated
paragraphs uncovered); M5 false qualification claim with three tests
including one per required AFQT subtest; M2 dead back arrow; M7 scale
collision with a legend; M4 abandon-vs-submit naming in button and dialog;
L7 unlabelled per-item time; L6 clipped review chip row; L13 goal value
casing; L14 dev-jargon export label; L5 grey-on-grey difficulty pill;
L4 clear-answer alignment.

Open: M3 (about 38% of each item screen is empty), L1, L2, L3, L8, L10,
L11, L12, L15.

CI note, fixed this stretch: device.yml had cancel-in-progress true on a
workflow that triggers on every push, so the fifteen-minute emulator
journey was cancelled by the next commit every time. Five rounds of pending
were self-inflicted. It is now cancel-in-progress false.

## Closed (7e48630)

Every finding in docs/PHONE_AUDIT.md is closed: 3 high, 7 medium and 15 low,
plus M3 (the empty item screen) and the low list in full. Verified on a real
emulator: the Android journey passed on 81ac134 (24m) and again on 7e48630
(19m) after the device workflow was taught to wait for a boot instead of
dying at a timeout. flutter test 620 passed, flutter analyze clean,
dart run tool/audit.dart --strict clean at 447 of 447 items explained.

Two CI defects were found and fixed on the way, both mine: device.yml had
cancel-in-progress true on a workflow that triggers on every push, so the
emulator job was killed by the next commit every time; and a multi-line shell
loop in that workflow dies because the runner hands each line to sh -c.

