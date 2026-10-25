# ASVAB Subtest Content Dossier — What Is Actually Tested (2026 Verification)

**Purpose:** ground-truth specification for an app that generates high-fidelity ASVAB practice items.
**Compiled:** this session, from primary documents retrieved live. **Latest official source located: ASVAB Fact Sheet PDF, upload folder /2026/10/, and ASVAB Career Exploration Program Overview, DD Form 1304-5OV, FEB 2026.**
**Companion machine-readable file:** subtests.json (in this directory).

---

## 0. Provenance legend (read this first)

Every factual claim in this document is tagged:

| Tag | Meaning |
|---|---|
| **[OFFICIAL-VERIFIED]** | Taken directly from a Defense Manpower Data Center / officialasvab.com / USMEPCOM document retrieved this session. Quoted or paraphrased faithfully. |
| **[OFFICIAL-DERIVED]** | Arithmetic or logical inference from verified official numbers (e.g. 15 + 10 = 25 items for VE). |
| **[SECONDARY]** | Published in widely circulated third-party prep material, service recruiting pages, or older DMDC documents; *not* confirmed in the current official fact sheet. |
| **[ESTIMATE]** | My professional judgment about item mix / weight. Not published by the ASVAB program. **Treat as a design hypothesis to be validated with real item-response data.** |

The ASVAB program does **not** publish per-topic percentage weights for its subtests. It publishes (a) the *topic lists* each subtest draws from, and (b) the *difficulty definition* it uses for item writing. Both are verified below and are the authoritative anchors. The weights you will see in Sections 6-14 are [ESTIMATE]s built on top of those verified topic lists.

---

## 1. CRITICAL CORRECTION — the counts and time limits in the brief are outdated

The brief for this report supplied: *GS 16 q / 8 min, AR 16 / 39, WK 16 / 8, PC 11 / 22, MK 16 / 20, EI 16 / 8, AS 11 / 7, MC 16 / 20, AO 16 / 16.* **These do not match the current operational CAT-ASVAB.** They are the numbers endlessly recycled by third-party prep sites; their item counts match the *school* ASVAB Career Exploration adaptive test (CEP iCAT), not the enlistment test, and the times match nothing current.

Current official CAT-ASVAB (10 subtests, 135 scoreable items, 197 minutes):

| Subtest | **CAT-ASVAB items** | **CAT-ASVAB minutes** | Brief said items/min | Verdict |
|---|---|---|---|---|
| General Science (GS) | 15 | 12 | 16 / 8 | **WRONG both** |
| Arithmetic Reasoning (AR) | 15 | 55 | 16 / 39 | **WRONG both** |
| Word Knowledge (WK) | 15 | 9 | 16 / 8 | **WRONG both** |
| Paragraph Comprehension (PC) | 10 | 27 | 11 / 22 | **WRONG both** |
| Mathematics Knowledge (MK) | 15 | 31 | 16 / 20 | **WRONG both** |
| Electronics Information (EI) | 15 | 10 | 16 / 8 | **WRONG both** |
| Auto Information (AI) | 10 | 7 | (brief used a single "AS" row) | **AI and SI are separate subtests on CAT** |
| Shop Information (SI) | 10 | 6 | — | separate subtest |
| Mechanical Comprehension (MC) | 15 | 22 | 16 / 20 | **WRONG both** |
| Assembling Objects (AO) | 15 | 18 | 16 / 16 | **WRONG both** |
| **TOTAL** | **135** | **197** | — | |

**[OFFICIAL-VERIFIED]** — Fact Sheet, table "ASVAB Test Lengths and Time Limits", CAT-ASVAB column; the document itself prints "Total 135 Questions 197 Minutes". Independent corroboration: officialasvab.com/applicants/cat-asvab/ ("Number of Scored Questions" column = 15/15/15/10/15/15/10/10/15/15) and the PiCAT & APT User's Guide v5.9 (USMEPCOM, March 2024), section 1.1, which lists identical item counts for CAT-ASVAB.

### 1.1 The drift is recent and documented

Per-subtest time limits on the CAT-ASVAB have been *loosened* over the last several years, while item counts have been stable at 15/15/15/10/15/15/10/10/15/15 since at least 2020. Verified by extracting the "Test Lengths and Time Limits" table from archived official Fact Sheet PDFs (Internet Archive snapshots of officialasvab.com):

| Fact Sheet edition | GS | AR | WK | PC | MK | EI | AI | SI | MC | AO | CAT total |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 2020-07 | 15/10 | 15/55 | 15/9 | 10/27 | 15/23 | 15/10 | 10/7 | 10/6 | 15/22 | 15/17 | 135 / 173 min |
| 2023-06 | 15/12 | 15/55 | 15/9 | 10/27 | 15/31 | 15/10 | 10/7 | 10/7 | 15/22 | 15/18 | 135 / 198 min |
| 2024-02 | 15/12 | 15/55 | 15/9 | 10/27 | 15/31 | 15/10 | 10/7 | 10/6 | 15/22 | 15/18 | 135 / 198 min |
| 2025-04 | 15/12 | 15/55 | 15/9 | 10/27 | 15/31 | 15/10 | 10/7 | 10/6 | 15/22 | 15/18 | 135 / 197 min |
| **2026-10 (current)** | **15/12** | **15/55** | **15/9** | **10/27** | **15/31** | **15/10** | **10/7** | **10/6** | **15/22** | **15/18** | **135 / 197 min** |

*Cells are items/minutes. The 2023-2024 documents print a total of 198 although the summed column is 197 — a typo carried in the document.* **[OFFICIAL-VERIFIED]**

**Implication for the app:** the current CAT is **not** a speeded test. AR gives 3.67 minutes per item; MK 2.07; PC 2.7; GS 0.8 (48 s/item). The old "8 minutes for 16 GS items" pacing (30 s/item) is a false constraint that trains panic behavior. Use per-item time targets derived from the current table (given per subtest below).

### 1.2 Tryout (experimental) items

The CAT-ASVAB can embed unscored tryout items, in which case the *time limit* is extended but the scored count does not change. **[OFFICIAL-VERIFIED]** — officialasvab.com/applicants/cat-asvab/ publishes a "With tryout questions" column: GS 25 min, AR 113 min, WK 18, PC 75, MK 65, EI 21, AI 18, SI 17, MC 42, AO 38 — against "Number of Possible Tryout Questions" of 15 per subtest. Practically: **an applicant may see up to ~30 items in a subtest, only 15 of which are scored.** An app should not model this; model the 15-scored-item test with the without-tryout time limit.

---

## 2. The five delivery formats (they differ; your app must pick one)

| Format | Where | Subtests | Items | Time limits | Adaptive? |
|---|---|---|---|---|---|
| **CAT-ASVAB** (primary) | All MEPS; internet version iCAT at MET sites | 10 | 135 scored (15/15/15/10/15/15/10/10/15/15) | Strict per-subtest, 197 min total | Yes, 3PL IRT, theta starts at 0.0 |
| **P&P-ASVAB** | Most MET sites | 9 sections (AI+SI combined as **AS**) | 225 (25/30/35/15/25/20/25/25/25) | 11/36/11/13/24/9/11/19/15 = 149 min | No |
| **PiCAT** (unproctored) | Home/library, recruiter-registered | 10 | "similar number of questions" to CAT-ASVAB | **None** (untimed) | Yes; must verify with short proctored Vtest; once per 2 years |
| **APT** (AFQT Predictor) | Anywhere, recruiter access code | 4 (the AFQT subtests only) | Shorter than CAT | **None** | Yes |
| **CEP iCAT** (school / career exploration) | High schools, ASVAB CEP | 8 (no AO in the current CEP table) | **16/16/16/11/16/16/(11+11)/16** | ~90 min session | Yes |

**[OFFICIAL-VERIFIED]** for P&P totals ("Total 225 Questions 149 Minutes"); PiCAT/APT (User's Guide v5.9, sections 1.2-1.3: "unlike the ASVAB ... there are no time limits"; "PiCAT has the same number of subtests and has a similar number of questions as CAT-ASVAB"); CEP iCAT (CEP Overview, FEB 2026, Table 1-1).

**The trap:** the 16-item figures in the brief are the **CEP iCAT** counts. That instrument is a career-exploration test given in schools, is not the enlistment battery, and does not include AO. An app aimed at enlistment must target the CAT-ASVAB 15-item spec and say so on the tin.

### 2.1 Paper-and-pencil detail (if you support P&P mode)

**[OFFICIAL-VERIFIED]**
- 9 timed sections in fixed order; you may review answers *within* a section only; unanswered items are scored **incorrect**, and there is **no guessing penalty** — the Fact Sheet explicitly advises filling in random guesses for remaining items.
- AS is one subtest (25 items) combining auto and shop; the score is *reported* as "AS" on **both** CAT and P&P.
- P&P is not adaptive: the Fact Sheet states it "contains some very easy and very hard questions, but most are of average difficulty."

### 2.2 Computerized detail (if you support CAT mode)

**[OFFICIAL-VERIFIED]**
- 3PL IRT; ability estimate starts at theta = 0.0 (population mean); sequential Bayesian update after each item; final estimate = mode of the posterior distribution.
- **Unfinished items are penalized**: the penalty is "equivalent to the score that would be obtained if the examinee guessed at random on the unfinished items", and it exists to remove "coachable" test-taking strategies. The Fact Sheet states: "If you are running out of time, it is best to continue trying to answer as best as you can rather than filling in random guesses for the remaining items, as the CAT-ASVAB has a penalty for guessing."
- No answer review or change; you may move to the next subtest as soon as you finish one; average examinee takes about 1.5 hours.

**This is the highest-value behavioral fact in the dossier:** the correct P&P strategy (guess everything, no penalty) is the *opposite* of the CAT rule (do not blind-guess; never let the clock expire with items outstanding; the penalty treats unfinished items as random responses). An app that teaches "fill in C when time is short" without conditioning on format is teaching a scoring penalty.

---

## 3. Scoring architecture: AFQT, VE, standard scores, line scores

### 3.1 Standard scores **[OFFICIAL-VERIFIED]**
Subtest scores are standard scores, **mean 50, SD 10**, referenced to a national sample of 18-23-year-olds (1997 norming study, "Profile of American Youth"). About half the population scores at or above 50; about 16% score 60 or above.

### 3.2 AFQT **[OFFICIAL-VERIFIED]**
- Computed from **four** subtests only: **AR, MK, PC, WK**.
- Reported as a **percentile, 1-99**, against the 1997 18-23 norm sample.
- Categories: I 93-99; II 65-92; IIIA 50-64; IIIB 31-49; IVA 21-30; IVB 16-20; IVC 10-15; V 1-9.
- **VE (Verbal Expression)** is a *derived* composite = WK + PC standard scores. It is never an administered subtest: the battery has 10 tests, not 11. **[OFFICIAL-DERIVED]**
- The commonly quoted raw formula **AFQT = 2*VE + AR + MK = 2*(WK + PC) + AR + MK** is **[SECONDARY]**. It is consistent with the verified statement that AFQT uses exactly those four subtests, and with the fact that the verbal pair is weighted double in that expression, but the weights are not published in current official material. Implement it as VE weight 2.0, AR weight 1.0, MK weight 1.0, label it "approximate", and map to a percentile via a norm table — never against your own user base.

### 3.3 What the AFQT weighting means for the app

Of 135 CAT items, only **50** feed the AFQT: WK 15 + PC 10 + AR 15 + MK 15. Verbal is double-weighted inside that numerator, so **WK+PC (25 items) carry the same nominal weight as AR+MK (30 items)**, and each PC or WK item is worth roughly twice an EI/MC/AO item for eligibility purposes. **[OFFICIAL-DERIVED]** Recommended default study priority for eligibility: AR, then WK, then MK, then PC; add EI and MC for technical/job-locked line scores.

### 3.4 Line scores / composites **[SECONDARY - partially UNVERIFIED]**

**Verified:** officialasvab.com states only that "Scores on all of the ASVAB tests are used to determine the best job for you in the military" and that services build composites. **The ASVAB program does not publish composite formulas.** Every formula below is secondary and changes with service policy. Do not hard-code them as truth; encode a configurable table and point users at the governing regulation.

Stable structure: each composite is a **sum of 2-4 subtest standard scores** compared against a job's required value.
- **VE = WK + PC** — universal; feeds nearly every composite.
- **GT (General Technical) = VE + AR** — Army, Navy, Marines, Coast Guard. Highest-confidence secondary formula; effectively universal.
- **Air Force: MAGE** — four composites (Mechanical, Administrative, General, Electronics) built from fixed subtest sums; **G** is generally cited as VE + AR.
- **Navy/Army electronics composites (EL, BEE)** cluster AR + MK + EI + GS.
- **Navy MECH / Army MM** cluster AR + MC + AS + EI.
- **Administrative/clerical composites (CL, ADM)** cluster VE + MK.

App rule: expose composites as an object list with a boolean "verified: false", render GT as the only near-certain entry, and display every other composite as "approximate — confirm with your recruiter."

---

## 4. Evidence-based learning techniques (what the app should actually implement)

Every subtest except AO is coachable content knowledge; AO improves with practice on the *item format*. The techniques below have the strongest evidence base in cognitive psychology.

| Technique | What to build | Evidence |
|---|---|---|
| **Retrieval practice (practice testing)** | Force production, not re-reading. Every review screen is a *question*, not a summary. Answer first, explanation second. Highest-utility technique in the field's reference review. | Dunlosky, Rawson, Marsh, Nathan & Willingham (2013), *Psychological Science in the Public Interest* 14(1), 4-58 — rated **high utility**. Meta-analytic mean effect g about 0.50 (Rowland, 2014, *Psychological Bulletin* 140(6), 1432-1463); g about 0.61 for practice testing vs restudy (Adesope, Trevisan & Sundararajan, 2017, *Review of Educational Research* 87(3), 659-701). |
| **Spaced / distributed practice** | Expanding intervals tied to mastery, with a final review shortly before the test date; the gap should scale with the retention interval. Second "high utility" technique. | Cepeda, Pashler, Vul, Wixted & Rohrer (2006), *Psychological Bulletin* 132(3), 354-380 (spacing beats massing); Cepeda et al. (2008), *Psychological Science* 19(11), 1095-1102 — optimal gap about 10-20% of the retention interval; Dunlosky et al. (2013), high utility. |
| **Interleaving** | Mix item *types* inside a session (AR: ratio, percent, rate; MK: algebra, geometry, number theory) instead of blocking 20 of one kind. Strongest for math and classification learning; weak for simple fact recall. | Rohrer & Taylor (2007), *Instructional Science* 35, 481-498; Taylor & Rohrer (2010), *JARMAC*; Brunmair & Richter (2019), *Psychological Bulletin* 145(11), 1029-1052 — overall g about 0.42, largest for inductive category learning. |
| **Worked-example fading** | For AR/MK/EI/MC: fully worked example, then completion problem (last step blank), then full problem. Fade as accuracy rises. | Sweller & Cooper (1985), *Cognition and Instruction* 2(1), 59-89; Renkl & Atkinson (2003) on fading; Kalyuga, Ayres, Chandler & Sweller (2003) **expertise-reversal effect** — stop showing worked examples once the learner is competent or they hurt performance. |
| **Elaborative interrogation / self-explanation** | After a correct answer, force "why is that right, and why is the attractive distractor wrong?" This is exactly what the reinforcement lessons in Section 15 are for. | Dunlosky et al. (2013) — moderate utility; Bisra, Liu, Nesbit, Salimi & Winne (2018), *Educational Psychology Review* 30, 703-725 — self-explanation prompting g about 0.55. |
| **Error-focused corrective feedback** | Immediate, specific feedback naming the misconception, plus requeue of that item type after a delay. | Butler & Roediger (2008), *European Journal of Cognitive Psychology* — the testing effect is larger with feedback; Hattie & Timperley (2007), *Review of Educational Research* 77(1), 81-112. |
| **Metacognitive calibration** | Ask for a confidence rating before revealing correctness; train users out of the fluency illusion (recognizing a solution feels like being able to produce it). | Koriat & Bjork (2005), *JEP: Learning, Memory, and Cognition* 31(2), 187-194; Dunlosky et al. (2013) on judgment-of-learning overconfidence. |
| **Format-specific strategy training** | Teach the CAT guessing-penalty rule vs the P&P no-penalty rule (Section 2.2). Not a learning technique — a documented scoring lever. | **[OFFICIAL-VERIFIED]** Fact Sheet, pages 1 and 4. |

**What not to build:** passive reading/video as the primary loop (low utility in Dunlosky et al., 2013); re-reading (rated low utility); cramming as the default schedule (fails across the 2-year score-validity window, and retest is gated: one calendar month after the first attempt, another month after the second, then six months **[OFFICIAL-VERIFIED]**).

---

## 5. Difficulty model — verified bands and how to use them

**[OFFICIAL-VERIFIED]** (DMDC, *ASVAB Technical Bulletin No. 4*, section 3.2.3): difficulty is defined by the p-value (proportion answering correctly), and "although the definitions of easy, medium, and hard vary by subtest, in general, the easy ASVAB items had a p value greater than .75, medium difficulty items had a p value between .75 and .45, and hard items had a p value less than .45."

Use exactly these bands in item metadata:

| Band | p-value | App label |
|---|---|---|
| Easy | p > 0.75 | easy |
| Medium | 0.45 <= p <= 0.75 | medium |
| Hard | p < 0.45 | hard |

**Distribution.** On the **P&P** form, "most are of average difficulty" with some very easy and very hard items **[OFFICIAL-VERIFIED]**; a defensible static target is easy 20% / medium 55% / hard 25%. On the **CAT** there is no fixed distribution — item difficulty is targeted at the examinee's current theta. To emulate CAT: start at b about 0, move difficulty by about +/-0.5 to 1.0 logits after each response (a crude 1-parameter approximation of the documented branching rule), and report an ability estimate rather than percent correct. **[OFFICIAL-VERIFIED]** for the branching rule itself ("if an examinee answers an item incorrectly, an easier item is selected ... if correctly, a harder item").

**Never** label an item's difficulty from your own users' accuracy — that is sample-dependent. Use the bands above only with calibrated p-values; otherwise use the [ESTIMATE] labels in this dossier.

---

## 6. General Science (GS)

**(a) Official name and abbreviation.** General Science (GS). Official description: "Knowledge of physical and biological sciences." Domain: Science/Technical. **[OFFICIAL-VERIFIED]**

Official scope statement (CEP Overview): "General Science tests the ability to answer questions on a variety of science topics drawn from courses taught in most high schools. The life science items cover botany, zoology, anatomy and physiology, and ecology. The earth and space science items are based on astronomy, geology, meteorology, and oceanography. The physical science items measure force and motion mechanics, energy, fluids, atomic structure, and chemistry." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT-ASVAB **15** scored (+ up to 15 unscored tryout). P&P **25**. CEP iCAT 16.

**(c) Time.** CAT **12 min** (48 s/item). P&P **11 min** (26 s/item). **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Topic list is official; weights are **[ESTIMATE]**.

| Topic | Weight | Notes |
|---|---|---|
| Life science: botany, zoology, anatomy & physiology, ecology | 0.35 | Largest single block. Cell/organ-system basics, food webs, plant reproduction, body systems. |
| Physical science: chemistry and atomic structure | 0.25 | Elements, compounds, mixtures, periodic-table logic, states of matter, chemical vs physical change, acids/bases, catalysts. |
| Physical science: force, motion, energy, fluids | 0.15 | Density, buoyancy, simple energy transfer, inertia, work/energy vocabulary. Do *not* duplicate MC's mechanics depth. |
| Earth & space science: astronomy | 0.10 | Planets, moon phases, eclipses, seasons, solar system scale. |
| Earth & space science: geology, meteorology, oceanography | 0.15 | Rock types, plate tectonics, weathering, weather fronts, water cycle, tides/currents, atmosphere composition. |

**(e) Difficulty distribution.** CAT: adaptive, no fixed mix. P&P target mix (based on the official "most are average" statement): **easy 25% / medium 55% / hard 20%**. GS is the subtest where a *pure recall* item pool is realistic; roughly half the items are one-step recall (a named fact or definition), half require one inference ("why is air less dense than water"). **[ESTIMATE]**

**(f) Five sample questions.** Items 1-4 are **official published sample items** with official answer keys; item 5 is an original item written to the same specification. Answer indices follow the official published order — an app must shuffle choices at render time.

**GS-1** *Air is less dense than water because*
A. it is lighter. B. its molecules are farther apart. C. its molecules are closer together. D. it moves more quickly and easily.
**Answer: B (index 1). Difficulty: easy.** Density is mass per unit volume; in a gas the molecules are spread far apart, so the same volume holds far less mass. "It is lighter" is the classic trap: a fixed *volume* of air does weigh less, but that is a restatement of lower density, not an explanation.

**GS-2** *Substances that hasten chemical reaction time without themselves undergoing change are called*
A. buffers. B. colloids. C. reducers. D. catalysts.
**Answer: D (index 3). Difficulty: easy.** A catalyst lowers the activation energy and is recovered unchanged at the end of the reaction. A buffer resists pH change; a reducer donates electrons; a colloid is a mixture type — three superficially science-sounding distractors.

**GS-3** *An eclipse of the sun throws the shadow of the*
A. moon on the sun. B. moon on the earth. C. earth on the sun. D. earth on the moon.
**Answer: B (index 1). Difficulty: medium.** A solar eclipse is the Moon passing between Earth and Sun, so the Moon's shadow falls on Earth. Option D describes a *lunar* eclipse (Earth's shadow on the Moon), which is the designed confusion.

