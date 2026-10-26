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