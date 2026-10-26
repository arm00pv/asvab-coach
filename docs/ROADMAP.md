# Roadmap: from a good coach to a trustworthy one

Each phase is a goal with an acceptance test, not a wish. A phase ships only
when `flutter test`, `dart run tool/audit.dart --strict` and
`flutter analyze --no-fatal-infos` are all green and the commit is pushed.

## Phase 1 — The roster must not lie (MOS completeness)

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

## Phase 2 — Explain the wrong answers (per-distractor reasoning)

**Goal.** Every practice item says why each *wrong* option is wrong, not only
why the right one is right.

**Why.** A candidate who picked B and is told only that A is correct learns
nothing. The distractor reason is where the teaching actually happens.

**Acceptance.** The question model carries per-option reasons in bank
coordinates; the review screen renders them; the audit fails an item whose
reasons do not line up with its options; the whole bank is populated and the
audit is clean.

## Phase 3 — Tell them the way out (what-if unlock path)

**Goal.** From any job they currently miss, the app names the cheapest concrete
route: which line score, how many points, roughly how many questions, and a
drill aimed at exactly that.

**Why.** Eligibility is a wall until you show its lowest stone.

**Acceptance.** For a chosen MOS the app computes the minimum-point path over
eligible line-score formulas, orders it by points, and starts a targeted drill
in one tap. The maths is unit-tested, including the case where no path exists.

## Phase 4 — Walk into the office prepared (recruiter export)

**Goal.** A single on-device page: scores, line scores, AFQT percentile, and
every job currently qualified for, ready to hand over.

**Acceptance.** Generated locally with no upload, readable, dated, and honest
about being an estimate rather than an official ASVAB record.

## Phase 5 — Fix what the hardware found

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