**GS-4** *Salt helps to melt ice because it*
A. dissolves in water to form an acid. B. chemically destroys the water molecules. C. lowers the temperature at which water freezes. D. is attracted to concrete sidewalks below the ice.
**Answer: C (index 2). Difficulty: medium.** Dissolved solute particles interfere with ice-crystal formation, depressing the freezing point (freezing-point depression). Salt does not "burn" or destroy water, and the sidewalk-attraction option is a plausible-sounding non-mechanism.

**GS-5** *(original, in official style) Which of the following is an example of a chemical change?*
A. Ice melting. B. Sugar dissolving in water. C. Iron rusting. D. Water boiling.
**Answer: C (index 2). Difficulty: medium.** Rusting forms a new substance (iron oxide) with different properties, which is the definition of a chemical change. Melting, dissolving, and boiling change only physical state or dispersion and are reversible without new substances.

**Common mistakes on GS**
1. Answering the *restatement* instead of the mechanism ("it's lighter" for density) — see GS-1.
2. Confusing solar and lunar eclipse geometry (GS-3).
3. Confusing physical vs chemical change, especially dissolving (GS-5).
4. Reaching for the most technical-sounding option: the ASVAB GS pool is high-school level, and the most jargon-heavy choice is frequently wrong.
5. Over-studying advanced topics (relativity, organic nomenclature) and under-studying the listed curriculum areas — the official list is literal.
6. Treating GS as unteachable trivia and skipping it. It is 15 of 135 items but feeds no AFQT component; it *does* feed science/technical line scores, so it is high value only for technical job locks.

**Top misconceptions that cause wrong answers (for reinforcement lessons)**
- "Gases weigh nothing." (False: they have mass; density is the issue.)
- "Heat and temperature are the same thing."
- "The seasons are caused by Earth's distance from the Sun." (It is axial tilt.)
- "Dissolving is a chemical reaction."
- "Sound travels faster in air than in water."
- "The Moon has no gravity / the far side of the Moon is dark."

**Generator spec.** Two item shapes only: (i) definition/identification stems ("Which of the following is ... ?"), (ii) one-step causal stems ("X happens because ..."). Distractor engine: swap a correct mechanism for (a) a restatement, (b) a paired-but-different concept (solar/lunar, mitosis/meiosis, igneous/sedimentary), (c) a category error. Avoid figure-dependent items entirely.

---

## 7. Arithmetic Reasoning (AR)

**(a) Official name and abbreviation.** Arithmetic Reasoning (AR). Official description: "Ability to solve arithmetic word problems." Domain: Math. **[OFFICIAL-VERIFIED]**

Official scope statement: "Arithmetic Reasoning tests the ability to solve basic arithmetic problems encountered in everyday life. One-step and multi-step word problems require addition, subtraction, multiplication, and division, and choosing the correct order of operations when more than one step is necessary. The items include operations with whole numbers, operations with rational numbers, ratio and proportion, interest and percentage, and measurement." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **15**. P&P **30**. (P&P AR is the longest section.) CEP iCAT 16.

**(c) Time.** CAT **55 min** — **3.67 minutes per item**, the most generous ratio in the battery and a strong signal that AR items are meant to be *worked*, not eyeballed. P&P 36 min for 30 items (72 s/item). **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Official content buckets quoted above; weights **[ESTIMATE]**.

| Topic | Weight | Notes |
|---|---|---|
| Multi-step whole-number word problems (rate, work, distance, unit-rate scaling) | 0.25 | Two or three operations with correct order of operations; the modal AR item. |
| Ratio, proportion, and scaling | 0.18 | Part-to-part and part-to-whole; "one in every N"; recipe/mixture scaling. |
| Percent, interest, discount, tax, percent change, depreciation | 0.22 | Percent-of, percent-increase/decrease, simple interest, sale price. Heavily represented in official samples. |
| Rational numbers: fractions, decimals, mixed numbers | 0.18 | Fraction of a quantity, decimal equivalents, fraction arithmetic in a word context. |
| Measurement, unit conversion, area/perimeter in context | 0.12 | Feet/inches, yards, gallons, time conversion, square measure (the official sample uses sq ft to sq yd). |
| Averages and simple data interpretation | 0.05 | Mean of a set, weighted average. |

**(e) Difficulty distribution.** P&P target: **easy 20% / medium 55% / hard 25%**. Item grammar, not vocabulary, drives difficulty: easy = single-step with the operation named implicitly; medium = single-step with the operation hidden ("how many buses"); hard = two or more steps, or a rate/percent chained with a unit conversion. Official samples span all three. **[ESTIMATE for the mix; the official samples corroborate the range]**

**(f) Five sample questions — all five are official published AR sample items with official answer keys.**

**AR-1** *If the tire of a car rotates at a constant speed of 552 times in one minute, how many times will it rotate in half-an-hour?*
A. 276 B. 5,520 C. 8,280 D. 16,560
**Answer: D (index 3). Difficulty: medium.** Half an hour is 30 minutes, so multiply the per-minute rate by 30: 552 x 30 = 16,560. The distractors are the two most common slips — dividing instead of multiplying (276 = 552/2) and misplacing a zero (5,520).

**AR-2** *One in every 9 people in a town votes for party A. All others vote for party B. How many people vote for party B in a town of 810?*
A. 90 B. 720 C. 801 D. 819
**Answer: B (index 1). Difficulty: medium.** 810/9 = 90 people vote A, so 810 - 90 = 720 vote B. Option A is the answer to the *unasked* question (party A), which is the defining AR distractor pattern; 801 and 819 are arithmetic-noise options.

**AR-3** *A motorcycle costs $7,250. If it depreciates by 12% per year, how much will it be worth after one year?*
A. $870 B. $1,250 C. $5,920 D. $6,380
**Answer: D (index 3). Difficulty: medium.** Depreciation of 12% removes 0.12 x 7,250 = $870, leaving 7,250 - 870 = $6,380 (equivalently 0.88 x 7,250). Option A is the *amount lost*, not the value remaining — the single most common percent-item error.

**AR-4** *It takes 5 seconds for 20 gallons of water to come out of a faucet. At this rate, how many gallons of water comes out in 7 seconds?*
A. 24 B. 26 C. 28 D. 30
**Answer: C (index 2). Difficulty: easy.** The unit rate is 20/5 = 4 gallons per second, so 7 x 4 = 28 gallons. Setting up the proportion 20/5 = x/7 gives the same result; option D comes from adding 20 + 7 or multiplying 7 by 4.3.

**AR-5** *It costs $0.50 per square yard to waterproof canvas. What will it cost to waterproof a canvas truck cover that is 15 feet by 24 feet?*
A. $6.67 B. $18.00 C. $20.00 D. $180.00
**Answer: C (index 2). Difficulty: hard.** Area is 15 x 24 = 360 square feet; at 9 sq ft per square yard that is 40 square yards; 40 x $0.50 = $20.00. Every distractor is a different point in the unit chain: $180 treats feet as yards on one side, $6.67 divides by 54, $18.00 uses 360/20.

**Common mistakes on AR**
1. Solving for the wrong quantity (AR-2, AR-3) — the "asked vs computed" error, the #1 AR loss.
2. Percent-change direction: reporting the change instead of the result.
3. Unit mismatch: feet vs square feet vs square yards (AR-5); minutes vs hours (AR-1).
4. Setting up the proportion upside-down (same answer, wasted time, more error surface).
5. Rounding mid-calculation then rounding again at the end.
6. Doing arithmetic in the head instead of on the scratch paper the CAT provides — the CAT gives 3.67 min/item precisely so you can write.
7. Time panic: leaving items blank at the 55-minute mark. The CAT penalty scores unfinished items as random guesses, so answering is weakly dominant. **[OFFICIAL-VERIFIED]**

**Top misconceptions (reinforcement lessons)**
- "Percent of means divide by the percent." (It means multiply by the decimal.)
- "A 20% loss needs a 20% gain to recover." (It needs 25%.)
- "Unit rate problems can be solved by adding rates."
- "If two rates are given, average them." (Only valid for equal time/quantity shares.)
- "The last number in the problem is the one you compute."

**Generator spec.** Always generate: a context sentence with 2-4 quantities, one asked quantity that is *not* the first quantity computed, and distractors planted at (i) the intermediate result, (ii) an off-by-one-order-of-magnitude of the answer, (iii) a wrong-operation result. Keep numbers integer-friendly (answers that terminate); mirror official magnitudes (hundreds to tens of thousands, dollars with cents).

---

## 8. Word Knowledge (WK)

**(a) Official name and abbreviation.** Word Knowledge (WK). Official description: "Ability to select the correct meaning of a word presented in context and to identify the best synonym for a given word." Domain: Verbal. **[OFFICIAL-VERIFIED]**

Official scope statement: "Word Knowledge tests the ability to understand the meaning of words through synonyms — words having the same or nearly the same meaning as other words. The test is a measure of one component of reading comprehension since vocabulary is one of many factors that characterize reading comprehension." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **15**. P&P **35** (the largest single section on paper). CEP iCAT 16.

**(c) Time.** CAT **9 min** = 36 s/item — the fastest verbal ratio. P&P 11 min for 35 items (19 s/item). This is a *recognition* test: if you have to reason it out, you have already lost time. **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Weights **[ESTIMATE]**; the *shape* is official (synonym + context variants).

