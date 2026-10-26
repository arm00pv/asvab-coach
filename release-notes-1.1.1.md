## Install on your phone

Download **asvab-coach-1.1.1-universal.apk** below and open it. Android will ask
you to allow installs from this source the first time; that is normal for an app
installed outside the Play Store.

This build is signed with the same key as 1.0.0 and 1.1.0, so it installs straight
over an existing copy and keeps your history.

## What changed

**An attempt survives the phone going away.** A mock lasts three hours; a call, a
flat battery or Android reclaiming memory used to end it for good. The attempt in
progress is now written to storage after every answer and again whenever the app
is backgrounded. The next launch shows "Attempt in progress" on the dashboard,
and resuming puts you back on the exact question, with the options in the order
you saw them and the clock where it left off. Submitting or discarding clears it.

**The clock counts real seconds.** It counted timer ticks, and Android throttles
timers for a backgrounded app, so leaving the app behind quietly bought extra
time. It now charges the interval that actually elapsed. Reading a section's
introduction no longer costs any of the section's time either, because the real
test does not charge it.

**The screen stays on during a section.** A sleeping display in the middle of a
timed block is its own kind of bug. The runner sets the keep-awake window flag;
this still adds no permission to the app.

**It fits the text size you actually use.** Every screen was checked at 1.3x and
2x system font size and on a 360x640 phone in both orientations. That found seven
real overflows - the readiness gauge, the hero figures, section headers, the
"do this next" card, the eligibility header, the results subtest rows and the
results app bar - all fixed rather than clipped.

**Housekeeping.** Static analysis is clean at zero findings, and the suite is now
209 tests plus 14 new layout cases.

## Verified on this build

- `aapt dump permissions`: the only entry is Android's own
  `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. No INTERNET, no storage, no camera.
- minSdk 24, targetSdk 36, versionName 1.1.1, versionCode 3.

## Still true

This is a study tool, not an official score. Only a test at MEPS - or a proctored
Vtest confirming a PiCAT - produces a real ASVAB score, and only a recruiter can
confirm the current aptitude requirement for a given MOS before you sign.
