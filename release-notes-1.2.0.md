## Install on your tablet or phone

Download **asvab-coach-1.2.0-universal.apk** and open it. This build is signed
with the same key as 1.0.0, 1.1.0 and 1.1.1, so it installs straight over an
existing copy and keeps your history.

From this version on you do not need a cable again: **Settings > Updates** checks
for a newer release and installs it through Android's own installer.

## What changed

**Nothing is cut off any more.** A test now walks every screen at phone,
small-phone and tablet width and fails if any label had to drop words. It found
real cuts that mattered, and each one is fixed:

- the dashboard's "/135" and "day" suffixes, which had collapsed to a bare "/"
- subtest names on the dashboard, the test centre, plan and progress screens
- job titles, and the verdict pill next to them ("Qualified" showed as "Quali…")
- the enlistment and officer requirement sentences, which were chips too small to
  hold a sentence - they are a readable bulleted list now
- the results title and the lesson title in the app bar
- the runner's section card, which now scrolls when enlarged text makes it tall

Names wrap instead of ending in an ellipsis, and the test measures with real font
metrics so it reports what a phone actually shows.

**Everything in shorthand is explained.** A new glossary - from the dashboard, the
report headings and Settings - spells out AFQT, VE, SS, GT and the other nine line
scores, the nine subtests, aptitude gates, PiCAT, Vtest, DEP and the category
bands, in the words a candidate would use.

**It updates itself.** Settings > Updates shows the build you are running, checks
GitHub for a newer release at launch (you can switch that off), and downloads and
hands the APK to Android's installer. Android asks you to allow installs from
this app the first time; that is the operating system's rule for anything
installed outside the Play Store.

## The permissions changed, on purpose

Two, and only two, each declared where you can read why:

- `INTERNET` - for the update check, and nothing else. It asks GitHub for the
  newest public release. No account, no identifier, no attempt data.
- `REQUEST_INSTALL_PACKAGES` - so the updater can open Android's installer.

No camera, no location, no contacts, no storage.

## Verified on this build

- `aapt dump permissions`: exactly those two, plus Android's own auto-generated
  dynamic-receiver entry.
- versionName 1.2.0, versionCode 4, minSdk 24, targetSdk 36.
- 253 tests, plus a truncation audit across every screen at three widths and
  enlarged system text.
