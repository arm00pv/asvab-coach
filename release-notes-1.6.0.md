## Install on your tablet or phone

Download **app-release.apk** and open it. This build is signed with the same key
as 1.0.0 through 1.5.0, so it installs straight over an existing copy and keeps
your history. If ASVAB Coach is already on the device, **Settings > Updates**
offers this release on its own and installs it through Android's own installer.

## What changed

**The plan now reflows when days are missed, instead of still assuming you never
stopped.** Until this build the schedule was drawn once and never revisited: a
candidate who went quiet for three days came back to a plan that still assumed
those days had been worked, and the plan said nothing about the difference. The
schedule now reads the date of the most recent attempt in the stored history,
counts the whole days that went by unworked between that day and today - today is
the day in hand, not a missed one - adds the minutes those days were meant to
hold to the work that is left, and divides that by the days remaining to the
target date. What comes out is the pace the plan actually needs now, catch-up
included, rather than the pace it needed on the day it was drawn. It costs
nothing new in storage and needs no migration: the last active day is derived
from attempts already in history, so the reflow works on the history a candidate
already has.

**It says the arithmetic once, and it is a sum rather than a verdict.** One
sentence, in ordinary text and not in a warning colour: no streak broken, no
badge, no count of days thrown away, no advice to do better. A gap the stated
minutes a day still absorb is stated with the number that proves it - three days
away on the 74-minute plan gives "You have not studied for 3 days, so the plan
now needs 2 minutes a day, and the 20 you set still covers it." A plan tight
enough that the gap has pushed the pace past the budget says the new number
instead of the old one: "You have not studied for 4 days, so the plan now needs
43 minutes a day instead of 20." When the gap has pushed the plan past any pace a
candidate could keep, naming that pace would be a number nobody could hold to, so
the sentence names what would have to go - "You have not studied for 16 days, so
the plan needs 187 minutes a day and no longer fits at any realistic pace;
dropping the 2 least valuable steps brings it to 175 minutes a day." The steps it
names are always the tail of the plan in value order, cheapest value first, never
an arbitrary set. Where not one step survives, it says that instead of a number:
"none of the 6 steps fit at 180 minutes a day." The note replaces the bare pace
line rather than joining it, so the card says one thing about the pace and not
two. A candidate who has kept up is told nothing at all, because there is nothing
to recalculate.

**Each Today row now starts that step in one tap.** The Today card used to name
the day's work and stop there: a candidate read "Numbers and order of operations
- 13 minutes" and then had to scroll down to the plan, find that same skill in
the list and tap it there. Telling someone what to do and not letting them start
it is the gap between a plan and a suggestion. Each row on the card is now the
step itself - the whole row is the tap target, never shorter than 48 dp however
small the text is, with a chevron so the card reads as a list of things to open -
and it routes to the same lesson, on the same skill id, that the step card below
it routes to. It is the same route call rather than a second entry point that
could drift away from the first, which is exactly what the test for it asserts:
tap a Today row, and the pushed route must carry the same skill id as tapping the
matching step card.

**A candidate with no history is never told they missed days.** No start date is
invented for someone who has not sat an attempt: with nothing in the record the
schedule is told nothing about activity, so it says nothing about a gap, and a
plan too tight to fit is still not "behind" for a candidate who has not begun.
The same guard covers the cases that are easy to get wrong. Activity dated in the
future cannot make a plan behind. The hour of the last attempt does not matter,
because the comparison is by calendar day and a late-night session counts as the
day it happened. A plan with no steps owes no catch-up minutes whatever the
history says. With no target date, or no daily minutes, there is no cadence to
have missed and no arithmetic to redo, so the gap is not restated against a
number the app cannot compute.

## Scores are estimates

This is a study tool, not an official ASVAB record. Only a test administered at
MEPS - or a proctored Vtest confirming a PiCAT - produces a real score, and ETS's
item-response equating cannot be reproduced from a practice test. Everything here
is difficulty-weighted accuracy against a documented model, and the app says so
wherever it prints a number. The reflow note is arithmetic on a calendar - the
minutes the plan's own steps cost, against the days left to the date you set -
and it claims nothing about a score. It does not say a pace predicts an AFQT, and
the target date in it is the one you chose, not one the app believes about you.

MOS aptitude requirements also change. The roster is what DA Pam 611-21 printed
on 04 December 2025 - chapter 10 section C for the 156 enlisted MOS, chapter 8
section B for the 71 warrant officer occupations - checked on 26 October 2026,
and that pamphlet is revised between editions, so **confirm the current
requirement for a job with a recruiter before you sign**. The app also does not
guess whether your State's Guard has a slot for a given MOS, and it models no
physical demand, PULHES, OPAT, clearance adjudication, evaluation file or
proponent waiver.

## Verified on this build

- versionName 1.6.0, versionCode 105.
- 674 tests green, `flutter analyze` clean, `dart run tool/audit.dart
  --strict` clean at 447 of 447 items explained.
- `study_schedule_test` derives every sentence from the real plan rather than a
  fixture: three days away on 74 minutes of work and 58 days of runway is 114
  minutes at 20 a day, which is 2 minutes a day and still inside the budget; four
  days away on the tight plan is 85 minutes in two days, which is 43; sixteen
  days away in a two-day runway is 374 minutes, which is 187 and drops the two
  twelve-minute drills to land at 175. It also asserts the note is silent for a
  candidate who studied today, for one with no attempts at all, for a plan with
  no steps, and where there is no date or no budget to redo the arithmetic
  against.
- `plan_screen_test` taps a Today row and asserts the route pushed carries the
  same skill id as tapping the matching step card, and paints the reflowed note
  at 360 dp with 2x text, where the chevron must not clip the label.
