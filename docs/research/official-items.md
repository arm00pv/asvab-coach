# ASVAB — Official Item Presentation & Format Research (2024–2026 cycle)

**Prepared:** 2026-10-25
**Purpose:** ground truth for item authoring in the ASVAB Coach study app, for candidates sitting the ASVAB in 2026.
**Audience:** item writers, reviewers, QA. Read §0 before writing a single item.

**Evidence tags used throughout**

- **[VERIFIED]** — I fetched the primary document myself on 2026-10-25 and read the statement/item. URL given.
- **[SECONDARY]** — Derived by arithmetic or inference from a verified primary source, or taken from a credible non-official source. Reasoning is stated.
- **[UNVERIFIED]** — Widely repeated claim, recollection, or inference I could not confirm in an official document. **Do not encode these into the app without further checking.**

**Copyright note.** Nothing below reproduces study-guide or commercial prep content. I quote only short excerpts of **US Government–published sample items** (officialasvab.com and the ASVAB Career Exploration Program publications of the Department of Defense), with attribution and link. All *illustrative* items in §3 are **my own construction** and are labelled as such; they imitate the documented convention and do not reproduce any real ASVAB item.

---

## 0. Ten rules that fall out of the evidence

1. **Four options. Always. Every subtest.** Verified twice over: doctrine ("one-stem, four-response options format") and by counting all 38 official website sample items (exactly 4 each).
2. **One stem, one question.** There are no multi-part stems, no "I and II only" option sets, no matching grids, no multi-select.
3. **WK is both a bare word and a word in context.** Both forms are official and both appear in official samples. An app that only does bare synonyms is not representative.
4. **PC is one question per passage on the computer test, but five per passage on paper.** This is the single biggest format trap.
5. **MK is symbolic/conceptual, not narrative.** "Word problems" is the official description of AR, not MK.
6. **MC is overwhelmingly figure-driven** in official samples, and its options are often just the letters A–D pointing at features drawn inside the figure.
7. **AO has exactly two item families**: label-matched connections, and fit-together puzzles. Both are 100% pictorial.
8. **AS is one score, two tests.** On the computer it is AI then SI administered separately; on paper it is one 25-item AS block (13 AI + 12 SI).
9. **Difficulty is expressed as p-values**, with the program's own easy/medium/hard cut points at .75 and .45 — and the program explicitly says those cut points **vary by subtest**.
10. **Reading level is officially "grade 10 or higher"**, not 9th grade.

---

## 1. What the ASVAB program actually publishes for free, and how big it is

### 1.1 The inventory

| Resource | Where | Items | Free | Status |
|---|---|---|---|---|
| Subtest sample questions (10 pages, one per subtest) | https://www.officialasvab.com/applicants/sample-questions/ | **38 items total** (GS 4, AR 4, WK 4, PC 4, MK 4, EI 4, AI 4, SI 3, MC 5, AO 2) | Yes, no login | **[VERIFIED]** — counted from page markup 2026-10-25; every item has exactly 4 options |
| Mirror of the same sample index for educators | https://www.officialasvab.com/counselors-educators/sample-questions/ | same set | Yes | **[VERIFIED]** page exists; content is the same set |
| ASVAB Fact Sheet (4 pp. PDF) | https://www.officialasvab.com/wp-content/uploads/2026/10/ASVAB-Fact_Sheet.pdf | 0 items | Yes | **[VERIFIED]** — 2026 upload |
| ASVAB Career Exploration Program **Overview** booklet (32 pp., DD Form 1304-5OV, FEB 2026) | https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Overview.pdf | **32 numbered sample questions + 8 worked examples**, answer key on p. 28 | Yes | **[VERIFIED]** — FEB 2026 edition |
| ASVAB CEP **Technical Summary** | https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Technical_Chapter.pdf | 0 items | Yes | **[VERIFIED]** — contains the official reading-level statement |
| ASVAB **Technical Bulletins 1–4** (DMDC / Personnel Testing Division) | https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_1.pdf (…_2, _3, _4) | 0 items | Yes | **[VERIFIED]** — TB4 = P&P Forms 23–27, March 2009 rev. May 2012; TB3 = CAT Forms 5–9; TB2 = CAT Forms 3–4; TB1 = CAT Forms 1–2, March 2006 |
| "Understanding ASVAB Scores" | https://www.officialasvab.com/applicants/scores/ (and /recruiters/scores/, /researchers/scores/, /counselors-educators/scores/) | 0 items | Yes | **[VERIFIED]** |
| ASVAB CEP interactive sample items (image assets) | https://www.asvabprogram.com/assets/images/q14_asvabtest.jpg … q40_asvabtest.jpg | ~27 image files | Yes | **[VERIFIED]** the files still resolve (HTTP 200, image/jpeg) on 2026-10-25; **[SECONDARY]** that they constitute the CEP site's on-screen sample-question set (the surrounding page is an Angular SPA I could not render) |
| March2Success (US Army) | https://www.march2success.com/ | ASVAB practice tests behind free registration | Yes | **[VERIFIED]** that the official ASVAB programme names it as a recommended free prep site; **[UNVERIFIED]** exact ASVAB test/item counts |
| PiCAT & APT User's Guide v5.8 | https://etoolbox.cnrc.navy.mil/assets/ARM/PiCAT-APT_UserGuide_v5.8_20231025.pdf | 0 items | Yes (CUI-marked, publicly reachable) | **[VERIFIED]** — dated October 2023, i.e. outside the 2024–2026 window; treat as recent-but-older |
| DACMPT briefing, *CAT-ASVAB Pool + P&P-ASVAB Form Development* (HumRRO) | https://dacmpt.com/wp-content/uploads/2022/12/04-CAT-and-PP-ASVAB-Pool-Form-Development-DACMPT-12-15-22.pdf | 0 items | Yes | **[VERIFIED]** — 15 Dec 2022; the most recent public statement of test lengths and blueprints I found |

### 1.2 What does **not** exist