| Topic | Weight | Notes |
|---|---|---|
| Single-word synonym ("X most nearly means") | 0.55 | Bare stem, four one-word choices. |
| Word used in a sentence, meaning resolved from context | 0.30 | Official sample: "His record provides no reason for apprehension." |
| Words with secondary or less-common meanings, and confusable pairs | 0.15 | The difficulty engine: the common meaning is the trap. |

Register of the word pool: high-school reading vocabulary and general academic words — not GRE-level, not military jargon. Official samples include *antagonize, wilted, apprehension, quiver, rudiments, variable*. **[OFFICIAL-VERIFIED by example]**

**(e) Difficulty distribution.** P&P target: **easy 30% / medium 50% / hard 20%**. Difficulty is driven by (i) word frequency, (ii) how strongly the distractors overlap the true meaning's semantic neighborhood, and (iii) whether a familiar word is used in an unfamiliar sense. **[ESTIMATE]**

**(f) Five sample questions — all official published WK sample items with official keys.**

**WK-1** *Antagonize most nearly means*
A. embarrass. B. struggle. C. provoke. D. worship.
**Answer: C (index 2). Difficulty: medium.** To antagonize is to provoke hostility or opposition. "Struggle" is the trap because antagonize shares the *conflict* semantic field without meaning "to fight"; "embarrass" captures the social discomfort but not the causation.

**WK-2** *Wilted most nearly means*
A. left. B. limp. C. budding. D. requested.
**Answer: B (index 1). Difficulty: easy.** Wilted describes a plant (or posture) that has sagged from loss of water, i.e. limp. "Budding" is the antonym-flavored trap (growth vs decay) built from the same plant context.

**WK-3** *His record provides no reason for apprehension.*
A. anxiety B. change C. enjoyment D. endorsement
**Answer: A (index 0). Difficulty: medium.** In the sentence, apprehension means anxiety or unease about something anticipated. The designed trap is the *other* dictionary sense of apprehension — "arrest/capture" — and, failing that, the fact that "no reason for apprehension" sounds vaguely positive, pulling solvers toward "enjoyment" or "endorsement."

**WK-4** *Quiver most nearly means*
A. shake. B. dance. C. rest. D. run.
**Answer: A (index 0). Difficulty: easy.** To quiver is to tremble or shake with slight rapid motion. The other three are motion verbs of the wrong kind — the item tests precision within a semantic field, not raw recognition.

**WK-5** *Rudiments most nearly means*
A. politics. B. minute details. C. promotion opportunities. D. basic methods and procedures.
**Answer: D (index 3). Difficulty: hard.** Rudiments are the fundamental elements or first principles of a subject ("the rudiments of algebra"). "Minute details" is the strongest distractor because rudiments *are* small units, but the word denotes fundamentals, not trivia — this is the classic near-miss trap.

**Common mistakes on WK**
1. Choosing a word you can *define* rather than the one that is *closest* — "most nearly means" tolerates neither a cousin nor a category member.
2. Falling for the secondary-meaning trap (WK-3) when the sentence pins the sense.
3. Letting word *sound* drive the choice (elegant-sounding or technical-sounding options).
4. Ignoring the sentence version entirely and answering from the bare word.
5. Spending 90 seconds on one item in a 36 s/item subtest; there is no partial credit and 14 more items remain.
6. Studying 5,000-word lists. The realistic pool is a few thousand mid-frequency academic words; yield comes from *how* they are reviewed (retrieval + spaced), not volume.

**Top misconceptions (reinforcement lessons)**
- "Synonyms must be interchangeable in every sentence." (ASVAB asks for nearest meaning, not identity.)
- "If I've never seen the word, guess the longest option."
- "Words with Latin roots always keep the root meaning."
- "The sentence version is just decoration." (It is usually the only thing disambiguating two close choices.)

**Generator spec.** Two stems: bare ("WORD most nearly means") and in-context. Choice set rule: one correct synonym, one *semantic-field neighbor* (the strongest distractor, mandatory), one *antonym-flavored* or *register* distractor, one unrelated. Never use a distractor that is a hypernym/hyponym of the answer without making the answer's specificity testable — that is what WK-5 is doing, and it must be deliberate.

---

## 9. Paragraph Comprehension (PC)

**(a) Official name and abbreviation.** Paragraph Comprehension (PC). Official description: "Ability to obtain information from written passages." Domain: Verbal. **[OFFICIAL-VERIFIED]**

Official scope statement: "Paragraph Comprehension tests the ability to obtain information from written material. Students read different types of passages of varying lengths and respond to questions based on information presented in each passage. Concepts include identifying stated and reworded facts, determining a sequence of events, drawing conclusions, identifying main ideas, determining the author's purpose and tone, and identifying style and technique." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **10** (the shortest subtest). P&P **15**. CEP iCAT 11.

**(c) Time.** CAT **27 min** = 2.7 min/item, and because passages are shared, effective reading time is generous. P&P 13 min for 15 items. **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** The concept list above is official; weights **[ESTIMATE]**.

| Topic | Weight | Notes |
|---|---|---|
| Main idea / primary purpose of the passage | 0.25 | Whole-passage synthesis; correct answer must cover the *whole* text. |
| Explicit detail and reworded facts ("According to the passage ...") | 0.25 | Answer is verbatim or near-verbatim in the text; tests locating, not inferring. |
| Inference / drawing conclusions / implied meaning | 0.25 | The hardest and most-tested inference type; answer must be *forced* by the text. |
| Vocabulary in context | 0.10 | Common word in an unusual sense inside the passage. |
| Author's purpose, tone, attitude | 0.10 | Usually signaled by adjectives and concessions. |
| Sequence of events / style and technique | 0.05 | Occasional; often a "which happened first" or "the phrase X is used to ..." item. |

Passage types in the official pool: expository science/technical, narrative-literary, and practical/informational. Passages run from roughly 50 to 150 words; several questions can share one passage. **[OFFICIAL-VERIFIED by example from the sample set]**

**(e) Difficulty distribution.** P&P target: **easy 25% / medium 50% / hard 25%**. Difficulty comes from (i) inference vs explicit, (ii) passage abstraction, (iii) distractor plausibility — specifically, distractors that are *true statements in general* but not supported by the passage. **[ESTIMATE]**

**(f) Five sample questions — all official published PC items with official keys.**

**PC-1** *"The eastern part of Texas will ambush the senses of all who enter it with preconceptions of sand and cacti around every bend. It has a look and atmosphere that does not fit the boots-and-saddle image of the state."*
*The author implies that the look and atmosphere of east Texas does NOT resemble that of the*
A. marshlands. B. mountains. C. seashore. D. desert.
**Answer: D (index 3). Difficulty: medium.** "Sand and cacti" is a description of desert terrain, and the sentence says east Texas does not fit that image. The other three are also non-desert landscapes, so the item is won only by mapping "sand and cacti" to "desert" — a reworded-fact/inference hybrid.

**PC-2** *"A thin transparent layer of oxide protects the metal titanium against corrosion. The same thin layer attracts artists interested in making their art with the help of technology. By using heat or electricity, an artist can thicken the oxide layer and thereby turn the metal a range of vivid colors."*
*According to the passage, some artists work with titanium because it*
A. is transparent. B. does not corrode. C. generates its own heat. D. can assume a variety of colors.
**Answer: D (index 3). Difficulty: easy.** The passage says artists use heat/electricity to "turn the metal a range of vivid colors," which is the stated reason artists are attracted to it. Option A inverts the passage (the *oxide layer* is transparent, not the metal); B is true of titanium but never given as the artists' reason.

**PC-3** *"They returned to the beach, where blankets spotted the slope to the water. An advancing wall of clouds, black and gray, darkening the expanse of ground beneath, approached from the west. To the east and above them, the sky remained clear, the sun warm, as if collaborating in the deception."*
*The "deception" referred to in the passage is that*
A. there is no storm approaching. B. the sky is clear in the east. C. it is too cold to swim. D. the sun is warm.
**Answer: A (index 0). Difficulty: hard.** The deception is the false impression of calm: clear sky and warm sun while a storm wall advances. Option B is a *true detail* but not the deception itself — the classic "true but not the answer" distractor; D is likewise a contributing detail, not the referent.

**PC-4** *"The orientation of a large expanse of glass in a house is important. Improperly positioned, it can cost precious fuel dollars, whereas good orientation can minimize heat lost in the winter and gained in the summer. The best direction to face is south, to make good use of solar energy. Since the sun is low in the southern sky during the winter, orienting any glass in that direction will allow light to shine through and help heat the home. During the summer, the sun is higher in the sky, and an overhang from the roof will shield the glass from direct sunlight."*
*According to the passage, large expanses of glass should be positioned to*
A. take advantage of summer sunlight. B. control heat gain and loss. C. shield the house from the low winter sun. D. avoid blockage of sunlight by an overhanging roof.
**Answer: B (index 1). Difficulty: medium.** The passage's stated purpose is to "minimize heat lost in the winter and gained in the summer," i.e. control heat gain and loss; the south-orientation advice is the *method*. A and C invert the passage, and D reverses the overhang's role.

**PC-5** *"Twenty-five percent of all household burglaries can be attributed to unlocked windows or doors. Crime is the result of opportunity plus desire. To prevent crime, it is each individual's responsibility to"*
A. provide the desire. B. provide the opportunity. C. prevent the desire. D. prevent the opportunity.
**Answer: D (index 3). Difficulty: medium.** Given crime = opportunity + desire, and that the only element an individual controls is the lock, the conclusion is to remove the opportunity. The item is a mini syllogism: two of the four options are logically absurd (providing desire/opportunity), which is how the correct answer is isolated.

**Common mistakes on PC**
1. Choosing a statement that is true in the world but not supported by *this* passage (PC-3 B, PC-2 B).
2. Answering a main-idea question with a detail (the correct main idea must cover the whole passage).
3. Over-inferring: the right inference is one the text *forces*, not one it merely permits.
4. Re-reading the passage after every question instead of answering all questions for one passage in one pass.
5. Ignoring absolutes and qualifiers ("always", "never", "some") that make an option indefensible.
6. On the CAT, skipping passages to "save time" — there are only 10 items and 27 minutes.
7. Vocabulary-in-context questions answered from the word's most common meaning rather than the passage's usage.

**Top misconceptions (reinforcement lessons)**
- "If it sounds right, it's right." (Plausibility is the distractor engine.)
- "Inference means guessing." (Inference means a conclusion the text already guarantees.)
- "Main idea = first sentence." (Often the thesis is embedded mid-passage.)
- "Longer answers are more complete, so pick them."
- "The passage's tone is always neutral."

**Generator spec.** Passages 50-150 words, three registers (expository, narrative, practical). For each passage emit one main-idea item, one explicit-detail item, and one inference item, then sample. Every distractor must be either (a) true-but-unsupported, (b) passage-reversed, or (c) over-extended. Never write a distractor that is simply false in a way the passage never mentions — that makes the item trivially eliminable.

---

## 10. Mathematics Knowledge (MK)

**(a) Official name and abbreviation.** Mathematics Knowledge (MK). Official description: "Knowledge of high school mathematics principles." Domain: Math. **[OFFICIAL-VERIFIED]**

Official scope statement: "Mathematics Knowledge tests the ability to solve problems by applying knowledge of mathematical concepts and applications. The problems focus on concepts and algorithms and involve number theory, numeration, algebraic operations and equations, geometry and measurement, and probability." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **15**. P&P **25**. CEP iCAT 16.

**(c) Time.** CAT **31 min** = 2.07 min/item. P&P 24 min for 25 items. **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Official buckets quoted above; weights **[ESTIMATE]**.

| Topic | Weight | Notes |
|---|---|---|
| Algebraic operations and equations | 0.35 | Solve linear equations/inequalities, simplify and factor expressions, exponent rules, substitution, the (x^2 - y^2)/(x - y) style identity. Highest-yield block. |
| Geometry and measurement | 0.30 | Angles and parallel lines, triangle properties and Pythagorean theorem, circles (area/circumference), rectangles/triangles area, volume of prisms/cylinders, coordinate basics. |
| Number theory and numeration | 0.25 | Factors, multiples, primes, LCM/GCD, fractions and decimals, percents, square roots, ratio and scientific notation. |
| Probability and counting | 0.10 | Single-event probability, simple combinations of independent events. |

MK is *concepts and algorithms*, not word problems — that is AR's lane. Do not generate story problems for MK. **[OFFICIAL-VERIFIED by contrast with the AR description]**

**(e) Difficulty distribution.** P&P target: **easy 25% / medium 50% / hard 25%**. Difficulty is set by (i) number of transformations required, (ii) whether the needed relation is recalled or given, (iii) whether a distractor equals a predictable partial result. Official samples range from a one-step linear equation to an algebraic identity requiring factoring. **[ESTIMATE + OFFICIAL examples]**

**(f) Five sample questions.** Items 1-3 are **official**; 4-5 are original in the same specification.

**MK-1** *If x + 6 = 7, then x is equal to*
A. -1 B. 0 C. 1 D. 7
**Answer: C (index 2). Difficulty: easy.** Subtract 6 from both sides: x = 7 - 6 = 1. The distractors are the sign flip (-1), the null operation (0), and the restated right side (7) — the three standard single-step traps.

**MK-2** *(x^2 - y^2) / (x - y) =* (given x - y is not zero)
A. x + y B. x - y C. x + 2y D. 2x - y
**Answer: A (index 0). Difficulty: hard.** Factor the difference of squares: x^2 - y^2 = (x + y)(x - y), which cancels the denominator, leaving x + y. The item tests whether you recognize the factoring pattern instead of attempting long division; option B is the denominator echoed back.

**MK-3** *If 50 percent of x = 66, then x =*
A. 33 B. 66 C. 99 D. 132
**Answer: D (index 3). Difficulty: medium.** 0.5x = 66, so x = 66/0.5 = 132. Option A is the classic direction error (halving again instead of doubling); option B ignores the percent entirely.

**MK-4** *The ratio 36 : 12 is the same as*
A. 2 : 1 B. 3 : 1 C. 4 : 1 D. 5 : 1
**Answer: B (index 1). Difficulty: easy.** Divide both terms by the greatest common factor, 12: 36/12 = 3 and 12/12 = 1, giving 3 : 1. The distractors are nearby ratios obtained by dividing one side only or rounding.

**MK-5** *(original) A bag contains 3 red and 5 blue marbles. If one marble is drawn at random, what is the probability that it is red?*
A. 3/5 B. 3/8 C. 5/8 D. 1/3
**Answer: B (index 1). Difficulty: medium.** There are 3 favorable outcomes out of 3 + 5 = 8 total, so the probability is 3/8. Option A divides by the blue count instead of the total, and C is the probability of drawing blue — the two standard probability-item errors.

**Common mistakes on MK**
1. Percent direction errors (MK-3) and percent-of-percent confusion.
2. Sign errors when transposing terms in a linear equation.
3. Using the diameter in place of the radius (area = pi*r^2, not pi*d^2).
4. Forgetting that the denominator of a probability is the *total* number of outcomes.
5. Not recognizing factorable forms — reaching for computation where factoring is the intended path (MK-2).
6. Treating MK as AR: writing equations for what should be direct computation, or vice versa.
7. Unit slips in geometry (perimeter vs area vs volume; square units).
8. Because there is no calculator on the real test, dependence on one in practice: the item numbers are hand-computable by design, and the app should *not* offer a calculator.

