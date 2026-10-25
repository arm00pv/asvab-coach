# Army National Guard Enlistment & Officer Aptitude Requirements (ASVAB / Line Scores), 2025-2026

**Status:** research report, compiled 2026-10-24. **Scope:** Army National Guard (ARNG) and the Army-wide standards the ARNG inherits, since DA Pam 611-21 and AR 601-210 both apply "to the Regular Army, the Army National Guard/Army National Guard of the United States, and the U.S. Army Reserve, unless otherwise stated."

**Machine-readable companion:** `mos.json` (same directory). Every MOS entry there carries a `gate` array that is an OR-list of AND-lists, so it can be evaluated directly by code.

---

## 0. Source hierarchy and how to read the confidence labels

| Tier | Meaning | Examples used here |
|---|---|---|
| **A - primary/official** | Regulation or DoD site fetched and quoted in this session | AR 601-210 (20 Mar 2026); DA Pam 611-21 ch.10 sec.C (Smartbook, 2024 build); DA Pam 601-6 (21 Aug 2023); AR 611-110 (9 Aug 2023); goarmy.com; officialasvab.com; nationalguard.com; armyrotc.army.mil |
| **B - official but secondary/dated** | Official document whose edition is older than the current baseline | DA Pam 611-21 2024 build superseded in places by later effective dates; NGR 600-5 (2023) |
| **C - unverified** | Widely repeated, no primary source located | GED AFQT 50; SIFT 40; the exact integer formulas for CL/CO/EL/FA/GM/MM/OF/SC/ST; direct-commission ASVAB rules |

**Access note (important for reproducibility):** the Army's *MOS Smartbook* chapters live on api.army.mil, which returns HTTP 403 to non-browser clients. Section 10C was retrieved from the Internet Archive copy of the canonical URL
`https://api.army.mil/e2/c/downloads/2024/11/20/bf11d2d2/chapter-10c-enlisted-mos-specifications.pdf`
(snapshot 2025-07-09). The 20-page file served by armypubs.army.mil for ARN36922 is only the front matter of DA Pam 611-21 - it does **not** contain MOS data. Anyone re-verifying should pull the Smartbook section, not the pamphlet cover file.

---

## 1. ASVAB minimum requirements to enlist in the Army National Guard

### 1.1 The AFQT floor is 31

* **goarmy.com (official Army recruiting site), ASVAB page:** "your Armed Forces Qualification Test (AFQT) score determines your eligibility to join and **requires a score of at least 31 to enlist**."
* **AR 601-210 (20 March 2026), para 2-8d** defines the Test Score Categories used for enlistment in the RA, USAR and ARNG:

| TSC | AFQT percentile | Enlistment status |
|---|---|---|
| I | 93-99 | eligible |
| II | 65-92 | eligible |
| IIIA | 50-64 | eligible |
| IIIB | **31-49** | eligible - the effective floor |
| IVA | 16-30 | not accepted as a general rule (see note) |
| IVB | 10-15 | "not currently accepted (except 09L)" |
| V | 0-9 | "not eligible to enlist (except 09L)" |

