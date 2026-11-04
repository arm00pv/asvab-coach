# Evaluating LFM3-Omni as a tutor

The question this answers: **can the model teach a candidate how to work out a
question, answer the question, and do it in the language the candidate chose?**
Not "is it impressive" - can it be trusted with a candidate's study time.

Everything below was run on this laptop, on the model as published, against the
app's own question bank.

## Method

| | |
| --- | --- |
| Model | `LFM3-Omni-2B-Q4_K_M.gguf`, 1 099 630 080 bytes, from Hugging Face |
| Runtime | llama.cpp `b12032`, CPU only, 4 threads, 1 135G7 (4C/8T), 7.7 GB RAM |
| Items | 16 real bank items, 2 per subtest (WK, PC, MK, AR, GS, AS, MC, EI), text only |
| Sampling | `--temp 0 --seed 42`, greedy, `-c 2048`, `-n 240` |
| Marking | against `answerIndex` from the bank, plus a text comparison for the case where the letter and the option text disagree |
| Harness | `tool/export_eval_items.dart`, `tool/eval_lfm3.ps1`, `tool/eval_translate.ps1` |

Two prompt shapes were compared, because the first one exposed a failure that
looked like a comprehension failure and was not:

* **LetterFirst** - "give the correct option first, then the working";
* **ReasonFirst** - "work it out step by step, then finish with `ANSWER: B`".

## Speed

| | |
| --- | --- |
| Generation | 16-20 tokens/s on 4 CPU threads |
| Prompt processing | 57-71 tokens/s |
| One answer, 220 tokens | **8.4-23 s**, mean **11.6 s** (English), 12.6-14.9 s (Spanish, Italian) |

A quarter of a million CPU cycles per syllable does not exist on a mid-range
phone, but this is the shape of the number: an answer a candidate would wait
for on a laptop, and a reason to stream the first sentence rather than the whole
reply.

## Accuracy

| Language | Prompt | Letter matched the key | Option text matched the key | Mean time |
| --- | --- | --- | --- | --- |
| English | LetterFirst | **6 / 16** | 9 / 16 | 11.6 s |
| English | ReasonFirst | **7 / 16** | - | 14.1 s |
| Spanish | LetterFirst | **2 / 6** | 3 / 6 | 14.9 s |
| Italian | LetterFirst | **4 / 6** | 3 / 6 | 12.6 s |

Read those numbers before anything else: **under half of the answers name the
right option**, and the gap between "letter matched" and "option text matched"
is the important part.

## The failure that matters, in its own words

Item `mk-001`: *Simplify 8 + 2(5 - 3)^2*, keyed **C) 16**.

> A) 12
>
> Working: First, evaluate the parentheses: 5 - 3 = 2. Then square the result:
> 2^2 = 4. Next, multiply: 2 x 4 = 8. Finally, add: 8 + 8 = 16. **The correct
> answer is 16**, not 12, 14, or 20. Options B, C, and D are wrong because they
> give incorrect results after following the order of operations.

It solved the item correctly, wrote the correct value, and opened with the wrong
option. In the reason-first variant it got worse before it got better:

> Answer: B
>
> ... Step 4: Add to the original number: 8 + 8 = 16.
>
> The correct option is B.
>
> A) 12 - Incorrect; the calculation yields 16, not 12.
> **C) 16 - Correct**; this matches the result of the simplification.

Three lines apart it says B is correct and C is correct. An item about a
25 percent discount went the same way: the arithmetic reached $63, the headline
said A, and the breakdown said "C) $63 - Correct". In Italian the same model
wrote the letter as `e)` for an option in the B slot.

This is not a gap in the subject. It is a gap in **binding a conclusion to a
position**, and it is the single most dangerous failure a tutor can have: fluent,
confident, internally inconsistent, and wrong about the one thing the candidate
is checking against.

## Translation

Two different jobs were tested.

**Explaining in Spanish and Italian.** Fluent and mostly faithful, with the same
letter problem:

> El serjeante de suministros tenía un inventario abundante de baterías en la
> conexión... Las otras opciones son incorrectas porque "damaged" describe un
> estado de deterioro...

* `serjeante` is not a Spanish word (it is *sargento*);
* `conex`, the shipping container, became `la conexión`, a connection.