- **There is no official full-length practice ASVAB.** **[VERIFIED]** — the programme's own "legitimate test preparation" notice lists exactly three free routes, and none of them is a full-length official practice form:

  > "reviewing free ASVAB practice tests or sample questions found at https://asvabprogram.com/student and https://www.officialasvab.com/applicants/sample-questions ; and using the Army's free online courses and test-prep programs found at https://www.march2success.com"

  — https://www.officialasvab.com/applicants/asvab-test-preparation-disclaimer/ (page updated 2025-06-09)

- **The programme does not release operational items, and disclaims anyone claiming to have them.** **[VERIFIED]**, same notice:

  > "The ASVAB Enlistment Testing Program does NOT provide actual test questions to any third-party test preparation service; endorse any paid program claiming to guarantee passing scores; recommend specific commercial ASVAB prep courses or study guides; or authorize any entity to sell 'correct answers' to the test."

- **DoD treats live items as controlled material.** **[VERIFIED]** — https://www.officialasvab.com/applicants/what-to-expect/ : "ASVAB test questions are treated as controlled testing materials. You should neither accept nor give information about specific test questions to other individuals."

- **MEPCOM's own site (mepcom.army.mil) returned HTTP 403 to my fetch**; I could not verify any MEPCOM-hosted ASVAB item-format fact sheet. **[UNVERIFIED]** — flagging the gap rather than filling it.

**Implication for the app:** any claim of "official ASVAB questions" in marketing copy is both false and specifically called out by the test maker. Position all content as *format-faithful original items*.

---

## 2. Per-subtest presentation conventions

### 2.1 Master format facts (all subtests)

**[VERIFIED]** Technical Bulletin No. 4, §3.2.2 (report p. 14, PDF p. 21):

> "All subtests had the typical multiple choice **one-stem, four-response options** format. In Forms 23–26, PC had **five items associated with each reading passage**."

> "Graphics were used when appropriate for an item; decorative art was not used. **The ASVAB subtests that included graphics were MK, GS, AS, MC, EI and AO.**"

**[SECONDARY]** Corroboration of four options from the psychometrics: TB4 Tables 6.5–6.13 report 3-PL guessing parameters (c) with subtest means clustered at **0.20–0.25** — the 1-in-4 chance floor. A five-option test would sit nearer 0.20 uniformly; four options predict 0.25, and WK's mean c is 0.21–0.25.

### 2.2 GS — General Science

- **Presentation.** Standalone 4-option multiple choice, no stimulus. Two stem shapes dominate: an incomplete sentence with "because" / "is called" / "are called", and a small number of direct questions. Diagram-bearing items exist (TB4 lists GS among the graphics subtests) but none of the 8 officially published GS samples is a figure item.
- **Content taxonomy [VERIFIED]** CEP Overview p. 17: life science = botany, zoology, anatomy and physiology, ecology; earth and space = astronomy, geology, meteorology, oceanography; physical = force and motion mechanics, energy, fluids, atomic structure, chemistry.
- **Official stems [VERIFIED]**, short excerpts from the ASVAB programme's published sample questions: *"Air is less dense than water because ___"*, *"Salt helps to melt ice because it ___"*, *"The principal gas in the earth's atmosphere is ___"*, *"Substances that hasten chemical reaction time without themselves undergoing change are called ___"*.
- **Options** are noun phrases or clauses, capitalised, sentence-cased, ending in a period.

### 2.3 AR — Arithmetic Reasoning

- **Presentation.** Word problems only. No figure items, no bare computation. Official description **[VERIFIED]** CEP Overview p. 18: "One-step and multi-step word problems require addition, subtraction, multiplication, and division, and choosing the correct order of operations when more than one step is necessary." Content set: whole numbers, rational numbers, ratio and proportion, interest and percentage, measurement.
- **Options are bare numerals or currency amounts**, usually ascending, with real formatting quirks in the official items (for example $ 870 vs $1,250 vs $5,920 vs $6,380). **[VERIFIED]** Do not imitate the typographic glitch; do imitate that AR options carry no explanatory words.
- **No calculator.** **[VERIFIED]** officialasvab.com FAQ: "the ability to do math without a calculator is assessed on the ASVAB."

### 2.4 WK — Word Knowledge — highest-risk subtest for an app

- **The official description names both presentations** **[VERIFIED]** (2026 Fact Sheet p. 2; also /counselors-educators/subtests/ and /applicants/what-to-expect/):

  > "Ability to select the correct meaning of **words presented in context** **and** to identify **best synonym** for a given word"

