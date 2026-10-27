## Install on your tablet or phone

Download **app-release.apk** and open it. This build is signed with the same key
as 1.0.0 through 1.3.0, so it installs straight over an existing copy and keeps
your history. If ASVAB Coach is already on the device, **Settings > Updates**
offers this release on its own and installs it through Android's own installer.

## What changed

**The plan now knows your test date and your daily minutes.** Until now the plan
ranked what was worth doing by the points each step is worth and said nothing
about when to do it. A candidate who had set a target date and a minutes-a-day
budget still had to invent a cadence between the two. The plan screen now does
that arithmetic out loud: the days that are left, what those days hold at the
minutes a day you stated, what the outstanding work costs, and whether the one
fits inside the other. Every step is costed in minutes - a lesson at its
authored length plus the six minutes its mastery check takes, a drill at twelve,
a review at eight, a full mock at 260 - so the total is a sum of real sittings
rather than a count of items.

**It tells you what to do today.** A "Today" card sits under the schedule and
lists the steps that fall on today in value order, each with its minutes, then
names tomorrow's. Days are counted between midnights, so a daylight-saving shift
inside the window cannot turn 58 days into 57, and the same date and budget
always produce the same schedule. With no target date set it says so plainly
and paces one step at a time; with no minutes a day it says the work left needs
its full length today; with the date already passed it says what is left is due
now.

**It says how much of the plan today covers.** A meter and a line count the
steps: "1 of 6 steps - 17 percent of the plan." That is the honest reading of a
long runway - the point of 58 days is that each day is small, which looks like
nothing until it is written down as a fraction of the whole.

**When the work does not fit, it names the minutes a day it would need instead.**
"Not enough time" is a feeling. "It needs 37 minutes a day instead of 20" is an
answer, and it is the one the card gives, in the same tone as the schedule
header's verdict pill.

**The worked example, from the app's own tests.** The plan that ships here is
six steps of 13, 13, 12, 12, 12 and 12 minutes - **74 minutes** of work in all.
Set a date **58 days** out and **20 minutes** a day and the runway holds **1,160
minutes**, so the work fits with 1,086 to spare; the scheduler paces **one step
a day**, and one of six is **17 percent of the plan done today**. Ask the same
question with the test **two days** away at the same 20 minutes and it does not
fit: 74 minutes across two days is **37 minutes a day**, and the card says so.
Those figures are fixed in the test suite against a fixed day, so the sentence
on screen cannot drift away from the arithmetic behind it.

**A copy bug the new card surfaced is fixed.** Two plan reasons interpolated the
whole priority object instead of its number, so the plan read "Only Instance of
SkillPriority.attempts question seen here so far" instead of "Only 2 questions
seen here so far". Both strings now print the count.

**The schedule card no longer overflows its header on a small phone.** The
verdict pill - "Not enough time", "No time budget" - was pushed right by a
spacer, and on a small phone at 2x text it ran 102 pixels past the card and
painted the overflow stripe. The header now wraps, so a long verdict drops to
its own line and stays legible at any text size.

## Scores are estimates

This is a study tool, not an official ASVAB record. Only a test administered at
MEPS - or a proctored Vtest confirming a PiCAT - produces a real score, and
ETS's item-response equating cannot be reproduced from a practice test.
Everything here is difficulty-weighted accuracy against a documented model, and
the app says so wherever it prints a number. The schedule is likewise arithmetic
on your own stated date and minutes: it does not promise that the plan it paces
will move your score by a given amount, because that depends on the day.

MOS aptitude requirements also change. The roster is what DA Pam 611-21 printed
on 26 October 2026, and that pamphlet is revised between editions, so **confirm
the current requirement for a job with a recruiter before you sign**. The app
also does not guess whether your State's Guard has a slot for a given MOS, or
model physical demand, PULHES, OPAT or clearance adjudication.

## Verified on this build

- versionName 1.4.0, versionCode 103.
- 635 tests green, `flutter analyze` clean, `dart run tool/audit.dart --strict`
  clean at 447 of 447 items explained.
- The scheduler's own tests pin the worked example above to a fixed day: 58 days
  at 20 minutes holds 1,160 minutes against 74, one step a day, 17 percent; two
  days at the same budget needs 37 minutes a day.