**Top misconceptions (reinforcement lessons)**
- "(x + y)^2 = x^2 + y^2." (It equals x^2 + 2xy + y^2.)
- "You can cancel terms across an addition." (Only factors cancel.)
- "Squaring a number smaller than 1 makes it bigger."
- "Area and perimeter scale together."
- "A negative times a negative is a negative."
- "Probability of A or B always means add."

**Generator spec.** Single-line stems, math typeset (SVG/MathML), no word-problem framing. Every item must be solvable without a calculator in under 90 seconds. Distractor engine: (i) sign-flipped, (ii) operand-swapped (radius/diameter, favorable/total), (iii) partial-result, (iv) restated-given. Vary the correct-answer position uniformly.

---

## 11. Electronics Information (EI)

**(a) Official name and abbreviation.** Electronics Information (EI). Official description: "Knowledge of electricity and electronics." Domain: Science/Technical. **[OFFICIAL-VERIFIED]**

Official scope statement: "Electronics Information tests understanding of electrical current, circuits, devices, and systems. Electronics information topics include electrical tools, symbols, devices, and materials; electrical circuits; electrical and electronic systems; and electrical currents." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **15**. P&P **20**. CEP iCAT 16.

**(c) Time.** CAT **10 min** = 40 s/item. P&P 9 min for 20 items (27 s/item). **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Official topic list quoted above; weights **[ESTIMATE]**.

| Topic | Weight | Notes |
|---|---|---|
| Electrical quantities, symbols, units, abbreviations | 0.15 | Volt/amp/ohm/watt, AC vs DC, schematic symbols, meter identification ("what does an ohmmeter measure"). Explicitly in the official topic list. |
| DC circuit behavior: series vs parallel, Ohm's law, resistance rules | 0.30 | The computational core: V = IR, P = VI, series-adds-resistance/parallel-splits, one-bulb-out consequences. |
| Components and devices | 0.25 | Resistor, capacitor, inductor, diode, transistor, relay, transformer, fuse; what each does and its distinguishing property. |
| Electrical/electronic systems | 0.20 | Motors, generators, alternators, batteries, ignition/charging, AC distribution, speakers/antennas at a conceptual level. |
| Tools, materials, wiring and safety | 0.10 | Solder, insulation, wire gauge, conduit, fuses/circuit breakers, lockout, grounding. |

**(e) Difficulty distribution.** P&P target: **easy 25% / medium 50% / hard 25%**. The DMDC technical documentation flags EI as the subtest most vulnerable to content obsolescence ("the field of electronics develops and changes so rapidly"), which in practice means the pool is deliberately conservative and *school-level* — no semiconductor physics. **[OFFICIAL-VERIFIED for the obsolescence note]**

**(f) Five sample questions — all official published EI items with official keys.**

**EI-1** *Which of the following has the least resistance?*
A. wood B. iron C. rubber D. silver
**Answer: D (index 3). Difficulty: easy.** Silver is the best room-temperature conductor among common metals, hence the lowest resistance. Wood and rubber are insulators; iron conducts but far worse than silver. The item tests the conductor/insulator ordering, not a calculation.

**EI-2** *In this circuit diagram, the resistance is 100 ohms, and the current is 0.1 amperes. The voltage is*
A. 5 volts. B. 10 volts. C. 100 volts. D. 1,000 volts.
**Answer: B (index 1). Difficulty: medium.** Ohm's law: V = IR = 100 x 0.1 = 10 volts. Option D is the decimal-point slip (100 x 0.1 mistaken for 1000); C repeats the resistance value.

**EI-3** *The circuit shown in the diagram contains a battery and two light bulbs. If one light bulb burns out, the other will*
A. no longer burn. B. continue to burn. C. flicker on and off. D. burn more brightly.
**Answer: A (index 0). Difficulty: medium.** The bulbs are in series, so the single path is broken and both go dark. This is the canonical series-vs-parallel item; the "burn more brightly" option is the parallel-circuit intuition misapplied (in parallel, the survivor keeps burning, and total current changes).

**EI-4** *Which of the following is measured using an ohmmeter?*
A. voltage B. resistance C. inductance D. capacitance
**Answer: B (index 1). Difficulty: easy.** An ohmmeter measures resistance in ohms; voltmeters measure potential difference, and inductance/capacitance require LCR meters or bridges. Pure instrument-identification recall.

**EI-5** *Because solid state diodes have no filament, they*
A. don't work. B. are less efficient than tubes. C. require less operating power. D. require more operating power.
**Answer: C (index 2). Difficulty: medium.** With no heated filament to power, a solid-state diode dissipates far less operating power than a vacuum tube. Option B inverts the historical fact (solid state replaced tubes *because* it is more efficient); A is an absurdity distractor.

**Common mistakes on EI**
1. Series/parallel confusion, especially the "one bulb burns out" family (EI-3).
2. Ohm's law rearranged as V = I/R or I = V*R under time pressure (EI-2).
3. Decimal-point errors when multiplying by 0.1/0.01-ampere currents.
4. Confusing resistance with conductance ("least resistance" answered as "least conductivity").
5. Mixing up voltage (across) and current (through) when reading a schematic.
6. Answering from automotive experience instead of electronics principles, or vice versa — EI is the most likely place for a crossover misconception.
7. Treating it as unfixable trivia and skipping it: EI is the highest-leverage technical subtest because it appears in EL/BEE-style composites that unlock electronics jobs. **[SECONDARY for the composite claim]**

**Top misconceptions (reinforcement lessons)**
- "Current is used up as it flows through a circuit." (It is not consumed; energy is.)
- "Voltage flows."
- "A battery's current is fixed regardless of the circuit."
- "In a parallel circuit, adding a bulb dims the others."
- "Ground means zero volts everywhere, so it is a return path for charge to disappear into."
- "Diodes and resistors are interchangeable in a circuit diagram."

**Generator spec.** Two families: (i) definition/identification (what does X measure / what is symbol Y / which is an insulator), (ii) one-step quantitative (V=IR, P=VI, series/parallel combination). Diagrams must be SVG with standard symbols. Never require code-level or semiconductor-physics knowledge. Distractors: wrong rearrangement of the same formula, reciprocal confusion, wrong unit.

---

## 12. Auto & Shop Information (AS) — Auto Information (AI) + Shop Information (SI)

**(a) Official names and abbreviations.** **Auto Information (AI)** and **Shop Information (SI)** are administered as **two separate subtests on the CAT-ASVAB** and combined into **one subtest, Auto & Shop Information (AS)**, on the P&P-ASVAB. A combined **AS score is reported for both administrations**. **[OFFICIAL-VERIFIED — Fact Sheet footnote and the officialasvab.com Subtests page]**

Official descriptions: AI, "Knowledge of automobile technology." SI, "Knowledge of tools and shop terminology and practices." Combined scope: "Auto and Shop Information tests aptitude for automotive maintenance and repair and wood and metal shop practices. The test covers several areas commonly included in most high school auto and shop courses such as automotive components, automotive systems, automotive tools, troubleshooting and repair, shop tools, building materials, and building and construction procedures." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT: AI **10** + SI **10** (20 total). P&P: AS **25** as one section. CEP iCAT: AI 11 + SI 11.

**(c) Time.** CAT: AI **7 min** (42 s/item) + SI **6 min** (36 s/item) = 13 min for 20 items. P&P: AS **11 min** for 25 items (26 s/item). **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Weights **[ESTIMATE]**, calibrated to the CAT's even 10/10 split.

| Topic | Weight | Notes |
|---|---|---|
| Auto: engine, combustion, lubrication, cooling | 0.16 | Four-stroke cycle, cylinder/piston/ring function, oil pump, radiator/thermostat/water pump. |
| Auto: drivetrain, brakes, steering, suspension | 0.16 | Transmission/clutch concept, differential, brake hydraulic theory, shock absorbers, differential vs axle. |
| Auto: automotive electrical and ignition | 0.09 | Battery, alternator, starter, spark plugs, ignition timing concept. |
| Auto: automotive tools, troubleshooting, maintenance | 0.09 | Diagnostic reasoning ("uses too much oil when which part is worn"), jack/stand safety, common service tasks. |
| Shop: hand tools — identification and correct use | 0.18 | Saw types (rip vs crosscut vs coping vs back), chisels, clamps, planes, wrenches, files, measuring tools. |
| Shop: power tools, materials, fasteners | 0.16 | Drill press, circular/table saw, sanding, wood species and sheet goods, steel/aluminum stock, screws/nails/bolts, adhesives. |
| Shop: building and construction procedures | 0.16 | Framing, layout, joinery, concrete/masonry basics, finishing, safety practices. |

**(e) Difficulty distribution.** P&P target: **easy 30% / medium 50% / hard 20%**. This subtest is the most *experience-dependent* in the battery: a candidate who has never held a coping saw will miss items that a shop student finds trivial, and vice versa for engines. Items are almost entirely identification/function recall with a minority of short troubleshooting reasoning. **The strategic implication for an app: AS is the highest-ROI coaching target for candidates with no vocational background, because the content is bounded, visual, and finite.** **[ESTIMATE]**

**(f) Five sample questions — all official published AI/SI items with official keys.**

**AS-1 (AI)** *Shock absorbers on a car connect the axle to the*
A. wheel. B. chassis. C. drive shaft. D. exhaust pipe.
**Answer: B (index 1). Difficulty: easy.** A shock absorber (damper) is mounted between the axle/suspension assembly and the vehicle body (chassis) to dissipate oscillation. "Wheel" is the trap: the wheel is at the far end of the same assembly, but the damper's other end attaches to the body.

**AS-2 (AI)** *The radiator on a car is part of the*
A. cooling system. B. ignition system. C. electrical system. D. lubrication system.
**Answer: A (index 0). Difficulty: easy.** The radiator transfers heat from engine coolant to the air, which is the definition of the cooling system. Engine oil also carries heat, which is why "lubrication system" is a plausible distractor.

**AS-3 (AI)** *A car uses too much oil when which of the following parts are worn?*
A. pistons B. piston rings C. main bearings D. connecting rods
**Answer: B (index 1). Difficulty: hard.** Piston rings seal the combustion chamber from the crankcase; worn rings let oil past into the cylinder where it burns, raising consumption. Pistons and rods are structural, and worn main bearings produce low oil *pressure*, not necessarily high consumption — the item rewards a real mechanism over a parts-list guess.

**AS-4 (SI)** *Sanding blocks are used to*
A. prevent high spots and ridges on sanded surfaces. B. prevent dirt from collecting on the sandpaper. C. stretch the length of the sandpaper. D. prolong the use of the sandpaper.
**Answer: A (index 0). Difficulty: medium.** A rigid block spreads finger pressure over a flat area, which prevents dishing and ridges that hand-sanding creates. The other options are plausible-sounding maintenance claims unrelated to the block's mechanical purpose.

**AS-5 (SI)** *Which handsaw should be used to make a rough cut with the grain in a thick board?*
A. ripsaw B. backsaw C. coping saw D. crosscut saw
**Answer: A (index 0). Difficulty: medium.** A ripsaw has large, chisel-like teeth filed for cutting *along* the grain; a crosscut saw is filed for cutting across it. Backsaws (fine, reinforced spine) and coping saws (fine, tight curves) are for joinery and curves, which is exactly the confusion this item tests.

*(Additional official items available for the pool: "A chisel is used for" — cutting (B); "Where does combustion take place?" — option 6 (D); "The saw shown is used mainly to cut" — odd-shaped holes in wood (B).)* **[OFFICIAL-VERIFIED]**

**Common mistakes on AS**
1. Grain direction: rip vs crosscut saw, and the same confusion for plane blades and chisels.
2. Naming the part that fails *because of* wear rather than the part whose wear causes the symptom (AS-3).
3. Confusing systems by shared components: oil and coolant both remove heat; the alternator and battery both supply electricity.
4. Tool identification by silhouette instead of function (clamp types, pliers types, wrench types).
5. Confusing wood and metal shop practice (e.g. using wood-cutting terms for sheet metal, or the wrong fastener for the material).
6. Skipping this subtest believing it requires prior shop class. The CAT gives 42 s per AI item because the pool is designed to be answerable from general mechanical reasoning plus limited vocabulary.

**Top misconceptions (reinforcement lessons)**
- "A bigger saw is always for heavier work." (Teeth count and filing define the job.)
- "Shock absorbers support the car's weight." (Springs do; shocks damp.)
- "The radiator cools the oil." (It cools coolant.)
- "Piston rings seal only at the top of the stroke."
- "Crosscut and rip saws are interchangeable in a pinch" — true in the shop, false on the test.
- "All clamps of the same size are equivalent." (Bar, spring, parallel, C, and web clamps are distinguished by mechanism.)

**Generator spec.** ~70% identification/function items with unambiguous single answers, ~30% short troubleshooting ("symptom, which worn part"). Heavy on labeled diagrams for tool and component identification (SVG needed). Do not generate exotic or brand-specific content; the pool is generic high-school shop/auto.

---

## 13. Mechanical Comprehension (MC)

**(a) Official name and abbreviation.** Mechanical Comprehension (MC). Official description: "Knowledge of mechanical and physical principles." Domain: Science/Technical. **[OFFICIAL-VERIFIED]**

Official scope statement: "Mechanical Comprehension tests understanding of the principles of mechanical devices, structural support, and properties of materials. Mechanical comprehension topics include simple machines, compound machines, mechanical motion, and fluid dynamics." **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **15**. P&P **25**. CEP iCAT 16.

**(c) Time.** CAT **22 min** = 88 s/item. P&P 19 min for 25 items. **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Official topic list quoted above; weights **[ESTIMATE]**.

| Topic | Weight | Notes |
|---|---|---|
| Simple machines: levers (classes, mechanical advantage), pulleys/block-and-tackle, inclined plane, wheel and axle, screw | 0.28 | The computational heart: MA = load/effort, effort arm/load arm, rope-segment counting. |
| Gears and gear trains | 0.15 | Direction of rotation, teeth-count to RPM ratio, compound trains (official sample: gear A 14 revs, gear B 21). |
| Structural support and loads | 0.18 | Beam/post load sharing, center of gravity (official crane item), trusses, tension vs compression, where a shelf/beam is strongest. |
| Fluid dynamics and pressure | 0.14 | Hydraulic advantage (force/area), pressure vs depth, buoyancy, pump/valve behavior by pressure differential (official intake-valve item). |
| Mechanical motion and friction | 0.15 | Velocity/acceleration concept, friction direction and effects, efficiency losses, work and power distinctions. |
| Properties of materials | 0.10 | Strength/stiffness/elasticity vs plasticity, corrosion, thermal expansion, why a material is chosen. |

**(e) Difficulty distribution.** P&P target: **easy 20% / medium 50% / hard 30%**. MC is the conceptual cousin of AR: the arithmetic is trivial (ratios, multiply/divide) and the difficulty lives in (i) interpreting a diagram, (ii) knowing which principle applies, (iii) resisting the intuitive-but-wrong answer (heavier object falls faster, longer lever always easier, etc.). **[ESTIMATE]**

**(f) Five sample questions.** Items 1-2 are **official**; 3-5 are original in the same specification.

