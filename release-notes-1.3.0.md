## Install on your tablet or phone

Download **app-release.apk** and open it. This build is signed with the same key
as 1.0.0 through 1.2.2, so it installs straight over an existing copy and keeps
your history. If ASVAB Coach is already on the device, **Settings > Updates**
offers this release on its own and installs it through Android's own installer.

## What changed

**Every job the Guard can actually put you in, with the score it wants.** The
roster went from 97 codes to 156 - the whole of DA Pam 611-21 chapter 10
section C for enlisted MOS - and each one carries its aptitude gate (including
every either/or alternative the pamphlet prints), the line scores that gate is
built from, and a note wherever the pamphlet publishes no aptitude requirement
at all. The date it was checked, **26 October 2026**, is on the jobs screen, in
Settings and in the glossary, because a list of scores with no date on it is a
rumour.

**Every wrong option now says why it is wrong.** All **447** practice items
explain each of the three wrong choices, not just the right one: 390 written by
hand and 57 computed from the Assembling Objects geometry, where the reason is
a rotation that does not fit, a mirrored piece, or two pieces that overlap. The
strict audit fails an item whose notes do not line up with its options, so this
is checked on every build rather than promised once.

**Miss a job and it tells you what it would take.** Open any job your scores do
not clear and the sheet answers: which line score is short, by how many points,
whether that one raise opens the job on its own, and which subtests that score
is made of. A button there starts a practice set aimed at exactly that gap. It
says which questions move the score - it does not promise the score will reach
the gate, because that depends on the day.

**A page for the recruiter's office.** Your report now produces a recruiter
sheet: the AFQT percentile, every aptitude-area score, every job you clear
grouped by career field, and separately the ones you are close to with the exact
raise that would open them. It is plain text wrapped to a phone, so it reads
correctly on screen, in a share sheet or printed, and copies in one tap to hand
over.

**What the jobs actually are.** All 156 codes now carry a two-sentence
description of the work, paraphrased from that MOS's own "Major duties"
paragraph in DA Pam 611-21 - the same authority the gates come from, so the job
and the score cannot disagree. 150 of them also carry a civilian transfer, taken
from the O*NET Military Occupational Classification crosswalk (milx0724, CC BY
4.0, credited in the app), because "what is this worth outside" is the next
question after "what do I need to score". The six codes the crosswalk has no
active Army enlisted record for are left out and named rather than filled in.

**The interface was audited on a real phone, and every finding is closed.** A
Pixel 7 Pro was driven screen by screen and 25 defects were written down - 3
high, 7 medium, 15 low - and each one is fixed:

- **The question screen is no longer half empty.** Roughly 38% of every item
  screen was blank between the last option and the pinned action bar. The
  question, its figure and its options now use that space.
- Review stops filing a correct answer under "Missed", and a question left blank
  is badged "Left blank" instead of being called wrong.
- Practice can be finished early from the top bar, the finish action carries one
  name everywhere instead of four, and the back arrow looks enabled when it is.
- A thin attempt no longer announces "you clear the Army National Guard floor":
  the qualification claim waits until the run actually measured something.
- The enlistment requirements table stacks at phone width instead of squeezing
  three columns into 411 dp, and the 38 truncated paragraphs that work uncovered
  went with it.
- Line-score bars carry a legend that states both means, so VE is not read as
  the same scale as GT.
- The Settings privacy paragraph no longer repeats itself. The rest of the
  low-severity list - alignment, contrast, chip scrolling, casing, unlabelled
  per-item timings - is in too, each with the test that pins it.

## Scores are estimates

This is a study tool, not an official ASVAB record. Only a test administered at
MEPS - or a proctored Vtest confirming a PiCAT - produces a real score, and
ETS's item-response equating cannot be reproduced from a practice test.
Everything here is difficulty-weighted accuracy against a documented model, and
the app says so wherever it prints a number.

MOS aptitude requirements also change. The roster is what DA Pam 611-21 printed
on 26 October 2026, and that pamphlet is revised between editions, so **confirm
the current requirement for a job with a recruiter before you sign**. The app
also does not guess whether your State's Guard has a slot for a given MOS, or
model physical demand, PULHES, OPAT or clearance adjudication.

## Verified on this build

- versionName 1.3.0, versionCode 102.
- 620 tests green, `flutter analyze` clean, `dart run tool/audit.dart --strict`
  clean at 447 of 447 items explained.
- The Android journey passed on a real emulator after the device workflow was
  taught to wait for a boot instead of dying at a timeout.
