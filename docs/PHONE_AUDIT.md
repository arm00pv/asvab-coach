# Phone audit — ASVAB Coach on a Pixel 7 Pro

Bounded pass (layout + copy defects only) over seven screens of `com.arm00pv.asvabcoach`.
Driven headless with adb taps and screenshots; no code was changed.

| | |
|---|---|
| Date | 2026-10-26 |
| Device | Pixel 7 Pro (`cheetah`), 1080x2340 @ 420 dpi = 411 dp wide, portrait |
| Serial | `adb-29241FDH300DLP-dkq9VW._adb-tls-connect._tcp` (tablet never touched) |
| Baseline | system `font_scale 1.0`, light mode, app "Dark mode" off |
| Run under test | General Science **Section Practice** — 15 items, Q1 answered right, Q2 answered wrong, Q13-Q15 left blank, submitted via **Submit exam** |
| Screenshots | `docs/phone-audit/*.png` |

## Defects

| # | Screen | Defect | Severity |
|---|---|---|---|
| H1 | Practice in progress | App-bar **Submit** is drawn in the muted "disabled" styling and does nothing on tap — 15 taps tried across the run, no dialog, no snackbar, no state change. The only working submit is the bottom action that appears on the last question. | High |
| H2 | Review | **Missed (15)** equals **All (15)**, and the one correctly answered item (Q1, *Troposphere*, green tick) is filed under the Missed filter and badged **Missed**. Counter and filter disagree with the results screen's own *CORRECT 1/15*. | High |
| H3 | Settings | YOUR DATA copy is duplicated and mangled: "4 attempts and 372 practice questions. **Everything is stored practice questions. Everything is stored on this device only** - no account, no server, and no attempt or score ever leaves it." | High |
| M1 | Review | Items that were never answered are badged and styled exactly like wrong answers (red **Missed** chip, correct option in green), with no "left blank" marker — the user cannot tell "I got this wrong" from "I skipped it", even though the submit dialog and the Pace card both treat blanks as their own category. | Medium |
| M2 | Practice in progress | The previous-question arrow is visually identical in both states: on Q1 (nothing to go back to) and on Q14 (back enabled) it is the same faded grey circle. No state is legible. | Medium |
| M3 | Practice in progress | Roughly the bottom 38% of the viewport is empty on every item — options end mid-screen, the progress bar and action bar are pinned to the very bottom, nothing bridges the gap. | Medium |
| M4 | Practice setup | One flow, four names: header **Section Practice**, "SECTION 1 OF 1", "Begin **section**", secondary action **Leave exam**, final action **Submit exam**, confirmation **Finish the exam?** | Medium |
| M5 | Results | A single-subtest practice with 13 of 15 items blank yields a full AFQT/GT/VE/line-score report headed **"You clear the Army National Guard floor"** with "QUALIFIES / Category IIIB" and "52 of 97 jobs" — the amber "practice tends to flatter" caveat sits three cards further down, below the verdict. Same root cause makes the Jobs tab say "Scored against your latest attempt (AFQT 48, GT 100)". | Medium |
| M6 | Jobs | The **Enlistment requirements** table keeps a three-column desktop layout at 411 dp: the explanation column is ~40% wide so every row wraps to four or five lines while the label column wastes ~30%. On the *Computer test* row the value "Answer everything" runs straight into the explanation — "Answer everything On the CAT-ASVAB a blank item…" — with no gutter between the columns. | Medium |
| M7 | Results | Line-score bars are colour-coded green / amber / blue with no legend (99 is amber, 100 is green), and VE — a "subtest scale, mean 50" score — is drawn as the same bar as the 100-scale GT/ST/CL rows, inviting a comparison the scales do not support. | Medium |
| L1 | Dashboard, Results | "CORRECT 1 /15": the "/15" sits on a raised baseline, not shared with the "1", and has no space around it. | Low |
| L2 | Dashboard | Header subtitle wraps to leave the orphan word "date" alone on line two, and its hyphen chain ("Officer track - GT 110 target - 59 days to your target date") duplicates the target date that Settings already shows. Body copy also writes "17 percent mastery" where the rest of the app uses numerals. | Low |
| L3 | Practice in progress | Stem punctuation is inconsistent: Q1 ends "?", Q2 ends "…is called" and Q14 "…is caused mainly by" with no terminal punctuation at all. | Low |
| L4 | Practice in progress | **Clear answer** (x icon and label) is inset ~8 dp from the option cards' left gutter, so it does not align with the stem or the cards. | Low |
| L5 | Practice in progress | The *Medium* difficulty pill is grey-on-grey and much weaker than the green *Easy* pill — same component, two contrast levels. | Low |
| L6 | Review | The filter chip row overflows the right edge; a chip is sliced in half at the screen edge with no fade and no scroll hint. | Low |
| L7 | Review | Bare "15s" / "44s" / "2s" per item, top-right of each card, with no label saying it is time spent. | Low |
| L8 | Results | Rows with a wrapped sublabel (Field Artillery, Mechanical Maintenance, Operators and Food) become three-line rows whose score and bar align to the first line only, breaking the list rhythm. | Low |
| L9 | Results | Sibling captions differ in case: "officer gate 110" (lowercase) under GT next to "VE composite" under Verbal. | Low |
| L10 | Jobs | Two sibling stats are styled differently: "34 within reach" is an amber pill, "11 further out" directly beneath it is plain grey text. | Low |
| L11 | Jobs | The Qualified / Within reach / Every job chip row sits flush on the bottom navigation with zero gap. | Low |
| L12 | Settings | The Dark mode card carries a large empty band above its label that the neighbouring cards do not. | Low |
| L13 | Settings | YOUR GOAL values are lowercase booleans ("yes", "none") under title-case labels, and "Target date: 59 days out" reports a countdown where the user set a date. | Low |
| L14 | Settings | "Copy history as JSON" is a developer affordance in a user settings card, sitting immediately above "Erase all data". | Low |
| L15 | Practice setup | "SECTION 1 OF 1" is noise on a single-section practice. | Low |

