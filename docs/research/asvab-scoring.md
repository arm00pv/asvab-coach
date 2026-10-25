# How ASVAB Scores Work — a verification-first reference for reproducing realistic scoring

Compiled from primary Department of Defense sources (DMDC technical report, official ASVAB technical bulletins and site, U.S. Code). Every claim is tagged: **[VERIFIED]** = stated in or directly computed from a primary document; **[SECONDARY]** = widely published but only found in secondary sources here; **[UNVERIFIED]** = could not be checked; **[APPROX]** = a modelling choice, not an official number.

---

## 0. The one-paragraph model

An examinee answers items. Responses become an IRT ability estimate per subtest (3PL model, Bayesian modal estimate). Each estimate is linearly transformed to a **standard score with mean 50 and SD 10** in a fixed national reference sample. Those standard scores are combined two ways: (a) into the **AFQT**, converted to a **percentile 1–99** — the enlistment gate; and (b) into **Service composites** ("line scores"), converted to a **mean-100 / SD-20 scale** for job classification. Nothing an examinee sees is a raw count or a percent-correct.

```
raw item responses
   -> IRT theta_hat per subtest        (3PL, Bayesian modal estimate)  [VERIFIED]
   -> subtest standard score S_k       mean 50, SD 10                  [VERIFIED]
   -> AFQTS = AR + MK + 2*VE           -> percentile 1..99 (AFQT)      [VERIFIED]
   -> Army/Navy/AF/USMC composites     -> mean 100, SD 20 (line scores) [VERIFIED]
```

---

## 1. Raw score to Standard Score — and the "1–99" question

**Answer up front: the 1–99 range belongs to the AFQT percentile, not to subtest standard scores.** Subtest standard scores sit on a mean-50 / SD-10 metric and are *not* bounded at 1 and 99.

### 1.1 What the primary source says

Standard scores are a linear transformation of the IRT ability estimate (Segall 2004, Eq. 2.1): **[VERIFIED]**

```
S_k = 10 * ((theta_hat_k - mu_k) / sigma_k) + 50
```

which simplifies to a per-subtest slope/intercept applied to reference Form 04D (Eq. 2.2), then rounded to the nearest integer: **[VERIFIED]**

```
S_k = A4_k * theta_hat_k + B4_k
```

Form 04D slope / intercept pairs: AR 11.528721 / 48.365417; MK 10.025804 / 46.255061; WK 11.032817 / 47.809880; PC 12.351821 / 45.886521; GS 11.543462 / 48.988873; MC 12.957792 / 51.247394; EI 11.034039 / 51.159592; AO 10.340850 / 50.273512.

### 1.2 The range question, settled

Segall (2004), Section 2.2, footnote 2:

> "Unlike the '80 standard score computational formulas, the range of standard scores is **not truncated at 20 or 80** (three standard deviations from the mean)." **[VERIFIED]**

| Claim | Status | Correction |
|---|---|---|
| Subtests have mean 50, SD 10 | **[VERIFIED]** | Correct. officialasvab.com: "in the case of the ASVAB subtests, the mean is set to 50 and the standard deviation is set to 10." |
| Subtests run 1–99 | **FALSE** | The '97 scale is unbounded by design; the '80 scale was clamped to [20, 80]. Printed scores cluster roughly 20–80 with tails. |
| AFQT runs 1–99 | **[VERIFIED]** | "AFQT scores are reported as percentiles between 1-99." |
| A standard score of 60 = top ~16% | **[VERIFIED]** | "about 16% of the population scores at or above a Standard Score of 60." |

**Implication for a web app:** clamp subtest standard scores to something like [1, 99] only as a *display* guard, and never present a subtest score as a percentile. 50 is average; 60 is +1 SD; 70 is +2 SD.

### 1.3 VE is not a sum

```
VE != WK + PC
```

