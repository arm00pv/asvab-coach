# How close is this to the real test?

This document records what the real ASVAB actually looks like, what this app does
to match it, and where it still diverges. The research behind it is committed
under `docs/research/`: `official-items.md`, `study-guides.md`,
`test-taker-reports.md`, `asvab-subtest-content.md` and
`ng-mos-and-officer-requirements.md`.

Everything below is either marked **[verified]** against a primary source or
**[unverified]**. Where practice material routinely gets this wrong, that is
called out, because those are exactly the habits a study app must not teach.

---

## What the real test is

| Fact | Value | Confidence |
| --- | --- | --- |
| Subtests scored | 9 (VE is derived, not administered) | verified |
| CAT-ASVAB length | 135 items, 197 minutes | verified (the same fact sheet also prints 130 in one place; the per-subtest lengths total 135) |
| Options per item | exactly 4, every subtest | verified |
| "All / none of the above" | never used | verified |
| Difficulty | defined by item p-value: easy > .75, medium .45 to .75, hard < .45, and the programme says those cut points vary by subtest | verified |
| Reading level | grade 10 or higher | verified |
| Tryout items | up to 15 unscored items can appear in 2 to 4 subtests, with extended time | verified |
| Official full-length practice test | does not exist | verified |

The programme's own disclaimer names three sanctioned free prep routes and states
plainly that anyone claiming to hold real ASVAB questions is lying. This app has
never held them either: every item in the bank is original, written to match the
published format.

---

## Subtest by subtest

### General Science (GS)
**Real format:** a standalone item with no stimulus. The dominant shape is an
incomplete sentence with a causal or definitional connective ("... because ___",
"... are called ___"), plus a minority of direct questions. Graphics are
permitted but rare.

**This app:** direct questions and completions, four short factual options, one
causal step at most. Matched.

### Arithmetic Reasoning (AR)
**Real format:** word problems only, one or more steps, everyday or military
context. Options are bare numerals or currency, with no explanatory words. No
figures, no calculator.

**This app:** narrative word problems containing numbers, usually two steps.
Distractors are the unasked intermediate value.
**Divergence:** options carry their units ("420 miles", "63.00 dollars"). The
real test prints bare numerals. Units are retained deliberately because they make
review clearer, but this is a real difference.

### Word Knowledge (WK)
**Real format:** two official forms, and a representative bank must contain both.
Either a bare word with "most nearly means", or one short sentence with the target
word underlined and **no trailing prompt** at all. Four lower-case single-word
options.

**This app:** 8 bare-word items and 6 sentence-pinned items per authoring pass,
with the target word capitalised in the sentence form. Matched on both families.

### Paragraph Comprehension (PC)
**Real format: one question per passage** on the computer test (10 items, 10
passages). The paper form is the exception, with five questions on one passage.

**This app:** the bank stores two questions per passage, which is efficient for
practice, but the exam builder enforces the computer convention: a PC section
picks items with **distinct passages**, so no passage is ever shown twice in one
section. Matched at serve time.

The option design also follows the real pattern, which runs opposite to most
practice material: the key is the **plain, literal, exactly-stated detail**, and
the attractive trap is the **polished generalisation** that sounds like the point
of the passage. The audit enforces this - an item whose correct option is the
longest of the four is flagged, because that is the item pulling the wrong way.

### Mathematics Knowledge (MK)
**Real format:** concepts and algorithms, rendered symbolically. It is never a
narrative word problem; "word problems" is the official description of AR, not
MK. No calculator.

**This app:** pure computation, algebra, geometry and symbolic manipulation, with
notation in plain text (x^2, sqrt(48), (x - 3)(x - 4)).

### Electronics Information (EI)
**Real format:** mixed verbal and circuit items. Direct questions, "Which of the
following...", or completions, with lower-case noun-phrase options.

**This app:** verbal circuit descriptions with clean arithmetic, including the
series/parallel "one bulb burns out" family and equivalent resistance.

### Auto & Shop Information (AS)
**Real format:** one score, two tests. On the computer the Auto Information and
Shop Information halves are administered separately, 10 items each; on paper they
merge into a 25-item block. Includes picture-based tool identification.

