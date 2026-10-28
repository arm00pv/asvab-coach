## Install on your tablet or phone

Download **app-release.apk** and open it. This build is signed with the same key
as 1.0.0 through 1.4.0, so it installs straight over an existing copy and keeps
your history. If ASVAB Coach is already on the device, **Settings > Updates**
offers this release on its own and installs it through Android's own installer.

## What changed

**The catalogue now has two halves: 156 enlisted MOS and 71 warrant officer
occupations.** Until this build the jobs screen carried the enlisted roster and
said so, which meant a candidate weighing the warrant route could read the whole
of the app and not find a single warrant code in it. DA Pam 611-21 chapter 8
section B - the same 04 December 2025 build of the MOS Smartbook that the 156
enlisted codes were transcribed from, so both halves of the catalogue cite one
edition of one pamphlet - specifies 76 occupation codes. Seventy-one are in. The
other five are recorded as deliberately excluded, with the reason: 011A and 011M
are branch- and MOS-immaterial duty positions rather than occupations, and 255Z,
915E and 948E are CW5 capstones that are non-accession and defer their own duties
to their feeder codes.

**They are a separate branch of the catalogue, not more rows in the enlisted
list.** A warrant officer is appointed from the ranks, so the entry belongs to a
different decision than "what do I enlist as". Nothing about the enlisted
arithmetic moved: the roster still reads 156 enlisted MOS, the eligibility strip
still counts your qualified jobs against the same 153 enlistment targets it
counted before - the three codes the pamphlet has rescinded are named rather than
silently dropped - and every count in the app is computed from the enlisted list
and therefore cannot see a warrant code. No warrant occupation can enter a met
list or a close-to list, and no filter chip counts one. The same search box and
field chips reach both lists, because a
candidate who types "153" means the code whichever list it lives in - but a hit
in the second list is rendered in its own section, under its own warning, rather
than as another row in the first.

**The finding that shaped the model: a warrant occupation does not carry a
line-score gate.** This was the question the app had to answer from the chapter
rather than from the shape of chapter 10. Chapter 8 section B prints a section in
a fixed order - licensing and certification, prerequisites, accession status and
feeder MOSs, SQI/ASI codes, the qualifications for each grade, the duties,
physical demands - and then prints **Qualifying scores**, which are OPAT physical
benchmarks: standing long jump, seated power
throw, strength deadlift, interval aerobic run. They are not aptitude areas.
Across the chapter's 161 pages exactly two occupations name a score at all:
**280A** (Software Operations Technician) and **490B** (Artificial Intelligence
and Machine Learning Operations Technician), each requiring an ASVAB **GT 110
with no waivers**. That is the whole of it.

**So 69 of the 71 carry the printed prerequisites instead of a fabricated gate.**
The alternative was to invent a line score for each one, which is the one thing
this app does not do. Each of the 69 carries the pamphlet's own prerequisite list
- feeder MOS, grade band, course, clearance, physical qualification, board - and
the card prints it under the heading the pamphlet gives it, never as a number.
Where an enlisted MOS with no gate reads "No aptitude gate published", a warrant
occupation with no gate reads "No line-score gate - appointed against
prerequisites, not a score", so the blank is answered rather than left to be
misread. The two that do publish a score print it under "Prerequisites and
aptitude", as one line of a longer requirement.

**It says, where they are listed, that you cannot enlist into a warrant
occupation.** The section opens under a callout titled exactly that, naming what
a warrant board actually weighs - grade, the feeder MOS you already hold,
evaluations, a board, and for the aviation occupations a flight physical - and
telling a candidate who has not served yet that the job they choose now is on the
enlisted list, with the feeder MOS they would need printed with each entry. No
row in that section prints a verdict: no "Qualified", no cheapest line score to
raise, no near-miss arithmetic. The eligibility engine is never asked a question
about a warrant occupation, because it was built to score a line score and a line
score is at most one line of what a board weighs.

**70 of the 71 have a description cited to the pamphlet, and 351Y does not.**
351Y's duties paragraph says only "see AR 614-115", a regulation that chapter 8
does not contain and that was not fetched for this build. So that one entry
carries its prerequisites, its grade qualifications and no description of the
work. An invented sentence about the day-to-day was the alternative, and the app
declines it - the same rule that makes it refuse to invent a gate.

**Two things the chapter contradicts, recorded rather than silently resolved.**
153E is listed as an accession occupation and, in the very next sentence, as
non-accession; the entry carries the contradiction in its note instead of the
reading the app would prefer. 420T is printed twice in the same chapter
(effective 202508 and 202710) and 280A twice identically; the app carries the
current one and says the superseded print exists.

**The gap report now covers the second half.** [docs/MOS_GAP.md](docs/MOS_GAP.md)
used to say plainly that warrant occupations were missing and why that mattered.
It now carries the arithmetic for both halves: 65 `8-XXXX` headings covering 76
occupation codes, 71 carried, 5 excluded with reasons, 2 gated and 69
prerequisite-only, 70 described and 1 not. The check date travels with the data
as `mosWarrantVerifiedAsOf` beside the enlisted roster's own, and both are shown
on the jobs screen, in Settings and in the glossary.

## Scores are estimates

This is a study tool, not an official ASVAB record. Only a test administered at
MEPS - or a proctored Vtest confirming a PiCAT - produces a real score, and ETS's
item-response equating cannot be reproduced from a practice test. Everything here
is difficulty-weighted accuracy against a documented model, and the app says so
wherever it prints a number. The two warrant aptitude gates that exist are the
pamphlet's printed lines, and a candidate who meets GT 110 is a candidate, not an
appointment: a board applies the rest.

MOS aptitude requirements also change. The enlisted roster is what DA Pam 611-21
chapter 10 section C printed on 04 December 2025; the warrant occupations are what
chapter 8 section B of that same build printed; both were checked on 26 October
2026, and that pamphlet is revised between editions, so **confirm the current
requirement for a job with a recruiter before you sign**. The app also does not
guess whether your State's Guard has a slot for a given MOS, and it models no
physical demand, PULHES, OPAT, clearance adjudication, evaluation file or
proponent waiver.

## Verified on this build

- versionName 1.5.0, versionCode 104.
- 654 tests green, `flutter analyze` clean, `dart run tool/audit.dart --strict`
  clean at 447 of 447 items explained.
- `warrant_mos_test` reads chapter 8 section B back from the extract and fails if
  a code the chapter specifies is neither carried nor recorded as excluded; it
  re-derives which sections print an ASVAB score and fails if that set is anything
  other than 280A and 490B; it asserts every one of the 71 requires prior service,
  that none is reachable from an enlisted count, filter, search or eligibility
  verdict, and that 351Y alone has no description.