**Discrepancy to flag:** officialasvab.com (DoD's own ASVAB site) publishes a *different* band set: I 93-99, II 65-92, IIIA 50-64, IIIB 31-49, **IVA 21-30, IVB 16-20, IVC 10-15**, V 1-9. Both are official and they do not reconcile. Cite the AR 601-210 version for Army enlistment questions and note the officialasvab variant.

### 1.2 The diploma / GED distinction - what is actually true in 2025-2026

This is the single most-repeated piece of folklore in ASVAB content, so it needs care:

* **Current rule (official).** AR 601-210 (20 Mar 2026) **para 3-5a**: "Applicant is eligible for enlistment if they are a GED holder or higher level of education credential." There is **no GED-specific AFQT number** in the current regulation.
* **Where the GED limit actually lives now.** Para 3-6a: an applicant must have a qualifying aptitude score for the MOS; "AFQT is not required for eligibility, if MOS qualified. If not MOS qualified, AFQT must fall within minimum acceptable **DoD quality mark standards for the annual accessions cohort**." In other words the education-tier constraint is expressed as a *cohort percentage cap*, not as an individual score a recruiter can quote.
* **Education tiers remain real.** AR 601-210 still sorts credentials into Tier 1 (HS diploma producing programs, including home school and NGYC+GED paths) and Tier 2 (test-based equivalency such as GED). The tier still affects training-pay category, incentive eligibility and accession accounting even when the AFQT floor is the same.
* **The "GED = 50" figure: UNVERIFIED / LEGACY.** I could not find AFQT 50 (or the ARNG variant 40) attached to GED holders in AR 601-210 as of 20 Mar 2026, nor in the 16 May 2005 edition I pulled for comparison (which simply says an applicant is eligible with a HSDG, a GED, or 15 college credits). Treat 50 as legacy recruiting practice, not current published policy, and never state it as an official ARNG minimum without a current source.
* **nationalguard.com** states eligibility as: 17-42 years old; U.S. citizen or permanent resident; "at least a junior in high school, or have a high school diploma or a GED certificate"; "Achieve a minimum score on the ASVAB test" - deliberately unspecific.

### 1.3 Age

* **goarmy.com requirements page:** "Be between 17 and 42 years old" (enlisted) and the FAQ adds: "The maximum age to join the Army as an enlisted Soldier is 42, while Officers must accept their commission before age 31."
* **nationalguard.com eligibility page:** "Be between the ages of 17 and 42."
* **AR 601-210 summary of change (20 Mar 2026):** "Increases the maximum enlistment age up to and including age 42 for non-prior service applicants" (and a parallel change for prior-service applicants, who may enter active duty after 42 under stated conditions). This is the codification of the 2024-2025 policy raise from 35 to 42.
* 17-year-olds enlist only with parental/guardian consent (statutory rule under 10 U.S.C. 505; not re-verified against the statute text in this session).

### 1.4 Waivers

* **Score waivers: none.** AR 601-210 para 2-8 opens: "**Waiver requests will not be considered if applicant does not meet requirements discussed in this paragraph (or administration of tests and retests).**" The way to fix a low AFQT is a retest (section 6.3), not a waiver.
* **MOS aptitude waivers: limited.** AR 601-210 para 9-10 and DA Pam 611-21 name specific non-waiverable scores, e.g. 51C Contracting NCO "**GT 110 (not waiverable)**"; 79R Recruiter allows a CG USAREC waiver to GT 100, or GT 95 with ST 95.
* **Medical, moral, dependency and age waivers** exist under AR 601-210 and AR 40-501. A denied waiver does not bar a civilian Army career path (goarmy.com FAQ).
* **Physical gate is separate and real.** Each MOS in DA Pam 611-21 sec. 10C also carries a physical demands rating, PULHES profile and an OPAT benchmark (e.g. 11B: OPAT at "Heavy (Black)" - long jump 0160 cm, seated power throw 0450 cm, strength deadlift 0160 lb, interval aerobic run 0043 shuttles). A qualifying ASVAB score alone does not qualify anyone.

---

## 2. Line scores ("aptitude areas") and what composes them

### 2.1 The honest headline

**DoD does not publish the exact formulas for nine of the Army's ten aptitude areas.** On officialasvab.com's Military Jobs page, the Army row lists ten composites but only **General Technical = AR + VE** is printed; the other nine rows carry asterisks, footnoted: "Computed as a **non-integer weighted linear combination of all ASVAB subtests** (GS, AR, WK, PC, MK, EI, AS, MC, and AO)."

So the truthful answer to "give the EXACT formula for every line score" is:

1. **GT = AR + VE** is official and exact.
2. **VE** is itself officially described as "a verbal composite formed from an optimally weighted composite of unrounded WK and PC standard scores" - so even VE is not literally WK + PC, though that sum is the standard approximation.
3. **CL, CO, EL, FA, GM, MM, OF, SC, ST** are officially *component-defined* on goarmy.com (which subtests drive them) but their integer weights are **not published**. Everything printed as a clean sum below is the widely taught approximation and is labelled UNVERIFIED.

The integer formulas below match the traditional recruiting/study-guide canon and are consistent with goarmy.com's component lists where they agree. Where they disagree with goarmy.com, goarmy.com wins for "which subtests drive this score," and the formula is marked UNVERIFIED.

### 2.2 Table of aptitude areas

| Code | Aptitude area | Officially published formula | Components (goarmy.com official) | Status of exact formula |
|---|---|---|---|---|
| **GT** | General Technical | **VE + AR** | VE, AR | **OFFICIAL** (officialasvab.com) |
| **CL** | Clerical | VE + AR + MK | VE, AR, MK | components official; weights UNVERIFIED |
| **CO** | Combat | VE + AS + MC (legacy tables print VE + AR + AS + MC) | VE, AS, MC | components official; weights UNVERIFIED |
| **EL** | Electronics | AR + EI + GS + MK | GS, AR, MK, EI | components official; weights UNVERIFIED |
| **FA** | Field Artillery | AR + MK + MC (legacy tables print AR + CS + MK + MC) | AR, MK, MC | components official; weights UNVERIFIED |
| **GM** | General Maintenance | GS + AS + MK + EI (legacy: AR + AS + MC + VE) | GS, AS, MK, EI | components official; weights UNVERIFIED |
| **MM** | Mechanical Maintenance | AS + MC + EI (legacy: AR + AS + MC + VE) | AS, MC, EI | components official; weights UNVERIFIED |
| **OF** | Operators / Food | VE + AS + MC | VE, AS, MC | components official; weights UNVERIFIED |
| **SC** | Surveillance & Communications | VE + AR + AS + MC | VE, AR, AS, MC | components official; weights UNVERIFIED |
| **ST** | Skilled Technical | GS + VE + MC + MK (legacy: VE + AR + MK + MC) | GS, VE, MC, MK | components official; weights UNVERIFIED |
| **VE** | Verbal Expression (input, not an area) | optimally weighted WK + PC | WK, PC | **OFFICIAL** definition |
| **AFQT** | Armed Forces Qualification Test | percentile of a composite of AR, MK, WK, PC (weights unpublished; "2VE + AR + MK" is widely quoted but UNVERIFIED) | AR, MK, WK, PC | definition official; weights UNVERIFIED |

### 2.3 Subtest abbreviations (2-digit official codes)

GS General Science | AR Arithmetic Reasoning | WK Word Knowledge | PC Paragraph Comprehension | MK Mathematics Knowledge | EI Electronics Information | AS Auto & Shop Information | MC Mechanical Comprehension | AO Assembling Objects | VE Verbal Expression (composite).

Two structural notes from officialasvab.com that change score interpretation:

* In the **paper-and-pencil** ASVAB, Auto Information (AI) and Shop Information (SI) are administered as one subtest (**AS**), and **AO is not administered at all**. Only the computer-adaptive form produces AO and separate AI/SI.
* **AFQT is a percentile**, normed on the 1997 national sample of 18-23 year-olds; subtest scores are **standard scores** with mean 50, SD 10. Line scores are therefore *sums of standard scores*, which is why ST 101 and GT 110 sit on a different scale than the 1-99 AFQT.

---

## 3. Army National Guard MOS aptitude requirements (DA Pam 611-21 sec. 10C)

The Army's real pattern is **one aptitude area with one minimum**, occasionally two areas ANDed, occasionally an "either/or" alternative pair. Below are 97 representative MOS, transcribed from **DA Pam 611-21, ch. 10, sec. C** entries (each entry is 10-XXX). "OR" separates alternative qualifying paths that the regulation itself offers; "+" means both are required.

| # | MOS | Title | Category | Aptitude gate (AND within a group, OR between groups) | Clearance | Extra test | Notes |
|---|---|---|---|---|---|---|---|
| 1 | **11B** | Infantryman | Combat Arms | CO 77 | No | - | - |
| 2 | **11C** | Indirect Fire Infantryman | Combat Arms | CO 77 | No | - | - |
| 3 | **12B** | Combat Engineer | Combat Arms | CO 82 | No | - | Score effective 9 Oct 2023 |
| 4 | **13B** | Cannon Crewmember | Combat Arms | GT 87 | Yes | - | GT 87 effective 202408; SECRET eligibility required to retain MOS at SGT+ |
| 5 | **13F** | Joint Fire Support Specialist | Combat Arms | GT 87 | Yes | - | GT 87 effective 202408 |
| 6 | **13J** | Fire Control Specialist | Combat Arms | GT 87 | Yes | - | GT 87 effective 202408 |
| 7 | **13M** | MLRS/HIMARS Crewmember | Combat Arms | GT 87 | Yes | - | GT 87 effective 202408 |
| 8 | **13R** | FA Weapons Locating Radar Specialist | Combat Arms | GT 87 | Yes | - | GT 87 effective 202408 |
| 9 | **19C** | Bradley Crewmember | Combat Arms | CO 77 | No | - | - |
| 10 | **19D** | Cavalry Scout | Combat Arms | CO 77 | No | - | - |
| 11 | **19K** | Armor Crewmember | Combat Arms | CO 77 | No | - | - |
| 12 | **18B** | Special Forces Weapons Sergeant | Special Operations | GT 110 + CO 100 | Yes | SFAS / SFQC | Accessed via the 18X enlistment option; MOS awarded after the SF qualification course |
| 13 | **18C** | Special Forces Engineer Sergeant | Special Operations | GT 110 + CO 100 | Yes | SFAS / SFQC | - |
| 14 | **18D** | Special Forces Medical Sergeant | Special Operations | GT 110 + CO 100 | Yes | SFAS / SFQC | - |
| 15 | **12D** | Diver | Combat Support (Engineer) | GM 98 + GT 107 | No | Y | - |
| 16 | **12G** | Quarrying Specialist (ARNG only) | Combat Support (Engineer) | GM 93 | No | - | National Guard-only MOS |
| 17 | **12K** | Plumber | Combat Support (Engineer) | GM 88 | No | - | - |
| 18 | **12M** | Firefighter | Combat Support (Engineer) | GM 88 | No | - | - |
| 19 | **12N** | Horizontal Construction Engineer | Combat Support (Engineer) | GM 85 | No | - | Score effective 9 Oct 2023 |
| 20 | **12P** | Prime Power Production Specialist | Combat Support (Engineer) | ST 107 + EL 107 + GT 110 | Yes | - | SECRET required for award and retention |
| 21 | **12R** | Interior Electrician | Combat Support (Engineer) | EL 93 | No | - | - |
| 22 | **12T** | Technical Engineer | Combat Support (Engineer) | ST 101 | No | - | - |
| 23 | **12W** | Carpentry and Masonry Specialist | Combat Support (Engineer) | GM 88 | No | - | - |
| 24 | **12Y** | Geospatial Engineer | Combat Support (Engineer) | ST 100 + GT 100 | Yes | - | TS/SCI required to be awarded and retain the MOS |
| 25 | **88H** | Cargo Specialist | Combat Service Support | GM 88 | No | - | - |
| 26 | **88K** | Watercraft Operator | Combat Service Support | MM 99 | No | - | - |
| 27 | **88L** | Watercraft Engineer | Combat Service Support | MM 99 | No | - | - |
| 28 | **88M** | Motor Transport Operator | Combat Service Support | OF 85 | No | - | - |
| 29 | **88N** | Transportation Management Coordinator | Combat Service Support | CL 95 | Yes | - | - |
| 30 | **89B** | Ammunition Specialist | Combat Service Support | ST 91 | No | N | - |
| 31 | **89D** | Explosive Ordnance Disposal Specialist | Combat Service Support | GM 105 | Yes | EOD Specialist Course (NAVSCOLEOD) | Final TOP SECRET eligibility required for MOS award |
| 32 | **92A** | Automated Logistical Specialist | Combat Service Support | CL 90 | Yes | - | - |
| 33 | **92F** | Petroleum Supply Specialist | Combat Service Support | CL 86 + OF 85 | Yes | - | - |
| 34 | **92G** | Culinary Specialist | Combat Service Support | OF 85 | Yes | - | - |
| 35 | **92L** | Petroleum Laboratory Specialist | Combat Service Support | ST 91 | No | - | - |
| 36 | **92M** | Fatality Management Specialist | Combat Service Support | GM 84 | Yes | - | Score effective 9 Oct 2023 |
| 37 | **92R** | Parachute Rigger | Combat Service Support | GM 78 + CO 77 | Yes | - | - |
| 38 | **92S** | Shower and Laundry Specialist | Combat Service Support | GM 84 | Yes | - | - |
| 39 | **92W** | Water Treatment Specialist | Combat Service Support | GM 88 | No | - | - |
| 40 | **92Y** | Unit Supply Specialist | Combat Service Support | CL 90 | Yes | - | - |
| 41 | **74D** | CBRN Specialist | Combat Service Support | ST 100 | Yes | - | - |
| 42 | **36B** | Financial Management Technician | Combat Service Support | CL 101 | Yes | - | - |
| 43 | **42A** | Human Resources Specialist | Combat Service Support | CL 90 | Yes | - | - |
| 44 | **51C** | Contracting NCO | Combat Service Support | GT 110 | Yes | - | GT 110 expressly NOT waiverable |
| 45 | **91B** | Wheeled Vehicle Mechanic | Mechanical Maintenance | MM 92 | No | N | - |
| 46 | **91E** | Allied Trades Specialist | Mechanical Maintenance | GM 88 + GT 95 | No | N | - |
| 47 | **91S** | Stryker Systems Maintainer | Mechanical Maintenance | MM 87 + GT 85 | No | N | - |
| 48 | **94E** | Radio Equipment Repairer | Mechanical Maintenance | EL 102 | No | Y | - |
| 49 | **68A** | Biomedical Equipment Specialist | Medical | EL 107 | Yes | - | - |
| 50 | **68C** | Practical Nursing Specialist | Medical | ST 101 | No | NCLEX-PN licensure required | Score effective 9 Oct 2023 |
| 51 | **68E** | Dental Specialist | Medical | ST 91 | Yes | - | - |
| 52 | **68G** | Patient Administration Specialist | Medical | CL 90 | Yes | - | - |
| 53 | **68J** | Medical Logistics Specialist | Medical | CL 90 | Yes | - | - |
| 54 | **68K** | Medical Laboratory Specialist | Medical | ST 106 | No | - | - |
| 55 | **68P** | Radiology Specialist | Medical | ST 101 | No | - | Score effective 9 Oct 2023 |
| 56 | **68S** | Preventive Medicine Specialist | Medical | ST 98 | No | - | Score effective 9 Oct 2023 |
| 57 | **68T** | Animal Care Specialist | Medical | ST 91 | Yes | - | - |
| 58 | **68V** | Respiratory Specialist | Medical | ST 102 | Yes | - | - |
| 59 | **68W** | Combat Medic Specialist | Medical | ST 101 | No | - | Score effective 9 Oct 2023; the pre-2023 figure of ST 107 is obsolete |
| 60 | **68X** | Behavioral Health Specialist | Medical | ST 101 | Yes | - | - |
| 61 | **17C** | Cyber Operations Specialist | Cyber & EW | GT 110 + ST 112 | Yes | TS/SCI with CI-scope polygraph | - |
| 62 | **17E** | Electronic Warfare Specialist | Cyber & EW | SC 105 + ST 105 + EL 105 | Yes | - | - |
| 63 | **25B** | Information Technology Specialist | Intelligence & Signal | ST 95 | Yes | - | - |
| 64 | **25D** | Cyber Network Defender | Cyber & EW | GT 105 + ST 105 | Yes | - | In-service only (SSG+ with verified IA/IT experience) |
| 65 | **25E** | Electromagnetic Spectrum Manager | Cyber & EW | GT 105 + EL 105 | Yes | - | - |
| 66 | **25H** | Network Communication Systems Specialist | Intelligence & Signal | EL 100 + ST 102 | Yes | - | Effective 202510; successor for legacy 25L/25N/25Q/25S |
| 67 | **25U** | Signal Operations Support Specialist | Intelligence & Signal | EL 95 + SC 95 | Yes | - | - |
| 68 | **35F** | Intelligence Analyst | Intelligence & Signal | ST 101 | Yes | - | 101 applies to ASVAB taken on/after 1 Jul 2004 (105 before 2 Jan 2002; 102 for 2002-2004 tests) |
| 69 | **35G** | Geospatial Intelligence Imagery Analyst | Intelligence & Signal | ST 101 | Yes | - | Same date-tiered schedule as 35F |
| 70 | **35L** | Counterintelligence Agent | Intelligence & Signal | ST 101 | Yes | - | - |
| 71 | **35M** | Human Intelligence Collector | Intelligence & Signal | ST 101 | Yes | DLAB (or DLPT/OPI proficiency) | - |
| 72 | **35N** | Signals Intelligence Analyst | Intelligence & Signal | ST 112 | Yes | - | - |
| 73 | **35P** | Signals Intelligence Voice Interceptor | Intelligence & Signal | ST 101 | Yes | DLAB; TS/SCI with CI-scope polygraph | ST 91 for ACASP applicants with Strategic Language List proficiency |
| 74 | **35S** | Signals Acquisition/Exploitation Analyst | Intelligence & Signal | ST 101 | Yes | - | - |
| 75 | **35T** | MI Systems Maintainer/Integrator | Intelligence & Signal | ST 112 | Yes | - | - |
| 76 | **15B** | Aircraft Powerplant Repairer | Aviation | MM 104 | No | - | - |
| 77 | **15E** | RQ-7 Repairer | Aviation | EL 93 + MM 104 | Yes | - | - |
| 78 | **15F** | Aircraft Electrician | Aviation | MM 104 | No | - | - |
| 79 | **15N** | Avionic Mechanic | Aviation | EL 93 | Yes | - | - |
| 80 | **15P** | Aviation Operations Specialist | Aviation | ST 91 | Yes | - | - |
| 81 | **15Q** | Air Traffic Control Operator | Aviation | ST 101 | Yes | ATC physical / FAA-class medical | - |
| 82 | **15R** | AH-64 Attack Helicopter Repairer | Aviation | MM 99 | No | - | - |
| 83 | **15T** | UH-60 Helicopter Repairer/Aircrew Member | Aviation | MM 104 | No | Class III flight physical (aircrew) | - |
| 84 | **15U** | CH-47 Helicopter Repairer/Aircrew Member | Aviation | MM 104 | No | Class III flight physical (aircrew) | - |
| 85 | **15W** | RQ-7 Operator | Aviation | SC 102 | Yes | - | - |
| 86 | **27D** | Paralegal Specialist | Legal | CL 105 | Yes | - | - |
| 87 | **31B** | Military Police | Military Police | ST 91 | Yes | - | - |
| 88 | **31D** | CID Special Agent | Military Police | GT 110 | Yes | - | In-service selection |
| 89 | **31E** | Corrections and Detention Specialist | Military Police | ST 91 | Yes | - | Score effective 9 Oct 2023 |
| 90 | **37F** | Psychological Operations Specialist | Special Operations | GT 105 | Yes | - | - |
| 91 | **38B** | Civil Affairs Specialist | Special Operations | GT 107 | Yes | - | - |
| 92 | **42R** | Musician | Band | **none published** | No | Instrument audition (ACASP) | No aptitude-area (line-score) requirement published; qualification is by audition |
| 93 | **42S** | Special Band Musician | Band | **none published** | No | Instrument audition | No line-score requirement; must be acceptable to the special band commander |
| 94 | **46S** | Public Affairs Mass Communication Specialist | Public Affairs | GT 105 | Yes | - | Score effective 9 Oct 2023; primarily an ARNG/USAR accession MOS |
| 95 | **46V** | Visual Information Specialist | Public Affairs | EL 93 + ST 91 | Yes | - | - |
| 96 | **56M** | Religious Affairs Specialist | Religious | CL 90 | Yes | - | - |
| 97 | **79R** | Recruiter | Recruiting | GT 110 | Yes | - | Waiver to GT 100 by CG USAREC, or GT 95 with ST 95 |

### 3.1 Reading the gates correctly

* **11B Infantryman is CO 77**, not CO 87 or CO 90 - older study guides still print the pre-2023 figures. The same 77 applies to 11C, 19C, 19D, 19K.
* **The 13-series moved off FA onto GT.** 13B, 13F, 13J, 13M and 13R now require **GT 87 (effective 202408)**. This is why "Field Artillery (FA)" is still a defined aptitude area but no longer gates any enlistment MOS.
* **Date-tiered scores are real.** 35F and 35G carry three thresholds keyed to ASVAB test date (105 before 2 Jan 2002; 102 for 2 Jan 2002 - 1 Jul 2004; **101 on/after 1 Jul 2004**). Only the latest tier matters for new accessions, but a prior-service applicant with an old test can legally hold a different threshold.
* **Alternatives are genuine alternatives.** 91B Wheeled Vehicle Mechanic: **MM 92** *or* **MM 87 + GT 85**. 89B Ammunition Specialist: **ST 91** *or* **ST 86 + GT 85**. 94E: **EL 102** *or* **EL 97 + ST 90**. A single-score gate of 92 is not the same test as 87+85, and coaches should teach to the OR branch the applicant can actually hit.
* **Security clearances:** almost every intelligence, signal, medical-clinical, MP and supply MOS requires SECRET or TS/SCI eligibility *at award or shortly after* (e.g. 12P allows 12 months after graduation to obtain SECRET; 35M/35P require an **interim TS/SCI** at award and fully adjudicated TS/SCI within 12 months). Clearance eligibility is a **separate gate** from the line score and can end an otherwise qualified enlistment.
* **Additional tests:** **DLAB** for 35M and 35P (35M explicitly points at DA Pam 11-8 for the current minimum; 35P also requires a CI-scope polygraph). **SIFT** is not an enlisted test at all - it is the aviation-selection instrument for officers/WOFT candidates (section 4). 42R/42S Musician require an **audition**, not a line score.
* **No published line score:** 42R Musician and 42S Special Band Musician have no aptitude-area gate in sec. 10C; qualification is by audition and, for 42S, acceptability to the special band commander.

### 3.2 MOS codes from the request that no longer exist

Verified by searching the full sec. 10C text:

* **25S, 25N, 25Q, 25L** - not present. The 25-series in the current table is 25B, 25D, 25E, 25H, 25U, 25X, 25Z. **25H Network Communication Systems Specialist** carries an explicit "(Effective 202510)" marker and is the successor specialty for the legacy nodal/satellite/multichannel/cable families (**EL 100 + ST 102**).
* **21B** - zero occurrences in sec. 10C. Combat engineer work is **12B** (CO 82).
* **13M / 13R** - do still exist (both GT 87), but they are easy to miss because their section headers wrap differently in the PDF.
* **18X** - zero occurrences in sec. 10C. 18X is an **enlistment option**, not an awardable MOS: the Soldier ships to SFAS and later receives 18B/18C/18D. The GT/CO gates above are the post-SFQC MOS gates; the 18X option's own gate is set in the accession options criteria and was **not verified** here.
* **09S / 09W** - accession codes, not aptitude areas (section 4.9).

---

## 4. Officer and warrant officer pathways

### 4.1 The anchor fact: GT 110

**AR 601-210 (20 March 2026), para 9-10, Enlistment Program 9D (U.S. Army Officer/Warrant Officer Enlistment Program):** "If enlisting for OCS, applicant must have received a baccalaureate or higher degree. If enlisting for WOFT, applicant must be a high school graduate or equivalent. ... **OCS and WOFT applicants must have a general technical score of 110 or greater.** Members of the DEP or DTP may not process for OCS or WOFT. **For ARNG, OCS/WOCS enlistment program options are listed in the Accession Options Criteria (AOC).**"

Your working assumption of **GT 110 is correct** for OCS. It is also correct for warrant officer and for Green to Gold - and for the warrant officer path it is expressly **non-waiverable**.

### 4.2 OCS (federal)

GT 110; bachelor's degree; U.S. citizen; age 19 to under 33 at shipment to training with commissioning before 34 (waivers considered); Secret clearance eligibility; **not more than 10 cumulative years of active federal service at appointment**; commissioning physical to AR 40-501 and AR 600-9 body composition.

*Caution:* the goarmy.com OCS page (current build) lists only five bullets - citizen, 19-32, Secret-eligible, bachelor's by commission, "**no more than six years of active service** for current military members" - and **does not print GT 110 at all**. The 6-year versus 10-year difference is a genuine source disagreement; the regulation (10 years) should govern, and the goarmy bullet set is best read as a simplified summary.

### 4.3 ARNG OCS

ARNG Soldiers have two routes besides federal OCS, per goarmy.com: **State OCS** (weekends, 16-18 months) and **National Guard Bureau Accelerated OCS** (8 weeks). GT 110 flows from Program 9D/the AOC; state programs may run their own board and waiver process, so the number to quote is 110 with "confirm State AOC."

### 4.4 Army ROTC

ROTC does **not** gate commissioning on a GT score. The gate that does exist is on the **ROTC/SMP enlistment option** in AR 601-210: non-scholarship applicants need SAT 850, ACT 19 or PSAT 85, and - where those are unavailable or unmet - "recruiting brigade commanders may approve waivers ... in cases where applicant **achieved a general technical score of 110 or higher**. All applicants must have an ASVAB score of record to enlist." So GT 110 is the Army's *fallback* validation for ROTC enlistment, not the primary instrument.

### 4.5 West Point

No ASVAB/GT requirement located. USMA accessions run on SAT/ACT, academic record, medical/physical aptitude and a Congressional nomination; goarmy.com notes commissioning from West Point must occur before age 27. Treat "ASVAB required for West Point" as **false** unless a primary source says otherwise.

### 4.6 Direct commission (JAG, Chaplain, AMEDD)

**UNVERIFIED.** No ASVAB/GT gate appears anywhere in AR 601-210 for direct-commission professional programs; those are governed by their own branch authorities and substitute professional credentialing (bar admission; MD/DO licensure; ecclesiastical endorsement for chaplains). I deliberately do not publish a number here.

### 4.7 Warrant officer (WOCS)

**DA Pam 601-6 (21 August 2023)** is unambiguous:

* Para 2-3a(3): "Applicants must achieve a **GT score of 110 or higher**."
* Para 2-2e: "The requirements for a minimum general technical (GT) aptitude area score of **110**, a high school diploma or general education diploma (GED), and possession of a **secret security clearance are not waiverable**."
* Also required: interim Secret to apply and completed Secret to attend WOCS; U.S. citizen or LPR; AFT within 6 months; AR 600-9; the specific WO MOS prerequisites from DA Pam 611-21 ch. 8 (proponent waivers case by case); service-length goals (8 years ideal; 12-year active cap, 8 for 153A).

### 4.8 WOFT / street-to-seat (aviation)

Two gates stack:

1. **GT 110** via AR 601-210 para 9-10.
2. **SIFT** via **AR 611-110 (9 August 2023) para 2-1c**: "Achieve at least the minimum score required on the Selection Instrument for Flight Training (SIFT) test before selection for the Initial-Entry Rotary Wing (IERW) Program. **Once attaining a qualifying score, the applicant cannot retest.** An applicant failing to attain a minimum qualifying score on the first attempt is authorized a SIFT retest. The second test must be no sooner than the **46th day** following the first test."
3. Plus: age over 18 and not yet 33 at board selection; at most 8 years active federal service at DA Form 61 signature; Class 1A flight duty medical exam, which cannot even be requested until SIFT is passed.

**AR 611-110 never prints the numeric SIFT minimum.** The figure 40 is ubiquitous online but I could not confirm it in a primary source in this session - label it **UNVERIFIED** and re-check the current USAREC warrant officer recruiting page or the SIFT information pamphlet before quoting it.

### 4.9 Green to Gold

**Army ROTC Green to Gold Active Duty Option Handbook 2026-2027**, requirement 13: "**GT Score. Must have a score of 110 or higher on the General Technical (GT) Aptitude Area** ..." The score must appear on the Soldier Talent Profile (an Education Center ASVAB score sheet is acceptable as the source document, with PII redacted). So **Green to Gold = GT 110**, the same bar as OCS and WOCS.

### 4.10 Officer candidate vs warrant officer: the actual ASVAB difference

| | OCS (09S) | WOCS | WOFT (09W) |
|---|---|---|---|
| GT | **110** | **110** | **110** |
| Waivable? | Yes, in practice via the accession-option/AOC process | **No** (DA Pam 601-6 para 2-2e) | Not for GT; SIFT retest is the only second chance |
| Underlying enlistment AFQT | 31 (Program 9D enlistment) | 31 | 31 |
| Education | Bachelor's | HS diploma or GED | HS diploma or GED |
| Clearance | Secret eligibility | Interim Secret to apply / Secret to attend | Secret + Class 1A flight physical |
| Extra test | None | None | **SIFT** (one retest, 46-day wait) |
| Other hard gates | 10 yrs AFS cap; commission before 34 | 12-yr active cap (8 for 153A); MOS prerequisites | Under 33 at board; 8 yrs AFS; SIFT before FDME |

Note what is *not* different: nobody gates officer accession on AFQT beyond the 31 enlistment floor, and nobody gates it on ST or CO. **GT is the officer currency.**

---

## 5. Civilian technician and full-time support roles

ARNG full-time support comes in three flavours: **AGR** (Active Guard/Reserve, Title 32 orders), **Military Technician** (dual-status federal civilian, Title 5, membership in the ARNG a condition of employment), and **ADOS** (Active Duty Operational Support tours).

* **There is no separate ASVAB gate for the technician or AGR job itself.** Both require you to already hold the military grade and MOS the position is coded for, so the ASVAB requirement is satisfied indirectly: you cannot be MOS-qualified without meeting that MOS's line score (section 3).
* **AR 601-210** addresses technician enlistments directly (USAR technician program language, and repeated prohibitions on enlisting *solely* to qualify for a technician position): "Persons currently employed, or who seek employment in the USAR Technician Program, may be enlisted for assignment to a unit vacancy. They must otherwise qualify and be authorized by the commander to which the technician will be assigned. If applicant has no prior military service, then enlistment requires prior receipt of a confirmed training space for entry on IADT." AGR/MilTech service is likewise excluded from several enlistment-incentive and reenlistment-bonus provisions.
* **AGR program rules** live in **NGR 600-5** (National Guard Regulation, AGR/FTNGD management). The 2023 edition could not be fetched (ngbpmc.ng.mil returned 403); the 2015 edition is mirrored at state sites. **UNVERIFIED** whether NGR 600-5 adds any aptitude requirement beyond MOS qualification - it historically does not.
* **Practical consequence for coaching:** a Guard member chasing a technician/AGR slot needs the *MOS* line score, not a distinct technician score. The higher-leverage targets are therefore the ones that unlock full-time-coded specialties: 25B/25H/25U (signal), 35-series (intel), 15-series (aviation maintenance), 68-series (medical), 88M/88N/92A/92Y (logistics), 42A (HR).
* **Officer candidate vs warrant officer for full-time slots:** a Warrant Officer appointment (GT 110, non-waivable) is frequently the *cheaper* full-time route for an enlisted technician than OCS, because WOCS needs no bachelor's degree - but the GT 110 is the same wall either way.

---

## 6. 2024-2026 changes to the ASVAB program

### 6.1 PiCAT - the unproctored CAT-ASVAB

From officialasvab.com's recruiter page ("Unproctored Administration of the ASVAB: PiCAT"):

* PiCAT = the unproctored version of the CAT-ASVAB. **Note the official expansion: "Pending Internet Computerized Adaptive Test"** - not "Pre-screening internet Computer Adaptive Test," which is the commonly repeated but unofficial gloss.
* Taken anywhere with internet; **no per-subtest time limits**; typically 2-3 hours total.
* Requires a recruiter-issued **access code that expires in 30 days**; once started the test must be **completed within 48 hours**.
* **Available only to applicants who have never taken the ASVAB, and only once.**
* "Once an applicant's PiCAT score is verified, it becomes the ASVAB score of record."
* **Verification Test (Vtest):** if the PiCAT score suggests eligibility, the applicant must report to a MEPS or MET site for a proctored Vtest "within **45 days**" of the PiCAT. It takes 25-30 minutes, yields **no score of its own**, and exists purely to validate that the unproctored performance was consistent. If the Vtest is successful, the PiCAT scores become the official scores of record for enlistment eligibility.
* Recruiters, not applicants, see PiCAT results.

### 6.2 The paper-and-pencil ASVAB is *not* dead (as of Oct 2026)

The DoD **ASVAB Fact Sheet** page, updated **2026-10-06**, still says: "The ASVAB is administered **by computer at all MEPS, and by paper and pencil at most MET sites**. Regardless of whether you take the ASVAB by computer or paper and pencil, your scores should be very similar."

So the widely circulated claim that paper ASVAB has been retired is **not supported**. What *is* true is the structural difference: paper omits AO and merges AI/SI into AS (section 2.3) - which means a paper test-taker has no Assembling Objects score at all.

### 6.3 Retest policy (official)

* One month between the initial test and a first retest; one month between first and second retest; **six months between any later retests**.
* A **"Critical AFQT Gain"** (gain of 20+ percentile points within 6 months) triggers a mandatory **Confirmation Test (C-Test)**, which may be taken immediately with no one-month wait.
* **Cheating** invalidations force a **six-month** wait.
* Administrative invalidations do not consume a test.
* goarmy.com adds the operational rule recruits care about: "your **most recent score - not your highest** - will be used."
* No current regulation I fetched imposes a *fixed expiry* on ASVAB scores for new accessions. AR 601-210 para 3-6b actually says the most recent DMDC results "may be used regardless of test date, provided all line scores are present" (in the prior-service context). The familiar "ASVAB scores are valid for two years" claim is **UNVERIFIED** against current text.

### 6.4 ASVAB Career Exploration Program (CEP)

* The ASVAB is offered to high school and post-secondary students through the **ASVAB Career Exploration Program**, free to schools; it is the same battery used for career exploration.
* **CEP/SST scores can be used for enlistment**, but with a catch: "**If you took the ASVAB through School Staff Testing (SST, which means school staff administered the test rather than military personnel), a Verification Test (Vtest) is required before your scores can be used for enlistment.**"
* So the CEP is not a separate, easier test - it is the ASVAB in a school setting, and the Vtest is the bridge to the enlistment use.

### 6.5 Is the ASVAB being replaced? Any "MET/PSAT-style" change?

* **No evidence of replacement.** Nothing on officialasvab.com, in AR 601-210 (Mar 2026), or in DA Pam 611-21 indicates the ASVAB is being retired or superseded. The battery, its ten subtests (nine on paper) and the 1997 norming sample are all intact.
* **"MET" is a testing site, not a test.** A **MET site** = Military Entrance Test site, a satellite location where the ASVAB is given (mostly on paper). It is not a new exam format. Confusing "MET" with a new test is a recurring error in secondary sources.
* **Adaptive format:** the CAT-ASVAB (and PiCAT) are computer-adaptive; that adaptivity is decades old and is not a 2024-2026 "PSAT-style" redesign. There is no PSAT-style scoring change; AFQT remains a 1-99 percentile.
* **AO status:** Assembling Objects exists only on the computer-adaptive form. No official announcement retiring AO from the CAT was found. Claims that AO "has been dropped" appear to be paper-format artefacts.

### 6.6 Regulatory changes that did happen (2024-2026), verified

| Change | Effective | Source |
|---|---|---|
| AR 601-210 rewritten; supersedes the 8 Nov 2023 edition; max enlistment age 42 codified for NPS and PS | Published 20 Mar 2026, effective 20 Apr 2026 | AR 601-210 (20 Mar 2026), summary of change |
| GED/Tier 2 education language simplified to "GED holder or higher level of education credential" | Same edition | AR 601-210 para 3-5a |
| Batch of MOS aptitude changes dated 9 Oct 2023 (68W ST 101, 68C ST 101, 68P ST 101, 12B CO 82, 12N GM 85, 31E ST 91, 46S GT 105, 92M GM 84, etc.) | 9 Oct 2023 | DA Pam 611-21 sec. 10C entries |
| 13-series (13B/13F/13J/13M/13R) re-gated to **GT 87**, off FA | 202408 | DA Pam 611-21 sec. 10C |
| 89B and 94E rewritten scores | 202406 | sec. 10C |
| **25H** Network Communication Systems Specialist introduced (legacy 25L/25N/25Q/25S families) | 202510 | sec. 10C, section 25H |
| 92A entry re-issued | 202610 | sec. 10C (appears twice: older and 202610 versions, both CL 90) |
| PiCAT Vtest window tightened to 45 days; retest/C-test policy published | Page refreshed 2024-11 / 2025 | officialasvab.com |

---

## 7. Discrepancies, dead ends and things not to assert

1. **GED AFQT 50** - not found in current (2026) or 2005 AR 601-210. Do not publish as official.
2. **SIFT 40** - not printed in AR 611-110. Find the SIFT information pamphlet or USAREC WO recruiting page before quoting.
3. **Officer "6 years vs 10 years" active service** - goarmy.com says six; AR 601-210 says ten cumulative years of AFS at appointment.
4. **AFQT band boundaries** - AR 601-210 (IVA 16-30) vs officialasvab.com (IVA 21-30, IVB 16-20, IVC 10-15).
5. **11B CO 77** vs the older folklore of CO 87/90; **68W ST 101** vs the older ST 107. The regulation is current as of the 2024 Smartbook build; re-check before hard-coding.
6. **Exact CL/CO/EL/FA/GM/MM/OF/SC/ST formulas** - not published by DoD. Any site presenting them as authoritative is inferring.
7. **Direct commission ASVAB rules** - no source located; do not invent.
8. **ASVAB 2-year validity** - not in current text.
9. **18X GT gate** - 18X is not in sec. 10C; its accession gate was not verified.
10. **"Paper ASVAB retired"** - contradicted by the Oct 2026 DoD fact sheet.

---

## 8. Machine-readable data

The JSON block below is duplicated verbatim in `mos.json`. The `gate` field is an OR-list of AND-lists: `[[{"score":"GT","min":110},{"score":"CO","min":100}]]` means GT 110 **and** CO 100; `[[{"score":"ST","min":91}],[{"score":"ST","min":86},{"score":"GT","min":85}]]` means ST 91 **or** (ST 86 and GT 85). An empty array means no published line-score gate.

```json
{
  "enlistment": {
    "afqtMinimumDiploma": 31,
    "afqtMinimumGed": null,
    "ageMin": 17,
    "ageMaxNoPriorService": 42,
    "notes": [
      "AFQT 31 is stated on goarmy.com ('requires a score of at least 31 to enlist') and matches the lowest accepted Test Score Category in AR 601-210 para 2-8d (TSC IIIB = AFQT 31-49).",
      "afqtMinimumGed is null / no separate floor: current AR 601-210 (20 Mar 2026) para 3-5a says 'Applicant is eligible for enlistment if they are a GED holder or higher level of education credential.' The long-circulated GED figure of 50 (and the ARNG variant of 40) does NOT appear in the 20 Mar 2026 regulation nor in the 16 May 2005 edition - treat it as LEGACY and UNVERIFIED for 2025-2026.",
      "AR 601-210 para 3-6a: if the applicant is not MOS qualified, the AFQT 'must fall within minimum acceptable DoD quality mark standards for the annual accessions cohort' - i.e. the GED limitation is now a cohort quality-mark/percentage cap, not a published individual score floor.",
      "Age: goarmy.com 'between 17 and 42'; nationalguard.com 'between the ages of 17 and 42'. AR 601-210 summary of change: 'Increases the maximum enlistment age up to and including age 42 for non-prior service applicants.' Prior-service applicants may also enter active duty after 42 under stated conditions.",
      "Test-score waivers do not exist: AR 601-210 para 2-8 opening - 'Waiver requests will not be considered if applicant does not meet requirements discussed in this paragraph (or administration of tests and retests).' Medical, moral, dependency and age waivers are separate and do exist.",
      "TSC bands per AR 601-210 para 2-8d: I 93-99; II 65-92; IIIA 50-64; IIIB 31-49; IVA 16-30; IVB 10-15 (not accepted, except 09L); V 0-9 (ineligible, except 09L). officialasvab.com publishes different bands (IVA 21-30, IVB 16-20, IVC 10-15) - a real, unresolved source disagreement.",
      "All applicants must have ASVAB scores to enlist; the MOS aptitude-area requirement is waived only for prior-service enlistees returning to their former MOS (AR 601-210 para 3-6b/c).",
      "Physical: each MOS in DA Pam 611-21 sec. 10C also carries a physical demands rating, a PULHES profile and an OPAT standard (e.g. 11B requires OPAT at the 'Heavy (Black)' demand category). ASVAB scores alone do not qualify an applicant."
    ]
  },
  "lineScores": [
    {
      "code": "GT",
      "name": "General Technical",
      "formula": "VE + AR",
      "components": [
        "WK",
        "PC",
        "AR"
      ],
      "description": "The only Army composite whose exact formula DoD publishes. Gates OCS/WOCS/WOFT entry (110), 13-series (87), SF 18-series (110), 17C/25D/25E, 51C, 79R, 31D, 12P.",
      "status": "official"
    },
    {
      "code": "CL",
      "name": "Clerical",
      "formula": "VE + AR + MK (widely published form; DoD does not publish Army composite weights)",
      "components": [
        "WK",
        "PC",
        "AR",
        "MK"
      ],
      "description": "goarmy.com lists VE, AR and MK as the drivers. Gates 42A and 56M (90), 36B (101), 27D (105).",
      "status": "components official / formula unofficial"
    },
    {
      "code": "CO",
      "name": "Combat",
      "formula": "VE + AS + MC (goarmy.com component list); older third-party tables print VE + AR + AS + MC",
      "components": [
        "WK",
        "PC",
        "AS",
        "MC"
      ],
      "description": "Gates 11B/11C/19C/19D/19K (77), 12B (82), 92R, and the CO 100 half of the SF 18-series gate. The addition of AR found in many study guides is UNVERIFIED.",
      "status": "components official / formula unofficial"
    },
    {
      "code": "EL",
      "name": "Electronics",
      "formula": "AR + EI + GS + MK",
      "components": [
        "AR",
        "EI",
        "GS",
        "MK"
      ],
      "description": "Gates 12R (93), 15N (93), 68A (107), 94E (102), 12P (107), 17E (105), 25E/25H.",
      "status": "components official / formula unofficial"
    },
    {
      "code": "FA",
      "name": "Field Artillery",
      "formula": "AR + MK + MC (goarmy.com components); legacy tables print AR + CS + MK + MC",
      "components": [
        "AR",
        "MK",
        "MC"
      ],
      "description": "Still a valid aptitude area but no current enlistment MOS in the 2024-2026 tables gates on FA: the 13-series moved to GT 87 effective 202408.",
      "status": "components official / formula unofficial"
    },
    {
      "code": "GM",
      "name": "General Maintenance",
      "formula": "GS + AS + MK + EI (goarmy.com components); legacy tables print AR + AS + MC + VE",
      "components": [
        "GS",
        "AS",
        "MK",
        "EI"
      ],
      "description": "Heavy use across engineering and logistics: 12N (85), 12K/12M/12W/92W/88H (88), 12G (93), 89D (105), 92R (78), 91E.",
      "status": "components official / formula unofficial"
    },
    {
      "code": "MM",
      "name": "Mechanical Maintenance",
      "formula": "AS + MC + EI (goarmy.com components); legacy tables print AR + AS + MC + VE",
      "components": [
        "AS",
        "MC",
        "EI"
      ],
      "description": "Aviation maintenance home area: 15T/15U/15B/15F (104), 15R (99), 88K/88L (99), 91B/91S.",
      "status": "components official / formula unofficial"
    },
    {
      "code": "OF",
      "name": "Operators / Food",
      "formula": "VE + AS + MC",
      "components": [
        "WK",
        "PC",
        "AS",
        "MC"
      ],
      "description": "Gates 88M (85), 92G (85), 92F (85 with CL 86), and air-defense 14P/14S.",
      "status": "components official / formula unofficial"
    },
    {
      "code": "SC",
      "name": "Surveillance & Communications",
      "formula": "VE + AR + AS + MC",
      "components": [
        "WK",
        "PC",
        "AR",
        "AS",
        "MC"
      ],
      "description": "Gates 15W/15C (102), 25U (95 with EL 95), 17E (105 with ST and EL 105).",
      "status": "components official / formula unofficial"
    },
    {
      "code": "ST",
      "name": "Skilled Technical",
      "formula": "GS + VE + MC + MK (goarmy.com components); legacy tables print VE + AR + MK + MC",
      "components": [
        "GS",
        "WK",
        "PC",
        "MC",
        "MK"
      ],
      "description": "The single most common gate in 2024-2026: 35F/35G/35L/35M/35P/35S/89B/31B/31E/68E/68T (91-101), 68W/68C/68P/68X (101), 35N/35T (112), 17C (112), 25B (95).",
      "status": "components official / formula unofficial"
    },
    {
      "code": "VE",
      "name": "Verbal Expression (composite input, not an aptitude area)",
      "formula": "optimally weighted composite of unrounded WK and PC standard scores (official description); plain WK + PC is the usual approximation",
      "components": [
        "WK",
        "PC"
      ],
      "description": "Not gated on by any MOS; it is the verbal block inside GT/CL/CO/OF/SC/ST. officialasvab.com footnote: 'VE is a verbal composite formed from an optimally weighted composite of unrounded WK and PC standard scores.'",
      "status": "official"
    },
    {
      "code": "AFQT",
      "name": "Armed Forces Qualification Test (percentile)",
      "formula": "percentile rank (0-99) of a composite built from AR, MK, WK and PC standard scores, normed on the 1997 national sample of 18-23 year-olds; DoD does not publish the weights (the 2VE + AR + MK form is widely quoted but UNVERIFIED)",
      "components": [
        "AR",
        "MK",
        "WK",
        "PC"
      ],
      "description": "Used for enlistment eligibility only (Army minimum 31), never for MOS assignment.",
      "status": "definition official / weights unverified"
    }
  ],
  "officerPathways": [
    {
      "id": "ocs",
      "title": "Officer Candidate School (OCS) - federal OCS / Enlistment Program 9D",
      "gtMinimum": 110,
      "afqtMinimum": 31,
      "summary": "AR 601-210 (20 Mar 2026) para 9-10: 'OCS and WOFT applicants must have a general technical score of 110 or greater.' Bachelor's degree required; U.S. citizen; age 19 to less than 33 at shipment to training and commission before 34 (waivers considered); Secret clearance eligibility; no more than 10 cumulative years of active federal service at appointment.",
      "otherRequirements": [
        "Bachelor's degree (senior in final semester may enlist in DEP)",
        "U.S. citizen",
        "Age 19-32 at shipment; commission before 34 (waivers considered)",
        "Secret clearance eligibility",
        "At most 10 years cumulative active federal service at appointment",
        "Commissioning physical per AR 40-501; AR 600-9 body composition",
        "No previous failure to complete an officer-producing program (waiver possible after 1 year)"
      ],
      "source": "https://armypubs.army.mil/epubs/DR_pubs/DR_a/ARN42922-AR_601-210-000-WEB-1.pdf para 9-10"
    },
    {
      "id": "arng-ocs",
      "title": "Army National Guard OCS (State OCS / NGB Accelerated OCS)",
      "gtMinimum": 110,
      "afqtMinimum": 31,
      "summary": "AR 601-210 para 9-10 directs that ARNG OCS/WOCS options follow the Accession Options Criteria (AOC); the GT 110 gate is the Program 9D standard. goarmy.com describes the two ARNG routes: State OCS run on weekends over 16-18 months, and NGB Accelerated OCS, an 8-week course.",
      "otherRequirements": [
        "GT 110 (same standard as federal OCS)",
        "State AOC / State OCS board governs any waiver - confirm with the State program",
        "Federal recognition on commissioning (NGR 600-101)"
      ],
      "source": "https://www.goarmy.com/careers-and-jobs/find-your-path/army-officers/ocs ; AR 601-210 para 9-10"
    },
    {
      "id": "rotc",
      "title": "Army ROTC (and the ROTC/SMP enlistment option)",
      "gtMinimum": null,
      "afqtMinimum": 31,
      "summary": "ROTC itself does not gate commissioning on a GT score. For the ROTC/SMP enlistment option AR 601-210 requires SAT 850, ACT 19 or PSAT 85 for non-scholarship applicants; where those scores are unavailable or not met, 'recruiting brigade commanders may approve waivers ... in cases where applicant achieved a general technical score of 110 or higher. All applicants must have an ASVAB score of record to enlist.'",
      "otherRequirements": [
        "SAT 850 / ACT 19 / PSAT 85 (non-scholarship)",
        "GT 110 can substitute for missing or failed SAT/ACT/PSAT via brigade commander waiver",
        "ASVAB score of record required to enlist (SMP)",
        "Commission before age 31 standard (waivers to 39 for uniquely qualified RFD-only applicants)",
        "PMS certification; enroll in ROTC Basic/Advanced Course"
      ],
      "source": "AR 601-210 (20 Mar 2026) ROTC/SMP enlistment option paragraphs"
    },
    {
      "id": "usma",
      "title": "U.S. Military Academy (West Point)",
      "gtMinimum": null,
      "afqtMinimum": null,
      "summary": "No ASVAB or GT requirement identified in the official sources reviewed. USMA admission rests on SAT/ACT, academic record, physical aptitude and a Congressional nomination; goarmy.com notes commissioning from West Point must occur before age 27.",
      "otherRequirements": [
        "SAT/ACT plus academic record",
        "Congressional or Service-connected nomination",
        "Medical qualification and Candidate Fitness Assessment",
        "Commission before age 27 per goarmy.com"
      ],
      "source": "https://www.goarmy.com/how-to-join/requirements"
    },
    {
      "id": "direct-commission",
      "title": "Direct Commission (JAG 27A, Chaplain 56A, AMEDD)",
      "gtMinimum": null,
      "afqtMinimum": null,
      "summary": "UNVERIFIED. No ASVAB/GT line-score gate appears in AR 601-210 for direct-commission professional accessions; those programs are governed by their own branch authorities and substitute professional credentialing. Do not publish a GT number for these paths without a primary source.",
      "otherRequirements": [
        "Professional degree and licensure (JD and bar admission; MD/DO and license; etc.)",
        "Chaplain: ecclesiastical endorsement plus 72+ semester hours",
        "Age/medical standards per AR 40-501"
      ],
      "source": "UNVERIFIED - no primary source fetched in this session"
    },
    {
      "id": "wocs",
      "title": "Warrant Officer Candidate School (WOCS)",
      "gtMinimum": 110,
      "afqtMinimum": 31,
      "summary": "DA Pam 601-6 (21 Aug 2023) para 2-3a(3): 'Applicants must achieve a GT score of 110 or higher.' Para 2-2e: 'The requirements for a minimum general technical (GT) aptitude area score of 110, a high school diploma or general education diploma (GED), and possession of a secret security clearance are not waiverable.'",
      "otherRequirements": [
        "HS diploma or GED",
        "Interim Secret to apply, completed Secret to attend WOCS",
        "GT 110 - expressly NOT waiverable",
        "U.S. citizen or lawful permanent resident",
        "AFT within 6 months of application; AR 600-9",
        "Meet the specific WO MOS prerequisites (DA Pam 611-21 ch. 8); proponent waivers case by case",
        "Army goal of 8 or fewer years of service; 12-year active cap (8 for 153A)"
      ],
      "source": "https://armypubs.army.mil/epubs/DR_pubs/DR_a/ARN39016-PAM_601-6-000-WEB-3.pdf paras 2-2e, 2-3a"
    },
    {
      "id": "woft",
      "title": "Warrant Officer Flight Training (WOFT / street-to-seat)",
      "gtMinimum": 110,
      "afqtMinimum": 31,
      "summary": "GT 110 via AR 601-210 para 9-10. AR 611-110 (9 Aug 2023) para 2-1 requires a qualifying SIFT score before selection for Initial-Entry Rotary Wing, age over 18 and not yet 33 at board selection, at most 8 years active federal service, and a Class 1A flight duty medical exam (which may not be requested until SIFT is passed). AR 611-110 never prints the numeric SIFT minimum - 40 is the figure commonly cited but is UNVERIFIED here.",
      "otherRequirements": [
        "Qualifying SIFT score (numeric minimum not in AR 611-110; 40 commonly cited = UNVERIFIED)",
        "Only one SIFT retest, and only after a failing first attempt; retest no sooner than the 46th day",
        "Age over 18, not yet 33 at board selection",
        "At most 8 years active federal service at DA Form 61 signature",
        "Class 1A flight physical after passing SIFT",
        "GT 110"
      ],
      "source": "AR 611-110 (9 Aug 2023) para 2-1 ; AR 601-210 para 9-10"
    },
    {
      "id": "green-to-gold",
      "title": "Green to Gold (Army ROTC, incl. Active Duty Option)",
      "gtMinimum": 110,
      "afqtMinimum": 31,
      "summary": "Army ROTC Green to Gold Active Duty Option Handbook 2026-2027, requirement 13: 'GT Score. Must have a score of 110 or higher on the General Technical (GT) Aptitude Area ...' The score must appear on the Soldier Talent Profile; an Education Center ASVAB score sheet may be used as the source document.",
      "otherRequirements": [
        "GT 110 or higher, documented on the Soldier Talent Profile",
        "U.S. citizenship",
        "Security clearance documented (may be redacted on STP)",
        "Commander recommendation/endorsement",
        "ROTC ADO eligibility: age, AFT, medical, academic acceptance"
      ],
      "source": "https://armyrotc.army.mil/wp-content/uploads/2025/06/G2G-ADO-Handbook-2026_2027-2.pdf"
    },
    {
      "id": "09s-09w",
      "title": "Enlistment options 09S (OCS candidate) and 09W (WOFT candidate)",
      "gtMinimum": 110,
      "afqtMinimum": 31,
      "summary": "09S and 09W are accession codes, not aptitude areas: the applicant enlists under Program 9D (U.S. Army Officer/Warrant Officer Enlistment Program) and ships to OCS or WOFT after BCT. Both require GT 110 or greater. 09L (translator aide) is the sole case in AR 601-210 where AFQT categories IVB/V are accepted.",
      "otherRequirements": [
        "GT 110",
        "Bachelor's (09S) or HS diploma/GED (09W)",
        "Secret clearance eligibility",
        "DEP/DTP members may not process for OCS or WOFT",
        "Guaranteed OCS/WOFT enrollment after BCT (NPS) or immediately (PS)"
      ],
      "source": "AR 601-210 (20 Mar 2026) paras 2-8d, 9-10"
    }
  ],
  "mos": [
    {
      "code": "11B",
      "title": "Infantryman",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "CO",
            "min": 77
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-11B"
    },
    {
      "code": "11C",
      "title": "Indirect Fire Infantryman",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "CO",
            "min": 77
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-11C"
    },
    {
      "code": "12B",
      "title": "Combat Engineer",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "CO",
            "min": 82
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12B"
    },
    {
      "code": "13B",
      "title": "Cannon Crewmember",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "GT",
            "min": 87
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "GT 87 effective 202408; SECRET eligibility required to retain MOS at SGT+",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-13B"
    },
    {
      "code": "13F",
      "title": "Joint Fire Support Specialist",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "GT",
            "min": 87
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "GT 87 effective 202408",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-13F"
    },
    {
      "code": "13J",
      "title": "Fire Control Specialist",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "GT",
            "min": 87
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "GT 87 effective 202408",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-13J"
    },
    {
      "code": "13M",
      "title": "MLRS/HIMARS Crewmember",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "GT",
            "min": 87
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "GT 87 effective 202408",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-13M"
    },
    {
      "code": "13R",
      "title": "FA Weapons Locating Radar Specialist",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "GT",
            "min": 87
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "GT 87 effective 202408",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-13R"
    },
    {
      "code": "19C",
      "title": "Bradley Crewmember",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "CO",
            "min": 77
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-19C"
    },
    {
      "code": "19D",
      "title": "Cavalry Scout",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "CO",
            "min": 77
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-19D"
    },
    {
      "code": "19K",
      "title": "Armor Crewmember",
      "category": "Combat Arms",
      "gate": [
        [
          {
            "score": "CO",
            "min": 77
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-19K"
    },
    {
      "code": "18B",
      "title": "Special Forces Weapons Sergeant",
      "category": "Special Operations",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          },
          {
            "score": "CO",
            "min": 100
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "SFAS / SFQC",
      "note": "Accessed via the 18X enlistment option; MOS awarded after the SF qualification course",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-18B"
    },
    {
      "code": "18C",
      "title": "Special Forces Engineer Sergeant",
      "category": "Special Operations",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          },
          {
            "score": "CO",
            "min": 100
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "SFAS / SFQC",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-18C"
    },
    {
      "code": "18D",
      "title": "Special Forces Medical Sergeant",
      "category": "Special Operations",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          },
          {
            "score": "CO",
            "min": 100
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "SFAS / SFQC",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-18D"
    },
    {
      "code": "12D",
      "title": "Diver",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "GM",
            "min": 98
          },
          {
            "score": "GT",
            "min": 107
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "Y",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12D"
    },
    {
      "code": "12G",
      "title": "Quarrying Specialist (ARNG only)",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "GM",
            "min": 93
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": "National Guard-only MOS",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12G"
    },
    {
      "code": "12K",
      "title": "Plumber",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "GM",
            "min": 88
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12K"
    },
    {
      "code": "12M",
      "title": "Firefighter",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "GM",
            "min": 88
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12M"
    },
    {
      "code": "12N",
      "title": "Horizontal Construction Engineer",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "GM",
            "min": 85
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12N"
    },
    {
      "code": "12P",
      "title": "Prime Power Production Specialist",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "ST",
            "min": 107
          },
          {
            "score": "EL",
            "min": 107
          },
          {
            "score": "GT",
            "min": 110
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "SECRET required for award and retention",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12P"
    },
    {
      "code": "12R",
      "title": "Interior Electrician",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "EL",
            "min": 93
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12R"
    },
    {
      "code": "12T",
      "title": "Technical Engineer",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12T"
    },
    {
      "code": "12W",
      "title": "Carpentry and Masonry Specialist",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "GM",
            "min": 88
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12W"
    },
    {
      "code": "12Y",
      "title": "Geospatial Engineer",
      "category": "Combat Support (Engineer)",
      "gate": [
        [
          {
            "score": "ST",
            "min": 100
          },
          {
            "score": "GT",
            "min": 100
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "TS/SCI required to be awarded and retain the MOS",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-12Y"
    },
    {
      "code": "88H",
      "title": "Cargo Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GM",
            "min": 88
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-88H"
    },
    {
      "code": "88K",
      "title": "Watercraft Operator",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "MM",
            "min": 99
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-88K"
    },
    {
      "code": "88L",
      "title": "Watercraft Engineer",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "MM",
            "min": 99
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-88L"
    },
    {
      "code": "88M",
      "title": "Motor Transport Operator",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "OF",
            "min": 85
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-88M"
    },
    {
      "code": "88N",
      "title": "Transportation Management Coordinator",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "CL",
            "min": 95
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-88N"
    },
    {
      "code": "89B",
      "title": "Ammunition Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "N",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-89B"
    },
    {
      "code": "89D",
      "title": "Explosive Ordnance Disposal Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GM",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "EOD Specialist Course (NAVSCOLEOD)",
      "note": "Final TOP SECRET eligibility required for MOS award",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-89D"
    },
    {
      "code": "92A",
      "title": "Automated Logistical Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "CL",
            "min": 90
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92A"
    },
    {
      "code": "92F",
      "title": "Petroleum Supply Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "CL",
            "min": 86
          },
          {
            "score": "OF",
            "min": 85
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92F"
    },
    {
      "code": "92G",
      "title": "Culinary Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "OF",
            "min": 85
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92G"
    },
    {
      "code": "92L",
      "title": "Petroleum Laboratory Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92L"
    },
    {
      "code": "92M",
      "title": "Fatality Management Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GM",
            "min": 84
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92M"
    },
    {
      "code": "92R",
      "title": "Parachute Rigger",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GM",
            "min": 78
          },
          {
            "score": "CO",
            "min": 77
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92R"
    },
    {
      "code": "92S",
      "title": "Shower and Laundry Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GM",
            "min": 84
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92S"
    },
    {
      "code": "92W",
      "title": "Water Treatment Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GM",
            "min": 88
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92W"
    },
    {
      "code": "92Y",
      "title": "Unit Supply Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "CL",
            "min": 90
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-92Y"
    },
    {
      "code": "74D",
      "title": "CBRN Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "ST",
            "min": 100
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-74D"
    },
    {
      "code": "36B",
      "title": "Financial Management Technician",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "CL",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-36B"
    },
    {
      "code": "42A",
      "title": "Human Resources Specialist",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "CL",
            "min": 90
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-42A"
    },
    {
      "code": "51C",
      "title": "Contracting NCO",
      "category": "Combat Service Support",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "GT 110 expressly NOT waiverable",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-51C"
    },
    {
      "code": "91B",
      "title": "Wheeled Vehicle Mechanic",
      "category": "Mechanical Maintenance",
      "gate": [
        [
          {
            "score": "MM",
            "min": 92
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "N",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-91B"
    },
    {
      "code": "91E",
      "title": "Allied Trades Specialist",
      "category": "Mechanical Maintenance",
      "gate": [
        [
          {
            "score": "GM",
            "min": 88
          },
          {
            "score": "GT",
            "min": 95
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "N",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-91E"
    },
    {
      "code": "91S",
      "title": "Stryker Systems Maintainer",
      "category": "Mechanical Maintenance",
      "gate": [
        [
          {
            "score": "MM",
            "min": 87
          },
          {
            "score": "GT",
            "min": 85
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "N",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-91S"
    },
    {
      "code": "94E",
      "title": "Radio Equipment Repairer",
      "category": "Mechanical Maintenance",
      "gate": [
        [
          {
            "score": "EL",
            "min": 102
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "Y",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-94E"
    },
    {
      "code": "68A",
      "title": "Biomedical Equipment Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "EL",
            "min": 107
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68A"
    },
    {
      "code": "68C",
      "title": "Practical Nursing Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "NCLEX-PN licensure required",
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68C"
    },
    {
      "code": "68E",
      "title": "Dental Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68E"
    },
    {
      "code": "68G",
      "title": "Patient Administration Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "CL",
            "min": 90
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68G"
    },
    {
      "code": "68J",
      "title": "Medical Logistics Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "CL",
            "min": 90
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68J"
    },
    {
      "code": "68K",
      "title": "Medical Laboratory Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 106
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68K"
    },
    {
      "code": "68P",
      "title": "Radiology Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68P"
    },
    {
      "code": "68S",
      "title": "Preventive Medicine Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 98
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68S"
    },
    {
      "code": "68T",
      "title": "Animal Care Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68T"
    },
    {
      "code": "68V",
      "title": "Respiratory Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 102
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68V"
    },
    {
      "code": "68W",
      "title": "Combat Medic Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023; the pre-2023 figure of ST 107 is obsolete",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68W"
    },
    {
      "code": "68X",
      "title": "Behavioral Health Specialist",
      "category": "Medical",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-68X"
    },
    {
      "code": "17C",
      "title": "Cyber Operations Specialist",
      "category": "Cyber & EW",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          },
          {
            "score": "ST",
            "min": 112
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "TS/SCI with CI-scope polygraph",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-17C"
    },
    {
      "code": "17E",
      "title": "Electronic Warfare Specialist",
      "category": "Cyber & EW",
      "gate": [
        [
          {
            "score": "SC",
            "min": 105
          },
          {
            "score": "ST",
            "min": 105
          },
          {
            "score": "EL",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-17E"
    },
    {
      "code": "25B",
      "title": "Information Technology Specialist",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 95
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-25B"
    },
    {
      "code": "25D",
      "title": "Cyber Network Defender",
      "category": "Cyber & EW",
      "gate": [
        [
          {
            "score": "GT",
            "min": 105
          },
          {
            "score": "ST",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "In-service only (SSG+ with verified IA/IT experience)",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-25D"
    },
    {
      "code": "25E",
      "title": "Electromagnetic Spectrum Manager",
      "category": "Cyber & EW",
      "gate": [
        [
          {
            "score": "GT",
            "min": 105
          },
          {
            "score": "EL",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-25E"
    },
    {
      "code": "25H",
      "title": "Network Communication Systems Specialist",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "EL",
            "min": 100
          },
          {
            "score": "ST",
            "min": 102
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "Effective 202510; successor for legacy 25L/25N/25Q/25S",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-25H"
    },
    {
      "code": "25U",
      "title": "Signal Operations Support Specialist",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "EL",
            "min": 95
          },
          {
            "score": "SC",
            "min": 95
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-25U"
    },
    {
      "code": "35F",
      "title": "Intelligence Analyst",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "101 applies to ASVAB taken on/after 1 Jul 2004 (105 before 2 Jan 2002; 102 for 2002-2004 tests)",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35F"
    },
    {
      "code": "35G",
      "title": "Geospatial Intelligence Imagery Analyst",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "Same date-tiered schedule as 35F",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35G"
    },
    {
      "code": "35L",
      "title": "Counterintelligence Agent",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35L"
    },
    {
      "code": "35M",
      "title": "Human Intelligence Collector",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "DLAB (or DLPT/OPI proficiency)",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35M"
    },
    {
      "code": "35N",
      "title": "Signals Intelligence Analyst",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 112
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35N"
    },
    {
      "code": "35P",
      "title": "Signals Intelligence Voice Interceptor",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "DLAB; TS/SCI with CI-scope polygraph",
      "note": "ST 91 for ACASP applicants with Strategic Language List proficiency",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35P"
    },
    {
      "code": "35S",
      "title": "Signals Acquisition/Exploitation Analyst",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35S"
    },
    {
      "code": "35T",
      "title": "MI Systems Maintainer/Integrator",
      "category": "Intelligence & Signal",
      "gate": [
        [
          {
            "score": "ST",
            "min": 112
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-35T"
    },
    {
      "code": "15B",
      "title": "Aircraft Powerplant Repairer",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "MM",
            "min": 104
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15B"
    },
    {
      "code": "15E",
      "title": "RQ-7 Repairer",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "EL",
            "min": 93
          },
          {
            "score": "MM",
            "min": 104
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15E"
    },
    {
      "code": "15F",
      "title": "Aircraft Electrician",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "MM",
            "min": 104
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15F"
    },
    {
      "code": "15N",
      "title": "Avionic Mechanic",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "EL",
            "min": 93
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15N"
    },
    {
      "code": "15P",
      "title": "Aviation Operations Specialist",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15P"
    },
    {
      "code": "15Q",
      "title": "Air Traffic Control Operator",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "ST",
            "min": 101
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": "ATC physical / FAA-class medical",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15Q"
    },
    {
      "code": "15R",
      "title": "AH-64 Attack Helicopter Repairer",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "MM",
            "min": 99
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15R"
    },
    {
      "code": "15T",
      "title": "UH-60 Helicopter Repairer/Aircrew Member",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "MM",
            "min": 104
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "Class III flight physical (aircrew)",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15T"
    },
    {
      "code": "15U",
      "title": "CH-47 Helicopter Repairer/Aircrew Member",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "MM",
            "min": 104
          }
        ]
      ],
      "securityClearance": false,
      "extraTest": "Class III flight physical (aircrew)",
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15U"
    },
    {
      "code": "15W",
      "title": "RQ-7 Operator",
      "category": "Aviation",
      "gate": [
        [
          {
            "score": "SC",
            "min": 102
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-15W"
    },
    {
      "code": "27D",
      "title": "Paralegal Specialist",
      "category": "Legal",
      "gate": [
        [
          {
            "score": "CL",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-27D"
    },
    {
      "code": "31B",
      "title": "Military Police",
      "category": "Military Police",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-31B"
    },
    {
      "code": "31D",
      "title": "CID Special Agent",
      "category": "Military Police",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "In-service selection",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-31D"
    },
    {
      "code": "31E",
      "title": "Corrections and Detention Specialist",
      "category": "Military Police",
      "gate": [
        [
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-31E"
    },
    {
      "code": "37F",
      "title": "Psychological Operations Specialist",
      "category": "Special Operations",
      "gate": [
        [
          {
            "score": "GT",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-37F"
    },
    {
      "code": "38B",
      "title": "Civil Affairs Specialist",
      "category": "Special Operations",
      "gate": [
        [
          {
            "score": "GT",
            "min": 107
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-38B"
    },
    {
      "code": "42R",
      "title": "Musician",
      "category": "Band",
      "gate": [],
      "securityClearance": false,
      "extraTest": "Instrument audition (ACASP)",
      "note": "No aptitude-area (line-score) requirement published; qualification is by audition",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-42R"
    },
    {
      "code": "42S",
      "title": "Special Band Musician",
      "category": "Band",
      "gate": [],
      "securityClearance": false,
      "extraTest": "Instrument audition",
      "note": "No line-score requirement; must be acceptable to the special band commander",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-42S"
    },
    {
      "code": "46S",
      "title": "Public Affairs Mass Communication Specialist",
      "category": "Public Affairs",
      "gate": [
        [
          {
            "score": "GT",
            "min": 105
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "Score effective 9 Oct 2023; primarily an ARNG/USAR accession MOS",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-46S"
    },
    {
      "code": "46V",
      "title": "Visual Information Specialist",
      "category": "Public Affairs",
      "gate": [
        [
          {
            "score": "EL",
            "min": 93
          },
          {
            "score": "ST",
            "min": 91
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-46V"
    },
    {
      "code": "56M",
      "title": "Religious Affairs Specialist",
      "category": "Religious",
      "gate": [
        [
          {
            "score": "CL",
            "min": 90
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": null,
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-56M"
    },
    {
      "code": "79R",
      "title": "Recruiter",
      "category": "Recruiting",
      "gate": [
        [
          {
            "score": "GT",
            "min": 110
          }
        ]
      ],
      "securityClearance": true,
      "extraTest": null,
      "note": "Waiver to GT 100 by CG USAREC, or GT 95 with ST 95",
      "source": "DA Pam 611-21 ch.10 sec.C, section 10-79R"
    }
  ]
}
```

---

### Primary sources (all fetched in this session)

* AR 601-210, *Regular Army and Reserve Components Enlistment Program*, 20 March 2026 (effective 20 April 2026) - https://armypubs.army.mil/epubs/DR_pubs/DR_a/ARN42922-AR_601-210-000-WEB-1.pdf
* DA Pam 611-21, ch. 10 sec. C, *Enlisted MOS specifications* (MOS Smartbook, 2024 build) - https://api.army.mil/e2/c/downloads/2024/11/20/bf11d2d2/chapter-10c-enlisted-mos-specifications.pdf (retrieved via Internet Archive snapshot 2025-07-09)
* DA Pam 601-6, *Warrant Officer Procurement Program*, 21 August 2023 - https://armypubs.army.mil/epubs/DR_pubs/DR_a/ARN39016-PAM_601-6-000-WEB-3.pdf
* AR 611-110, *Selection of Army Aviation Officers and Warrant Officers*, 9 August 2023
* goarmy.com - https://www.goarmy.com/how-to-join/steps/asvab ; https://www.goarmy.com/how-to-join/requirements ; https://www.goarmy.com/careers-and-jobs/find-your-path/army-officers/ocs
* nationalguard.com - https://nationalguard.com/eligibility ; https://www.nationalguard.com/the-asvab
* officialasvab.com - /applicants/military-jobs/ (Army composite table) ; /recruiters/picat/ ; /applicants/asvab-retest-policy/ ; /recruiters/fact-sheet/ (updated 2026-10-06) ; /recruiters/scores/ ; /counselors-educators/asvab-career-exploration-program/
* Army ROTC Green to Gold ADO Handbook 2026-2027 - https://armyrotc.army.mil/wp-content/uploads/2025/06/G2G-ADO-Handbook-2026_2027-2.pdf

*Report ends. Compiled for the ASVAB coach project; verify any score before it gates a real applicant's plan.*