**This app:** a full mock now administers AS as **two blocks**, Auto Information
(10 items, 7 minutes) and Shop Information (10 items, 6 minutes), split by skill
tag, so the section headers a candidate sees match the computer form. Items are
classified by their skill tags: engine, drivetrain and automotive electrical are
the Auto half; tools, materials, construction and welding are the Shop half.
**Tool identification is drawn.** Eight items carry a line-art drawing of the
tool and ask its name or its use, which is what the real Shop half does. The
drawings are original line art built from the same primitive vocabulary as the
Mechanical Comprehension figures, and a wrong answer therefore says something
specific about what the candidate cannot yet recognise by shape.

### Mechanical Comprehension (MC)
**Real format:** figure-led. Every officially published sample item shows a
diagram, and in several of them the four answer choices are the bare letters
printed inside the drawing.

**This app:** was verbal-only, which taught the wrong shape of thinking. It now
renders real diagrams: a lever with its fulcrum and arms, an inclined plane with
a crate on the slope, a gear train with an idler, a beam on two supports, a wheel
and axle, and a fixed pulley. The figures are drawn from a Flutter-free primitive
model, so the bank still loads outside a rendering engine.
**Divergence:** twenty MC items remain verbal by design, and no item places its
answer choices inside the drawing.

### Assembling Objects (AO)
**Real format:** exactly two pictorial families, named by the programme itself.

- **Connections / AP:** two shapes carrying lettered connection points plus an
  a-to-b key, stem "Which of these figures will appear if the letters for each
  object are matched?"
- **Puzzles / AC:** three or four unlabelled loose pieces, stem "Which of these
  figures will appear if they are fit together?"

There is no prose in the stimulus beyond that stem.

**This app:** both families are implemented and rendered. Puzzles use polyominoes
and enforce the real rules: pieces may rotate, never mirror, never overlap, and
the result must be one joined body. Connections carry lettered cells, and the
answer is the arrangement in which the required letters meet, with a
touching-the-wrong-letter option as the characteristic distractor. Both families
use the official stem wording verbatim.
**Divergence:** the pieces are grid-based polygons rather than the drawn line art
of the real items.

---

## Difficulty and answer-key hygiene

- Item difficulty is tagged easy, medium or hard, and the bank is kept near the
  real pool's rough shape: a fifth easy, three fifths medium, a fifth hard.
  **Caveat: the programme publishes no per-subtest quota.** This mix is an
  authoring target, not replicated fact.
- Options are reshuffled per attempt, so answer position cannot be learned.
- The audit rejects "all of the above", flags an item whose correct option is
  visibly longer than its distractors, rejects a thin explanation, and rejects a
  duplicate stem or option set.

---

## Test-day mechanics the app tells you about

- On the computer form a **blank item scores as a random guess**, so never leave
  one empty. The paper form has no guessing penalty.
- The **PiCAT** is a real pre-screening option: a recruiter access code valid for
  30 days, a 48-hour window to finish, one attempt only, and a proctored
  confirmation test (Vtest) within 45 days to make the score official.
- **Retest spacing** is 30 days, then 30 days again, then every six months.
- There are **no score waivers**; only retests.
- **Tryout items** exist and are unscored. If a question feels wildly
  off-subtest, it may not count.

---

## What this app deliberately does not do

- It does not claim to hold real ASVAB questions, because no prep product does.
- It does not reproduce commercial study-guide items. The guides were mined for
  format, weighting and distractor design; every item here is original.
- It does not present its score as official. Only MEPS, or a proctored Vtest
  confirming a PiCAT, produces a real ASVAB score.

---

## Known gaps, ranked by how much they cost a candidate

1. **Mechanical Comprehension is not fully figure-based.** The figure renderer
   works and thirty-four of the fifty-four MC items use it, which makes figures the majority as on the real test; the twenty that remain verbal are the ones where a drawing would either print the answer or argue the wrong way.
   The real subtest is figure-led throughout.
2. **Assembling Objects pieces are grid polygons**, not the drawn line art of the
   real items. The rules are enforced exactly; the artwork is a simplification.
3. **Arithmetic Reasoning options carry units** ("420 miles"). The real test
   prints bare numerals. Units are kept for clarity in review.
4. **Bank size.** 372 items against a 135-item mock means a determined user will
   see repeats across many attempts. The real computer form draws from a far
   larger pool, and up to 15 unscored tryout items may appear on top of that.

Nothing on this list stops the app being useful, and each is stated on screen or
in the docs rather than papered over.