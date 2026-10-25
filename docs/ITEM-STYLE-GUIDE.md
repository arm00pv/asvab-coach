# Item style guide

Every question in the bank has to read like an ASVAB item. This guide is the
authoring contract, and most of it is enforced mechanically by
`lib/data/bank/bank_audit.dart` plus `test/bank_integrity_test.dart`.
Run `dart run tool/audit.dart` after any edit.

## The short version

An item is only acceptable if a real candidate, sitting the real test, could not
tell it apart from the surrounding material. That excludes four things practice
material gets wrong all the time:

1. **The answer is telegraphed by shape.** If the correct option is visibly
   longer, more specific or more technical than the distractors, the item tests
   nothing.
2. **Absurd distractors.** "Photosynthesis / Jupiter / A bicycle / All of the
   above" is a giveaway. A distractor must be something a real candidate might
   plausibly pick.
3. **Explanations that restate the answer.** "The answer is 15, because 15 is the
   answer" teaches nothing. Every explanation names the concept and says why the
   tempting distractor is wrong.
4. **Off-convention presentation.** Mathematics Knowledge does not use word
   problems. Word Knowledge does not use fill-in-the-blank. Paragraph
   Comprehension always has a passage.

## Schema

```dart
Question(
  id: 'ar-x01',                    // lowercase, subtest-prefixed, unique
  subtest: Subtest.ar,
  stem: 'A convoy covers 270 miles in 4.5 hours. At the same average speed, '
      'how far does it travel in 7 hours?',
  choices: <String>['390 miles', '420 miles', '405 miles', '450 miles'],
  answerIndex: 1,
  explanation: 'The rate is 270 / 4.5 = 60 miles per hour. In 7 hours the convoy '
      'covers 60 x 7 = 420 miles. Using d = rt keeps the units honest: miles '
      'divided by hours gives miles per hour.',
  difficulty: Difficulty.medium,   // easy | medium | hard
  skills: <String>['ar.rate'],     // 1-3 ids from Skills.all, same subtest
)
```

Paragraph Comprehension items also carry `passage: '...'`.

## Hard rules

- **Four options, all distinct, all non-empty.** Never "all of the above" or
  "none of the above": the real test does not use them.
- **Option length parity.** Keep the four options within about 2.5x of each other
  in length (3.4x for single-word Word Knowledge). Numeric options are exempt.
- **Explanation at least 70 characters**, naming the concept and explaining the
  trap.
- **Difficulty mix for a set of 18 items: about 4 easy, 10 medium, 4 hard.** The
  real pool runs roughly a fifth easy, three fifths medium, a fifth hard
  (official p-value bands: easy > .75, medium .45 to .75, hard < .45).
- **Spread the correct answer across positions.** The app shuffles options at
  serve time, but a set where every answer is option B means the distractors were
  an afterthought.
- **No duplicate stems** and no duplicate option sets.
- **Skill ids must exist** in `Skills.all` and belong to the item's subtest.
- Plain ASCII only: no smart quotes, no em dashes, and no $ characters inside
  Dart strings.

## Presentation conventions per subtest

| Subtest | Convention |
| --- | --- |
| **GS** | Four short factual options. Direct questions ("Which of the following...", "What is..."). One-step causal reasoning at most. No diagrams. |
| **AR** | A narrative word problem that always contains numbers, usually two steps. Units matter and distractors are the unasked intermediate result. Never a bare equation. |
| **WK** | Either a word alone, or a word pinned by a short sentence, with four near-synonyms of the same register. Never a definition stem like "The word X means". |
| **PC** | A passage of 60 to 130 words, then a question. Two questions may share a passage. Ask for main idea, stated detail, inference, purpose or tone, vocabulary in context, or sequence. |
| **MK** | Pure computation, algebra or geometry. Symbolic notation as plain text: x^2, sqrt(3), (x - 3)(x - 4). No word problems, no calculator, no long stems. |
| **EI** | Quantities with units, circuit behaviour, component identification, or safety. Numeric items must have clean arithmetic. Schematic symbols are described in words. |
| **AS** | Name a tool by its job, identify a system fault, or pick the right material or procedure. Shop-floor vocabulary, not engineering. |
| **MC** | Verbal descriptions of simple machines and structures. Mechanical advantage with clean numbers only. Never a diagram: describe the setup in words. |
| **AO** | Rendered puzzle. Never text-only. See below. |

## Distractor engineering

The distractors are the item. Build them from the mistake the concept invites.

| Subtest | The distractor to use |
| --- | --- |
| AR | The unasked intermediate value; the answer to the inverse operation; a value computed with the wrong unit. |
| MK | The sign error, the dropped negative, the diameter used as radius, the exponent multiplied instead of added. |
| WK | A word the candidate can define but which is not the nearest synonym; the secondary meaning when the sentence pins another sense. |
| PC | A statement true in the world but not stated in this passage; a supporting detail offered as the main idea; an inference the text permits but does not force. |
| GS | The restatement that sounds like an explanation; the confusable system (oil versus coolant, solar versus lunar eclipse). |
| EI | Series/parallel confusion; Ohm's law rearranged wrongly; a decimal-point slip. |
| AS | The part that fails as a result rather than the part that caused it; a system that shares a component. |
| MC | The mechanical-advantage ratio inverted; rope segments miscounted; the gear direction reversed by an idler. |
| AO | A mirrored piece, a substituted piece, an overlap, or two islands that touch at one corner. |