Summary: 3 High, 7 Medium, 15 Low.

## Prioritised list

### 1. H1 — the practice app-bar Submit is a dead control (High)
**Screen:** practice in progress. **Observed:** tapped at the app-bar control on Q1, Q2, Q14 and Q15; nothing happens — no dialog, no snackbar, no disabled-state explanation, the clock keeps running. The button also *looks* disabled the whole time (muted grey label, no ripple emphasis), while the bottom action bar shows a live "Next". On the last item the bottom action flips to **Submit exam**, which does work and does open the "Finish the exam?" dialog.
**Impact:** the one affordance a test-taker looks for when they want to stop early — finishing mid-run — appears broken. Either it is a stub left in the app bar, or it is enabled only when all items are answered and never says so.
**Fix direction:** either remove it, or make it the real finish entry point and give it an enabled state once at least one answer exists, with the same confirm dialog the bottom action uses.

### 2. H2 — Review files a correct answer under "Missed" (High)
**Screen:** Review, reached from the results app bar. **Observed:** chips read All (15) / **Missed (15)** / Flagged (0). With Missed selected, the first card is Q1 "Nearly all weather on Earth occurs in which layer of the atmosphere?" — *Troposphere* in a green correct-answer frame with a tick — badged **Missed**. The results screen for the same run says CORRECT 1/15, so the badged set is off by one and includes the item that earned that 1.
**Impact:** the review screen is the learning surface; telling a user they missed the one thing they got right destroys trust in every other badge. It also makes the Missed chip useless as a filter (it equals All).
**Fix direction:** drive the chip counts and the per-card badge from the same per-item outcome enum the results screen already uses (correct / wrong / blank).

### 3. H3 — Settings has a duplicated, broken sentence (High)
**Screen:** Settings, YOUR DATA card. **Observed text:** "4 attempts and 372 practice questions. Everything is stored practice questions. Everything is stored on this device only - no account, no server, and no attempt or score ever leaves it."
**Impact:** it is the paragraph that carries the privacy promise; garbled as it is, it reads like a build artifact and undercuts the "no server" claim it is trying to make.
**Fix direction:** re-render as "4 attempts and 372 practice questions. Everything is stored on this device only — no account, no server, and no attempt or score ever leaves it."

### 4. First wave after those
- **M1** review: give blank items their own badge ("Left blank") instead of reusing Missed.
- **M2** practice: make the back arrow's enabled state actually readable (it is the only way to revisit an item).
- **M5** results/jobs: gate the AFQT/GT/line-score verdict on what the run actually measured, or lead with the caveat instead of the verdict headline.
- **M6** jobs: collapse the requirements table to label-over-description rows at phone width, and stop the value column colliding with the explanation.
- **M3** practice: fill or reclaim the empty lower half of the item screen.
- **M4** practice: pick one word (section or exam) and use it in the header, the secondary action and the confirmation.

### 5. Copy and polish
L1, L2, L3, L9, L13, L15 are pure copy/typography; L4, L5, L6, L7, L8, L10, L11, L12, L14 are spacing, contrast and affordance nits. None of them block a user.

## Could not check
- **Accessibility tree.** This is a Flutter app and exposes no semantics to `uiautomator` (the dump is a single opaque node), so everything above is visual only. No text-tree, font-size or 42 dp tap-target measurements were possible; contrast ratios are eyeballed from screenshots, not computed.
- **H1's root cause.** I never had all 15 items answered, so I cannot say whether the app-bar Submit is permanently dead or only enabled once nothing is blank.
- **Large text.** Audited at font_scale 1.0 as instructed; the 1.3 and 2.0 overflow pass was not run.
- **Dark mode.** The app's own toggle was left off; system dark was disabled for the audit, so app-vs-system theme behaviour is untested.
- **Screens outside the brief:** Plan tab, lesson screens, MOS/job detail, Progress tab, MOS search results, empty and error states, orientation changes, keyboard states.
- **Ring gauge.** The dashboard/results arc for a 48th-percentile value looks like it sweeps ~60% of the circle. My pixel sampling at the estimated centre and radius did not converge, so this is an unverified suspicion, not a finding.
- **Tablet.** Not touched, by design.

## Device state
Left as required: `font_scale 1.0`, `cmd uimode night no` (light), app force-stopped, temporary `/sdcard` captures deleted.
Note for whoever runs this next: the phone arrived at **font_scale 2.0 with system dark mode on**, not at the stated baseline, so the first action was to reset it to 1.0 / light.
