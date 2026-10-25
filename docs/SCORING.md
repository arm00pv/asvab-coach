# How the scoring works

This is the contract the scoring engine implements. If the code and this document
disagree, one of them is a bug.

## 1. Subtest standard scores

ASVAB subtest scores are reported on a scale with **mean 50 and standard
deviation 10**. The '97 scale is explicitly untruncated, so values are not forced
into 1-99 - that range belongs to the AFQT percentile, not to subtest scores.

A practice test cannot reproduce ETS item-response equating, so the engine takes
the documented approximation route:

```
p             = clamp(difficultyWeightedAccuracy, 0.005, 0.995)
standardScore = clamp(50 + 10 * PhiInverse(p), 1, 99)
```

Half right lands exactly on the national mean of 50; 90 percent accuracy lands
near 63. Answers are weighted by difficulty before conversion (easy 0.85, medium
1.0, hard 1.2).

**Small samples are shrunk toward 50.** A three-question diagnostic section
cannot support a confident estimate, so accuracy is pulled toward 0.5 by a
confidence factor `0.55 + 0.45 * min(1, answered / (expected * 0.6))`.

`PhiInverse` is Acklam's rational approximation, accurate to about 1.15e-9.

## 2. Verbal Expression (VE)

VE is **not** a raw `WK + PC` count. It is an optimally weighted composite with a
published weight ratio:

```
b_PC / b_WK = 0.61934
w_WK = 1 / (1 + 0.61934) = 0.6175
w_PC = 0.3825
```

The weighted pair is narrower than a single subtest, so it is rescaled back onto
the subtest scale (multiplied by ~1.1104) to restore SD 10. VE is reported on the
**subtest** scale (mean 50), not the line-score scale.

## 3. AFQT

```
AFQTS = AR + MK + 2 * VE        (composite mean 202, SD ~36 in PAY97)
```

The percentile is read from an empirical anchor table derived from the published
AFQT lookup (Segall 2004, Table 2.5) rather than a pure normal curve, because the
real distribution has heavier tails. Endpoints follow the published clamps:
`AFQTS <= 109 -> 1st percentile`, `AFQTS >= 269 -> 99th`.

Category bands (Segall Table 2.2):

| Band | AFQT |
| --- | --- |
| I | 93-99 |
| II | 65-92 |
| IIIA | 50-64 |
| IIIB | 31-49 |
| IVA | 21-30 |
| IVB | 16-20 |
| IVC | 10-15 |
| V | 1-9 |

The Army National Guard enlistment floor is **AFQT 31** (Category IIIB), which is
also the bottom of the lowest accepted test score category in AR 601-210.

> Note: AR 601-210 groups the IV band as 16-30 rather than splitting IVA/IVB/IVC.
> The app displays the ASVAB reporting bands because that is the AFQT's own
> scale, and documents the Army grouping in the Settings screen.

## 4. Line scores

All ten Army aptitude areas are reported on a scale with **mean 100 and standard
deviation 20** in the PAY97 youth reference population.

Only GT is a literal sum:

```
GT_S = VE + AR                      (mean 100.01, SD 18.62)
GT   = round(1.074292 * GT_S - 7.443781)
```

The 1.074292 slope is exactly `20 / 18.6169`: pure standard-deviation rescaling.
**GT 110 is therefore about +0.5 SD, roughly the 69th percentile - not one
standard deviation above average.** The app never narrates it as a full standard
deviation.

The other nine are regression-weighted composites over all seven reported
standard scores plus VE, with an intercept chosen so that every input at 50
yields exactly 100:

| Area | Nominal (textbook) definition | Operational weights |
| --- | --- | --- |
| ST | GS + VE + MK + MC | GS .12865, AR .49010, MK .47825, MC .31207, EI .14493, AS .21736, VE .62177, c -19.65219 |
| CL | VE + AR + MK | AR .75179, MK .58715, MC .11541, EI .07756, AS .07489, VE .67976, c -14.32772 |
| CO | VE + AR + AS + MC | GS .19868, AR .33090, MK .63397, MC .38486, EI .19979, AS .41161, VE .30347, c -23.17105 |
| EL | GS + AR + MK + EI | GS .08324, AR .44254, MK .49064, MC .26341, EI .30258, AS .36786, VE .49906, c -22.46667 |
| FA | AR + CS + MK + MC | GS .15031, AR .42263, MK .60172, MC .42966, EI .16389, AS .35866, VE .31958, c -22.32119 |
| GM | GS + AS + MK + EI | GS .23521, AR .46357, MK .45285, MC .29280, EI .30216, AS .50542, VE .21527, c -23.36174 |
| MM | NO + AS + MC + EI | GS .05942, AR .32829, MK .28517, MC .39607, EI .30796, AS .87309, VE .21150, c -23.08481 |
| OF | VE + NO + AS + MC | GS .14306, AR .53676, MK .34092, MC .36843, EI .19683, AS .50334, VE .36757, c -22.84882 |
| SC | VE + AR + AS + MC | GS .01235, AR .42812, MK .63650, MC .25070, EI .32194, AS .24636, VE .52770, c -21.18951 |

Two things to be explicit about:

1. The nominal definitions are *recognition* aids, not the arithmetic. The
   textbook forms reference subtests **NO** and **CS**, removed from the battery
   in 2002, so `MM = NO + AS + MC + EI` cannot be computed at all today.
2. Coefficients come from Segall (2004) Table 2.7. The DoD does not publish them
   on its public ASVAB site, which asterisks the nine composites as
   "non-integer weighted linear combinations". The values here reproduce a
   published third-party worked example exactly (GT 110, CO 101, ST 104, MM 98
   from GS 52 / AR 55 / VE 54 / MK 51 / EI 48 / AS 45 / MC 50), and
   `scoring_test.dart` asserts the all-50s -> 100 property for every area.

## 5. Skill mastery

Each question carries one to three skill tags. Mastery is shrunk toward 0.5 with
a Beta-style prior so a single correct answer does not read as 100 percent:

```
mastery = (correct + 2 * 0.5) / (total + 2)
```

## 6. Coaching priority

```
urgency = (1 - mastery) * subtestLeverage * 10 + flagRate * 1.5
```

`subtestLeverage` is 3.0 for AR, 2.6 for MK, 2.4 for WK, 2.2 for PC and 1.0 for
everything else, with extra weight on the verbal pair and AR when the officer
track is enabled. That ordering reflects the composite weights: AR and MK enter
the AFQT directly, the WK/PC pair enters it at double weight via VE, and
Assembling Objects moves no AFQT component at all.

## 7. Eligibility

An MOS gate is a list of OR alternatives, each a list of ANDed line-score
requirements. A gate with no published requirement (the audition-only band MOS)
is treated as open. `bestShortfall` is the smallest gap across alternatives, and
anything within 8 points is surfaced as a near miss with the arithmetic for
closing it.