VE is an **optimally weighted** composite of *unrounded* WK and PC standard scores, with regression weight ratio **b_PC / b_WK = 0.61934** (PC gets about two-thirds of WK's weight), then rescaled to mean 50 / SD 10 (Segall 2004, Sec. 2.3, Eq. 2.3). **[VERIFIED]** It is printed as its own line on the score report. Same for AS: Auto Information + Shop Information combine into one AS score (one subtest on paper-and-pencil).

---

## 2. The AFQT percentile

### 2.1 Composition and formula

Four subtests, fixed since January 1989: **AR, MK, WK, PC** (ASVAB Technical Bulletin No. 4, Sec. 2.2.1). **[VERIFIED]**

```
VE    = standardise( S_WK + 0.61934 * S_PC )      # then forced to mean 50, SD 10
AFQTS = round(S_AR) + round(S_MK) + 2 * round(S_VE)
```

The "2*WK + 2*PC + AR + MK" form on prep sites assumes VE = WK + PC; it drifts whenever WK and PC differ. **[APPROX]**

### 2.2 Percentile conversion

AFQT% is the percentage of the reference sample scoring **at or below** AFQTS (Eq. 2.5), rounded, with 0 forced to 1 and 100 forced to 99 — a convention inherited from the '80 scale. **[VERIFIED]**

```
AFQT% = Rnd( 100 * sum_{x <= AFQTS} f(x) )
if AFQT% == 0   -> 1
if AFQT% == 100 -> 99
if AFQTS <= 109 -> 1
if AFQTS >= 269 -> 99
```

f(x) is the discrete density of AFQTS in the reference sample. Operationally this is a **fixed lookup table** (Segall Table 2.5), not an analytic formula. Anchors: **[VERIFIED]**

```
AFQTS  150  160  170  180  190  200  202  210  220  230  240  250  260  269+
AFQT%    9   14   20   28   38   48   50   59   70   79   87   93   97   99
```

A closed-form fit for a web app (mean 202, SD 36), accurate to ~1–2 points over the central 90%:

```
AFQT% ≈ clamp( round( 100 * Phi( (AFQTS - 202.5) / 36 ) ), 1, 99 )
```

**[APPROX]** — checks: AFQTS 214 -> 63 (table 63); 230 -> 78 (table 79); 180 -> 27 (table 28). Use the table when exactness matters.

### 2.3 Which normative sample? 1997, not 1980

This is the most common factual error in ASVAB content, including in the brief for this report.

| Era | Reference sample | In force |
|---|---|---|
| '80 scale | **PAY80** — Profile of American Youth, 1980 nationwide household sample | 1980 → July 2004 |
| '97 scale | **PAY97** — ~6,000 youths aged 18–23, screened from 90,000+ housing units, CAT-ASVAB administered summer/fall 1997 | **July 2004 → present** |

officialasvab.com, Norming Information: "The current national norms for the ASVAB were implemented in 2004. A nationally representative sample consisting of about 6,000 American youths aged 18-23 was utilized..." **[VERIFIED]**

The **formula and the percentile convention are identical on both scales** (Segall footnote 4: "This same formula was used to calculate AFQT scores on the '80 metric"; the 0->1 / 100->99 convention "was used in AFQT percentile calculations for the '80 score scale"). The **distribution** differs: PAY97 youth scored higher on the math and verbal subtests, so identical performance yields a *lower* AFQT percentile on the '97 scale (mean percentile 52.3 on the '80 scale vs 50.0 on the '97 scale, for the same PAY97 sample). **[VERIFIED]**

UI copy should read: "reference group: ~6,000 U.S. 18–23 year-olds tested in 1997."

### 2.4 Why a percentile and not a scale score

1. **The enlistment decision variable is written into law in percentiles.** 10 U.S.C. 520 caps accessions "at or above the tenth percentile and below the thirty-first percentile" at 4% of active-duty accessions. Categories I–V are percentile bands, so the reported statistic must be a percentile to be administrable. **[VERIFIED]**
2. **The categories are percentile bands by construction.** Segall: "Category II is defined to include AFQT scores in the range 65–92, which is defined to include 28% of the population (since the AFQT is defined as percentile scores relative to the population)." **[VERIFIED]**
3. **Interpretability for a non-technical decision-maker.** Category labels are explicitly meant to represent "trainability" (Sands & Waters, 1997, cited in Technical Bulletin No. 4). **[VERIFIED]**

Note the asymmetry: **AFQT 50 is exactly average and subtest standard score 50 is also average, but they are different scales** (percentile vs mean-50/SD-10). AFQT 50 sits at AFQTS ≈ 202 — and because AFQTS = AR + MK + 2*VE, the four subtest standard scores do **not** need to average 50 to produce an AFQT of 50. The AFQT is a *verbal-weighted* composite, which is the central coaching implication.

---

## 3. Line scores (Service classification composites)

### 3.1 The headline finding

**Only one Army line score is a plain sum of subtests: GT = AR + VE.** The other nine are **regression-weighted sums of all seven reported standard scores**, rescaled to mean 100 / SD 20. Segall (2004), Sec. 2.5.3: "One composite is calculated from integer-weighted subtest scores, while the other nine are calculated from non-integer weights." The official ASVAB site's Military Jobs table footnotes all nine: "Computed as a non-integer weighted linear combination of all ASVAB subtests (GS, AR, WK, PC, MK, EI, AS, MC, and AO)." ASVAB Technical Bulletin No. 4, Table C.1, prints the same asterisk. **[VERIFIED]**

Therefore the folklore formulas on prep sites — "CL = VE + AR + MK", "MM = NO + AS + MC + EI" — are **nominal definitions**, not the computation behind the printed number. Several reference **NO (Numerical Operations)** and **CS (Coding Speed)**, subtests **removed from the ASVAB in 2002** and replaced by AO. Those formulas cannot be evaluated on a current test at all.

### 3.2 The operational formulas (use these in code)

GT, the integer-weighted exception: **[VERIFIED]**

```
GT_S = round(AR) + round(VE)                 # mean 100.0135, SD 18.6169 in PAY97
GT   = Rnd( 1.074292 * GT_S - 7.443781 )     # -> mean 100, SD 20
```

The other nine, from Segall (2004) **Table 2.7, Army Composite Weights ('97 Metric)**: **[VERIFIED — transcribed and cross-validated, §3.4]**

```
CL = Rnd( 0.00000*GS + 0.75179*AR + 0.58715*MK + 0.11541*MC + 0.07756*EI + 0.07489*AS + 0.67976*VE - 14.32772 )
CO = Rnd( 0.19868*GS + 0.33090*AR + 0.63397*MK + 0.38486*MC + 0.19979*EI + 0.41161*AS + 0.30347*VE - 23.17105 )
EL = Rnd( 0.08324*GS + 0.44254*AR + 0.49064*MK + 0.26341*MC + 0.30258*EI + 0.36786*AS + 0.49906*VE - 22.46667 )
FA = Rnd( 0.15031*GS + 0.42263*AR + 0.60172*MK + 0.42966*MC + 0.16389*EI + 0.35866*AS + 0.31958*VE - 22.32119 )
GM = Rnd( 0.23521*GS + 0.46357*AR + 0.45285*MK + 0.29280*MC + 0.30216*EI + 0.50542*AS + 0.21527*VE - 23.36174 )
MM = Rnd( 0.05942*GS + 0.32829*AR + 0.28517*MK + 0.39607*MC + 0.30796*EI + 0.87309*AS + 0.21150*VE - 23.08481 )
OF = Rnd( 0.14306*GS + 0.53676*AR + 0.34092*MK + 0.36843*MC + 0.19683*EI + 0.50334*AS + 0.36757*VE - 22.84882 )
SC = Rnd( 0.01235*GS + 0.42812*AR + 0.63650*MK + 0.25070*MC + 0.32194*EI + 0.24636*AS + 0.52770*VE - 21.18951 )
ST = Rnd( 0.12865*GS + 0.49010*AR + 0.47825*MK + 0.31207*MC + 0.14493*EI + 0.21736*AS + 0.62177*VE - 19.65219 )
```

Built-in sanity check: **every weight row sums to exactly 1.0** (CL: .75179+.58715+.11541+.07756+.07489+.67976 = 2.28656, and 2.28656*50 − 14.32772 = 100.00). Feed all seven standard scores as 50 and every composite returns 100. If your implementation doesn't, your transcription is wrong. **[VERIFIED — computed]**

### 3.3 Nominal vs operational, composite by composite

| Code | Name | Nominal definition (as published) | Status |
|---|---|---|---|
| GT | General Technical | **VE + AR** | **[VERIFIED]** official ASVAB site + Tech Bulletin Table C.1 + Segall 2.5.3. The only one where nominal = operational. |
| CL | Clerical | VE + AR + MK | **[SECONDARY]** nominal; operational = Table 2.7. |
| CO | Combat | VE + AR + AS + MC (some sources: AR + CS + AS + MC) | **[SECONDARY]**; the CS variant is dead. |
| EL | Electronics Repair | GS + AR + MK + EI | **[SECONDARY]** nominal — and it matches Navy EL / Air Force E, which **are** verified literal sums in Tech Bulletin Table C.1. |
| FA | Field Artillery | AR + CS + MK + MC | **[SECONDARY]**; contains CS -> not computable today. |
| GM | General Maintenance | GS + AS + MK + EI | **[SECONDARY]** nominal. |
| MM | Mechanical Maintenance | NO + AS + MC + EI | **[SECONDARY]**; contains NO -> not computable today. This is the composite most often mis-stated. |
| OF | Operators and Food | VE + NO + AS + MC | **[SECONDARY]**; contains NO -> not computable today. |
| SC | Surveillance and Communications | VE + AR + AS + MC | **[SECONDARY]** nominal. |
| ST | Skilled Technical | GS + VE + MK + MC | **[SECONDARY]** nominal. |

**[UNVERIFIED]** The nominal column could not be checked against the current text of **DA PAM 611-21** (Army Military Occupational Classification), which defines them; that document was not retrievable in this session, and the secondary table relied on cites DA PAM 611-21 while still listing CS/NO — evidence it reproduces a pre-2002 edition. Tech Bulletin No. 4, footnote 7, acknowledges the gap: "the Services made some changes in their composites; those changes are not documented in this report."

**Recommendation for a web app:** compute the ten composites with Table 2.7 (plus the GT transform). Show the nominal definition as explanatory *prose* ("GT emphasizes verbal and arithmetic reasoning"), never as the arithmetic.

### 3.4 Cross-validation of the transcribed weights

Three checks passed: **(a)** all-50s -> 100.00 for all nine; **(b)** GT(AR 55, VE 54) = round(1.074292*109 − 7.443781) = **110**, matching an independently published worked example; **(c)** with GS 52 / AR 55 / VE 54 / MK 51 / EI 48 / AS 45 / MC 50, the Table 2.7 formulas return CO 101, ST 104, MM 98 — the same values that third-party site publishes. Reproducing someone else's printed numbers from your own transcription is strong evidence the weights are correct. **[VERIFIED — computed]**

### 3.5 Other Services (completeness)

All verified as literal integer-weighted sums in Tech Bulletin No. 4, Table C.1 and the official ASVAB Military Jobs page:

```
Navy   GT = VE + AR        EL = GS+AR+MK+EI    BEE = GS+AR+2*MK   ENG = AS+MK
       MEC = AR+AS+MC      MEC2 = AR+MC+AO     NUC = VE+AR+MK+MC  OPS = VE+AR+MK+AO
       HM = VE+GS+MK       ADM = VE+MK
Air Force  M = AR+2*VE+MC+AS   A = VE+MK   G = VE+AR   E = AR+MK+EI+GS
USMC   MM = AR+MC+AS+EI     CL = VE+MK   GT = VE+AR+MC   EL = AR+MK+EI+GS
```

USMC also rescales to mean 100 / SD 20: MM = Rnd(0.588215*MM_S − 17.645724), GT = Rnd(0.755294*GT_S − 13.289535), EL = Rnd(0.577992*EL_S − 15.599795), CL = Rnd(1.092264*CL_S − 9.232992). **Navy is the exception**: raw unit-weighted sums, no rescaling ("the Navy reports their scores directly as the 'sum of standardized subtest scores'"). **[VERIFIED]**

---

## 4. From a practice-test raw score to a realistic AFQT — a labelled approximation

**[APPROX] — this entire section is a defensible model, not an official conversion path.** Nothing official accepts percent-correct as input; the pipeline starts from IRT ability estimates.

### 4.1 The model

```
1. p      = clamp(rawPct / 100, 0.005, 0.995)
2. SS     = clamp(round(50 + 10 * PhiInv(p)), 1, 99)
3. AFQTS  = 4 * SS          /* = AR + MK + 2*VE when AR=MK=WK=PC=SS */
4. AFQT%  = clamp(lookupTable2_5(AFQTS), 1, 99)
5. optional realism haircut: AFQT_practice = clamp(AFQT% - 7, 1, 99)
```

Why step 2 is defensible: the standard-score scale is *defined* so a given percentile of the reference population maps to a knowable standard score (mean 50, SD 10, roughly normal). If a practice set is representative of the operational item pool, "I got 70% right" approximates "I out-scored 70% of the reference group," and the normal CDF inverts that cleanly. If the set is unrepresentative, the chain inherits the bias.

Why step 3: AFQTS = 1*AR + 1*MK + 2*VE = 1 + 1 + 2 = **4x** a common standard score.

Why step 4 is exact: it uses the published Table 2.5 lookup (§2.2), not a fitted curve.

**[APPROX]** Known distortions, all conservative: guessing inflates the low end (10% raw is usually worse than a 10th-percentile performance); practice items are easier than operational items; test-day timing and unfamiliar formats cost points; and the verbal double-weighting means a student weak in WK/PC scores lower than a single "overall %" implies.

### 4.2 The mapping table

| Raw % correct | Est. subtest standard score | Implied AFQTS | Est. AFQT percentile | Practice-adjusted (−7) |
|---:|---:|---:|---:|---:|
| 0 | 24 | 96 | 1 | 1 |
| 5 | 34 | 136 | 5 | 1 |
| 10 | 37 | 148 | 9 | 2 |
| 15 | 40 | 160 | 14 | 7 |
| 20 | 42 | 168 | 19 | 12 |
| 25 | 43 | 172 | 22 | 15 |
| 30 | 45 | 180 | 28 | 21 |
| 35 | 46 | 184 | 32 | 25 |
| 40 | 47 | 188 | 35 | 28 |
| 45 | 49 | 196 | 44 | 37 |
| 50 | 50 | 200 | 48 | 41 |
| 55 | 51 | 204 | 52 | 45 |
| 60 | 53 | 212 | 61 | 54 |
| 65 | 54 | 216 | 66 | 59 |
| 70 | 55 | 220 | 70 | 63 |
| 75 | 57 | 228 | 77 | 70 |
| 80 | 58 | 232 | 81 | 74 |
| 85 | 60 | 240 | 87 | 80 |
| 90 | 63 | 252 | 94 | 87 |
| 95 | 66 | 264 | 98 | 91 |
| 100 | 76 | 304 | 99 | 92 |

Read it like this: **45–50% raw is average; 30% raw is the Category IV/V boundary zone; 55% raw clears the Army's 31-point floor with margin; 70% raw is Category II.**

| Category | AFQT band | Approx. raw % needed (this model) |
|---|---|---|
| I | 93–99 | 89%+ |
| II | 65–92 | 64%+ |
| IIIA | 50–64 | 54%+ |
| IIIB | 31–49 | 34%+ |
| IV | 10–30 | 17%+ |
| V | 1–9 | below ~17% |

### 4.3 If you have per-subtest practice scores, do better

```
SS_k   = clamp(round(50 + 10 * PhiInv(clamp(pct_k/100, 0.005, 0.995))), 1, 99)   # per subtest
SS_VE  = 50 + 0.80 * ( 1.0*(SS_WK - 50) + 0.61934*(SS_PC - 50) )               # APPROX
AFQTS  = SS_AR + SS_MK + 2*SS_VE
AFQT%  = lookupTable2_5(AFQTS)
```

**[APPROX]** The 0.61934 ratio is **[VERIFIED]** (Segall Eq. 2.3); the 0.80 scaling factor and the omission of a PC reliability correction are **[APPROX]**. If the app shows a VE value, label it as estimated.

---

## 5. Worked examples

### 5.1 Cross-check example (reproduces a published third-party answer)

```
Reported: GS 52, AR 55, VE 54, MK 51, EI 48, AS 45, MC 50

AFQTS = 55 + 51 + 2*54 = 214                        -> AFQT 63  (Category IIIA)
GT    = Rnd(1.074292*(55+54) - 7.443781)
      = Rnd(117.0982 - 7.4438) = Rnd(109.654)       -> GT 110
CO    = Rnd(101.44) -> 101
ST    = Rnd(104.30) -> 104
MM    = Rnd( 97.90) ->  98
CL    = Rnd(106.54) -> 107
EL 102.42 | FA 102.17 | GM 100.97 | OF 101.87 | SC 103.03
```

### 5.2 A cleaner hypothetical profile

```
Reported: GS 55, AR 60, WK 58*, PC 52*, VE 56, MK 57, EI 50, AS 48, MC 52
(*WK/PC shown for transparency; only VE feeds the formulas)

AFQTS = 60 + 57 + 2*56 = 229                        -> AFQT 78  (Category II)
GT    = Rnd(1.074292*116 - 7.443781) = Rnd(117.17)  -> GT 117
CL    = Rnd(115.79) -> 116
CO    = Rnd(110.50) -> 111
EL    = Rnd(111.06) -> 111
FA    = Rnd(111.25) -> 111
GM    = Rnd(109.85) -> 110
MM    = Rnd(105.88) -> 106
OF    = Rnd(110.40) -> 110
SC    = Rnd(111.97) -> 112
ST    = Rnd(112.82) -> 113
```

### 5.3 Same AR/VE, different technical profile — why non-integer weights matter

```
Profile A: GS 45, AR 60, MK 55, EI 40, AS 35, MC 40, VE 56   (verbal/math strong, technical weak)
   MM = Rnd(0.05942*45 + 0.32829*60 + 0.28517*55 + 0.39607*40
           + 0.30796*40 + 0.87309*35 + 0.21150*56 - 23.08481)
      = Rnd(2.674 + 19.697 + 15.684 + 15.843 + 12.318 + 30.558 + 11.844 - 23.085)
      = Rnd(85.53) -> 86
   GT = Rnd(1.074292*116 - 7.443781) = 117     (unchanged)

Profile B: GS 60, AR 60, MK 55, EI 62, AS 65, MC 62, VE 56   (technical strong)
   MM = Rnd(3.565 + 19.697 + 15.684 + 24.556 + 19.093 + 56.751 + 11.844 - 23.085)
      = Rnd(128.11) -> 128
   GT = 117                                    (unchanged)
```

GT moves only with AR and VE; MM swings 42 points on the technical subtests alone. That pair of numbers is the best argument for using Table 2.7 rather than the nominal four-subtest formulas.

---

## 6. Recruiter-relevant facts

### 6.1 AFQT categories

| Category | AFQT percentile | Nominal share of population | Practical meaning |
|---|---|---:|---|
| I | 93–99 | 7.5% | Top tier; every branch, best programs |
| II | 65–92 | 28% | Above average; virtually all jobs |
| IIIA | 50–64 | 15% | Above average; the "quality" benchmark is IIIA+ |
| IIIB | 31–49 | 19% | Below average; meets most branch floors |
| IVA | 21–30 | 10% | Category IV; capped, waivers possible |
| IVB | 16–20 | 5% | Category IV; waivers rarely approved |
| IVC | 10–15 | 6% | Category IV; bottom of the legal range |
| V | 1–9 | 9.5% | Statutory bar; not eligible for active duty |

**[VERIFIED]** boundaries and nominal percentages (Segall Table 2.2; identical on officialasvab.com). Segall also computed '97-scale boundaries that would have re-cut the bands (e.g. III 26–63, IV 6–25); **DoD did not adopt them — the 1980-era bands remain in force.** Don't ship the proposal. **[VERIFIED]**

### 6.2 The legal floor and the Category IV cap

```
10 U.S.C. 520(a)(1):
  accessions scoring >= 10th percentile and < 31st percentile (Category IV)
  may not exceed 4% of a Service's active-duty accessions in a fiscal year.

10 U.S.C. 520(a)(2):
  the Secretary of Defense may, on request of the Secretary concerned,
  raise that limit to not more than 20%.

Category V (1-9): no applicant below the 10th percentile may be accepted
  into active duty.  (ASVAB Technical Bulletin No. 4, Sec. 2.2.1)
```

**[VERIFIED]** — statute text read directly; the Category V bar is stated in the Technical Bulletin: "By law, DoD is not allowed to accept into active duty an applicant who scores below the 10th percentile on the AFQT."

### 6.3 Minimum scores by branch

| Branch | Diploma-track minimum AFQT | GED-track (secondary sources) |
|---|---:|---:|
| Army | 31 | 50 |
| Marine Corps | 32 | 50 |
| Navy | 31 (35 in practice) | 50 + 15 college credits |
| Air Force | 36 | 65 |
| Space Force | 36 | 65 |
| Coast Guard | 32 | 50 + 15 college credits |

**[SECONDARY]** — consistently published by commercial ASVAB sites. The authoritative source is **AR 601-210** plus each Service's accession regulation; **[UNVERIFIED]** against primary text here. Caveat it in the UI as "verify with a recruiter; standards change."

What *is* verifiable without the regulation: **the Army minimum cannot sit below 31, because 31 is the bottom of Category IIIB**, and everything below 31 is Category IV and therefore rate-capped at 4%. That structural argument holds regardless of the current policy number.

### 6.4 Education tiers (Tier I / II / III)

**[SECONDARY / UNVERIFIED against regulation text]**

| Tier | Definition | Why it matters |
|---|---|---|
| **Tier I** | High school diploma graduate, or 15+ semester hours of college credit | Preferred pool; most contracts and virtually all bonuses are Tier I |
| **Tier II** | GED, alternative high-school credential, adult-education diploma, certificate of completion | Accessible, but usually demands a **higher AFQT** (commonly 50 vs 31) and counts against a DoD quality cap |
| **Tier III** | Non-high-school graduate | Rarely accessed; needs waiver plus a high AFQT (typically Category I–IIIA) |

The tiers are an **education** classification, deliberately orthogonal to AFQT **categories**. Recruiters discuss them jointly because DoD's "high quality" metric is defined as *Tier I AND AFQT Category IIIA or above* (Tech Bulletin No. 4: "The modern 'quality' benchmark is Category IIIA and above"). **[VERIFIED for the quality definition; SECONDARY for the tier definitions]**

---

## 7. Implementation recipe

```ts
// ---- constants verified in this report ----
const ARMY_W = {
  CL: [0.00000,0.75179,0.58715,0.11541,0.07756,0.07489,0.67976, -14.32772],
  CO: [0.19868,0.33090,0.63397,0.38486,0.19979,0.41161,0.30347, -23.17105],
  EL: [0.08324,0.44254,0.49064,0.26341,0.30258,0.36786,0.49906, -22.46667],
  FA: [0.15031,0.42263,0.60172,0.42966,0.16389,0.35866,0.31958, -22.32119],
  GM: [0.23521,0.46357,0.45285,0.29280,0.30216,0.50542,0.21527, -23.36174],
  MM: [0.05942,0.32829,0.28517,0.39607,0.30796,0.87309,0.21150, -23.08481],
  OF: [0.14306,0.53676,0.34092,0.36843,0.19683,0.50334,0.36757, -22.84882],
  SC: [0.01235,0.42812,0.63650,0.25070,0.32194,0.24636,0.52770, -21.18951],
  ST: [0.12865,0.49010,0.47825,0.31207,0.14493,0.21736,0.62177, -19.65219],
}; // order: GS, AR, MK, MC, EI, AS, VE, constant

const rnd = (x) => Math.round(x + 1e-9);          // guard FP dust

function lineScores(s) {                          // s = {GS,AR,MK,MC,EI,AS,VE}
  const keys = ["GS","AR","MK","MC","EI","AS","VE"];
  const out = { GT: rnd(1.074292 * (s.AR + s.VE) - 7.443781) };  // integer-weighted
  for (const [code, w] of Object.entries(ARMY_W)) {
    let v = w[7];
    keys.forEach((k, i) => { v += w[i] * s[k]; });
    out[code] = rnd(v);
  }
  return out;        // mean 100, SD 20 in PAY97
}

function afqtPercentile(s, lookupTable2_5) {
  const afqts = s.AR + s.MK + 2 * s.VE;
  if (afqts <= 109) return 1;
  if (afqts >= 269) return 99;
  return lookupTable2_5[afqts];                   // exact table; do not fit a curve
}
```

Three rules that prevent most bugs:

1. **Round once, at the end.** Subtest standard scores are already integers on the report; everything downstream is a weighted sum of those integers.
2. **Sanity-band the outputs.** On a mean-100/SD-20 scale, line scores realistically run ~60–140. A 50 or a 180 means you fed unrounded or mis-scaled inputs.
3. **Keep the AFQT lookup table in data, not code.** That table *is* the norm; refitting it is the one thing that will silently drift.

---

## 8. Sources

**Primary**

1. Segall, D. O. (2004). *Development and Evaluation of the 1997 ASVAB Score Scale.* Defense Manpower Data Center. https://www.officialasvab.com/wp-content/uploads/2019/08/1997score_scale.pdf — Sec. 2.2 (standard scores), 2.3 (VE/AS composites), 2.4 + Table 2.5 (AFQT), 2.5.1–2.5.4 + Tables 2.6/2.7 (Service composites), Table 2.2 (categories), Table 5.1 (composite definitions). **The single authoritative source for the arithmetic.**
2. *ASVAB Technical Bulletin No. 4.* https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_4.pdf — Sec. 2.2.1, Table 2.2 (categories), Table C.1 (Service composites), footnote 7.
3. officialasvab.com — [ASVAB Scoring](https://www.officialasvab.com/researchers/scores/), [Understanding ASVAB Scores](https://www.officialasvab.com/applicants/scores/), [Norming Information](https://www.officialasvab.com/researchers/norming-information/), [Military Jobs](https://www.officialasvab.com/applicants/military-jobs/).
4. 10 U.S.C. § 520 — https://www.law.cornell.edu/uscode/text/10/520

**Secondary / cross-checks**

5. asvabscores.org, *ASVAB Score Calculator* — https://asvabscores.org/asvab-score-calculator/ — the Table 2.7 transcription and the §5.1 worked example; its nominal-definition column is the source of the legacy CS/NO formulas in §3.3.
6. ASVAB Hero, *ASVAB Score Chart* — https://asvabhero.com/asvab-score-chart — category bands, branch minimums, an independent transcription of the same Table 2.7 weights.
7. military.com, *ASVAB Scores for Jobs* — https://www.military.com/join-the-military/asvab-test/scores-by-career-path

---

## 9. Machine-readable summary

```json
{
  "_meta": {
    "title": "ASVAB scoring model - machine-readable extract",
    "primarySources": [
      "Segall, D. O. (2004). Development and Evaluation of the 1997 ASVAB Score Scale. DMDC. https://www.officialasvab.com/wp-content/uploads/2019/08/1997score_scale.pdf",
      "ASVAB Technical Bulletin No. 4. https://www.officialasvab.com/wp-content/uploads/2019/08/asvab_techbulletin_4.pdf",
      "https://www.officialasvab.com/researchers/scores/",
      "https://www.officialasvab.com/applicants/scores/",
      "https://www.officialasvab.com/researchers/norming-information/",
      "https://www.officialasvab.com/applicants/military-jobs/",
      "10 U.S.C. 520. https://www.law.cornell.edu/uscode/text/10/520"
    ],
    "legend": "verified=true means stated in, or directly computed from, a primary ASVAB/DMDC/DoD document read during this research. false means secondary source, inference, or approximation."
  },
  "subtestScale": {
    "min": null,
    "max": null,
    "mean": 50,
    "sd": 10,
    "verified": true,
    "rangeIs1to99": false,
    "clarification": "Subtest standard scores are NOT on a 1-99 scale; 1-99 is the AFQT percentile range. The '97 scale is explicitly not truncated (Segall 2004 Sec. 2.2 fn 2); the '80 scale was truncated at 20 and 80.",
    "observedPracticalRange": [
      10,
      90
    ],
    "source": "Segall 2004 Eq. 2.1-2.2 + fn 2; officialasvab.com/researchers/scores/"
  },
  "afqt": {
    "subtests": [
      "AR",
      "MK",
      "WK",
      "PC"
    ],
    "rawFormula": "AR + MK + 2 * VE",
    "veDefinition": "standardised optimally-weighted WK/PC composite, weight ratio b_PC/b_WK = 0.61934, rescaled to mean 50 SD 10",
    "naiveRawFormula": "2*WK + 2*PC + AR + MK",
    "naiveFormulaVerified": false,
    "naiveFormulaNote": "Prep-site simplification treating VE as WK+PC. Real VE weights PC at ~0.61934 of WK.",
    "compositeName": "AFQTS",
    "compositeMean": 202,
    "compositeSdApprox": 36,
    "normalisation": "AFQT% = Rnd(100 * cumulative density of AFQTS in the reference sample); rounded 0 -> 1, rounded 100 -> 99; AFQTS <= 109 -> 1, AFQTS >= 269 -> 99. Operationally a fixed lookup table (Segall Table 2.5).",
    "range": [
      1,
      99
    ],
    "rangeIsPercentile": true,
    "referencePopulation": "PAY97: ~6,000 nationally representative US youths aged 18-23, CAT-ASVAB administered summer/fall 1997; norms implemented July 2004.",
    "historicalReferencePopulation": "PAY80: Profile of American Youth 1980, used on the '80 score scale until the 2004 changeover. Same AFQTS formula and same 0->1/100->99 convention on both scales.",
    "meanOfPercentileDistribution": 50,
    "source": "Segall 2004 Sec. 2.4 + Table 2.5; Technical Bulletin No. 4 Sec. 2.2.1; officialasvab.com/researchers/scores/"
  },
  "lineScores": [
    {
      "code": "GT",
      "name": "General Technical",
      "formula": "Rnd(1.074292 * (VE + AR) - 7.443781)",
      "nominalFormula": "VE + AR",
      "unstandardisedComposite": "GT_S = round(AR) + round(VE)  (mean 100.0135, SD 18.6169 in PAY97)",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": true,
      "verified": true,
      "source": "Segall (2004) Development and Evaluation of the 1997 ASVAB Score Scale, DMDC, Sec. 2.5.3; officialasvab.com Military Jobs table; ASVAB Technical Bulletin No. 4 Table C.1",
      "weights": {
        "GS": 0,
        "AR": 1.074292,
        "MK": 0,
        "MC": 0,
        "EI": 0,
        "AS": 0,
        "VE": 1.074292,
        "constant": -7.443781
      }
    },
    {
      "code": "CL",
      "name": "Clerical",
      "formula": "Rnd(0*GS + 0.75179*AR + 0.58715*MK + 0.11541*MC + 0.07756*EI + 0.07489*AS + 0.67976*VE + (-14.32772))",
      "nominalFormula": "VE + AR + MK",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0,
        "AR": 0.75179,
        "MK": 0.58715,
        "MC": 0.11541,
        "EI": 0.07756,
        "AS": 0.07489,
        "VE": 0.67976,
        "constant": -14.32772
      }
    },
    {
      "code": "CO",
      "name": "Combat",
      "formula": "Rnd(0.19868*GS + 0.3309*AR + 0.63397*MK + 0.38486*MC + 0.19979*EI + 0.41161*AS + 0.30347*VE + (-23.17105))",
      "nominalFormula": "VE + AR + AS + MC   (legacy variant: AR + CS + AS + MC)",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.19868,
        "AR": 0.3309,
        "MK": 0.63397,
        "MC": 0.38486,
        "EI": 0.19979,
        "AS": 0.41161,
        "VE": 0.30347,
        "constant": -23.17105
      }
    },
    {
      "code": "EL",
      "name": "Electronics Repair",
      "formula": "Rnd(0.08324*GS + 0.44254*AR + 0.49064*MK + 0.26341*MC + 0.30258*EI + 0.36786*AS + 0.49906*VE + (-22.46667))",
      "nominalFormula": "GS + AR + MK + EI",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.08324,
        "AR": 0.44254,
        "MK": 0.49064,
        "MC": 0.26341,
        "EI": 0.30258,
        "AS": 0.36786,
        "VE": 0.49906,
        "constant": -22.46667
      }
    },
    {
      "code": "FA",
      "name": "Field Artillery",
      "formula": "Rnd(0.15031*GS + 0.42263*AR + 0.60172*MK + 0.42966*MC + 0.16389*EI + 0.35866*AS + 0.31958*VE + (-22.32119))",
      "nominalFormula": "AR + CS + MK + MC   (legacy; CS removed from the battery in 2002)",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.15031,
        "AR": 0.42263,
        "MK": 0.60172,
        "MC": 0.42966,
        "EI": 0.16389,
        "AS": 0.35866,
        "VE": 0.31958,
        "constant": -22.32119
      }
    },
    {
      "code": "GM",
      "name": "General Maintenance",
      "formula": "Rnd(0.23521*GS + 0.46357*AR + 0.45285*MK + 0.2928*MC + 0.30216*EI + 0.50542*AS + 0.21527*VE + (-23.36174))",
      "nominalFormula": "GS + AS + MK + EI",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.23521,
        "AR": 0.46357,
        "MK": 0.45285,
        "MC": 0.2928,
        "EI": 0.30216,
        "AS": 0.50542,
        "VE": 0.21527,
        "constant": -23.36174
      }
    },
    {
      "code": "MM",
      "name": "Mechanical Maintenance",
      "formula": "Rnd(0.05942*GS + 0.32829*AR + 0.28517*MK + 0.39607*MC + 0.30796*EI + 0.87309*AS + 0.2115*VE + (-23.08481))",
      "nominalFormula": "NO + AS + MC + EI   (legacy; NO removed from the battery in 2002)",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.05942,
        "AR": 0.32829,
        "MK": 0.28517,
        "MC": 0.39607,
        "EI": 0.30796,
        "AS": 0.87309,
        "VE": 0.2115,
        "constant": -23.08481
      }
    },
    {
      "code": "OF",
      "name": "Operators and Food",
      "formula": "Rnd(0.14306*GS + 0.53676*AR + 0.34092*MK + 0.36843*MC + 0.19683*EI + 0.50334*AS + 0.36757*VE + (-22.84882))",
      "nominalFormula": "VE + NO + AS + MC   (legacy; NO removed from the battery in 2002)",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.14306,
        "AR": 0.53676,
        "MK": 0.34092,
        "MC": 0.36843,
        "EI": 0.19683,
        "AS": 0.50334,
        "VE": 0.36757,
        "constant": -22.84882
      }
    },
    {
      "code": "SC",
      "name": "Surveillance and Communications",
      "formula": "Rnd(0.01235*GS + 0.42812*AR + 0.6365*MK + 0.2507*MC + 0.32194*EI + 0.24636*AS + 0.5277*VE + (-21.18951))",
      "nominalFormula": "VE + AR + AS + MC",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.01235,
        "AR": 0.42812,
        "MK": 0.6365,
        "MC": 0.2507,
        "EI": 0.32194,
        "AS": 0.24636,
        "VE": 0.5277,
        "constant": -21.18951
      }
    },
    {
      "code": "ST",
      "name": "Skilled Technical",
      "formula": "Rnd(0.12865*GS + 0.4901*AR + 0.47825*MK + 0.31207*MC + 0.14493*EI + 0.21736*AS + 0.62177*VE + (-19.65219))",
      "nominalFormula": "GS + VE + MK + MC",
      "unstandardisedComposite": "non-integer weighted sum of all seven reported standard scores",
      "reportedScale": "mean 100, SD 20 (PAY97 youth reference population)",
      "nominalEqualsOperational": false,
      "verified": true,
      "verifiedNote": "Operational weights verified against Segall Table 2.7 and independently reproduced (all-50s -> 100.00; a third-party worked example reproduced exactly). The nominal 4-subtest definition is NOT what produces the printed number.",
      "source": "Segall (2004), Table 2.7 - Army Composite Weights ('97 Metric)",
      "weights": {
        "GS": 0.12865,
        "AR": 0.4901,
        "MK": 0.47825,
        "MC": 0.31207,
        "EI": 0.14493,
        "AS": 0.21736,
        "VE": 0.62177,
        "constant": -19.65219
      }
    }
  ],
  "reportedLineScoreScale": {
    "mean": 100,
    "sd": 20,
    "population": "PAY97 youth reference population",
    "verified": true,
    "source": "Segall 2004 Sec. 2.5.2/2.5.3: 'places the unstandardized composite score on a scale with mean 100 and standard deviation 20 in the '97 reference population'"
  },
  "categories": [
    {
      "name": "I",
      "afqtMin": 93,
      "afqtMax": 99,
      "nominalPopulationPct": 7.5,
      "verified": true
    },
    {
      "name": "II",
      "afqtMin": 65,
      "afqtMax": 92,
      "nominalPopulationPct": 28,
      "verified": true
    },
    {
      "name": "IIIA",
      "afqtMin": 50,
      "afqtMax": 64,
      "nominalPopulationPct": 15,
      "verified": true
    },
    {
      "name": "IIIB",
      "afqtMin": 31,
      "afqtMax": 49,
      "nominalPopulationPct": 19,
      "verified": true
    },
    {
      "name": "IVA",
      "afqtMin": 21,
      "afqtMax": 30,
      "nominalPopulationPct": 10,
      "verified": true
    },
    {
      "name": "IVB",
      "afqtMin": 16,
      "afqtMax": 20,
      "nominalPopulationPct": 5,
      "verified": true
    },
    {
      "name": "IVC",
      "afqtMin": 10,
      "afqtMax": 15,
      "nominalPopulationPct": 6,
      "verified": true
    },
    {
      "name": "V",
      "afqtMin": 1,
      "afqtMax": 9,
      "nominalPopulationPct": 9.5,
      "verified": true
    }
  ],
  "categoryNotes": {
    "statute": "10 U.S.C. 520(a)(1): accessions scoring at or above the 10th and below the 31st percentile (Category IV) may not exceed 4% of a Service's active-duty accessions in a fiscal year; 520(a)(2) lets the Secretary of Defense raise that to not more than 20% on request. No applicant below the 10th percentile may be accepted into active duty (Category V bar) - ASVAB Technical Bulletin No. 4 Sec. 2.2.1.",
    "rejected1997Reband": "Segall 2004 also computed '97-scale boundaries (III 26-63, IV 6-25, V 1-5) but DoD did not adopt them; the 1980-era bands remain in force."
  },
  "enlistment": {
    "armyMinimumAfqtDiploma": 31,
    "armyMinimumAfqtGed": 50,
    "verified": false,
    "note": "Widely reported secondary-source values; AR 601-210 / DA PAM 611-21 could not be retrieved in this session. Structurally verifiable constraint: 31 is the bottom of Category IIIB, so anything below is Category IV and rate-capped at 4%.",
    "branchMinimumsSecondary": {
      "Army": 31,
      "Marine Corps": 32,
      "Navy": 31,
      "Air Force": 36,
      "Space Force": 36,
      "Coast Guard": 32
    }
  },
  "educationTiers": {
    "verified": false,
    "note": "Standard DoD accessions terminology; not verified against regulation text in this session.",
    "tierI": "High school diploma graduate, or 15+ semester hours of college credit",
    "tierII": "GED / alternative high-school credential / adult-education diploma",
    "tierIII": "Non-high-school graduate (rarely accessed; requires waiver)"
  },
  "calibrationTable": [
    {
      "rawAccuracyPct": 0,
      "estimatedStandardScore": 24,
      "estimatedAfqtPercentile": 1,
      "estimatedAfqtPercentilePracticeAdjusted": 1
    },
    {
      "rawAccuracyPct": 5,
      "estimatedStandardScore": 34,
      "estimatedAfqtPercentile": 5,
      "estimatedAfqtPercentilePracticeAdjusted": 1
    },
    {
      "rawAccuracyPct": 10,
      "estimatedStandardScore": 37,
      "estimatedAfqtPercentile": 9,
      "estimatedAfqtPercentilePracticeAdjusted": 2
    },
    {
      "rawAccuracyPct": 15,
      "estimatedStandardScore": 40,
      "estimatedAfqtPercentile": 14,
      "estimatedAfqtPercentilePracticeAdjusted": 7
    },
    {
      "rawAccuracyPct": 20,
      "estimatedStandardScore": 42,
      "estimatedAfqtPercentile": 19,
      "estimatedAfqtPercentilePracticeAdjusted": 12
    },
    {
      "rawAccuracyPct": 25,
      "estimatedStandardScore": 43,
      "estimatedAfqtPercentile": 22,
      "estimatedAfqtPercentilePracticeAdjusted": 15
    },
    {
      "rawAccuracyPct": 30,
      "estimatedStandardScore": 45,
      "estimatedAfqtPercentile": 28,
      "estimatedAfqtPercentilePracticeAdjusted": 21
    },
    {
      "rawAccuracyPct": 35,
      "estimatedStandardScore": 46,
      "estimatedAfqtPercentile": 32,
      "estimatedAfqtPercentilePracticeAdjusted": 25
    },
    {
      "rawAccuracyPct": 40,
      "estimatedStandardScore": 47,
      "estimatedAfqtPercentile": 35,
      "estimatedAfqtPercentilePracticeAdjusted": 28
    },
    {
      "rawAccuracyPct": 45,
      "estimatedStandardScore": 49,
      "estimatedAfqtPercentile": 44,
      "estimatedAfqtPercentilePracticeAdjusted": 37
    },
    {
      "rawAccuracyPct": 50,
      "estimatedStandardScore": 50,
      "estimatedAfqtPercentile": 48,
      "estimatedAfqtPercentilePracticeAdjusted": 41
    },
    {
      "rawAccuracyPct": 55,
      "estimatedStandardScore": 51,
      "estimatedAfqtPercentile": 52,
      "estimatedAfqtPercentilePracticeAdjusted": 45
    },
    {
      "rawAccuracyPct": 60,
      "estimatedStandardScore": 53,
      "estimatedAfqtPercentile": 61,
      "estimatedAfqtPercentilePracticeAdjusted": 54
    },
    {
      "rawAccuracyPct": 65,
      "estimatedStandardScore": 54,
      "estimatedAfqtPercentile": 66,
      "estimatedAfqtPercentilePracticeAdjusted": 59
    },
    {
      "rawAccuracyPct": 70,
      "estimatedStandardScore": 55,
      "estimatedAfqtPercentile": 70,
      "estimatedAfqtPercentilePracticeAdjusted": 63
    },
    {
      "rawAccuracyPct": 75,
      "estimatedStandardScore": 57,
      "estimatedAfqtPercentile": 77,
      "estimatedAfqtPercentilePracticeAdjusted": 70
    },
    {
      "rawAccuracyPct": 80,
      "estimatedStandardScore": 58,
      "estimatedAfqtPercentile": 81,
      "estimatedAfqtPercentilePracticeAdjusted": 74
    },
    {
      "rawAccuracyPct": 85,
      "estimatedStandardScore": 60,
      "estimatedAfqtPercentile": 87,
      "estimatedAfqtPercentilePracticeAdjusted": 80
    },
    {
      "rawAccuracyPct": 90,
      "estimatedStandardScore": 63,
      "estimatedAfqtPercentile": 94,
      "estimatedAfqtPercentilePracticeAdjusted": 87
    },
    {
      "rawAccuracyPct": 95,
      "estimatedStandardScore": 66,
      "estimatedAfqtPercentile": 98,
      "estimatedAfqtPercentilePracticeAdjusted": 91
    },
    {
      "rawAccuracyPct": 100,
      "estimatedStandardScore": 76,
      "estimatedAfqtPercentile": 99,
      "estimatedAfqtPercentilePracticeAdjusted": 92
    }
  ],
  "calibrationModel": {
    "approx": true,
    "steps": [
      "p = clamp(rawPct/100, 0.005, 0.995)",
      "standardScore = clamp(round(50 + 10 * PhiInv(p)), 1, 99)",
      "AFQTS = 4 * standardScore  (equals AR + MK + 2*VE when AR=MK=WK=PC=standardScore)",
      "afqtPercentile = clamp(lookupTable2_5(AFQTS), 1, 99)",
      "optional realism haircut: subtract ~7 points because practice tests are easier than the operational ASVAB"
    ],
    "caveat": "Approximation, not the official conversion. Guessing inflates low raw scores; practice items are usually easier than operational items; the official pipeline starts from IRT ability estimates, not percent-correct."
  },
  "unverified": [
    "Exact current nominal 4-subtest definitions for the nine non-GT Army composites as printed in DA PAM 611-21 (document not retrievable).",
    "Branch minimum AFQT scores and Tier I/II/III definitions against AR 601-210 text.",
    "Whether Service composites were officially revised after the 2002 removal of NO and CS (Technical Bulletin No. 4 fn 7 says such changes exist but are undocumented)."
  ]
}
```
