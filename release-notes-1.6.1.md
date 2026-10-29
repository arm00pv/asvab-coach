## Install on your tablet or phone

Download **app-release.apk** and open it. This build is signed with the same key
as 1.0.0 through 1.6.0, so it installs straight over an existing copy and keeps
your history. If ASVAB Coach is already on the device, **Settings > Updates**
offers this release on its own and installs it through Android's own installer.

## What changed

**The plan screen no longer prints two different day counts on one screen.** It
said 57 days left in the schedule card and 58 in the Today card two cards below
it, in the same minute, on the same phone. The schedule card was subtracting a
clock reading that carried a time of day from a midnight target date, so Dart
truncated the part day away; the Today card asked the scheduler, which counts
whole calendar days. The screen also read the clock twice, once per card, so the
two were not even counting from the same instant. One schedule is now built once
at the top of the screen and both cards read its days remaining, its minutes and
its status, so there is one clock read and no second subtraction left to
disagree with the first.

**The dashboard carried the same off-by-one and counts whole days now.** Its
header subtitle did the same subtraction against a time-of-day clock reading,
which put it a day behind the plan screen for the whole of any evening. It now
compares whole calendar days, from midnight to midnight, so the two screens
cannot slip apart at 6pm.

The test for it is pinned to an evening time on purpose: run against the old code
it fails 57 against 58, which is exactly what the phone showed. A midnight
fixture would have let the regression through, and did.

## Scores are estimates

This is a study tool, not an official ASVAB record. Only a test administered at
MEPS - or a proctored Vtest confirming a PiCAT - produces a real score, and ETS's
item-response equating cannot be reproduced from a practice test. Everything here
is difficulty-weighted accuracy against a documented model, and the app says so
wherever it prints a number. A day count is arithmetic on a calendar against the
target date you chose, and it claims nothing about a score.

MOS aptitude requirements also change. The roster is what DA Pam 611-21 printed
on 04 December 2025 - chapter 10 section C for the 156 enlisted MOS, chapter 8
section B for the 71 warrant officer occupations - checked on 26 October 2026,
and that pamphlet is revised between editions, so **confirm the current
requirement for a job with a recruiter before you sign**. The app also does not
guess whether your State's Guard has a slot for a given MOS, and it models no
physical demand, PULHES, OPAT, clearance adjudication, evaluation file or
proponent waiver.

## Verified on this build

- versionName 1.6.1, versionCode 106.
- 677 tests green, `flutter analyze --no-fatal-infos` clean, `dart run
  tool/audit.dart --strict` clean at 447 of 447 items explained, `dart format`
  clean across 155 files.
- `plan_screen_test` pins the screen to 21:47 and asserts the schedule card and
  the Today card print the same day count - 58 whole days from 1 January to 28
  February, where the old subtraction gave 57 whenever "now" carried a time of
  day - and that both cards take their minutes and their verdict from that one
  schedule. Three tests, and the whole suite moved 674 to 677.
