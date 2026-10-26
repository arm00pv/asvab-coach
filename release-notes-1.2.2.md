## What changed

**The download is verified against GitHub's own checksum.** GitHub publishes a
SHA-256 for every release asset, and the updater now carries it through, hashes
what it downloaded, and throws the file away if the two disagree. Together with
the existing size check that means an update is either exactly the file that was
published or it is not installed at all.

Small copy fix: the update card now mentions the Play Protect scan, which appears
for anything installed outside the Play Store.

## Where updates come from

Straight from this repository, with nothing in between:

1. `GET https://api.github.com/repos/arm00pv/asvab-coach/releases/latest`
2. the newest asset, `asvab-coach-<version>-universal.apk`
3. downloaded and verified against the SHA-256 GitHub published for it
4. handed to Android's own installer

Any network with ordinary internet access works - home Wi-Fi, a hotel, a hotspot
on mobile data. There is no server of ours to reach, and no VPN or port to open.

## Verified on this build

- versionName 1.2.2, versionCode 101.
- 254 tests green, including the updater's checksum pass-through.
