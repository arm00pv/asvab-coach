# QA personas and internal testing

The app is tested by simulated learners as well as by unit tests. A persona is a
probability of answering each subtest correctly; the harness feeds it through the
**real** exam builder, scoring engine, eligibility engine and coaching engine.
Nothing is stubbed, so a persona result is evidence that the whole pipeline still
behaves.

Run them from **Settings > QA lab** in the app, or in CI via
`flutter test test/personas_test.dart`.

## The seven personas

| Persona | Profile | Purpose |
| --- | --- | --- |
| **Marcus** - fresh recruit | 8 years out of school, 28-52 percent accuracy, 62 s/question, flags a lot | The candidate the diagnostic exists for. Proves the floor case still produces usable coaching rather than a blank screen. |
| **Jenna** - strong student | 54-86 percent, 40 s/question | Proves a strong profile reaches Category II and unlocks technical MOS. |
| **Dana** - maths anxious | Reads well (80+ percent verbal), 26-30 percent on AR and MK | Proves the coach points at arithmetic rather than at reading, which is the whole point of skill-level diagnosis. |
| **Ruiz** - career mechanic | 86-92 percent on EI, AS and MC; 34-40 percent verbal | Proves a lopsided profile still unlocks mechanical and aviation work, and that the advice is not simply "read more". |
| **Ava** - officer candidate | 82-90 percent across the AFQT subtests | Proves GT 110 is reachable and that the officer track is wired to GT, not to AFQT. |
| **Sam** - pure guesser | 25 percent everywhere, 8 s/question | The safety case: the engine must never report a chance-level candidate as qualified for a technical MOS. |
| **Taylor** - speed runner | 58-72 percent, 14 s/question | Exercises the pace analysis and the "left blank" warning. |

## Assertions the suite makes

1. Every persona produces a complete nine-subtest report with valid line scores.
2. Scoring is deterministic - the same persona and seed give identical results.
3. A strong candidate outscores a weak one.
4. A pure guesser stays below the AFQT 31 floor.
5. A pure guesser cannot clear ST 95 or GT 110.
6. A strong candidate reaches at least Category II.
7. An officer-minded candidate clears GT 110.
8. Eligibility never shrinks as ability rises.
9. The maths-anxious persona is coached on AR or MK specifically.
10. The mechanic persona unlocks a mechanical, aviation or logistics job.
11. Every persona gets a concrete next action, never an empty state.

## Manual test script

The automated suite cannot judge whether the thing feels right, so these are the
walkthroughs worth doing by hand after a UI change:

1. **Cold start.** Clear storage, reload. Onboarding renders, all four steps
   advance, and no step allows an empty name forward.
2. **Diagnostic.** Sit all 27 questions. Section transitions are clearly
   announced, the timer is visible but not alarming, the last-minute state turns
   red, and submitting reaches the score report.
3. **Report integrity.** AFQT, category chip, all ten line scores and nine
   subtest rows are populated and internally consistent (GT matches the sum of
   VE and AR on the displayed scale).
4. **Review.** Filter by missed and by flagged; every card states your answer, the
   correct answer and a real explanation. Skill chips open a lesson.
5. **Lesson to mastery check.** Every one of the 39 skills opens content and a
   four-question check; no skill dead-ends.
6. **Jobs.** Search, filter by field, open a detail sheet, and confirm a near-miss
   MOS shows the specific shortfall and how to close it.
7. **Progress.** Two attempts of different kinds produce two sparklines and a
   sensible streak.
8. **Keyboard.** In the exam, 1-4 select, arrows move, F flags, and nothing
   scrolls unexpectedly.
9. **Persistence.** Reload mid-history: attempts, goal and theme all survive.
10. **Responsive.** At 380 dp the bottom bar is used and no card overflows; at
    1440 dp the rail is used and the dashboard reads as a two-column layout.
