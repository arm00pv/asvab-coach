# ASVAB Test-Taker Reports, 2024–2026 — Ground Truth Mined From Candidates

**Purpose:** tell an item-bank team what real candidates say actually appeared on the CAT-ASVAB / PiCAT in 2024, 2025 and 2026, what surprised them, and — most importantly — **where their practice material misled them**.
**Compiled:** this session, from live retrieval (Reddit via a Redlib mirror, plus Hacker News, Quora, practice-platform data, and officialasvab.com).
**Companion machine-readable file:** `test-taker-reports.json`.

---

## 0. Provenance legend — read before quoting anything here

| Tag | Meaning |
|---|---|
| **[VERIFIED]** | Stated in a document I retrieved this session, with the URL given. Includes official ASVAB program pages. |
| **[SECONDARY]** | Third-party, aggregator, tutor/coach, or platform-data claim; or a Reddit *commenter's* opinion rather than a first-person recounting. |
| **[UNVERIFIED]** | Single first-person anecdote, or a claim I could not corroborate in a second independent source. **Do not build product decisions on these alone.** |
| **[GAP]** | I looked and did not find adequate evidence. Recorded so nobody assumes silence means "nothing there". |

**Evidence-quality rule used throughout:** corroboration counts are **distinct Reddit threads or distinct articles**, counted by hand, 2024+ only unless explicitly flagged older. "One report" means one human. It is never presented as fact.

**Method note / limitation.** Reddit blocks direct JSON and HTML from this network; `pullpush.io` (the Pushshift successor) served ~1,460 comments + 306 submissions before rate-limiting, and the remainder came from a Redlib mirror (`reddit.synth.download`) via a reader proxy. Quora works only through a reader proxy. **YouTube/TikTok comment sections could not be harvested** — that whole source class is a [GAP].

Sample actually mined: **139 opened r/ASVAB, r/Militaryfaq, r/AirForceRecruits, r/newtothenavy, r/nationalguard, r/USMC threads**, of which roughly **35 contain first-person "I took it" narrative** and the rest are study-advice threads. That is a small, self-selected sample: people who post are disproportionately stressed or unusually successful.

---

## 1. What candidates say they actually saw, per subtest

### AR — Arithmetic Reasoning
The most consistently detailed reports, all 2026.

