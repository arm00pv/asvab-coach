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