**MC-1** *Extending the reach of this crane will shift its*
A. total weight. B. allowable speed. C. center of gravity. D. center of buoyancy.
**Answer: C (index 2). Difficulty: medium.** Extending the boom moves mass outward, so the system's center of gravity shifts toward the load and the overturning moment grows. Total weight is unchanged by geometry; "center of buoyancy" is a ship concept imported as a plausible distractor.

**MC-2** *Why does the intake valve open on this pump when the piston goes down?*
A. Air pressure at X is less than air pressure at Y. B. Air pressure at Z is less than air pressure at X. C. Air pressure at X is greater than air pressure at Y. D. Air pressure at Y is greater than air pressure at Z.
**Answer: C (index 2). Difficulty: hard.** A valve opens toward the lower pressure, so the intake opens when the pressure on its far side (X) exceeds the pressure inside the cylinder (Y). The item is a pressure-differential reasoning test dressed as plumbing; the mirrored option A is the sign-flip trap.

**MC-3** *(original, official style) If gear A makes 14 revolutions, gear B will make 21. Which statement is true?*
A. Gear A has more teeth than gear B. B. Gear B has more teeth than gear A. C. The two gears have the same number of teeth. D. Gear B cannot turn faster than its driver.
**Answer: A (index 0). Difficulty: medium.** Revolutions are inversely proportional to tooth counts: if B turns 1.5x faster, B has 1/1.5 the teeth, so A has more teeth. The item forces the inverse relationship explicitly rather than a mechanical-advantage formula.