**Translating the app's own explanation.** Eight runs, four items, two
languages. The mathematical ones came out very well:

> **EN:** (-3)^2 = 9 because a negative squared is positive. Then 4 - 7 = -3, and
> subtracting a negative adds: 9 - (-3) = 9 + 3 = 12. The trap is treating (-3)^2
> as -9, which produces 3.
>
> **IT:** (-3)^2 = 9 perché un numero negativo elevato al quadrato è positivo.
> Poi 4 - 7 = -3, e sottrarre un numero negativo aggiunge: 9 - (-3) = 9 + 3 = 12.
> Il trucco è trattare (-3)^2 come -9, il che produce 3.
>
> **ES:** (-3)^2 = 9 porque un número negativo elevado al cuadrado es positivo.
> Luego 4 - 7 = -3, y restar un número negativo suma: 9 - (-3) = 9 + 3 = 12. La
> trampa es tratar (-3)^2 como -9, lo que produce 3.

Every number survives, the terminology is right in both. The vocabulary items
did not fare as well:

* `obstinente` for *obstinate* - a word Spanish does not have;
* `CAUCIoso` for *cautious* (*cauteloso*), with broken capitalisation;
* `entra en vigor` ("comes into force") for *comes into play*;
* `unrelated` left in English inside a Spanish sentence.

So: **numbers and procedure translate; vocabulary and idiom do not.** A study app
whose whole point is that every explanation has been checked cannot ship the
second kind.

## The third run: ask for the answer, not for a letter

The first two runs forced a format - "letter and option text, then the working".
That format is partly what broke it. A third pass asked the model only to work
the item out and finish with `CHOICE: <the option text>`, and left the mapping to
the app, which already has the option list:

| Prompt | Recovered the keyed option |
| --- | --- |
| LetterFirst ("A) ..." then the working) | 6 / 16 |
| ReasonFirst ("step by step, then ANSWER: B") | 7 / 16 |
| **ValueOnly** ("work it out, then CHOICE: <text>") | **12 / 16** |

The same item that opened "A) 12" and finished "the correct answer is 16" now
reads:

> Let's simplify step by step.
>
> First, evaluate the expression inside the parentheses: 5 - 3 = 2.
>
> Next, square that result: 2^2 = 4.
>
> Now multiply by 2: 2 x 4 = 8.
>
> Finally, add 8 to the original number: 8 + 8 = 16.
>
> **CHOICE: C**

Right answer, right option, three quarters of the time, at 10.8 s an answer. So
the honest summary is not "the model cannot do the questions" - it is **"the
model can do the questions, and asking it for an option letter destroys that
ability."** Four still failed: one arithmetic item, two shop items (engine
stroke, gear ratio) and one that ran out of tokens without answering.

## What this means for the app

1. **The app owns the answer; the model never does.** The bank already knows the
   key and already has an audited explanation per option. The "Help me" bubble
   should teach from that, and the model's job is to re-explain it in the
   candidate's words and language.
2. **Never take a letter from the model.** If its reasoning reaches a value, the
   app can map the value onto its own option list deterministically, and compare
   with its own key. Where they disagree, the app says so instead of showing the
   contradiction to a candidate who cannot check it.
3. **Translations are labelled.** A translated explanation is a rendering, not a
   reviewed text; it appears beside the English one with that said plainly.
4. **Stream the first sentence.** Eleven seconds of silence is a broken button.
   The authored explanation can be shown instantly; the model's version fills in
   behind it.
5. **Audio is a separate, later question.** This test used text only. Voice in
   and voice out exist in the model family and are wired in llama.cpp, but they
   need the audio encoder (`mmproj`, 278 MB) and the codec, and none of that was
   exercised here.

## What was not tested

Audio input and output; anything on a phone (memory, thermals, battery); models
larger than 2B; few-shot prompting; grammar-constrained decoding, which is the
obvious fix for the letter problem and should be tried next; and translation
reviewed by native speakers, which is the only kind of translation this app would
be willing to ship.

## Reproducing it

