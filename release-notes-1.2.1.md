## What changed since 1.2.0

Two things the first real-device update found, both fixed:

- **A partial download is thrown away instead of handed to the installer.** A
  download that stopped early produced Android's bare "App not installed" with no
  explanation. The updater now checks the finished size against the release's own
  size, deletes anything short, and reports the real reason.
- **The updater opens the system installer directly.** On a device with another
  app that also handles APK files - a terminal, a file manager - Android put an
  "Open with" chooser in front of the update. It now asks for the package
  installer by name and falls back to the chooser only if there is no package
  installer.

Also: the settings screen said history is "stored in this browser only", and
"1 attempts". Both read correctly on a phone now.

## Install

Download **asvab-coach-1.2.1-universal.apk** and open it, or just let the in-app
updater do it from **Settings > Updates**. Same signing key as every earlier
release, so it installs over the copy already on the device with history intact.

## Verified on this build

- versionName 1.2.1, versionCode 100, minSdk 24, targetSdk 36.
- `aapt dump permissions`: INTERNET and REQUEST_INSTALL_PACKAGES, nothing else.
- 253 tests green, including the truncation audit at three widths.