## Assembling Objects

Items are rendered from polyominoes and the answer is COMPUTED, never declared.
Two families, in roughly the proportions the real subtest uses.

**Fit-together** (about 60 percent). Give the loose pieces and four candidate
assemblies. Exactly one must satisfy all three invariants: the piece multiset
matches under rotation, no two pieces overlap, and the result is one joined body.
Each distractor breaks exactly one invariant.

```dart
puzzle: AoPuzzle(
  pieces: <Poly>[_p('10/10/11'), _p('11')],
  options: <List<Poly>>[
    <Poly>[_p('10/10/11'), _p('11').at(1, 1)],   // legal
    <Poly>[_p('01/01/11'), _p('11').at(2, 1)],   // mirrored piece
    <Poly>[_p('10/10/11'), _p('10').at(1, 2)],   // overlaps the foot
    <Poly>[_p('10/10/11'), _p('10/11').at(2, 2)],// substituted piece
  ],
)
```

**Labeled connection** (about 40 percent). Each stem piece carries a letter on a
specific cell. The answer is the arrangement in which the REQUIRED letters meet.
Pieces must be visually distinct so a letter identifies exactly one piece.

```dart
puzzle: AoPuzzle(
  pieces: <Poly>[_p('10/10/11'), _p('11')],
  labels: <String>['A', 'B'],                       // parallel to pieces
  anchors: <GridCell>[const GridCell(1, 2), const GridCell(0, 0)],
  connections: const <AoConnection>[AoConnection('A', 'B')],
  options: <List<Poly>>[
    <Poly>[_p('10/10/11'), _p('11').at(1, 1)],
    <Poly>[_p('10/10/11'), _p('11').at(4, 1)],
    <Poly>[_p('10/10/11'), _p('10').at(0, 2)],
    <Poly>[_p('01/01/11'), _p('11').at(2, 1)],
  ],
  optionAnchors: <List<GridCell>>[
    <GridCell>[const GridCell(1, 2), const GridCell(1, 1)],
    <GridCell>[const GridCell(1, 2), const GridCell(4, 1)],
    <GridCell>[const GridCell(1, 2), const GridCell(0, 2)],
    <GridCell>[const GridCell(2, 2), const GridCell(2, 1)],
  ],
)
```

Rules for `optionAnchors`: one entry per option, and inside each entry one
absolute cell per piece **in that option's own piece order**. The letter is
resolved by shape, so an option may list its pieces in any order.

`_p('10/10/11')` reads a bitmap: rows separated by a slash, a 1 is a
filled cell. `.at(dx, dy)` translates a piece. Because the legal count is
computed, a mis-authored anchor shows up as the wrong number of legal options and
the check will tell you.

## Self-check

Every authoring pass ends with:

```bash
dart format lib test
flutter test test/bank_integrity_test.dart
dart run tool/audit.dart
```

If the audit reports an error, the item is broken, not the checker.




---

## Rules added from 2024-2026 test-taker evidence

These come from `docs/research/test-taker-reports.md`, which harvested 139
threads with about 35 first-person "I sat it" narratives. They are the patterns
where practice material most often diverges from the real thing.

**Paragraph Comprehension: make the wrong answer the better-sounding one.** Real
PC difficulty lives in the options, not the passage. Multiple options read as
near-identical, and the correct one is usually the **boring literal detail**,
while the trap is the **plausible main-idea summary** that sounds like what the
passage is "about". Author PC items so the tempting distractor is the more
eloquent, more sweeping statement and the key is the modest, exactly-supported
one.

**Do not over-weight geometry in AR or MK.** Candidates who drilled triangle and
circle formulas reported barely seeing geometry, while real AR leaned on literal
`ax + b = c` solving, sign decisions and subtraction of large mixed numbers.
Geometry earns its stated share, not more.

**EI and AS are the surprise sections.** Across both practice-platform data and
test-taker reports, series versus parallel circuits and gears and axles are the
two hardest topics in the battery, and both sections surprise candidates who
over-prepared on the AFQT subtests. Keep them fully stocked and keep the items
concrete.

**Assembling Objects is not a differentiator.** No 2024-2026 test-taker named it
as hard, and it is frequently a candidate's strongest technical subscore. Build
both item families correctly, but do not spend disproportionate authoring effort
here.

**Never imply that a practice score is a prediction.** Calibration is unreliable
in both directions in the real world: candidates have overshot the real AFQT by
more than twenty points and missed a cut by four after five months of drilling.
The app must keep saying that this is an estimate.