```
dart run tool/export_eval_items.dart build/eval_items.json
powershell -File tool/eval_lfm3.ps1 -Languages en -Variant LetterFirst  -Out build/eval
powershell -File tool/eval_lfm3.ps1 -Languages en -Variant ReasonFirst  -Out build/eval2
powershell -File tool/eval_lfm3.ps1 -Languages es -MaxItems 6 -Out build/eval_translate
powershell -File tool/eval_lfm3.ps1 -Languages it -MaxItems 6 -Out build/eval_translate
powershell -File tool/eval_translate.ps1
```

The model file is 1.1 GB and is not in the repository. Point `-Model` at a local
copy; nothing above needs the network once it is there.

## Decision record

**1 November 2026** - LFM3-Omni-2B Q4 is fast enough to feel like a conversation
on a laptop and explains a method well, including in Spanish and Italian. Asked
to reason and then state what it chose, it agrees with the app's key 12 times in
16; asked to open with an option letter it collapses to 6. Its vocabulary
translation is not accurate enough to ship, though its translation of numerical
work is.

It stays a documented, reserved slot behind the existing written guide. When it
ships, the prompt must ask for the working and a choice in the model's own
words, the app must do the mapping onto its own options, and nothing it says may
reach a candidate unchecked against the key.

## On the phone (3 November 2026)

The laptop numbers above were the reason to build it. These are the reason to
believe it, taken on a Pixel 7 Pro with the release APK installed: LFM3-Omni-2B
Q4_K_M, llama.cpp b12032, `n_ctx` 2048, six threads, greedy sampling, aeroplane
mode.

**The item.** *"How many atoms are in one formula unit of calcium hydroxide,
Ca(OH)2?"* - A) 5, B) 6, C) 3, D) 4. The app's key is A. The candidate answered
D. Both the key and the app's authored explanation are in the prompt.

**What it wrote** (156 tokens, unedited):

> The question asks for the total number of atoms in one formula unit of calcium
> hydroxide, Ca(OH)2. The formula contains one calcium atom, and the subscript 2
> after the parentheses multiplies the oxygen and hydrogen inside, giving two
> oxygen atoms and two hydrogen atoms. Adding them together: 1 (calcium) + 2
> (oxygen) + 2 (hydrogen) = 5 atoms. The subscript 2 applies to the entire group
> in parentheses, not just oxygen or hydrogen. The student's answer of 4 comes
> from incorrectly applying the subscript only to oxygen, ignoring the hydrogen,
> or ignoring the hydrogen entirely. The correct working step is to count all
> atoms in the formula unit, which yields 5.

Grounded, correct, and it does the thing the sheet promises: it teaches the
marked answer and names the mistake behind the one the candidate chose, without
ever calling the key wrong.

**The timing**, measured on the device and shown in the sheet:

| | |
| --- | --- |
| Reading the question (prompt processing) | 3.9 s and 4.0 s, two runs |
| Writing the answer (156 tokens) | 30.8 s and 30.7 s |
| Writing speed | 4.6 and 5.1 tokens/s |
| Load into memory, first question after opening Review | about 10 s |

That is **thirty-five seconds** for one explanation: fine for a considered
re-explanation under a question, too slow to replace the instant written one -
which is why the sheet streams, and why the authored explanation is on screen
before the tutor starts.

**Three things only the phone showed.**

* *Marker-first collapse.* The first version of the prompt ended with "finish
  with I GET: <option>". The model read the last instruction, wrote
  `<​think​>​<​/think​>I GET: A) 5` and stopped - ten tokens, no
  teaching at all, reported as "1.7 tokens/s" because the whole call was divided
  by ten tokens. The demand for the explanation now comes before the marker, and
  reading and writing are timed apart.
* *"Could not start answering."* A question asked while the Review warm-up was
  still loading went to an engine with no model. Loading is single-flight now.
* *A crash in `generate`.* The shrinker renamed the JNI token callback.
  `GetMethodID` failed and the pending `NoSuchMethodError` killed the process
  mid-answer. Both fixes are in [AI_TUTOR.md](AI_TUTOR.md) with the tests that
  pin them.

**Still not tested:** audio in (the `mmproj` encoder is not packaged, so the
tutor cannot listen); the model's own speech output, which is not used - answers
are read by the phone's own voice instead; Spanish and Italian on the device,
which are exercised by unit tests and by the laptop run above but not yet by ear
on the phone; and battery or thermal behaviour over a long session.
