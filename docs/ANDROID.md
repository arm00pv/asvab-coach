# The Android app

The same Flutter codebase ships as an installable Android application as well as
a web page. The APK is self-contained: the item bank, the lessons, the personas
and the scoring engine are all inside it, so it works with no connection, no
account and no server.

- **Application id:** `com.arm00pv.asvabcoach`
- **Label:** ASVAB Coach
- **Minimum SDK:** whatever Flutter's current default is (24 as of Flutter 3.47)
- **Version:** taken from `version:` in `pubspec.yaml` - `1.0.0+1` means
  version name 1.0.0, version code 1. Bump both for every release.

## Permissions: none, deliberately

The manifest requests **no permissions at all**, not even `INTERNET`.

That is not an oversight. The app never opens a socket: the item bank is
compiled in, scoring happens on the device, and history is written to the app's
own private storage through `shared_preferences`. It has no use for the camera,
location, contacts, the microphone, or external storage, so it asks for none of
them. An app that requests permissions it does not need is asking the person
installing it to trust a claim that is not true.

The only `INTERNET` entry in the tree is in
`android/app/src/debug/AndroidManifest.xml`, which Flutter adds so the
development tool can attach for hot reload. It is not in the release APK. You
can verify that on a built APK with:

```bash
aapt dump permissions build/app/outputs/flutter-apk/app-release.apk
```

## Building

```bash
flutter pub get
flutter build apk --release
```

The APK lands at `build/app/outputs/flutter-apk/app-release.apk`. That single
file is the whole app, about 20 MB, and installs on any Android phone from
version 6 or later.

Smaller per-architecture builds, if you need them:

```bash
flutter build apk --release --split-per-abi
```

That produces `app-armeabi-v7a-release.apk`, `app-arm64-v8a-release.apk` and
`app-x86_64-release.apk`. Most modern phones want `arm64-v8a`. For sending one
file to a person, prefer the universal `app-release.apk`.

## Signing

The release build is signed with a keystore outside version control:

- `android/keystore.jks` - the key
- `android/key.properties` - its alias and passwords

Both are gitignored. **Back them up.** If the keystore is lost you can still
build a new APK, but Android will refuse to install it over an existing one,
because an update has to be signed by the same key. The candidate would have to
uninstall first, which erases their history.

If `key.properties` is absent - on CI, or on a fresh clone - the build falls
back to the debug key. That is fine for a smoke test and not for distribution.

To make a new keystore:

```bash
keytool -genkeypair -v -keystore android/keystore.jks -alias asvabcoach \
  -keyalg RSA -keysize 4096 -validity 10950
```

then write `android/key.properties`:

```properties
storePassword=...
keyPassword=...
keyAlias=asvabcoach
storeFile=../keystore.jks
```

## Installing on a phone

1. Copy the APK to the phone, or send it however you like.
2. Open it. Android will warn about installing from an unknown source - that is
   the normal prompt for any app that did not come from Play.
3. Allow it for that one app (Files, or your messaging app), then install.

From a computer with the phone attached:

```bash
flutter install --release
```

## What the app stores, and where it goes

Attempt history, the goal, the spaced-repetition queue and theme preference are
kept in the app's private storage. Nothing leaves the device. Uninstalling the
app deletes all of it, and **Settings > Erase all data** does the same without
uninstalling.

`android:allowBackup` is true, so Android's own backup can carry the history to
a new phone if the user has device backup switched on. If you would rather the
history were not included in a device backup, set it to false in
`android/app/src/main/AndroidManifest.xml`.

## The icon and the launch screen

The launcher icon is drawn from a Material glyph - a shield with a check - in the
app's brand green, and is generated rather than pasted in:

```bash
flutter test test/visual/icon_dump.dart --update-goldens
```

That writes `ic_launcher.png` at all five density buckets plus the adaptive
foregrounds, and `mipmap-anydpi-v26/ic_launcher.xml` supplies the adaptive
form for Android 8 and later. The launch window is brand green rather than
white, so the first frame does not flash a colour the app never uses.

Nothing in the icon imitates an official Army or National Guard insignia.

## Continuous integration

`ci.yml` builds the Android APK on every push and uploads it as a build
artifact, so a downloadable APK exists for every green commit without anyone
needing the SDK locally. That build is signed with the debug key because the
release key is not (and must not be) in the repository; build locally with
`android/key.properties` present to produce the distributable one.