- **Algebraic equation-solving inside a "word problem" subtest** — including `ax + b = c` forms and `x/n + b = c` where the learner forgets the final multiply, plus "decide whether the answer is positive or negative". **1 detailed first-person report (r/ASVAB, 2026)** [UNVERIFIED]. This is the single most useful report in the corpus.
- **Large mixed-number arithmetic** (the reporter's own example involved subtracting mixed numbers in the 18–45 range). Same thread. [UNVERIFIED]
- **Money/cents, decimals, multi-step problems, "which operation do I even use" framing.** Same thread. [UNVERIFIED]
- Corroboration for "AR is mostly algebra rather than arithmetic": **weak**. One detailed report plus **2** generic complaints that "AR/MK wrecked me" (r/ASVAB threads `1vom6vp`, `1ueyghm`) [SECONDARY]. Treat "AR now leans algebraic" as a **hypothesis**, not a finding.
- A separate 2026 commenter says the math was **"different than anything I've ever seen"** despite having taken Algebra and Geometry (r/Militaryfaq, Jul 2026) [UNVERIFIED, 1].

### WK — Word Knowledge
- **Vocabulary difficulty is the top complaint from non-native / long-out-of-school candidates.** One 2026 report (r/Militaryfaq, Jul 2026, trilingual European) says they **guessed on nearly every WK item** and recognised exactly one word. [UNVERIFIED, 1] — but it is a vivid, specific, internally consistent account.
- Format expectation worth designing to: candidates describe WK as **"word X most nearly means"** with four single-word/short-phrase options. A 2025 Hacker News commenter quotes it in exactly that shape. [SECONDARY — two independent sources on format, but the specific word quoted may itself come from prep material]
- **No 2024–2026 report in my sample lists actual words seen.** [GAP] Anyone claiming a "words that appear" list for 2026 is extrapolating.

### PC — Paragraph Comprehension
- **Distractor design, not passage difficulty, is what candidates report as hard.** One 2026 report: "longer passages where the answer choices were VERY similar… the challenge was figuring out which answer was actually supported vs. an answer that sounded reasonable but wasn't directly supported." [UNVERIFIED, 1, but high-quality detail]
- **Passage register**: a 2026 report describes passages written in heavy colloquial/dialect English ("typed just like some Chicago gangster would say them") plus questions that hinge on a **literal detail mentioned in passing** rather than the main idea. [UNVERIFIED, 1 — and note this candidate was describing *practice* tests, so it is evidence about prep content as much as about the real test]
- Counter-evidence: in the same r/Militaryfaq thread, another 2026 test-taker calls **reading and word knowledge "the easiest part"**. [UNVERIFIED, 1] The two views are consistent with a wide ability spread — do not over-fit to either.

### MK — Mathematics Knowledge
- **"Presented differently than I was used to"** — same concepts, unfamiliar surface form. [UNVERIFIED, 1]
- **Geometry was memorised but barely appeared** on one candidate's form, while algebra/exponents did. [UNVERIFIED, 1] This directly contradicts the geometry-heavy emphasis of most prep. See §5.
- Tutor-side consensus (not test-takers): drill **fractions, decimals, percents, order of operations, basic + two-step algebra, geometry formulas**. [SECONDARY — 3+ tutor/coach comments, 2026]
- Platform data (60,534 practice answers, 2026) ranks **geometry (area/perimeter/volume) as the hardest math topic at 54.6% correct**, then number properties 55.9%, exponents/polynomials 56.5%. [SECONDARY — this is accuracy on *their* practice items, not the real test](https://asvabhero.com/hardest-asvab-topics)

### GS — General Science
- Consistently described as **broad, shallow, "common sense" recall** — "science is also just common sense questions" (2026) [UNVERIFIED, 1] and "focus on your weak points" advice. Very little subtest-specific detail exists in my sample. [GAP]
- One 2024 r/ASVAB post asks how much **physics** is really involved, implying prep books overshoot into complicated kinematics. [SECONDARY]

### EI / AI / SI — Electronics and Auto & Shop
- **This is the most under-predicted section by candidates' own admission.** A 2026 test-taker who scored 74 says the thing that surprised them was the **electric/shop questions**. [UNVERIFIED, 1]
- Platform data agrees EI is genuinely hard: **47.6% correct**, with series/parallel circuits the single hardest topic at **45.2%**, Ohm's law 45.9%. [SECONDARY](https://asvabhero.com/hardest-asvab-topics)
- Low scorers' self-diagnosis clusters here too: "struggling with all the math, the **auto and shop info**, and mechanical comprehension" (r/ASVAB, 2024) [SECONDARY].
- A 2026 score sheet from a strong candidate shows the pattern that technical subtests *lag* the academic ones: AFQT 91, but **AS 46** and EI 51 against AO 70 and MC 63. [UNVERIFIED — one score sheet, but mechanically plausible]

### MC — Mechanical Comprehension
- Named in "I'm weak here" posts far more often than described in detail. Platform data: hardest subtest at **46.8%**, with **gears/wheels/axles 45.3%**, forces/friction/pressure 45.7%, inclined planes/hydraulics 47%, levers/pulleys 48.7%. [SECONDARY](https://asvabhero.com/hardest-asvab-topics)
- [GAP] No 2024–2026 first-person report in my sample describes a specific MC item.

### AO — Assembling Objects
Covered in §4 (it deserves its own section).

---

## 2. Which subtests candidates call harder than expected

Ranked by how often volunteers raise it unprompted in my 2024–2026 sample:

1. **AR / MK math** — the dominant anxiety and the dominant post-mortem subject. **~20+ distinct threads**, overwhelmingly from people targeting a line score. [SECONDARY as a *perception* claim — this is solidly corroborated]
2. **WK/PC vocabulary** for anyone not schooled in English. **3 distinct 2026 threads** [SECONDARY].
3. **EI / AS** — "surprised", "didn't study it". **2 distinct 2026 threads + platform data** [SECONDARY].
4. **MC** — rarely described, but the platform accuracy data and the volume of "mechanical is my weak spot" posts both point the same way. **~5 threads** [SECONDARY].
5. **PC** — split verdict: hardest-format complaints from some, "easiest part" from others [UNVERIFIED either way].

**What nobody says:** no report in my sample calls GS or AO the hardest thing they faced. AO is consistently either unmentioned or shrugged at (§4).

---

## 3. Pacing and the timer

This is my weakest evidence area. Honest summary:

- **PiCAT is untimed at home; the ASVAB at MEPS is timed.** This is stated by candidates repeatedly and is the practical fact that most affects practice design. One 2026 commenter: "Picat can be taken from home and **isn't timed**, also have to do a verification test… Asvab is timed and can't be taken at home." [SECONDARY — 3+ threads, 2025–2026, consistent with the official PiCAT description](https://www.officialasvab.com/recruiters/picat/)
- **Candidates describe the anxiety, not the clock.** In ~139 threads I found **zero** reliable "I had N minutes left on AR" style reports. The two closest are "I sat there taking my time" and "I didn't finish everything". [UNVERIFIED]
- The widely-repeated prep-site timings (e.g. "8 minutes for General Science") were **not** echoed by a single 2024–2026 test-taker as their lived experience. [GAP — treat prep-site timings as suspect; see the sibling dossier `asvab-subcontent.md` §1 for the official table]
- **Design implication:** candidates run out of *confidence*, not clock, on AR. Practise untimed-first, then pressure-test; do not build a 30-seconds-per-item simulator, because that is a prep-site fiction.

---

## 4. Adaptive behaviour — what candidates actually describe

**Official rule [VERIFIED]:** "if an examinee answers an item **incorrectly** on the CAT-ASVAB, an **easier** item is selected… If an examinee answers an item **correctly**, then a **harder** item is selected." ([officialasvab.com/applicants/cat-asvab](https://www.officialasvab.com/applicants/cat-asvab/))

**What candidates report:**
- The *belief* is near-universal and correct in direction: "know it's an adaptive test — **the better you do the harder questions it gives you**" (r/ASVAB, Oct 2026) [SECONDARY, 2 threads saying the same thing].
- **No candidate in my sample describes the moment the difficulty steps up** — no "by question 6 it was obvious", no item-count threshold. [GAP] Anyone claiming a specific step size is inventing it.
- Candidates **do** correctly conclude that a hard-feeling form means they were doing well: "since the CAT is adaptive and my first test had a lot of questions I wasn't expecting" (2026) [UNVERIFIED, 1]. This is a real UX failure mode — **harder items get read as failure**, and a coach app should say so explicitly.
- PiCAT→ASVAB drift is the one adaptive-adjacent pattern with multiple 2026 reports: **86 → 73** AFQT (r/ASVAB, Oct 2026) and **98 on a recruiter-administered PiCAT** then anxiety about the real sitting (r/Militaryfaq, Jul 2026). Two different forms + a verification step = score movement, not necessarily "the ASVAB is harder". [UNVERIFIED, 2]

---

## 5. WHERE PRACTICE TESTS MISLED CANDIDATES — the highest-value section

Every item here is a **specific, dated, first-person report**. Read this as a list of failure modes your bank must not reproduce.

### 5.1 Practice that was *too easy* and over-predicted the real score
- **DDRPT 74, 80, 84 on practice → missed the real AFQT cut by 4 points** after ~5 months of study. The candidate's own verdict: "the actual test didn't feel like a lot of the material I had spent so much time practicing." (r/ASVAB, 2026) [UNVERIFIED, 1 — **but the most decision-relevant single data point in this report**]
- **PiCAT 86 AFQT → real ASVAB 73** (r/ASVAB, Oct 2026) [UNVERIFIED, 1]
- Prep sites themselves are described as **"almost too easy"** by a candidate who had already scored well on three of them (r/Militaryfaq, 2026) [SECONDARY]
- A 2026 r/ASVAB commenter evaluating the popular free sites calls them **"ancient"** and recommends alternatives precisely because they are *not adaptive* like the real test. [SECONDARY, 1]

### 5.2 Practice that was *harder* than the real thing (and scared people off)
- **Recruiter's short screening test: 35 → real ASVAB 73**, a week later, after ~4–5 days with *ASVAB For Dummies*. A serving Army recruiter in the same thread confirms the screening test is a **needs-diagnosis tool, not a predictor**. (r/ASVAB, Oct 2026) [SECONDARY — two parties in one thread agree; corroborated by recruiter framing]
- **Net effect: both directions of miscalibration are live.** A candidate who took a free online bank might be over-confident or catastrophising, and neither maps to their AFQT.

### 5.3 Practice tested the WRONG content
- **Geometry over-weighted.** One candidate drilled triangle area, circle area, circumference, `1/2bh`, factorials — then "on my particular test I **barely saw geometry**". [UNVERIFIED, 1]
- **AR under-weighted algebra.** Prep framed AR as arithmetic word problems; the form was heavy on solving linear equations, sign handling, and large mixed-number operations. [UNVERIFIED, 1]
- **EI/AS under-weighted**, again from the candidate's side: surprise at "electric/shop questions". [UNVERIFIED, 1]
- **PC distractor philosophy wrong.** Prep teaches "find the main idea"; the reported items require **literal support discrimination between near-identical options**. [UNVERIFIED, 1]
- **WK register wrong.** Prep vocabulary is schoolbook English; one candidate reports words "that don't even look english" and passages in heavy dialect. [UNVERIFIED, 1 — describing practice material, which makes it a warning about *imitative* banks like ours]

### 5.4 Practice that inflated the score by removing the clock
- **The home PiCAT is untimed**, so home practice at "real test" pace is not real-test pace. [SECONDARY, 3 threads] This is the mechanism behind a lot of the "I scored 90+ at home and 60s at MEPS" folklore.

### 5.5 Practice that was *out of date* or repetitive
- The **US Army ASVAB Challenge app: "the question bank starts getting repetitive"** — reported by a candidate who still scored 98 (r/greenberets, 2024) [SECONDARY, 1]
- Tutor/community answer to "is X still good?" is repeatedly **"those are ancient websites"** (2026) [SECONDARY]

### 5.6 The uncomfortable one
- A 2026 r/Militaryfaq commenter claims **Grammar Hero's YouTube bank "had questions verbatim on the ASVAB"**. [UNVERIFIED, 1] I could not verify this and it would be a leak/reuse allegation if true. **Flagging it because it is the kind of claim candidates act on** — and because it tells you candidates believe verbatim overlap exists, which shapes what they trust.

---

## 6. Score outcomes vs. study effort, and retests

| Report | Study | Result | Source / label |
|---|---|---|---|
| Recruiter screening test 35 → real **73** | ~4–5 days, ASVAB For Dummies, 90% of it on math | +38 vs the screening test | r/ASVAB, Oct 2026 [UNVERIFIED] |
| **97 AFQT** | "only a month of studying", free resource, out of school 20 years, age 38 | 97 | r/Militaryfaq, Jul 2026 [UNVERIFIED] |
| **66 AFQT** | self-described "borderline an idiot", broken English, Grammar Hero | 66 | same thread [UNVERIFIED] |
| **75 AFQT** | no study at all | 75 | same thread [UNVERIFIED] |
| **64 AFQT** | high-school senior, "math threw me off" | 64 | same thread [UNVERIFIED] |
| **74 AFQT** | March2Success | 74 | same thread [UNVERIFIED] |
| **94 AFQT** | studied, then asked for advice anyway | 94 | r/ASVAB, 2026 [UNVERIFIED] |
| **GT 119** on a retake | previous ASVAB >2 years old, forced retake | GT 119, rest 105+ | r/Militaryfaq, Apr 2026 [UNVERIFIED] |
| **19 → 29 AFQT** | 2 h/day for 4 weeks between attempts | still 29 | r/ASVAB, Aug 2026 [UNVERIFIED] |
| Failed **4 times** | unclear; commenters push a physical book + every test in it | — | r/Militaryfaq, May 2026 [UNVERIFIED] |
| **AFQT 23**, **AFQT 16**, 3× fail at 21/16/16 | unclear | — | r/ASVAB [UNVERIFIED, 3 separate] |

**Patterns (all [SECONDARY] at best):** study effort and score are only loosely coupled in these reports; the *outlier* gains (35→73, 97 after a month) are the ones people post. **There is no evidence in this sample that any particular commercial product reliably moves AFQT** — the 74/80/84-on-practice candidate is the counter-example.

**Retest mechanics [VERIFIED]:** one-month wait after the first test, one month again before the second retest, then **six months** between all further retests; an AFQT gain of **20+ points in six months triggers a Confirmation Test (C-Test)**. ([officialasvab.com retest policy](https://www.officialasvab.com/recruiters/asvab-retest-policy/)) Recruiters in-thread add the operational warning that a big jump invites the C-Test [SECONDARY, 2 threads], and assert "**they take your most recent score, not your highest**" [SECONDARY, 3 threads — consistent with policy; worth stating in-app].

---

## 7. Assembling Objects — what the reports actually support

**What AO is, officially [VERIFIED]:** "Ability to determine how an object will look when its parts are put together." ([officialasvab.com sample questions](https://www.officialasvab.com/applicants/sample-questions/)) The official one-line description mentions **only the fit-together family**; it says nothing about a labelled-line/connection family.

**The two-family structure** (parts-assembly vs. connect-labelled-points) is real in prep material and historical ASVAB forms [SECONDARY — e.g. achievable's "Connection Items" page, ASVAB For Dummies ch.12], **but no 2024–2026 test-taker report in my sample distinguishes the two families.** [GAP — this is the single biggest hole in this section. Nobody in 139 threads said "it was all the line-drawing ones" or vice versa.]

What candidates *do* say, 2024–2026:
- **AO is "more logical reasoning than anything"** — a candidate who took it in Apr 2026 and scored GT 119, listing it among the *easy* parts. [UNVERIFIED, 1]
- **AO is frequently the candidate's highest technical subscore.** A 2026 score sheet: AO 70 with AS 46, EI 51. [UNVERIFIED, 1]
- **Nobody studies it and nobody blames it.** Across 139 threads there is no "AO ruined me" post. The pre-2024 record is the opposite: 2021–2022 threads titled *"Taking ASVAB but I can't comprehend Assembly Object at all"* (r/newtothenavy) and *"I've been studying… assembling objects wasn't even mentioned on the paper my recruiter gave me"* (r/AirForceRecruits). [SECONDARY, pre-2024 — cited only to show the perception flipped]
- Platform data splits AO into **3-D object visualisation (46.5% correct)** and **spatial counting/orientation (50.1%)**, with AO overall at 50.8% — i.e. AO is mid-difficulty in practice, not trivial. [SECONDARY](https://asvabhero.com/hardest-asvab-topics)

**Best inference for your bank, and its confidence:** AO is *not* where candidates lose their AFQT (it isn't in the AFQT composite at all), and it is where a well-built spatial bank can look impressive for little cost. **Build both families to be safe, weight fit-together higher because that is what the official description names, and do not invest in AO as a differentiator.** Confidence: medium.

---

## 8. What I could not establish (please don't let anyone paper over these)

1. **No item-level leakage.** Zero verified accounts of specific 2026 items. Everything specific above is one candidate's paraphrase. [GAP]
2. **Pacing.** No credible per-subtest clock data from test-takers. [GAP]
3. **Adaptive step size / question-count thresholds.** Not described by anyone. [GAP]
4. **AO family split on the live form.** Not described by anyone in 2024–2026. [GAP]
5. **YouTube/TikTok comment sections.** Not harvested (blocked/JS-only). [GAP]
6. **Quora value was near zero** — the 2024–2026 answers I reached were generic ("it's like the SAT") or undated. Do not cite Quora as 2026 evidence. [GAP]
7. **Service Academy Forums** yielded nothing on enlistment-test experience — it is an officer-accession community. [GAP]

---

## 9. Illustrative items — MY OWN construction, designed against the reports above

These are **not** real ASVAB items and are **not** copied from any study guide. They are written to the *shape* the 2026 reports describe, so the bank team has a concrete target. Each is labelled with the claim it encodes.

**AR — multi-step with a sign trap** (encodes §1 AR, §5.3)
> A worker's pay is 3 times her hourly rate for every hour past 40 in a week. She worked 47 hours at $12.50/hour. What were her total earnings for the week?
> *(Tests: identify the operation, chain two steps, keep units straight.)*

**AR — mixed-number arithmetic under time pressure** (encodes §1 AR)
> A board 44⅔ inches long has 18¾ inches cut from one end. How long is the remaining piece?
> *(Candidates reported this family; prep books under-serve it.)*

**MK — same concept, unusual presentation** (encodes §1 MK "presented differently")
> If `(x − 7)/3 = −2`, what is the value of `x`?
> *Distractors to include: −13 (sign error on the isolate step), 1 (forgot to remove the division), −1 (sign error on both steps).*

**PC — near-identical distractors requiring literal support** (encodes §1 PC, §5.3)
> Passage: *"All living things carry DNA, including the strawberry in your refrigerator and the bacteria on its skin. A test can recover DNA from a single strawberry."*
> Q: Which statement is best supported by the passage?
> A. The passage explains how DNA testing works. *(plausible, unsupported — the trap)*
> B. The passage states that strawberries carry DNA. *(supported, unexciting)*
> C. The passage argues strawberries are living things. *(overreach)*
> D. The passage compares plant and bacterial DNA. *(unsupported comparison)*
> **Design note: the correct answer must be the boring literal one. That is exactly the discrimination candidates say they failed.**

**WK — register breadth, not obscurity for its own sake** (encodes §1 WK)
> *Frugal* most nearly means: A. wasteful B. thrifty C. generous D. careless
> Include, across the bank, words that are *ordinary but low-frequency in school English* rather than SAT archaisms.

**EI — series vs. parallel, the hardest reported topic** (encodes §1 EI, §5.3)
> Two 6-ohm resistors are wired in parallel across a 12-volt source. What is the total current drawn?
> *(Prep under-serves this; platform data says it is the single hardest topic.)*

**AO — fit-together family, four rotated/exploded options** (encodes §7)
> Show four exploded parts (a bracket, two pins, a plate) and require the candidate to choose the assembled object from four options that differ only by **part orientation** and **one mirrored part**.
> **Design note:** per §7, ship both families, but make fit-together the default and the labelled-line family the minority.

---

*End of report. Every claim above is tagged; if a claim has no tag it is my editorial inference and should be treated as [UNVERIFIED].*