**MC-4** *(original) A lever is used to lift a 200-pound rock. If the effort arm is 4 feet and the load arm is 1 foot, how much effort force is required? (Ignore the lever's own weight.)*
A. 25 pounds B. 50 pounds C. 200 pounds D. 800 pounds
**Answer: B (index 1). Difficulty: easy.** Mechanical advantage = effort arm / load arm = 4/1 = 4, so effort = load / MA = 200/4 = 50 pounds. Option D is the MA applied in the wrong direction (multiplying instead of dividing); A divides twice.

**MC-5** *(original) A block and tackle has three rope segments supporting the movable block. Ignoring friction, the effort needed to lift a 300-pound load is about*
A. 75 pounds B. 100 pounds C. 150 pounds D. 900 pounds
**Answer: B (index 1). Difficulty: medium.** Each supporting rope segment carries an equal share, so effort = load / number of segments = 300/3 = 100 pounds. Option C uses two segments (a common mis-count), and D multiplies instead of dividing.

**Common mistakes on MC**
1. Counting rope segments incorrectly in a block and tackle (count only segments supporting the *movable* block).
2. Inverting the mechanical-advantage ratio (multiplying where dividing is required) — MC-4, MC-5.
3. Gear-direction errors on idler gears (an idler reverses direction but does not change ratio).
4. Assuming a longer lever is always easier regardless of where the fulcrum sits; confusing the three lever classes.
5. Ignoring the center of gravity in stability items (MC-1) and answering "total weight".
6. Pressure-differential valves reasoned by flow direction instead of pressure (MC-2).
7. Treating friction as always bad: friction questions often ask for direction and effect, not desirability.
8. Applying formulas where the item only asks which of four diagrams is strongest — many MC items are *qualitative*.

**Top misconceptions (reinforcement lessons)**
- "Pulleys create energy / reduce the work." (Force is reduced; work is unchanged, or worse with friction.)
- "Heavier objects accelerate faster in free fall."
- "A gear ratio can be determined from diameter alone when tooth counts differ." (Count teeth.)
- "A wider base always increases stability regardless of height/CoG."
- "Liquid is incompressible, so hydraulics multiply energy."
- "Tension and compression act the same way in a beam."

**Generator spec.** Two families: (i) diagram-qualitative ("which shelf supports more", "which pulley turns fastest", "direction of friction"), (ii) numeric ratio one-step (MA, gear RPM, hydraulic force, pressure at depth). Keep arithmetic to a single multiply/divide. Never require calculus, thermodynamics, or electrical knowledge. Every numeric item needs a matched "inverted ratio" distractor.

---

## 14. Assembling Objects (AO)

**(a) Official name and abbreviation.** Assembling Objects (AO). Official description: "Ability to determine how an object will look when its parts are put together." Domain: **Spatial** (the only subtest in that domain). **[OFFICIAL-VERIFIED]**

**(b) Questions.** CAT **15**. P&P **25**. Not part of the CEP iCAT/school product.

**(c) Time.** CAT **18 min** = 72 s/item. P&P 15 min for 25 items. **[OFFICIAL-VERIFIED]**

**(d) Domains (weighted).** Two official item formats appear in the published sample set. Weights **[ESTIMATE]**.

| Item format | Weight | Notes |
|---|---|---|
| "Which figure best shows how the objects in the left box will appear if they are fit together?" — jigsaw/assembly style: pieces rotate and translate to form one object; nothing may be stretched or mirrored | 0.60 | The dominant format in current pools. Tests mental rotation plus shape composition. |
| "Which figure best shows how the objects in the left box will touch if the letters for each object are matched?" — connection style: piece-to-piece attachment points are labeled and must be matched | 0.40 | Tests attachment-point tracking rather than silhouette matching. |

**The governing rule for both: pieces may be rotated and translated, but never flipped, mirrored, stretched, or rescaled.** All distractors are built by violating exactly that rule (or by misassembling the join). **[OFFICIAL-VERIFIED that both formats exist; the rotation-only rule is [SECONDARY], consistent with the official samples and universally described in prep literature]**

**(e) Difficulty distribution.** P&P target per the official "most are average" statement: **easy 20% / medium 55% / hard 25%**. Difficulty is controlled by (i) number of pieces, (ii) rotation angle applied, (iii) whether the join is on a straight edge or on internal geometry, (iv) how similar the distractors' overall silhouettes are. **[ESTIMATE]**

**(f) Five sample questions.** AO is intrinsically graphical; these are **text-precise surrogates** that an app should render as generated SVG (see the generator spec below). The underlying geometry and answers are exact.

**AO-1** *(easy, fit-together)* Two congruent right triangles, each with legs 3 and 4 and hypotenuse 5, are joined along their hypotenuses. What shape do they form?
A. A 3-by-4 rectangle. B. A 4-by-4 square. C. A 7-by-3 rectangle. D. A trapezoid with parallel sides 3 and 4.
**Answer: A (index 0).** Joining two congruent right triangles along the hypotenuse produces a rectangle whose sides are the two legs, 3 and 4 (area 12 = 2 x 6). A square would require equal legs; options C and D cannot be produced from 12 square units of material in those shapes.

**AO-2** *(easy, fit-together)* Piece 1 is a 6-by-2 rectangle. Piece 2 is a 6-by-4 rectangle with a 6-by-2 slot cut out of its top edge. Fitted together, the two pieces form
A. a 6-by-4 rectangle. B. a 6-by-6 square. C. a 12-by-4 rectangle. D. an L shape.
**Answer: A (index 0).** Piece 1 has 12 square units and piece 2 has 24 - 12 = 12, for 24 total, and the slot is exactly the shape of piece 1, so the union fills a 6-by-4 rectangle. The area test alone eliminates B (36) and C (48).

**AO-3** *(medium, fit-together)* Piece A is a 4-by-4 square with a 1-by-2 tab extending from its top edge. Piece B is a 4-by-4 square with a matching 1-by-2 slot cut into its bottom edge. Fitted together (no overlap), they form
A. a 4-by-8 rectangle. B. a 4-by-8 rectangle with a 1-by-2 hole. C. an 8-by-8 square. D. a T shape.
**Answer: A (index 0).** Areas are 16 + 2 = 18 and 16 - 2 = 14, totaling 32 = 4 x 8, and the tab exactly fills the slot so no void remains. Option B is the designed trap for solvers who notice the slot but forget the tab is the filler.

**AO-4** *(medium, rotation — the mirror trap)* An L-shaped piece has a 3-unit arm and a 2-unit arm meeting at a square corner. Held so that the 3-unit arm points up and the 2-unit arm points right, the piece is rotated 90 degrees clockwise. Which description matches the result?
A. The 3-unit arm points right and the 2-unit arm hangs down from its left end. B. The 3-unit arm points right and the 2-unit arm rises from its right end. C. The 3-unit arm points left and the 2-unit arm rises from its right end. D. The 3-unit arm points down and the 2-unit arm points right.
**Answer: A (index 0).** A 90-degree clockwise rotation maps "up" to "right" and "right" to "down", so the 3-arm ends up horizontal (right) and the 2-arm vertical (down), still meeting at the same corner — which is the far left of the 3-arm. Option B is a mirror image of the correct result, exactly the error the test is built to catch.

**AO-5** *(hard, arrangement)* Four identical right triangles with legs 3 and 4 are arranged around a central square hole of side 5 (their hypotenuses forming the hole's edges). What is the area of the smallest square that contains the four triangles and the hole?
A. 25. B. 48. C. 49. D. 50.
**Answer: C (index 2).** Each triangle's legs lie along the outer square's edges, so the outer square's side is 3 + 4 = 7 and its area is 49 (this is the standard proof of the Pythagorean theorem). Option A is the hole alone, and 25 + 24 = 49 is exactly the decomposition: four triangles of area 6 each (24) plus the 25-unit hole.

**Common mistakes on AO**
1. Selecting the answer that requires a **mirrored** piece — the most common AO error by a wide margin.
2. Matching overall silhouette while ignoring an internal notch or tab (AO-3 option B).
3. Assuming a piece may be scaled to fit.
4. Losing the attachment-point correspondence in the connect-the-dots format and joining the wrong labeled point.
5. Mentally rotating the whole assembly when only one piece may move.
6. Spending too long: at 72 s/item, an item that is not resolving in about a minute should be marked and guessed, because AO is not in the AFQT.

**Top misconceptions (reinforcement lessons)**
- "Flipping a piece is allowed if the outline still matches."
- "The pieces can be resized to fit the answer choice."
- "The answer with the biggest pieces must be right."
- "Rotation by 90 degrees and reflection produce the same result." (They do not — AO-4 exists to test exactly this.)
- "AO measures drawing skill." (It measures mental rotation; it is highly trainable with practice.)

**Generator spec.** Generate programmatically: 2-4 polygon pieces from a small vocabulary (rectangles, right triangles, L-shapes, tabs/slots), apply a random rotation from {0, 90, 180, 270} and translation, compute the union, then render four choices in which (a) the correct union, (b) a mirrored variant, (c) a rescaled variant, (d) a mis-joined variant. Store the transformation matrix with each item so explanations can be auto-generated ("piece B was rotated 90 degrees clockwise; option B mirrors it"). Never emit text-only AO items in production.

---

## 15. Derived composite VE (Verbal Expression)

**Not an administered subtest.** VE = WK + PC standard scores. It exists only as a scoring component and appears in nearly every service composite, including GT = VE + AR. **[OFFICIAL-DERIVED]**

- CAT: 25 items' worth of input (15 WK + 10 PC), 36 minutes of test time.
- P&P: 50 items' worth of input (35 WK + 15 PC), 24 minutes.
- App treatment: never generate VE items. Track it as a computed statistic only, weighted 60/40 toward WK on the CAT item basis and 70/30 on the P&P item basis.

---

## 16. Master misconception taxonomy (drives the reinforcement lessons)

These six error classes recur across nearly every wrong answer on the battery. Tag every item you generate with the class it induces, and build one reinforcement lesson per tag per subtest.

| # | Error class | What the learner actually does | Where it appears |
|---|---|---|---|
| 1 | **Answered the wrong quantity** | Computes a valid intermediate value and selects it (amount lost vs value remaining; party A vs party B) | AR, MK, MC |
| 2 | **Restatement accepted as explanation** | Chooses the sentence that repeats the premise rather than the mechanism | GS, PC, EI |
| 3 | **Semantic-neighbor seduction** | Picks a word from the right *field* but the wrong *specificity* (struggle vs provoke; details vs fundamentals) | WK, PC |
| 4 | **Inverted relation** | Applies a ratio upside-down (MA, gear ratio, percent change, radius vs diameter, effort vs load) | AR, MK, MC, EI |
| 5 | **True-but-unsupported** | Chooses a fact that is true in the world but not in the passage/data | PC, GS |
| 6 | **Format-rule violation** | Mirrors/flips in AO; blind-guesses on the CAT; refuses to guess on the P&P | AO, all (test strategy) |

Plus the subtest-specific traps already listed (unit mismatch, grain direction, series/parallel, center of gravity vs weight). Each reinforcement lesson should state: the misconception in the learner's own words, one counterexample that breaks it, and one item re-attempt.

---

## 17. Cross-subtest item-writing rules for the generator

Rules distilled from the official documents and the sample sets:

1. **Four choices (A-D) at all times.** Every official sample has four options. **[OFFICIAL-VERIFIED by example]**
2. **Exactly one defensible answer.** Every distractor must be wrong for a *nameable* reason (Section 16 taxonomy), never wrong by accident.
3. **Do not duplicate the AR/MK boundary.** AR = word problems, arithmetic operations only. MK = concepts/algorithms, no story context. **[OFFICIAL-VERIFIED from the two scope statements]**
4. **No calculator on the real test**; keep AR/MK arithmetic hand-computable and integers terminating.
5. **Difficulty label from p-value bands** (easy > 0.75, medium 0.45-0.75, hard < 0.45) once calibration exists; otherwise use the [ESTIMATE] labels here.
6. **Match the official vocabulary register per subtest**: GS/MK/AR/PC are high-school curriculum; WK is mid-frequency academic; EI/AS/MC are vocational-but-generic.
7. **Shuffle correct-answer position.** The official sample items used above keep their published order for authenticity; production items must be position-balanced.
8. **Never generate content outside the verified topic lists.** In particular: no calculus, no chemistry beyond atomic structure/states/basic reactions, no semiconductor physics, no brand-specific automotive procedures, no military-specific terminology.
9. **Format-gate the guessing advice.** P&P: "never leave a bubble empty, no penalty." CAT/PiCAT/APT: "do not blind-guess; the penalty treats unfinished items as random, and there is no answer review." **[OFFICIAL-VERIFIED]**
10. **AO and diagram items require real graphics.** Ship SVG; a text-only AO item is not valid AO content.

---

## 18. Sources

Primary documents retrieved and parsed this session (all links verified live unless noted):

1. **ASVAB Fact Sheet, ENLISTMENT TESTING PROGRAM** - https://www.officialasvab.com/wp-content/uploads/2026/10/ASVAB-Fact_Sheet.pdf (4 pp.). Source for CAT/P&P item counts and time limits, the 135/197 and 225/149 totals, guessing-penalty rules, test content table, retest ladder, AFQT explanation.
2. **ASVAB Fact Sheet, archived editions** (used to date the drift): /uploads/2020/07/, /uploads/2023/06/, /uploads/2024/02/, /uploads/2025/04/ - retrieved via Internet Archive snapshots (20200927, 20230928, 20240424, 20250806).
3. **The CAT-ASVAB** - https://www.officialasvab.com/applicants/cat-asvab/ (scored-question table, tryout-item time limits, penalty procedure summary).
4. **ASVAB Scoring (Researchers)** - https://www.officialasvab.com/researchers/scores/ (3PL IRT, theta = 0.0 start, Bayesian update, penalty properties, standard score mean 50/SD 10, AFQT subtests, AFQT categories).
5. **Understanding ASVAB Scores** - https://www.officialasvab.com/applicants/scores/ (AFQT percentile definition, 1997 norming sample, categories).
6. **ASVAB Subtests** - https://www.officialasvab.com/applicants/subtests/ (official subtest descriptions and domains; AI/SI vs AS administration rule).
7. **Official sample-question pages for all 10 subtests** - https://www.officialasvab.com/general-science-gs/ , /arithmetic-reasoning-ar/ , /word-knowledge-wk/ , /paragraph-comprehension-pc/ , /mathematics-knowledge-mk/ , /electronics-information-ei/ , /auto-information-ai/ , /shop-information-si/ , /mechanical-comprehension-mc/ , /assembling-objects-ao/ (the sample items quoted in Sections 6-13).
8. **ASVAB Career Exploration Program Overview** (DD Form 1304-5OV, FEB 2026) - https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Overview.pdf . Source for CEP iCAT item counts (16/16/16/11/16/16/11+11/16), formal subtest scope statements (life/earth/physical science lists, AR operation list, MK concept list, PC concept list, EI topic list, AS area list, MC topic list), and the 32-item official sample set with answer key.
9. **ASVAB CEP Counselor Guide** - https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Counselor_Manual.pdf (P&P = 8 subtests/200 items/134 min test time; iCAT Table 1-1).
10. **PiCAT & APT User's Guide v5.9** (USMEPCOM, March 2024) - https://etoolbox.cnrc.navy.mil/assets/ARM/PiCAT-APT_UserGuide_v5.9.pdf (CAT-ASVAB 10-subtest item counts; PiCAT and APT are untimed; Vtest requirement; once-per-two-years rule).
11. **ASVAB Technical Bulletin No. 4** (DMDC Personnel Testing Division, March 2009, rev. May 2012) - https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_4.pdf . Source for the official p-value difficulty bands (easy > .75, medium .45-.75, hard < .45) and the content-taxonomy/obsolescence discussion (EI).

Learning-science references (secondary literature, cited in Section 4): Dunlosky et al. (2013); Rowland (2014); Adesope et al. (2017); Cepeda et al. (2006, 2008); Rohrer & Taylor (2007); Taylor & Rohrer (2010); Brunmair & Richter (2019); Sweller & Cooper (1985); Renkl & Atkinson (2003); Kalyuga et al. (2003); Bisra et al. (2018); Butler & Roediger (2008); Hattie & Timperley (2007); Koriat & Bjork (2005).

### Explicitly UNVERIFIED / open items

- **Per-topic percentage weights** for all nine subtests. Not published by the ASVAB program. Everything in the "weight" columns is [ESTIMATE].
- **AFQT raw-score weights** (2*VE + AR + MK). Not published in current official material; consistent with official statements but unconfirmed.
- **All line-score/composite formulas** except the structural facts (VE = WK + PC; composites are sums of subtest standard scores; services define them). GT = VE + AR is the most confidently reported.
- **The AO "rotation only, never mirrored" rule.** Universal in prep literature and consistent with every official sample, but not stated in a document retrieved this session.
- **Whether the current CEP iCAT includes AO.** The FEB 2026 Table 1-1 shows 8 subtests with no AO row, while older Counselor Guide text says "10 subtests" for the computerized version. Unresolved; irrelevant to enlistment testing.
- **Per-item difficulty labels** attached to the sample questions in this dossier. They are my [ESTIMATE]s mapped onto the official p-value bands, not calibrated values.

---

## 19. Machine-readable payload

The canonical, minimal spec for the app is **subtests.json** in this directory (see its sourceVersionNote for provenance). The block below is the *expanded* payload including the sample questions and per-subtest mistake lists.

```json
{
  "subtests": [
    {
      "abbr": "GS",
      "name": "General Science",
      "questions": 15,
      "minutes": 12,
      "catQuestions": 15,
      "catMinutes": 12,
      "paperQuestions": 25,
      "paperMinutes": 11,
      "domains": [
        {
          "topic": "Life science: botany, zoology, anatomy & physiology, ecology",
          "weight": 0.35,
          "notes": "Official topic list [OFFICIAL-VERIFIED]; weight estimate [ESTIMATE]. Cell/organ basics, body systems, food webs."
        },
        {
          "topic": "Physical science: chemistry and atomic structure",
          "weight": 0.25,
          "notes": "Elements/compounds/mixtures, states of matter, physical vs chemical change, acids-bases, catalysts."
        },
        {
          "topic": "Physical science: force, motion, energy, fluids",
          "weight": 0.15,
          "notes": "Density, buoyancy, energy transfer, inertia. Shallower than MC."
        },
        {
          "topic": "Earth & space: astronomy",
          "weight": 0.1,
          "notes": "Planets, moon phases, eclipses, seasons (axial tilt), solar system scale."
        },
        {
          "topic": "Earth & space: geology, meteorology, oceanography",
          "weight": 0.15,
          "notes": "Rock types, tectonics, weathering, fronts, water cycle, tides, atmosphere composition."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Air is less dense than water because",
          "choices": [
            "it is lighter.",
            "its molecules are farther apart.",
            "its molecules are closer together.",
            "it moves more quickly and easily."
          ],
          "answerIndex": 1,
          "explanation": "Density is mass per unit volume; gas molecules are spread far apart, so the same volume holds far less mass. 'It is lighter' restates the low density instead of explaining it, and is the designed trap.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "Substances that hasten chemical reaction time without themselves undergoing change are called",
          "choices": [
            "buffers.",
            "colloids.",
            "reducers.",
            "catalysts."
          ],
          "answerIndex": 3,
          "explanation": "A catalyst lowers activation energy and is recovered unchanged. A buffer resists pH change, a reducer donates electrons, and a colloid is a mixture type.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "An eclipse of the sun throws the shadow of the",
          "choices": [
            "moon on the sun.",
            "moon on the earth.",
            "earth on the sun.",
            "earth on the moon."
          ],
          "answerIndex": 1,
          "explanation": "A solar eclipse is the Moon passing between Earth and Sun, so the Moon's shadow falls on Earth. Option D describes a lunar eclipse, the intended confusion.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Salt helps to melt ice because it",
          "choices": [
            "dissolves in water to form an acid.",
            "chemically destroys the water molecules.",
            "lowers the temperature at which water freezes.",
            "is attracted to concrete sidewalks below the ice."
          ],
          "answerIndex": 2,
          "explanation": "Dissolved solute particles interfere with ice-crystal formation, depressing the freezing point (freezing-point depression). Salt does not destroy water or act through sidewalk attraction.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Which of the following is an example of a chemical change?",
          "choices": [
            "Ice melting.",
            "Sugar dissolving in water.",
            "Iron rusting.",
            "Water boiling."
          ],
          "answerIndex": 2,
          "explanation": "Rusting forms a new substance (iron oxide) with different properties, which defines a chemical change. Melting, dissolving and boiling change only physical state or dispersion.",
          "difficulty": "medium",
          "provenance": "original"
        }
      ],
      "commonMistakes": [
        "Accepting a restatement as the explanation (density item answered 'it is lighter').",
        "Confusing solar and lunar eclipse geometry.",
        "Calling dissolving a chemical change.",
        "Choosing the most jargon-heavy option; the pool is high-school level.",
        "Studying advanced topics instead of the officially listed curriculum areas.",
        "Skipping GS entirely; it feeds science/technical line scores even though it is not in the AFQT."
      ]
    },
    {
      "abbr": "AR",
      "name": "Arithmetic Reasoning",
      "questions": 15,
      "minutes": 55,
      "catQuestions": 15,
      "catMinutes": 55,
      "paperQuestions": 30,
      "paperMinutes": 36,
      "domains": [
        {
          "topic": "Multi-step whole-number word problems (rate, work, distance, unit rate)",
          "weight": 0.25,
          "notes": "Official operation list; weight [ESTIMATE]. Modal AR item, two or three operations with correct order of operations."
        },
        {
          "topic": "Percent, interest, discount, tax, percent change, depreciation",
          "weight": 0.22,
          "notes": "Heavily represented in official samples ($7,250 at 12% depreciation)."
        },
        {
          "topic": "Ratio, proportion and scaling",
          "weight": 0.18,
          "notes": "Part-to-part and part-to-whole ('one in every 9'), mixture and recipe scaling."
        },
        {
          "topic": "Rational numbers: fractions, decimals, mixed numbers",
          "weight": 0.18,
          "notes": "Fraction of a quantity in a word context; decimal equivalents."
        },
        {
          "topic": "Measurement, unit conversion, area/perimeter in context",
          "weight": 0.12,
          "notes": "Feet vs square feet vs square yards (official sample), gallons, time conversion."
        },
        {
          "topic": "Averages and simple data interpretation",
          "weight": 0.05,
          "notes": "Mean of a set, weighted average."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "If the tire of a car rotates at a constant speed of 552 times in one minute, how many times will it rotate in half-an-hour?",
          "choices": [
            "276",
            "5,520",
            "8,280",
            "16,560"
          ],
          "answerIndex": 3,
          "explanation": "Half an hour is 30 minutes, so multiply the per-minute rate by 30: 552 x 30 = 16,560. The distractors catch dividing instead of multiplying (276) and a misplaced zero (5,520).",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "One in every 9 people in a town votes for party A. All others vote for party B. How many people vote for party B in a town of 810?",
          "choices": [
            "90",
            "720",
            "801",
            "819"
          ],
          "answerIndex": 1,
          "explanation": "810/9 = 90 vote for party A, so 810 - 90 = 720 vote for party B. Option A answers the unasked question (party A), the defining AR distractor pattern.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "A motorcycle costs $7,250. If it depreciates by 12% per year, how much will it be worth after one year?",
          "choices": [
            "$870",
            "$1,250",
            "$5,920",
            "$6,380"
          ],
          "answerIndex": 3,
          "explanation": "12% of $7,250 is $870, so the value remaining is 7,250 - 870 = $6,380 (equivalently 0.88 x 7,250). Option A is the amount lost, not the value left.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "It takes 5 seconds for 20 gallons of water to come out of a faucet. At this rate, how many gallons of water come out in 7 seconds?",
          "choices": [
            "24",
            "26",
            "28",
            "30"
          ],
          "answerIndex": 2,
          "explanation": "The unit rate is 20/5 = 4 gallons per second, so 7 x 4 = 28 gallons. The proportion 20/5 = x/7 gives the same result.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "It costs $0.50 per square yard to waterproof canvas. What will it cost to waterproof a canvas truck cover that is 15 feet by 24 feet?",
          "choices": [
            "$6.67",
            "$18.00",
            "$20.00",
            "$180.00"
          ],
          "answerIndex": 2,
          "explanation": "Area is 15 x 24 = 360 square feet; at 9 sq ft per square yard that is 40 square yards; 40 x $0.50 = $20.00. Each distractor is a different error in the unit chain.",
          "difficulty": "hard",
          "provenance": "official"
        }
      ],
      "commonMistakes": [
        "Solving for the wrong quantity (party A instead of B; amount lost instead of value left).",
        "Reporting the percent change instead of the resulting value.",
        "Unit mismatch: feet vs square feet vs square yards; minutes vs hours.",
        "Setting the proportion up upside-down.",
        "Rounding mid-calculation and twice at the end.",
        "Doing the arithmetic mentally instead of on the provided scratch paper, despite 3.67 minutes per item.",
        "Leaving items blank at the time limit; the CAT penalty treats unfinished items as random guesses."
      ]
    },
    {
      "abbr": "WK",
      "name": "Word Knowledge",
      "questions": 15,
      "minutes": 9,
      "catQuestions": 15,
      "catMinutes": 9,
      "paperQuestions": 35,
      "paperMinutes": 11,
      "domains": [
        {
          "topic": "Single-word synonym ('X most nearly means')",
          "weight": 0.55,
          "notes": "Bare stem, four one-word choices. Official format [OFFICIAL-VERIFIED]; weight [ESTIMATE]."
        },
        {
          "topic": "Word used in a sentence, meaning resolved from context",
          "weight": 0.3,
          "notes": "Official sample: 'His record provides no reason for apprehension.'"
        },
        {
          "topic": "Secondary/less-common meanings and confusable pairs",
          "weight": 0.15,
          "notes": "The difficulty engine: the common meaning is the trap."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Antagonize most nearly means",
          "choices": [
            "embarrass.",
            "struggle.",
            "provoke.",
            "worship."
          ],
          "answerIndex": 2,
          "explanation": "To antagonize is to provoke hostility or opposition. 'Struggle' sits in the same conflict field without meaning 'to fight', and 'embarrass' captures social discomfort but not causation.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Wilted most nearly means",
          "choices": [
            "left.",
            "limp.",
            "budding.",
            "requested."
          ],
          "answerIndex": 1,
          "explanation": "Wilted describes something sagging from loss of water, i.e. limp. 'Budding' is the antonym-flavored trap drawn from the same plant context.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "His record provides no reason for apprehension.",
          "choices": [
            "anxiety",
            "change",
            "enjoyment",
            "endorsement"
          ],
          "answerIndex": 0,
          "explanation": "In this sentence apprehension means anxiety about something anticipated. The trap is the other dictionary sense (arrest), plus the pull toward 'enjoyment' because 'no reason for apprehension' sounds positive.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Quiver most nearly means",
          "choices": [
            "shake.",
            "dance.",
            "rest.",
            "run."
          ],
          "answerIndex": 0,
          "explanation": "To quiver is to tremble with slight rapid motion. The other options are motion verbs of the wrong kind, so the item tests precision inside a semantic field.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "Rudiments most nearly means",
          "choices": [
            "politics.",
            "minute details.",
            "promotion opportunities.",
            "basic methods and procedures."
          ],
          "answerIndex": 3,
          "explanation": "Rudiments are the fundamental elements or first principles of a subject ('the rudiments of algebra'). 'Minute details' is the strong distractor: rudiments are small units, but they are fundamentals, not trivia.",
          "difficulty": "hard",
          "provenance": "official"
        }
      ],
      "commonMistakes": [
        "Choosing a word you can define rather than the nearest synonym.",
        "Falling for the secondary-meaning trap when the sentence pins the sense.",
        "Letting word sound or technicality drive the choice.",
        "Ignoring the sentence version and answering from the bare word.",
        "Spending 90 seconds on one item in a 36-second-per-item subtest.",
        "Studying 5,000-word lists instead of reviewing mid-frequency words with retrieval and spacing."
      ]
    },
    {
      "abbr": "PC",
      "name": "Paragraph Comprehension",
      "questions": 10,
      "minutes": 27,
      "catQuestions": 10,
      "catMinutes": 27,
      "paperQuestions": 15,
      "paperMinutes": 13,
      "domains": [
        {
          "topic": "Main idea / primary purpose",
          "weight": 0.25,
          "notes": "Whole-passage synthesis; correct answer must cover the whole text. Official concept list; weight [ESTIMATE]."
        },
        {
          "topic": "Explicit detail and reworded facts ('According to the passage')",
          "weight": 0.25,
          "notes": "Answer is verbatim or near-verbatim; tests locating, not inferring."
        },
        {
          "topic": "Inference / drawing conclusions / implied meaning",
          "weight": 0.25,
          "notes": "Answer must be forced by the text, not merely permitted."
        },
        {
          "topic": "Vocabulary in context",
          "weight": 0.1,
          "notes": "Common word in an unusual sense inside the passage."
        },
        {
          "topic": "Author's purpose, tone, attitude",
          "weight": 0.1,
          "notes": "Usually signaled by adjectives and concessions."
        },
        {
          "topic": "Sequence of events / style and technique",
          "weight": 0.05,
          "notes": "Occasional 'which happened first' or 'the phrase X is used to...' item."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "The eastern part of Texas will ambush the senses of all who enter it with preconceptions of sand and cacti around every bend. It has a look and atmosphere that does not fit the boots-and-saddle image of the state. The author implies that the look and atmosphere of east Texas does NOT resemble that of the",
          "choices": [
            "marshlands.",
            "mountains.",
            "seashore.",
            "desert."
          ],
          "answerIndex": 3,
          "explanation": "'Sand and cacti' describes desert terrain, and the sentence says east Texas does not fit that image. The other three are also non-desert landscapes, so only mapping sand-and-cacti to desert wins the item.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "A thin transparent layer of oxide protects the metal titanium against corrosion. The same thin layer attracts artists interested in making their art with the help of technology. By using heat or electricity, an artist can thicken the oxide layer and thereby turn the metal a range of vivid colors. According to the passage, some artists work with titanium because it",
          "choices": [
            "is transparent.",
            "does not corrode.",
            "generates its own heat.",
            "can assume a variety of colors."
          ],
          "answerIndex": 3,
          "explanation": "The passage states that heat or electricity can turn the metal a range of vivid colors, which is the stated attraction for artists. Option A inverts the passage (the oxide layer is transparent, not the metal); B is true but never given as the artists' reason.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "They returned to the beach, where blankets spotted the slope to the water. An advancing wall of clouds, black and gray, darkening the expanse of ground beneath, approached from the west. To the east and above them, the sky remained clear, the sun warm, as if collaborating in the deception. The 'deception' referred to in the passage is that",
          "choices": [
            "there is no storm approaching.",
            "the sky is clear in the east.",
            "it is too cold to swim.",
            "the sun is warm."
          ],
          "answerIndex": 0,
          "explanation": "The deception is the false impression of calm: clear sky and warm sun while a storm wall advances. Options B and D are true details that are not the referent, the classic true-but-not-the-answer distractor.",
          "difficulty": "hard",
          "provenance": "official"
        },
        {
          "stem": "The orientation of a large expanse of glass in a house is important. Improperly positioned, it can cost precious fuel dollars, whereas good orientation can minimize heat lost in the winter and gained in the summer. The best direction to face is south, to make good use of solar energy. Since the sun is low in the southern sky during the winter, orienting any glass in that direction will allow light to shine through and help heat the home. During the summer, the sun is higher in the sky, and an overhang from the roof will shield the glass from direct sunlight. According to the passage, large expanses of glass should be positioned to",
          "choices": [
            "take advantage of summer sunlight.",
            "control heat gain and loss.",
            "shield the house from the low winter sun.",
            "avoid blockage of sunlight by an overhanging roof."
          ],
          "answerIndex": 1,
          "explanation": "The stated purpose is to minimize heat lost in winter and gained in summer, i.e. control heat gain and loss; the south-facing advice is only the method. Options A and C invert the passage, and D reverses the overhang's role.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Twenty-five percent of all household burglaries can be attributed to unlocked windows or doors. Crime is the result of opportunity plus desire. To prevent crime, it is each individual's responsibility to",
          "choices": [
            "provide the desire.",
            "provide the opportunity.",
            "prevent the desire.",
            "prevent the opportunity."
          ],
          "answerIndex": 3,
          "explanation": "If crime equals opportunity plus desire and the only element an individual controls is the lock, the conclusion is to remove the opportunity. Two options are logically self-defeating, which is how the answer is isolated.",
          "difficulty": "medium",
          "provenance": "official"
        }
      ],
      "commonMistakes": [
        "Choosing a statement true in the world but not supported by this passage.",
        "Answering a main-idea question with a supporting detail.",
        "Over-inferring: accepting an inference the text permits rather than forces.",
        "Re-reading the passage for every question instead of answering all its questions in one pass.",
        "Ignoring absolutes ('always', 'never') that make an option indefensible.",
        "Skipping passages on the CAT when there are only 10 items in 27 minutes.",
        "Answering a vocabulary-in-context item from the word's most common meaning."
      ]
    },
    {
      "abbr": "MK",
      "name": "Mathematics Knowledge",
      "questions": 15,
      "minutes": 31,
      "catQuestions": 15,
      "catMinutes": 31,
      "paperQuestions": 25,
      "paperMinutes": 24,
      "domains": [
        {
          "topic": "Algebraic operations and equations",
          "weight": 0.35,
          "notes": "Official bucket; weight [ESTIMATE]. Linear equations/inequalities, simplify and factor, exponent rules, identities."
        },
        {
          "topic": "Geometry and measurement",
          "weight": 0.3,
          "notes": "Angles, triangles, Pythagorean theorem, circles, area/volume, coordinate basics."
        },
        {
          "topic": "Number theory and numeration",
          "weight": 0.25,
          "notes": "Factors, multiples, primes, LCM/GCD, fractions/decimals, percents, roots, ratio."
        },
        {
          "topic": "Probability and counting",
          "weight": 0.1,
          "notes": "Single-event probability, simple independent events."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "If x + 6 = 7, then x is equal to",
          "choices": [
            "-1",
            "0",
            "1",
            "7"
          ],
          "answerIndex": 2,
          "explanation": "Subtract 6 from both sides: x = 7 - 6 = 1. The distractors are the sign flip (-1), the null operation (0), and the restated right side (7).",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "If x - y is not zero, then (x^2 - y^2) / (x - y) =",
          "choices": [
            "x + y",
            "x - y",
            "x + 2y",
            "2x - y"
          ],
          "answerIndex": 0,
          "explanation": "Factor the difference of squares: x^2 - y^2 = (x + y)(x - y), which cancels the denominator and leaves x + y. Option B simply echoes the denominator.",
          "difficulty": "hard",
          "provenance": "official"
        },
        {
          "stem": "If 50 percent of x = 66, then x =",
          "choices": [
            "33",
            "66",
            "99",
            "132"
          ],
          "answerIndex": 3,
          "explanation": "0.5x = 66, so x = 66/0.5 = 132. Option A halves again instead of doubling, and option B ignores the percent entirely.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "The ratio 36 : 12 is the same as",
          "choices": [
            "2 : 1",
            "3 : 1",
            "4 : 1",
            "5 : 1"
          ],
          "answerIndex": 1,
          "explanation": "Divide both terms by the greatest common factor, 12: 36/12 = 3 and 12/12 = 1, giving 3 : 1. The alternatives come from rounding or dividing only one side.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "A bag contains 3 red and 5 blue marbles. If one marble is drawn at random, what is the probability that it is red?",
          "choices": [
            "3/5",
            "3/8",
            "5/8",
            "1/3"
          ],
          "answerIndex": 1,
          "explanation": "There are 3 favorable outcomes out of 3 + 5 = 8 total, so the probability is 3/8. Option A divides by the blue count and C is the probability of drawing blue.",
          "difficulty": "medium",
          "provenance": "original"
        }
      ],
      "commonMistakes": [
        "Percent direction errors (halving again instead of doubling).",
        "Sign errors when transposing terms.",
        "Using the diameter where the radius belongs (area is pi*r*r).",
        "Using the favorable count instead of the total as a probability denominator.",
        "Not recognizing factorable forms and attempting long division.",
        "Treating MK as AR (writing equations for direct computations) or vice versa.",
        "Unit slips in geometry: perimeter vs area vs volume, square vs cubic units.",
        "Depending on a calculator that does not exist on the real test."
      ]
    },
    {
      "abbr": "EI",
      "name": "Electronics Information",
      "questions": 15,
      "minutes": 10,
      "catQuestions": 15,
      "catMinutes": 10,
      "paperQuestions": 20,
      "paperMinutes": 9,
      "domains": [
        {
          "topic": "Electrical quantities, symbols, units, abbreviations, meters",
          "weight": 0.15,
          "notes": "Official topic list; weight [ESTIMATE]. Volt/amp/ohm/watt, AC vs DC, schematic symbols, instrument identification."
        },
        {
          "topic": "DC circuits: series vs parallel, Ohm's law, resistance rules",
          "weight": 0.3,
          "notes": "The computational core: V = IR, P = VI, series/parallel behavior, one-bulb-out consequences."
        },
        {
          "topic": "Components and devices",
          "weight": 0.25,
          "notes": "Resistor, capacitor, inductor, diode, transistor, relay, transformer, fuse."
        },
        {
          "topic": "Electrical and electronic systems",
          "weight": 0.2,
          "notes": "Motors, generators, alternators, batteries, ignition/charging, AC distribution."
        },
        {
          "topic": "Tools, materials, wiring and safety",
          "weight": 0.1,
          "notes": "Solder, insulation, wire gauge, conduit, fuses/breakers, grounding."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Which of the following has the least resistance?",
          "choices": [
            "wood",
            "iron",
            "rubber",
            "silver"
          ],
          "answerIndex": 3,
          "explanation": "Silver is the best room-temperature conductor among common metals, hence the lowest resistance. Wood and rubber are insulators; iron conducts but far worse than silver.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "In the circuit diagram, the resistance is 100 ohms and the current is 0.1 amperes. The voltage is",
          "choices": [
            "5 volts.",
            "10 volts.",
            "100 volts.",
            "1,000 volts."
          ],
          "answerIndex": 1,
          "explanation": "Ohm's law gives V = IR = 100 x 0.1 = 10 volts. Option D is the decimal-point slip and C merely repeats the resistance value.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "The circuit shown contains a battery and two light bulbs. If one light bulb burns out, the other will",
          "choices": [
            "no longer burn.",
            "continue to burn.",
            "flicker on and off.",
            "burn more brightly."
          ],
          "answerIndex": 0,
          "explanation": "The bulbs are in series, so the single current path is broken and both go dark. 'Continue to burn' is the parallel-circuit intuition misapplied.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Which of the following is measured using an ohmmeter?",
          "choices": [
            "voltage",
            "resistance",
            "inductance",
            "capacitance"
          ],
          "answerIndex": 1,
          "explanation": "An ohmmeter measures resistance in ohms; voltmeters measure potential difference, while inductance and capacitance need LCR meters or bridges.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "Because solid state diodes have no filament, they",
          "choices": [
            "don't work.",
            "are less efficient than tubes.",
            "require less operating power.",
            "require more operating power."
          ],
          "answerIndex": 2,
          "explanation": "With no heated filament to power, a solid-state diode dissipates far less operating power than a vacuum tube. Option B inverts the historical reason solid state replaced tubes.",
          "difficulty": "medium",
          "provenance": "official"
        }
      ],
      "commonMistakes": [
        "Series/parallel confusion, especially the one-bulb-burns-out family.",
        "Rearranging Ohm's law incorrectly (V = I/R) under time pressure.",
        "Decimal-point errors with currents like 0.1 A.",
        "Confusing resistance with conductance when the stem says 'least resistance'.",
        "Mixing voltage (across) with current (through) when reading a schematic.",
        "Answering from automotive intuition instead of electronics principles.",
        "Skipping EI, which drives electronics line scores."
      ]
    },
    {
      "abbr": "AS",
      "name": "Auto & Shop Information (AI + SI)",
      "questions": 20,
      "minutes": 13,
      "catQuestions": 20,
      "catMinutes": 13,
      "paperQuestions": 25,
      "paperMinutes": 11,
      "domains": [
        {
          "topic": "Shop: hand tools, identification and correct use",
          "weight": 0.18,
          "notes": "Official area list; weight [ESTIMATE]. Rip vs crosscut vs coping vs back saws, chisels, clamps, planes, files, measuring tools."
        },
        {
          "topic": "Auto: engine, combustion, lubrication, cooling",
          "weight": 0.16,
          "notes": "Four-stroke cycle, piston rings, oil pump, radiator/thermostat/water pump."
        },
        {
          "topic": "Auto: drivetrain, brakes, steering, suspension",
          "weight": 0.16,
          "notes": "Transmission/clutch concept, differential, hydraulic brakes, shock absorbers."
        },
        {
          "topic": "Shop: power tools, materials, fasteners",
          "weight": 0.16,
          "notes": "Drill press, circular/table saw, wood species and sheet goods, metal stock, screws/nails/bolts, adhesives."
        },
        {
          "topic": "Shop: building and construction procedures",
          "weight": 0.16,
          "notes": "Framing, layout, joinery, concrete/masonry basics, finishing, safety."
        },
        {
          "topic": "Auto: automotive electrical and ignition",
          "weight": 0.09,
          "notes": "Battery, alternator, starter, spark plugs, ignition timing concept."
        },
        {
          "topic": "Auto: automotive tools, troubleshooting, maintenance",
          "weight": 0.09,
          "notes": "Diagnostic reasoning ('uses too much oil when which part is worn'), jack/stand safety, service tasks."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Shock absorbers on a car connect the axle to the",
          "choices": [
            "wheel.",
            "chassis.",
            "drive shaft.",
            "exhaust pipe."
          ],
          "answerIndex": 1,
          "explanation": "A shock absorber (damper) is mounted between the axle/suspension assembly and the vehicle body (chassis) to dissipate oscillation. The wheel is at the far end of the same assembly, which is the trap.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "The radiator on a car is part of the",
          "choices": [
            "cooling system.",
            "ignition system.",
            "electrical system.",
            "lubrication system."
          ],
          "answerIndex": 0,
          "explanation": "The radiator transfers heat from engine coolant to the air, which defines the cooling system. Engine oil also carries heat, which is why the lubrication system is a plausible distractor.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "A car uses too much oil when which of the following parts are worn?",
          "choices": [
            "pistons",
            "piston rings",
            "main bearings",
            "connecting rods"
          ],
          "answerIndex": 1,
          "explanation": "Piston rings seal the combustion chamber from the crankcase; worn rings let oil into the cylinder where it burns, raising consumption. Worn main bearings reduce oil pressure rather than consumption.",
          "difficulty": "hard",
          "provenance": "official"
        },
        {
          "stem": "Sanding blocks are used to",
          "choices": [
            "prevent high spots and ridges on sanded surfaces.",
            "prevent dirt from collecting on the sandpaper.",
            "stretch the length of the sandpaper.",
            "prolong the use of the sandpaper."
          ],
          "answerIndex": 0,
          "explanation": "A rigid block spreads finger pressure over a flat area, preventing the dishing and ridges that hand-sanding creates. The other options are plausible maintenance claims unrelated to the block's purpose.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Which handsaw should be used to make a rough cut with the grain in a thick board?",
          "choices": [
            "ripsaw",
            "backsaw",
            "coping saw",
            "crosscut saw"
          ],
          "answerIndex": 0,
          "explanation": "A ripsaw has large chisel-like teeth filed for cutting along the grain; a crosscut saw is filed for cutting across it. Backsaws and coping saws are for joinery and curves.",
          "difficulty": "medium",
          "provenance": "official"
        }
      ],
      "commonMistakes": [
        "Grain-direction confusion: rip vs crosscut saw (and the same error for plane blades and chisels).",
        "Naming the part that fails because of wear rather than the part whose wear causes the symptom.",
        "Confusing systems that share components (oil and coolant both remove heat; battery and alternator both supply electricity).",
        "Identifying tools by silhouette instead of function (clamp, plier and wrench types).",
        "Crossing wood and metal shop practice, or choosing the wrong fastener for the material.",
        "Skipping the subtest on the belief that it requires prior shop class; the pool rewards general mechanical reasoning."
      ]
    },
    {
      "abbr": "MC",
      "name": "Mechanical Comprehension",
      "questions": 15,
      "minutes": 22,
      "catQuestions": 15,
      "catMinutes": 22,
      "paperQuestions": 25,
      "paperMinutes": 19,
      "domains": [
        {
          "topic": "Simple machines: levers, pulleys/block-and-tackle, inclined plane, wheel and axle, screw",
          "weight": 0.28,
          "notes": "Official topic list; weight [ESTIMATE]. MA = load/effort, effort arm/load arm, rope-segment counting."
        },
        {
          "topic": "Structural support and loads",
          "weight": 0.18,
          "notes": "Beam/post load sharing, center of gravity, trusses, tension vs compression."
        },
        {
          "topic": "Gears and gear trains",
          "weight": 0.15,
          "notes": "Rotation direction, teeth-to-RPM ratio, compound trains (official: gear A 14 revs, gear B 21)."
        },
        {
          "topic": "Mechanical motion and friction",
          "weight": 0.15,
          "notes": "Velocity/acceleration concept, friction direction and effect, work vs power, efficiency."
        },
        {
          "topic": "Fluid dynamics and pressure",
          "weight": 0.14,
          "notes": "Hydraulic advantage (force/area), pressure vs depth, buoyancy, valve behavior by pressure differential."
        },
        {
          "topic": "Properties of materials",
          "weight": 0.1,
          "notes": "Strength/stiffness/elasticity vs plasticity, corrosion, thermal expansion, material selection."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Extending the reach of the crane will shift its",
          "choices": [
            "total weight.",
            "allowable speed.",
            "center of gravity.",
            "center of buoyancy."
          ],
          "answerIndex": 2,
          "explanation": "Extending the boom moves mass outward, so the center of gravity shifts toward the load and the overturning moment grows. Total weight is unchanged by geometry, and center of buoyancy is a ship concept used as a plausible distractor.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "Why does the intake valve open on this pump when the piston goes down?",
          "choices": [
            "Air pressure at X is less than air pressure at Y.",
            "Air pressure at Z is less than air pressure at X.",
            "Air pressure at X is greater than air pressure at Y.",
            "Air pressure at Y is greater than air pressure at Z."
          ],
          "answerIndex": 2,
          "explanation": "A valve opens toward the lower pressure, so the intake opens when the pressure on its far side (X) exceeds the pressure inside the cylinder (Y). The mirrored option is the sign-flip trap.",
          "difficulty": "hard",
          "provenance": "official"
        },
        {
          "stem": "If gear A makes 14 revolutions, gear B will make 21. Which statement is true?",
          "choices": [
            "Gear A has more teeth than gear B.",
            "Gear B has more teeth than gear A.",
            "The two gears have the same number of teeth.",
            "Gear B cannot turn faster than its driver."
          ],
          "answerIndex": 0,
          "explanation": "Revolutions are inversely proportional to tooth counts; since B turns 1.5 times faster, B must have fewer teeth, so A has more. The item forces the inverse relationship rather than a formula lookup.",
          "difficulty": "medium",
          "provenance": "original"
        },
        {
          "stem": "A lever is used to lift a 200-pound rock. If the effort arm is 4 feet and the load arm is 1 foot, how much effort force is required? (Ignore the lever's own weight.)",
          "choices": [
            "25 pounds",
            "50 pounds",
            "200 pounds",
            "800 pounds"
          ],
          "answerIndex": 1,
          "explanation": "Mechanical advantage is effort arm / load arm = 4/1 = 4, so effort = load / MA = 200/4 = 50 pounds. Option D multiplies instead of dividing and A divides twice.",
          "difficulty": "easy",
          "provenance": "original"
        },
        {
          "stem": "A block and tackle has three rope segments supporting the movable block. Ignoring friction, the effort needed to lift a 300-pound load is about",
          "choices": [
            "75 pounds",
            "100 pounds",
            "150 pounds",
            "900 pounds"
          ],
          "answerIndex": 1,
          "explanation": "Each supporting rope segment carries an equal share, so effort = load / segments = 300/3 = 100 pounds. Option C miscounts two segments and D multiplies instead of dividing.",
          "difficulty": "medium",
          "provenance": "original"
        }
      ],
      "commonMistakes": [
        "Counting rope segments wrong (count only those supporting the movable block).",
        "Inverting the mechanical-advantage ratio (multiplying instead of dividing).",
        "Gear-direction errors with idler gears, which reverse direction but do not change the ratio.",
        "Assuming a longer lever is always easier regardless of fulcrum position; confusing lever classes.",
        "Answering 'total weight' where center of gravity is the issue.",
        "Reasoning valves by flow direction instead of pressure differential.",
        "Treating friction as always undesirable when the item asks direction and effect.",
        "Applying formulas where the item only asks which of four diagrams is strongest."
      ]
    },
    {
      "abbr": "AO",
      "name": "Assembling Objects",
      "questions": 15,
      "minutes": 18,
      "catQuestions": 15,
      "catMinutes": 18,
      "paperQuestions": 25,
      "paperMinutes": 15,
      "domains": [
        {
          "topic": "Fit-together (jigsaw) items: pieces rotate and translate to form one object",
          "weight": 0.6,
          "notes": "Both formats [OFFICIAL-VERIFIED]; the 60/40 split is [ESTIMATE]. Rules: rotate/translate only, never mirror, flip, stretch or rescale."
        },
        {
          "topic": "Connection items: match labeled attachment points on two or more pieces",
          "weight": 0.4,
          "notes": "Tests attachment-point tracking rather than silhouette matching."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Two congruent right triangles, each with legs 3 and 4 and hypotenuse 5, are joined along their hypotenuses. What shape do they form?",
          "choices": [
            "A 3-by-4 rectangle.",
            "A 4-by-4 square.",
            "A 7-by-3 rectangle.",
            "A trapezoid with parallel sides 3 and 4."
          ],
          "answerIndex": 0,
          "explanation": "Joining two congruent right triangles along the hypotenuse produces a rectangle whose sides are the two legs, 3 and 4 (area 12 = 2 x 6). A square would require equal legs.",
          "difficulty": "easy",
          "provenance": "original"
        },
        {
          "stem": "Piece 1 is a 6-by-2 rectangle. Piece 2 is a 6-by-4 rectangle with a 6-by-2 slot cut out of its top edge. Fitted together, the two pieces form",
          "choices": [
            "a 6-by-4 rectangle.",
            "a 6-by-6 square.",
            "a 12-by-4 rectangle.",
            "an L shape."
          ],
          "answerIndex": 0,
          "explanation": "Piece 1 has 12 square units and piece 2 has 24 - 12 = 12, for 24 total, and the slot is exactly the shape of piece 1, so the union fills a 6-by-4 rectangle. Area alone eliminates 36 and 48.",
          "difficulty": "easy",
          "provenance": "original"
        },
        {
          "stem": "Piece A is a 4-by-4 square with a 1-by-2 tab extending from its top edge. Piece B is a 4-by-4 square with a matching 1-by-2 slot cut into its bottom edge. Fitted together without overlap, they form",
          "choices": [
            "a 4-by-8 rectangle.",
            "a 4-by-8 rectangle with a 1-by-2 hole.",
            "an 8-by-8 square.",
            "a T shape."
          ],
          "answerIndex": 0,
          "explanation": "Areas are 16 + 2 = 18 and 16 - 2 = 14, totaling 32 = 4 x 8, and the tab fills the slot so no void remains. The hole option traps solvers who see the slot but forget the tab is the filler.",
          "difficulty": "medium",
          "provenance": "original"
        },
        {
          "stem": "An L-shaped piece has a 3-unit arm and a 2-unit arm meeting at a square corner. Held with the 3-unit arm pointing up and the 2-unit arm pointing right, the piece is rotated 90 degrees clockwise. Which description matches the result?",
          "choices": [
            "The 3-unit arm points right and the 2-unit arm hangs down from its left end.",
            "The 3-unit arm points right and the 2-unit arm rises from its right end.",
            "The 3-unit arm points left and the 2-unit arm rises from its right end.",
            "The 3-unit arm points down and the 2-unit arm points right."
          ],
          "answerIndex": 0,
          "explanation": "A 90-degree clockwise rotation maps up to right and right to down, so the 3-arm ends up horizontal to the right and the 2-arm vertical downward, still meeting at the same corner. Option B is a mirror image, exactly the error AO is built to catch.",
          "difficulty": "medium",
          "provenance": "original"
        },
        {
          "stem": "Four identical right triangles with legs 3 and 4 are arranged around a central square hole of side 5, their hypotenuses forming the hole's edges. What is the area of the smallest square that contains the four triangles and the hole?",
          "choices": [
            "25",
            "48",
            "49",
            "50"
          ],
          "answerIndex": 2,
          "explanation": "Each triangle's legs lie along the outer square's edges, so the outer side is 3 + 4 = 7 and the area is 49 (the standard Pythagorean arrangement). Option A is the hole alone, and 24 + 25 = 49 confirms the decomposition.",
          "difficulty": "hard",
          "provenance": "original"
        }
      ],
      "commonMistakes": [
        "Selecting the answer that requires a mirrored or flipped piece.",
        "Matching the overall silhouette while ignoring an internal notch or tab.",
        "Assuming a piece may be scaled to fit.",
        "Losing attachment-point correspondence in the connection format.",
        "Mentally rotating the whole assembly when only one piece may move.",
        "Spending too long: at 72 seconds per item, mark and move on; AO is not in the AFQT."
      ]
    },
    {
      "abbr": "VE",
      "name": "Verbal Expression (derived composite: WK + PC)",
      "questions": 25,
      "minutes": 36,
      "catQuestions": 25,
      "catMinutes": 36,
      "paperQuestions": 50,
      "paperMinutes": 24,
      "domains": [
        {
          "topic": "Word Knowledge contribution (synonyms in and out of context)",
          "weight": 0.6,
          "notes": "Derived, not administered. CAT basis 15 of 25 items; P&P basis 35 of 50 items [OFFICIAL-DERIVED]."
        },
        {
          "topic": "Paragraph Comprehension contribution (main idea, detail, inference, tone)",
          "weight": 0.4,
          "notes": "Derived. CAT basis 10 of 25; P&P basis 15 of 50. Feeds AFQT and nearly every line score, including GT = VE + AR."
        }
      ],
      "sampleQuestions": [
        {
          "stem": "Small most nearly means",
          "choices": [
            "sturdy.",
            "round.",
            "cheap.",
            "little."
          ],
          "answerIndex": 3,
          "explanation": "The nearest synonym for small is little, the official CEP example for Word Knowledge. 'Cheap' rides along on the commercial sense of small ('small price') and is the intended trap.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "The wind is variable today.",
          "choices": [
            "mild",
            "steady",
            "shifting",
            "chilling"
          ],
          "answerIndex": 2,
          "explanation": "Variable wind means it shifts direction or speed, so shifting is the nearest meaning. Mild, steady and chilling describe conditions rather than variability; 'steady' is the near-antonym trap.",
          "difficulty": "easy",
          "provenance": "official"
        },
        {
          "stem": "From a building designer's standpoint, three things that make a home livable are the client, the building site, and the amount of money the client has to spend. According to this statement, to make a home livable",
          "choices": [
            "the prospective piece of land makes little difference.",
            "it can be built on any piece of land.",
            "the design must fit the owner's income and site.",
            "the design must fit the designer's income."
          ],
          "answerIndex": 2,
          "explanation": "The statement names client, site and budget as the three factors, so the design must fit the owner's income and site. The other options contradict the listed factors or confuse who supplies the money.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "In certain areas, water is so scarce that every attempt is made to conserve it. For instance, on one oasis in the Sahara Desert the amount of water necessary for each date palm tree has been carefully determined. How much water should each tree be given?",
          "choices": [
            "no water at all",
            "exactly the amount required",
            "water on alternate days",
            "water only if it is healthy"
          ],
          "answerIndex": 1,
          "explanation": "If the need has been 'carefully determined' for each tree, the passage implies giving exactly that determined amount. The alternatives impose schedules or conditions the passage never mentions.",
          "difficulty": "medium",
          "provenance": "official"
        },
        {
          "stem": "A chisel is used for",
          "choices": [
            "prying.",
            "cutting.",
            "twisting.",
            "grinding."
          ],
          "answerIndex": 1,
          "explanation": "Included here because VE measures the same verbal reading skill that decodes technical stems: a chisel is an edge tool used for cutting (paring or chopping) wood or metal. Prying is the misuse that ruins the edge.",
          "difficulty": "easy",
          "provenance": "official"
        }
      ],
      "commonMistakes": [
        "Treating VE as a separate test to study, when it is only WK plus PC.",
        "Under-investing in PC because it has only 10 CAT items while it contributes 40% of VE.",
        "Ignoring VE when selecting an enlistment goal, since GT = VE + AR gates a large share of technical jobs."
      ]
    }
  ],
  "commonMistakes": [
    {
      "class": "answered-the-wrong-quantity",
      "lesson": "Learner computes a valid intermediate value and selects it (amount lost vs value left; party A vs party B). Countermeasure: before computing, restate the asked quantity; after computing, re-read the stem's last sentence.",
      "subtests": [
        "AR",
        "MK",
        "MC"
      ]
    },
    {
      "class": "restatement-as-explanation",
      "lesson": "Learner accepts a sentence that repeats the premise instead of naming a mechanism ('it is lighter' for density). Countermeasure: require a 'because' clause that introduces a new causal fact.",
      "subtests": [
        "GS",
        "PC",
        "EI"
      ]
    },
    {
      "class": "semantic-neighbor",
      "lesson": "Learner picks a word from the right semantic field at the wrong level of specificity (struggle for provoke; details for fundamentals). Countermeasure: rank choices by closeness and reject any choice that is a category member rather than a synonym.",
      "subtests": [
        "WK",
        "PC"
      ]
    },
    {
      "class": "inverted-relation",
      "lesson": "Learner applies the ratio upside-down (mechanical advantage, gear teeth vs RPM, percent change, radius vs diameter, effort vs load). Countermeasure: sanity-check direction ('does more effort arm mean less force?').",
      "subtests": [
        "AR",
        "MK",
        "MC",
        "EI"
      ]
    },
    {
      "class": "true-but-unsupported",
      "lesson": "Learner selects a real-world fact that the passage or data never states. Countermeasure: point to the exact sentence that licenses the choice; if none exists, reject it.",
      "subtests": [
        "PC",
        "GS"
      ]
    },
    {
      "class": "format-rule-violation",
      "lesson": "Learner mirrors or flips a piece in AO, blind-guesses on the CAT despite the penalty, or leaves bubbles empty on the P&P form. Countermeasure: format-gate the strategy coaching.",
      "subtests": [
        "AO",
        "AR",
        "WK",
        "PC",
        "MK",
        "EI",
        "AS",
        "MC",
        "GS"
      ]
    }
  ],
  "unverified": [
    "All per-topic percentage weights (not published by the ASVAB program).",
    "AFQT raw weights 2*VE + AR + MK (consistent with official statements, not published).",
    "All line-score composite formulas except VE = WK + PC and the structural fact that composites are sums of subtest standard scores.",
    "The AO rotation-only/never-mirrored rule (universal in prep literature, not stated in a retrieved official document).",
    "Whether the current CEP iCAT includes AO.",
    "Every per-item difficulty label (mapped by the author onto the official p-value bands; not calibrated)."
  ]
}
```