- **Both appear in the official samples.** **[VERIFIED]** Of the four items on officialasvab.com/word-knowledge-wk/, **three are bare-word** and **one is in-context**; the target word is **underlined** in the rendered stem (confirmed directly in the page's quiz markup, where the stem is "underlined target most nearly means"). The CEP Overview FEB 2026 booklet likewise has both: a bare item (*"Rudiments most nearly means"*) and an in-context item (*"The wind is variable today."*).
- **Bare-word stem formula:** TARGET most nearly means — no question mark.
- **In-context stem formula:** a single short sentence containing the target, with the target underlined, and **no trailing prompt at all** — the four options follow immediately. There is no "In this sentence, X most nearly means" wrapper.
- **Options:** single words or at most a two-word phrase, lower case, and in the website rendering each ends with a period (embarrass. / struggle. / provoke. / worship.). The same trailing-period convention holds for the in-context item's bare-word options (anxiety / change / enjoyment / endorsement). **[VERIFIED]**
- **Distractor design, documented.** The programme's WK enemy-item algorithm "extract[s] the focal word from item stems and the corresponding keyed responses", confirming that the stem has one focal word and the options are single lexical items. **[VERIFIED]** DACMPT 2022 slide 12.

### 2.5 PC — Paragraph Comprehension — second-highest-risk

**One question per passage on the computer, five per passage on paper.**

- **[VERIFIED]** TB4 §3.2.2: "In Forms 23–26, PC had five items associated with each reading passage."
- **[VERIFIED]** TB1 (2006), Item Pool Development chapter p. 2-2: "The Paragraph Comprehension test (as measured in P&P-ASVAB) typically contains reading passages followed by several questions referring to the same passage. Items of these types are likely to violate the assumption of local independence made by the standard unidimensional IRT model. Consequently, **CAT-ASVAB items were written to have a single question per passage**."
- **[VERIFIED]** DACMPT 2022 slide 29 restates both as a live engineering problem: "When P&P-ASVAB was originally developed, Paragraph Comprehension (PC) items were developed with 5 questions per paragraph stimulus. CAT-ASVAB items are developed with one question per paragraph stimulus. Maintaining a fifteen-item PC test would result in increasing the number of paragraphs from three to fifteen."

**Consequence:** a 2026 candidate on the CAT-ASVAB, iCAT or PiCAT sees **10 passages × 1 question**. A candidate at one of the few remaining paper MET sites sees **15 items built from 3 passages × 5 questions**.

**[SECONDARY]** The 2022 recommendation was to cut paper PC to 10 items (10 passages) for time reasons — "Ten-item solution is optimal". The current official table still prints paper PC at 15 items / 13 min, so I treat the reduction as **not yet reflected in the published spec**.

- **Content taxonomy [VERIFIED]** CEP Technical Summary p. 3 and CEP Overview p. 21: "identifying stated and reworded facts, determining a sequence of events, drawing conclusions, identifying main ideas, determining the author's purpose and tone, and identifying style and technique." Passages are "different types of passages of varying lengths".
- **Observed stems in official samples [VERIFIED]:** *"According to the passage, some artists work with titanium because it ___"*; *"According to this statement, to make a home livable ___"*; *"The author implies that the look and atmosphere of east Texas does NOT resemble that of the ___"*; *"The 'deception' referred to in the passage is that ___"*; *"How much water should each tree be given?"*.
- **Option convention:** sentence-cased fragments that complete the stem grammatically, each ending in a period. Distractors are frequently verbatim lifts from the passage that answer a different question than the one asked — that is the observable house style.

### 2.6 MK — Mathematics Knowledge

- **Presentation: symbolic and conceptual, not narrative.** Official description **[VERIFIED]** CEP Technical Summary: "The problems focus on **concepts and algorithms** and involve number theory, numeration, algebraic operations and equations, geometry and measurement, and probability." Note the contrast with AR, whose description is the one that says "word problems" (2026 Fact Sheet p. 2: AR = "Ability to solve arithmetic word problems"; MK = "Knowledge of high school mathematics principles").
- **Does MK ever use word problems? [SECONDARY] — rarely, and never as the defining form.** Evidence: of 8 official MK samples (4 on officialasvab.com plus 4 in CEP Overview 2026), 6 are bare expressions or equations, 1 is a figure item phrased as a noun clause not a narrative (*"The volume of the brick is ___"*, with a 3-D rectangular solid labelled 8, 3 and 4), and 1 is a short applied question (*"What is the area of this square?"*). None is a multi-sentence story problem. Recommendation: keep MK symbolic plus occasional single-clause applied or geometry items; put every narrative problem in AR.
- **Math is rendered as graphics.** Official MK items use typeset fractions, radicals and superscripts (square root of 3; x squared minus y squared; 36 : 12) presented as images, plus geometry figures with dashed hidden edges for solids. The app must render math as real math, not ASCII art. **[VERIFIED]** — the MK sample page's images are mk1-equals.jpg and mk2.jpg.
- **Options:** bare expressions or values, no units unless the answer needs them, and no "cannot be determined".
- **No calculator. [VERIFIED]** FAQ.

### 2.7 EI — Electronics Information

- **Presentation: a mixture.** Verbal items use direct questions, "Which of the following…", or a completion stem; a minority are circuit-diagram items where the figure carries the whole stimulus.
- **Observed official stems [VERIFIED]:** *"The current in the 2-ohm resistor is ___"* (with a circuit schematic); *"The circuit shown in the diagram contains a battery and two light bulbs. If one light bulb burns out, the other will ___"*; *"Because solid state diodes have no filament, they ___"*; *"Which of the following is measured using an ohmmeter?"*; *"What does the abbreviation AC stand for?"*; *"Which of the following has the least resistance?"*.
- **Content taxonomy [VERIFIED]** CEP Overview p. 22: "electrical tools, symbols, devices, and materials; electrical circuits; electrical and electronic systems; and electrical currents."
- **Options:** lower-case noun phrases with periods; for the ohmmeter item the options are bare quantity names (voltage, resistance, inductance, capacitance). Numeric options for circuit items include units (5 volts.).

### 2.8 AS — Auto & Shop Information (AI + SI)

- **One score, two tests on computer.** **[VERIFIED]** 2026 Fact Sheet p. 2 note: "AI and SI are administered as separate tests in the CAT-ASVAB, but combined into one single score (labeled AS). AI and SI are combined into one test (AS) in the P&P-ASVAB." Paper AS = **25 items = 13 AI + 12 SI**. **[VERIFIED]** DACMPT 2022 slide 25.
- **Item families observed [VERIFIED]:**
  - *Component/function recall*: "The radiator on a car is part of the ___" (cooling system / ignition system / electrical system / lubrication system).
  - *Tool identification from a picture*: "The clamp shown is called a ___"; "The saw shown is used mainly to cut ___" — the picture **is** the stimulus and the stem is a sentence completion.
  - *Diagram call-out*: "Where does combustion take place?" with options that are **bare numerals 3 / 4 / 5 / 6** keyed to numbered call-outs on an engine diagram. This is a distinctive AS/EI format: options are location numbers, not words.
  - *Diagnosis / fault-finding*: "A car uses too much oil when which of the following parts are worn?" — plural part names, no periods.
- **Content taxonomy [VERIFIED]** CEP Overview p. 23: "automotive components, automotive systems, automotive tools, troubleshooting and repair, shop tools, building materials, and building and construction procedures."

### 2.9 MC — Mechanical Comprehension

**Diagrams are the house style, and options are often just A/B/C/D.** Of the **9** MC items published across the two official sample sets, **every one is figure-based**:

- officialasvab.com (5 items): crane reach, asking which quantity shifts (total weight / allowable speed / center of gravity / center of buoyancy); skier friction direction, with options A / B / C / D; piston pump valve, with four text options naming X/Y/Z pressure comparisons; which shelf supports the most weight, with options A / B / C / D; gear arrangement, with options spur / bevel / rack and pinion / worm and wheel. **[VERIFIED]**
- CEP Overview 2026 (4 items): which post holds the greater part of the load (post A / post B / both equal / not clear); which pulley turns fastest (A / B / C / D); friction on skier (A / B / C / D); intake valve X/Y/Z pressure comparison. **[VERIFIED]**

**So there are two option styles, both official:** (a) the four answer choices are the letters referring to parts drawn inside the figure — the letters A, B, C, D are printed on the drawing; (b) the choices are short verbal statements about the drawn situation.

**Is MC ever purely verbal? [SECONDARY]** Official documentation lists MC among the graphics-bearing subtests without claiming every item has a graphic (TB4 §3.2.2), and the description is knowledge-phrased ("Knowledge of mechanical and physical principles"). **No official statement says all MC items are diagrams, but 9 of 9 published samples are.** For the app: treat verbal MC items as a legitimate minority for coverage, but make diagrams the default.

**Content taxonomy [VERIFIED]** CEP Overview p. 25: "principles of mechanical devices, structural support, and properties of materials… simple machines, compound machines, mechanical motion, and fluid dynamics."

### 2.10 AO — Assembling Objects — the subtest apps most often get wrong

**Two and only two item families, confirmed by official artifacts and by the programme's own tryout taxonomy.**

**[VERIFIED]** DACMPT 2022 slide 5 defines the AO tryout seed groups as **"AP = AO Puzzles"** and **"AC = AO Connections"** — the programme's internal names for the two types.

**Type 1 — "labeled connection" / Connections (AC).**

- Stimulus: a left-hand box containing **two (occasionally more) separate shapes**. Each shape carries a **small dot marked with a lower-case letter** (a, b, …). Beside or below the shapes is a tiny **key diagram** showing the two letters joined by a straight line segment — for example a —●—●— b — telling the candidate which points must be brought together.
- Stem, verbatim official wording **[VERIFIED]**:

  > "Which figure best shows how the objects in the left box will **touch** if the letters for each object are **matched**?"

- Options: A–D boxes, each showing the same two shapes joined by a straight connector. They differ in **the angle and length of the connector** and in **the rotation of each shape about its connection point**. The shapes themselves are the same size and are not mirrored.
- The official image at https://www.officialasvab.com/wp-content/uploads/2024/03/ao-2.jpg shows exactly this: a half-disc with dot **a**, a triangle with dot **b**, a key linking a to b, and four options with the connecting bar at different angles and the triangle rotated.

**Type 2 — "fit together" / Puzzles (AP).**

- Stimulus: a left-hand box containing **three or four loose, unlabeled pieces** — typically wedge, sector and blade shapes drawn apart and at assorted rotations. **No letter labels and no key.**
- Stem, verbatim official wording **[VERIFIED]**:

  > "Which figure best shows how the objects in the left box will **appear** if they are **fit together**?"

- Options: A–D boxes each showing the **completed outline** (usually a circle or another closed figure) subdivided by internal seam lines. Options differ in **where the internal seams fall**, i.e. in how the same pieces are arranged. Pieces are rotated and translated only; nothing is resized or mirrored.
- The official image at https://www.officialasvab.com/wp-content/uploads/2024/03/ao1.jpg shows exactly this: four loose curved pieces on the left, then four circles with four different internal seam patterns.

**Other AO facts**

- **AO is 25 items / 15 min on paper**, and **15 items / 18 min on the computer**. **[VERIFIED]**
- **AO is not administered in the school / Career Exploration Program (STP).** **[VERIFIED]** officialasvab.com FAQs: "the Assembling Objects test is given in the Enlistment Testing Program but not the Student Testing Program". Consistent with this, the CEP Overview FEB 2026 booklet contains 32 sample questions and **no AO section**.
- **AO is 100% non-verbal.** It should never be modelled with text-only options in the app.

---

## 3. Illustrative items — **my own construction**, written to the documented conventions

> **Everything in §3 is invented by me for this report.** It is **not** taken from any ASVAB form, study guide, or prep product. It exists to demonstrate the conventions in §2 so the item-writing team has a visible target.

**GS — incomplete-sentence "because" stem, 4 clause options, period-terminated**

    Sound travels faster in steel than in air because steel ___
    A. is colder than air.
    B. is more elastic.
    C. weighs more per unit volume.
    D. reflects sound waves.

**AR — one-step word problem, bare numeric options**

    A crew lays 84 metres of cable in 7 hours. At the same rate, how many
    metres will it lay in 4 hours?
    A. 12
    B. 42
    C. 48
    D. 56

**WK, bare-word form — target underlined, "most nearly means", single-word options with periods**

    Reluctant (underlined) most nearly means
    A. unwilling.
    B. hurried.
    C. careless.
    D. grateful.

**WK, in-context form — one sentence, target underlined, no trailing prompt**

    The supervisor's remarks were deliberately ambiguous (underlined).
    A. brief
    B. unclear
    C. rude
    D. rehearsed

**PC, CAT-style — one passage, one question, "According to the passage…"**

    Most of the harbour's pilings were replaced in 2019, but the eastern pier was
    left untouched because the ferry that had used it was retired the year before.
    Today the pier is the only structure in the harbour still standing on timber.

    According to the passage, the eastern pier was not rebuilt because ___
    A. its timber was still sound.
    B. the vessel it served no longer ran.
    C. it stood outside the harbour.
    D. the pilings were too costly to move.

*(Note the house-style distractor: option A is a plausible inference the passage does not state. The official samples repeatedly use this "true-sounding but not stated" trap.)*

**MK — symbolic, no narrative**

    If 4x - 7 = 21, then x =
    A. 3.5
    B. 4
    C. 7
    D. 14

**EI — completion stem with a quantity answer**

    In a series circuit, adding a second identical resistor ___
    A. doubles the total resistance.
    B. halves the total resistance.
    C. leaves the total resistance unchanged.
    D. removes the need for a voltage source.

**AS — tool identification from a picture; the picture is the stimulus**

    [IMAGE: a wood chisel]  The tool shown is used mainly to ___
    A. pry nails.
    B. cut and pare wood.
    C. twist wire.
    D. smooth plaster.

**MC — options are letters printed inside the figure**

    [IMAGE: a beam supported at three points, labelled A, B and C]
    Which support carries the least load?
    A. A
    B. B
    C. C
    D. All three carry equal load.

**AO, Connections type**

    [LEFT BOX: a small square with dot c on its lower edge; a narrow bar with
     dot d at its left end; key showing c linked to d]
    Which figure best shows how the objects in the left box will touch if the
    letters for each object are matched?
    A.  B.  C.  D.   (four assembled figures differing in connector angle and
                      bar rotation)

**AO, Puzzles type**

    [LEFT BOX: a quarter-disc, a thin sliver and a large sector, unlabelled]
    Which figure best shows how the objects in the left box will appear if they
    are fit together?
    A.  B.  C.  D.   (four closed outlines differing in internal seam placement)

---

## 4. Difficulty calibration

### 4.1 The official p-value taxonomy

**[VERIFIED]** Technical Bulletin No. 4, §3.2.3 (PDF p. 22):

> "Difficulty, in classical testing theory, is defined by the item's **p value**, the proportion of examinees giving the correct response to the item. Although **the definitions of easy, medium, and hard vary by subtest**, in general, the **easy** ASVAB items had a p value **greater than .75**, **medium** difficulty items had a p value **between .75 and .45**, and **hard** items had a p value **less than .45**."

Two things to hold onto: the .75/.45 cut points are real and citable, **and** the programme explicitly refuses to treat them as universal across subtests. Do not build one global difficulty scale in the app and present it as the ASVAB's own.

### 4.2 How many of each does a candidate see?

**No official count is published. [VERIFIED] by absence** — I searched TB1–TB4, the 2026 Fact Sheet, the CAT-ASVAB pages, the PiCAT/APT guide and the DACMPT deck. What the programme says instead:

- **Paper:** forms are built to a target blueprint, not a published easy/medium/hard quota. TB4 §3.2.3: new forms were built by "matching Form 8A on an item-by-item basis with respect to content, difficulty, and discrimination"; later forms used "content taxonomies" plus "target distributions of difficulty for each subtest" (TB4 §3.1). Item writers were assigned "content taxonomy, difficulty level, and the number of items in each category" (§3.2.2). The actual numbers live in internal specifications.
- **Computer:** there is no fixed mix, by design. **[VERIFIED]** officialasvab.com/applicants/cat-asvab/: "if an examinee answers an item incorrectly… an easier item is selected to be administered next. If an examinee answers an item correctly, then a harder item is selected to be administered next." And the PiCAT/APT guide: "**All examinees begin the test with an item of average difficulty.**" A candidate's easy/medium/hard mix is an *output* of their own performance, converging toward roughly 50 percent success.
- **Practical approximation for the app [SECONDARY]:** model a competent-but-not-exceptional candidate as moving from medium into upper-medium. Never present "you will see X easy, Y medium, Z hard" as fact anywhere in the UI.

### 4.3 Calibration anchors you can use

Test lengths and time limits — all **[VERIFIED]** (officialasvab.com/applicants/what-to-expect/ and the 2026 Fact Sheet p. 3):

| Subtest | CAT / iCAT / PiCAT items | CAT minutes (no tryout / with tryout) | Paper items | Paper minutes |
|---|---|---|---|---|
| GS | 15 | 12 / 25 | 25 | 11 |
| AR | 15 | 55 / 113 | 30 | 36 |
| WK | 15 | 9 / 18 | 35 | 11 |
| PC | 10 | 27 / 75 | 15 | 13 |
| MK | 15 | 31 / 65 | 25 | 24 |
| EI | 15 | 10 / 21 | 20 | 9 |
| AI | 10 | 7 / 18 | — (inside AS) | — |
| SI | 10 | 6 / 17 | — (inside AS) | — |
| AS | — (AI + SI reported together) | — | 25 (= 13 AI + 12 SI) | 11 |
| MC | 15 | 22 / 42 | 25 | 19 |
| AO | 15 | 18 / 38 | 25 | 15 |
| **Total** | **130 scored** | **197 min** | **225** | **149 min** |

**Documented inconsistency, flagged deliberately.** The 2026 Fact Sheet p. 3 prints a CAT total of "**135 Questions  197 Minutes**". The per-test lengths it lists on the same page sum to **130**, and the **197** minutes is correct (12+55+9+27+31+10+7+6+22+18). The website table gives 130 scored items. Both sources are authoritative and disagree; the individual cell values are mutually consistent, so the "135" appears to be a legacy total. **[VERIFIED]** observation; cause **[UNVERIFIED]**.

**Tryout (unscored) items. [VERIFIED]** officialasvab.com/applicants/what-to-expect/: "Each examinee receives tryout questions in **2 to 4** of the ASVAB subtests, with tryout questions **randomly dispersed** throughout each of the selected subtests." Up to **15** per selected subtest. Tryout items are **not** administered on the PiCAT.

**Empirical mean p-values per subtest [SECONDARY — computed by me]** from TB4 Table 6.1 (Forms 23A/23B, N ≈ 10,750 each), raw-score mean divided by item count:

| Subtest | Mean NR (Form 23A) | Items | Implied mean p |
|---|---|---|---|
| AO | 18.07 | 25 | **.72** |
| PC | 9.99 | 15 | **.67** |
| WK | 23.30 | 35 | **.67** |
| GS | 14.57 | 25 | **.58** |
| MC | 13.92 | 25 | **.56** |
| EI | 10.87 | 20 | **.54** |
| MK | 13.27 | 25 | **.53** |
| AS | 12.78 | 25 | **.51** |
| AR | 14.23 | 30 | **.47** |

Read this as: the applicant population averages a mid-band p, so a whole form is roughly medium difficulty; AR and AS are the hardest lines, AO and WK the easiest. These are **form-level** averages, not per-item targets — do not confuse them with the §4.1 item bands. An individual item at p = .67 is *medium* by the official definition even though WK's form average is .67.

**Item parameter spread [SECONDARY]** from TB4 Tables 6.5–6.13: 3-PL b values run roughly −1.6 to +2.1 for GS, −1.3 to +1.9 for AR and −2.4 to +1.8 for WK across forms, confirming that each form deliberately spans easy through hard rather than clustering.

---

## 5. Wording conventions and distractor design, as actually observed

### 5.1 Stem shapes seen in officially published items

All rows **[VERIFIED]**; the taxonomy of shapes is mine.

| Shape | Official example (short excerpt) | Subtest |
|---|---|---|
| Completion with causal connective | "Air is less dense than water **because** ___" | GS |
| Completion with definitional cue | "Substances that hasten chemical reaction time without themselves undergoing change **are called** ___" | GS |
| Completion, functional | "Sanding blocks **are used to** ___" | SI |
| Completion, identification from picture | "The clamp shown **is called a** ___" | SI |
| Completion, quantity | "The volume of the brick **is** ___" | MK |
| Completion after a passage | "According to the passage, some artists work with titanium **because it** ___" | PC |
| Direct question | "What does the abbreviation AC stand for?" / "Where does combustion take place?" / "What is the area of this square?" / "How much water should each tree be given?" | EI, AS, MK, PC |
| "Which of the following …" | "Which of the following is measured using an ohmmeter?" / "Which of the following has the least resistance?" / "A car uses too much oil when **which of the following parts** are worn?" | EI, AS |
| "Which X …" over a figure | "Which shelf will support the most weight?" / "In this arrangement of pulleys, **which pulley** turns fastest?" / "Which post holds up the greater part of the load?" | MC |
| "Which figure best shows …" | "Which figure best shows how the objects in the left box will **touch** if the letters for each object are matched?" / "… will **appear** if they are **fit together**?" | AO |
| "X most nearly means" | "Antagonize most nearly means" / "Rudiments most nearly means" | WK (also GS/AR worked examples) |

**Observations for the writing guide**

- **The canonical synonym question is "most nearly means"** — not "means", not "is closest in meaning to". All five official WK synonym items I read use "most nearly means". **[VERIFIED]**
- **"Which of the following" is used, but sparingly** — roughly 4 of the ~70 published sample items and worked examples. It is *not* the default wrapper, contrary to what many commercial item banks assume. **[SECONDARY]** (my count across the two official sample sets).
- **"Which of the following best describes…"** — I did **not** find this exact formula in any official ASVAB sample item I read. Treat the phrase as **[UNVERIFIED]** as an ASVAB convention.
- **Negative and superlative stems do occur** ("does NOT resemble" on PC, "least resistance" on EI, "least load"-type MC items), so the app should train them — but they are rare enough that an item bank dominated by negatives would misrepresent the test. **[SECONDARY]**
- **No "all of the above", "none of the above" or "both A and B" appeared in any official sample.** **[VERIFIED] by absence** across ~70 items. Recommend banning them.
- **Punctuation house style:** verbal and in-context options are sentence-cased and end with a period; bare single-word WK options are lower case and (in the web rendering) also end with a period; numeric options in AR and EI are bare or carry currency/units; options in the "letters printed on the figure" style are just A. / B. / C. / D.

### 5.2 The documented distractor screening rules

**[VERIFIED]** TB4 §3.4.3 (PDF p. 24) — items were **rejected** when:

> "the biserial of the correct answer was not significantly positive, a distractor with a significant p value was selected by examinees with higher subtest scores, a distractor with a significant p value was selected by examinees with subtest scores not significantly lower than examinees with high subtest scores, **examinees with high subtest scores had less than a p = .5 probability of answering the item correctly**, or if p values for the highest and lowest distractors were too close."

Translated into authoring rules an app team can actually apply:

1. The key must be *positively* correlated with overall ability — never write a "gotcha" key that only low performers pick.
2. A distractor must never out-perform the key among strong candidates.
3. Distractors must be *distinguishable* from one another in attractiveness — two distractors of near-identical drawing power is a defect.
4. **A strong candidate must have a better-than-even chance of getting the item right** — no item whose key requires a coin flip.
5. Distractor **balance** across A/B/C/D is a formal constraint in modern form assembly ("Item key 'balance'" appears among the Automated Test Assembly constraints). **[VERIFIED]** DACMPT 2022 slide 26. So the key should be uniformly distributed across the four positions, not biased toward B or C.

Additional documented quality gates: editorial review for "key accuracy" and "the distribution of response options corresponding to the item keys" **[VERIFIED]** TB4 §3.4.1; DIF screening (White vs Hispanic, White vs Black, male vs female) on every item **[VERIFIED]** DACMPT 2022 slide 9; sensitivity and bias review by a demographically diverse external panel **[VERIFIED]** CEP Technical Summary.

---

## 6. PiCAT vs CAT-ASVAB vs iCAT vs paper — do the items differ?

**Short answer: no. The item formats are identical; only delivery, timing, length and scoring differ.** **[VERIFIED]** officialasvab.com/applicants/prepare/: "**[Note, however, that the test content is the same across both versions.]**" (referring to paper vs computer). And the PiCAT/APT guide: "PiCAT has the same number of subtests and has a similar number of questions as CAT-ASVAB."

| Dimension | Paper (P&P) | CAT-ASVAB (proctored, MEPS) | iCAT (internet CAT at MET sites) | PiCAT (unproctored) |
|---|---|---|---|---|
| Item formats | Same 4-option MC, same content **[VERIFIED]** | Same | Same | Same |
| Subtests administered | 9 blocks; **AI + SI merged into AS**; AO given only in the Enlistment programme | 10 blocks (AI and SI separately); AS reported as a composite | 10 blocks, same as CAT | 10 blocks, same as CAT |
| Items | 225 total **[VERIFIED]** | 130 scored, plus 0–15 tryout items in 2–4 subtests **[VERIFIED]** | same as CAT | "similar number of questions"; **no tryout items** **[VERIFIED]** |
| Adaptive? | No — fixed form | Yes — starts at **average difficulty**, steps up or down | Yes | Yes |
| Time limits | 149 min total, per-subtest limits | Per-subtest limits **[VERIFIED]** | Per-subtest limits | **None** — "there are no time limits for the individual subtests" **[VERIFIED]** |
| Answer review | Yes, within a subtest | **No** — cannot return to an answered item | No | No |
| Guessing penalty | None; fill in everything | Yes — under-completion scored as if remaining items were random **[VERIFIED]** | Yes | Yes |
| PC passage structure | **5 questions per passage** **[VERIFIED]** | **1 question per passage** **[VERIFIED]** | 1 per passage | 1 per passage |
| Score visibility | After a few days via recruiter | Immediately at the site | At site | Recruiter only, then Vtest |
| Verification | n/a | n/a | n/a | **Vtest** within 45 days (officialasvab.com) vs 30 days (PiCAT guide v5.8) — the sources differ, so flag it |

**The one substantive item-type difference is PC passage structure (paper vs computer).** Everything else about the items is held constant, and the programme is explicit that scores are equated across modes precisely because content is the same: "Even though the questions differ in difficulty across the CAT-ASVAB and P&P-ASVAB, the reported scores are statistically linked." **[VERIFIED]**

**Naming note worth getting right in the app. [VERIFIED]** PiCAT & APT User's Guide v5.8 §1.1: "CAT-ASVAB is given in all Military Entrance Processing Stations (MEPS) and in some Military Entrance Test (MET) sites. In the MET sites, an internet-based version of CAT-ASVAB is given. **This version is called iCAT.**" The same guide names the recruiter-facing web apps "iCAT Authorization & Reporting" and "iCAT Test Delivery". So "iCAT" is a real, current, official term — and it explains why some sample-item image files on officialasvab.com are named icat_q5.jpg and icat_q6.jpg.

**Operational fact that changes what a candidate experiences. [VERIFIED]** PiCAT guide: "If the examinee's AFQT score is too low after five subtests, the test will end, and the remaining five subtests will not be administered." A low-scoring candidate on PiCAT may never see the technical subtests at all.

**PiCAT eligibility — two official statements that differ. [VERIFIED] both:**

- officialasvab.com/recruiters/picat/ (page updated 2025-07-15): "PiCAT can be taken **only once** and is available only to those who have never taken the ASVAB before."
- PiCAT/APT User's Guide v5.8 (Oct 2023): "The PiCAT can only be taken **once every two years**."

Use the website wording for 2026 and note the older guide.

---

## 7. Reading level — the official answer

**[VERIFIED]** ASVAB CEP **Technical Summary**, section "ASVAB Reading Level" (https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Technical_Chapter.pdf):

> "The vocabulary and comprehension levels of the ASVAB test questions and directions are **well within the range of the target audience which is students in grade 10 or higher**. For example, vocabulary words on the Word Knowledge test are often **found in books used by high school students** and Paragraph Comprehension passages are generally **written for a target audience of 10th graders**."

**[VERIFIED]** Corroborating procedural statement — Technical Bulletin No. 4, §3.2.2:

> "This procedure ensured that items were relevant in content, technically correct, and **appropriately targeted to the specified grade levels**. **Vocabulary level (or reading grade level) was controlled** to ensure examinees were likely to understand what they read. The exception was when a term was necessary in a math, science, or technical subtest item to measure knowledge of the content area."

**What this means for the app**

- **Author WK and PC at a 10th-grade level** — not 12th, and not 8th. **[VERIFIED]**
- **Technical vocabulary is exempt** from the reading-level control. GS, EI, AS and MC items *must* use the domain term ("capacitance", "bevel gear") because knowing it *is* the construct. **[VERIFIED]**
- **Plain-language rewriting of PC passages would be wrong.** The official target is 10th-grade authentic prose across "different types of passages of varying lengths", including literary and expository registers.
- **The prep-industry claim that the ASVAB sits at a "9th-grade reading level" is [UNVERIFIED] and is not supported** by the official statement, which names grade 10. Do not repeat it.
- **No official readability formula, Lexile range or Flesch-Kincaid band is published** for the ASVAB. **[VERIFIED] by absence.**

---

## 8. Gaps and cautions

Things I could **not** verify, listed so nobody accidentally treats them as settled:

1. **Whether the paper PC reduction to 10 items was ever implemented.** The 2022 recommendation is documented; the 2026 Fact Sheet still prints 15. **[UNVERIFIED]**
2. **The exact easy/medium/hard quota in any operational form.** Not published. **[UNVERIFIED]**
3. **Whether any MC item is ever purely verbal.** No official statement either way; 9 of 9 published samples are figure-based. **[UNVERIFIED]**
4. **The CEP site's live interactive sample set.** asvabprogram.com is an Angular SPA behind a strict CSP; my fetches returned only the 5.5 KB shell for every route including /student, and the Wayback captures of its media-center-article pages are also shells. I therefore rely on the **CEP Overview PDF (FEB 2026)** for CEP sample items, which is the CEP's own published practice material. **[VERIFIED for the PDF; UNVERIFIED for the live site]**
5. **March2Success ASVAB practice-test item counts.** Registration-walled. **[UNVERIFIED]**
6. **A MEPCOM-hosted ASVAB format fact sheet.** mepcom.army.mil returned HTTP 403. **[UNVERIFIED]**
7. **Whether the ASVAB changes in 2026–2027.** Per a 2022 briefing, CAT pools 11–15 were expected operational 2023–2025 with pools 16–20 in development; I found **no** official announcement of a new subtest or format change. **[SECONDARY]** for the 2022 plan, **[UNVERIFIED]** for anything after 2025.
8. **The "icat_q5.jpg / icat_q6.jpg" filenames** on officialasvab.com are consistent with the iCAT terminology, but I found no document explaining why those particular sample images carry that prefix. Do not build a story on it.

---

## 9. Source list

**Official — ASVAB programme (US Department of Defense); all fetched 2026-10-25**

- Sample questions index: https://www.officialasvab.com/applicants/sample-questions/
- Subtest sample sets: https://www.officialasvab.com/general-science-gs/ · /arithmetic-reasoning-ar/ · /word-knowledge-wk/ · /paragraph-comprehension-pc/ · /mathematics-knowledge-mk/ · /electronics-information-ei/ · /auto-information-ai/ · /shop-information-si/ · /mechanical-comprehension-mc/ · /assembling-objects-ao/
- What to Expect When You Take the ASVAB (page updated 2026-10-23): https://www.officialasvab.com/applicants/what-to-expect/
- The CAT-ASVAB: https://www.officialasvab.com/applicants/cat-asvab/
- Preparing for the ASVAB: https://www.officialasvab.com/applicants/prepare/
- Understanding ASVAB Scores: https://www.officialasvab.com/applicants/scores/
- FAQs: https://www.officialasvab.com/applicants/faqs/
- ASVAB Subtests (counselors & educators): https://www.officialasvab.com/counselors-educators/subtests/
- Official Statement Regarding Deceptive ASVAB Test Preparation Claims (2025-06-09): https://www.officialasvab.com/applicants/asvab-test-preparation-disclaimer/
- Myths About the ASVAB: https://www.officialasvab.com/recruiters/myths/
- Unproctored Administration of the ASVAB: PiCAT: https://www.officialasvab.com/recruiters/picat/
- The AFQT Predictor Test: APT: https://www.officialasvab.com/recruiters/afqt-predictor-test/
- **ASVAB Fact Sheet (2026 upload, 4 pp.):** https://www.officialasvab.com/wp-content/uploads/2026/10/ASVAB-Fact_Sheet.pdf
- ASVAB Technical Bulletin No. 1 — CAT-ASVAB Forms 1 & 2 (DMDC, March 2006): https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_1.pdf
- ASVAB Technical Bulletin No. 2 — CAT-ASVAB Forms 3 and 4: https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_2.pdf
- ASVAB Technical Bulletin No. 3 — CAT-ASVAB Forms 5–9: https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_3.pdf
- **ASVAB Technical Bulletin No. 4 — P&P-ASVAB Forms 23–27 (DMDC Personnel Testing Division, March 2009, rev. May 2012):** https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_4.pdf — *the key source for four options, five PC items per passage, the graphics-subtest list, and the .75/.45 p-value bands*

**Official — ASVAB Career Exploration Program (DoD)**

- CEP Overview booklet, **DD Form 1304-5OV, FEB 2026** — 32 sample questions plus 8 worked examples plus answer key: https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Overview.pdf
- CEP Technical Summary — reading-level statement, PC/MK/AR content descriptions, DIF and sensitivity policy: https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Technical_Chapter.pdf
- CEP Counselor Guide: https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Counselor_Manual.pdf
- CEP Fact Sheet: https://prod-media.asvabprogram.com/CEP_PDF_Contents/ASVAB_CEP_Fact_Sheet.pdf

**Official — other US Government releases**

- PiCAT & APT User's Guide v5.8, 25 Oct 2023 (Navy-hosted; CUI-marked; publicly reachable): https://etoolbox.cnrc.navy.mil/assets/ARM/PiCAT-APT_UserGuide_v5.8_20231025.pdf
- *CAT-ASVAB Pool + P&P-ASVAB Form Development*, HumRRO briefing to the Defense Advisory Committee on Military Personnel Testing, 15 Dec 2022: https://dacmpt.com/wp-content/uploads/2022/12/04-CAT-and-PP-ASVAB-Pool-Form-Development-DACMPT-12-15-22.pdf — *the key source for the AP/AC AO item families, AS = 13 AI + 12 SI, one-question-per-passage PC on CAT, and the 10-item PC recommendation*
- March 2 Success (US Army): https://www.march2success.com/

**Not reachable / not verified on 2026-10-25**

- https://www.mepcom.army.mil/ — HTTP 403.
- https://asvabprogram.com/student — Angular SPA shell only; content not retrievable without a JS runtime.

---

## 10. One-paragraph brief for the item-writing team

Write **one stem and exactly four options** — never five, never "all of the above". Keep GS, AR, EI, AS and MK verbal and self-contained, with completion stems ending in "because / is called / is used to / is" plus a minority of direct questions and "Which of the following…" wrappers. Write **WK both ways**: a bare underlined word with "most nearly means", and a one-sentence context item with the target underlined and no prompt, in both cases with lower-case single-word options. Write **PC one question per passage** (the computer format every 2026 applicant will actually meet), phrase stems as "According to the passage…", "The author implies…", "The ___ referred to in the passage is…", and make one distractor a true-but-not-stated inference. Write **MK symbolically** — expressions, equations, figures with labelled dimensions — and push narrative problems into AR. Make **MC diagram-first**, with options that are either short verbal statements about the drawing or the bare letters A–D printed inside it. Draw **AO in exactly two shapes**: label-matched connections (dots a and b plus an a-to-b key, options differing in connector angle and part rotation) and fit-together puzzles (three or four unlabelled pieces, options differing in internal seam placement). Target **p between .45 and .75** for most items, with a deliberate easy (> .75) and hard (< .45) tail, keep the key balanced across A–D, and **write WK and PC at a 10th-grade level** while keeping the real technical term in GS, EI, AS and MC.
