# MOS roster gap report

**Question this answers.** The app is the only place these numbers come from for
a candidate planning a National Guard enlistment. Telling someone they do not
qualify for a job they do qualify for is the most expensive mistake this
codebase can make, so the roster was diffed against the authority rather than
reviewed by eye.

**Result, in one table.**

| | Count |
|---|---|
| Distinct section headings in the authority (chapter 10 section C) | **194** |
| Of those, substantive enlisted MOS (an enlistment or reclassification target) | **156** |
| Of those, position reporting codes and the "unqualified" marker | 13 |
| Of those, senior-sergeant / supervisory codes (awarded by reclassification only) | 25 |
| Enlisted MOS the app carried before this diff | **97** |
| Of those, codes that no longer exist or were never real | **0** |
| Enlisted MOS added in this diff | **59** |
| Enlisted MOS the app carries now | **156** |
| Entries marked "no aptitude requirement is published" | **3** (18F, 42R, 42S) |
| Entries marked "gate not verified" | **0** |
| Entries marked as not an Army National Guard job | **9** |
| Entries the pamphlet marks rescinded | **3** (12M 202510; 15E and 15W 202610) |

And the half this report used to leave out (section 5):

| Warrant officer occupations (chapter 8 section B) | Count |
|---|---|
| Occupation codes specified in the chapter | **76** |
| Carried by the app | **71** |
| Recorded as deliberately excluded, with the reason | **5** |
| Printing an ASVAB line-score gate | **2** (280A and 490B: GT 110, no waivers) |
| Printing prerequisites instead of a gate | **69** |
| Described in plain language | **70** |
| Left undescribed because the chapter prints no duties | **1** (351Y) |

Verified as of **26 October 2026** against the **04 December 2025 build** of DA
Pam 611-21: chapter 10 section C for the enlisted roster, chapter 8 section B for
the warrant occupations. The app carries that date as `mosRosterVerifiedAsOf`
and `mosWarrantVerifiedAsOf` and shows both in the jobs screen, in Settings and
in the glossary.

---

## 1. Finding the authority is itself part of the work

The URL in the brief,
`https://armypubs.army.mil/epubs/DR_pubs/DR_a/ARN36922-PAM_611-21-000-WEB-2.pdf`,
is **not** the roster. It is a 20-page file: cover, summary of change,
applicability paragraph, and the certification page for the 20 December 2022
edition. It contains no MOS data at all. Anyone who "diffed the roster against
that PDF" would have diffed against nothing.

The specifications live in the *MOS Smartbook* build of the pamphlet, published
as separate chapter files on `api.army.mil`:

| Build | URL | Use |
|---|---|---|
| 20 Nov 2024 | `api.army.mil/e2/c/downloads/2024/11/20/bf11d2d2/chapter-10c-enlisted-mos-specifications.pdf` | superseded - used only to see what changed |
| 04 Dec 2025 | `api.army.mil/e2/c/downloads/2025/12/04/20612de5/chapter-10c-enlisted-mos-specifications.pdf` | **the authority for this diff** |

`api.army.mil` answers HTTP 403 to anything that is not a browser, so both builds
were read from the Internet Archive snapshot of those exact URLs
(`https://web.archive.org/web/2026id_/<url>`). 361 pages, 1.14 M characters of
text, extracted with pypdf. Individual per-MOS files exist too
(`.../2026/01/13/78785d19/17e.pdf`, `.../2025/06/26/b4cc33ad/25h.pdf`); the two
newest codes were checked against those as well.

Also checked and **not** usable as a gate source: `recruiting.army.mil/ISO/AWOR/ARMYMOS/`
redirects into the recruiting site's job pages, which publish "minimum score"
prose with no aptitude-area or section citation and no revision date. Every gate
in the app is cited to a section of the pamphlet instead.

## 2. The roster arithmetic

Chapter 10 section C carries 194 distinct `10-XXX` headings in the current build.
Not all of them are jobs a candidate can be put into:

- **13 are not MOS at all.** `00D, 00F, 00G, 00J, 00K, 00L, 00M, 00P, 00R, 00T, 00X, 00Z`
  are Position / Personnel Special Reporting Codes (duty positions, not
  specialties), and `09U` is the marker used to report a soldier who has lost
  MOS qualification. Deliberately not in the app: they cannot be enlisted for,
  and every one of them prints "aptitude requirement: not applicable".
- **25 are senior-sergeant or supervisory codes**: `11Z, 12A, 12X, 12Z, 13Z, 14Z,`
  `15K, 15L, 15Z, 17Z, 18Z, 19Z, 25Z, 31Z, 35Z, 38Z, 46Y, 46Z, 68Z, 88Z, 91X,`
  `91Z, 92Z, 94W, 94Z`. These are the E7-E9 management codes for a career
  management field. **Deliberately not in the app**, for two reasons: a candidate
  cannot enlist into one, and listing them under a filter called "Enlisted (n)"
  next to entry-level jobs would misrepresent what the chip means. Three of them
  do print a gate (19Z CO 90, 31Z ST 91, 38Z GT 107); that is recorded here so
  nobody re-discovers it as a gap. If the app ever gains an "in-service moves"
  screen, they belong there, not here.
- **156 are substantive MOS.** All 156 are now in the app.

Changes between the two builds, for anyone re-verifying:

- removed since the 2024 build: **14S** (Avenger Crewmember, USAR/NG only) and
  **15S** (OH-58D repairer, the airframe is gone), plus **25X** (Chief Signal
  NCO). None of the three was carried by the app, so no removal was needed.
- added since the 2024 build: **08H** (Army Equestrian, effective 202603),
  **15X** (TUAS Specialist, effective 202610), **40D** (Space Operations
  Specialist, effective 202610), **42T** (Talent Acquisition Specialist,
  effective 202510).

## 3. What we had, and what was wrong with it

**Every one of the 97 codes the app carried was a real MOS** - no phantom codes,
no retired specialties. The failures were of a different kind, and they were
worse than phantoms, because each one told a real candidate they did not qualify
for a job they did qualify for:

### 3a. Six gates were missing the pamphlet's second path

The pamphlet prints many gates as "a score of X **or** a combination of Y and Z".
The app carried only the first path, so a candidate who met the combination was
reported as short:

| MOS | The pamphlet | What the app had |
|---|---|---|
| 91B | MM 92 **or** (MM 87 with GT 85) | MM 92 |
| 91E | (GM 88 with GT 95) **or** GM 98 | GM 88 + GT 95 |
| 91S | (MM 87 with GT 85) **or** MM 92 | MM 87 + GT 85 |
| 89B | ST 91 **or** (ST 86 with GT 85) | ST 91 |
| 94E | EL 102 **or** (EL 97 with ST 90) | EL 102 |
| 12D | GM 98 **and** (GT 107 **or** ST 106) | GM 98 + GT 107 |

All six now carry every alternative the pamphlet prints, and
`test/mos_roster_test.dart` asserts it by name.

### 3b. Six entries claimed an "extra selection requirement" of `Y` or `N`

12D, 89B, 91B, 91E, 91S and 94E carried `extraTest: 'Y'` / `'N'`. The jobs screen
renders that field as *"Extra selection requirement"*, so the app was telling
candidates these jobs required a test called Y. The flags were transcription
noise; all six are gone.

### 3c. Nine jobs were listed as Guard jobs without saying they are not

The pamphlet restricts some MOS to another component. The app listed them with
no marking, which is the same harm pointing the other way:

| MOS | Restriction printed in the pamphlet |
|---|---|
| 38B, 88P, 88U | `(USAR Only)` / `(USAR only)` |
| 38R, 38W | `(Active Component Only)` |
| 79S | `(Active Component)` |
| 79V | `(Army Reserve)` |
| 79R, 42T | `(Active Component and USAR)` |

These are still in the catalogue - a candidate comparing components should see
them - but the model now carries the restriction, the row reads **"Not a Guard
job"** instead of "Qualified", and the detail sheet repeats the pamphlet's own
wording. Two more carry a restriction that *includes* the Guard and are marked as
fielded with the restriction noted: **12Q** (Reserve Components) and **79T**
(Army National Guard).

### 3d. Three entries read as "you qualify" when there is nothing to qualify on

42R and 42S carried an empty gate, and an empty gate was rendered as satisfied,
so every candidate was told they qualified for both musicians' jobs. The pamphlet
publishes **no** aptitude-area requirement for them (qualification is by
audition). The correct fact is "no requirement", not "no data" - and not a number
invented to fill the hole. `MosGateStatus` now distinguishes:

- `published` - a transcribed gate (153 entries);
- `noRequirement` - the pamphlet states there is none (42R, 42S, and 18F,
  which prints "Minimum score in aptitude area--N/A");
- `unverified` - the MOS exists but its gate was not checked. This state is
  implemented, tested, and **currently used by nothing**, because this diff
  verified every gate. An unverified entry is counted as neither qualified nor
  short, and shows as "Gate not verified" rather than an empty pass.

### 3e. Two titles were stale

15E and 15W were still "RQ-7 Repairer" and "RQ-7 Operator". The pamphlet renamed
both to Tactical Unmanned Aircraft System (TUAS) Repairer / Operator effective
202510. Titles updated, with a note recording the old name.

### 3f. Four codes the app carried that the November 2024 build lacks

17E, 25E, 25H and 42S do not appear in the 2024 chapter file. They are **not
phantoms**: each has its own current specification in the Smartbook (17E
"Electronic Warfare Specialist", 25H "Network Communication Systems Specialist",
effective 202510; 25E "Electromagnetic Spectrum Manager"; 42S "Special Band
Musician"). The lesson is that the chapter file lags the per-MOS files, so a diff
against one build can invent a gap that is really a stale source.

### 3g. Three rescinded MOS were offered as live enlistment targets

The pamphlet marks a rescinded section in the section heading itself, with the
month it takes effect. The app carried none of those markings, so a candidate
whose line scores cleared 12M was told they qualified for a Firefighter
enlistment the Army retired in October 2025, with a written description of the
work attached. There are exactly three, and they are the only three:

| MOS | Heading, as printed | Rescind date |
|---|---|---|
| 12M | `10-12M. MOS 12M--Firefighter, CMF 12 (Rescind) 202510)` | **202510** - retired October 2025 |
| 15E | `10-15E. MOS 15E—TUAS Repairer CMF 15 (Rescind 202610)` | **202610** - retires October 2026 |
| 15W | `10-15W. MOS 15W—TUAS Operator, CMF 15 (Rescind` / `202610)` | **202610** - same date |

15W is the one that hides from a line-by-line search: the annotation wraps, with
"(Rescind" ending one line and "202610)" opening the next, so the heading has to
be read as a block. 12M prints a stray bracket - "(Rescind) 202510)" - which is
why the extractor reads the date loosely instead of demanding tidy punctuation.

Two things were deliberately **not** done:

- **the entries were not deleted.** A candidate still meets the code in older
  material and in the roster of soldiers who hold it, and a list that quietly
  forgot 12M would leave them unable to find out what happened to it. The gate,
  the description and the civilian crosswalk all stay;
- **the two cases were not collapsed into one.** A rescission month that has
  arrived is "Retired October 2025 - not available for enlistment". A rescission
  month still ahead is "Retiring October 2026 - confirm with a recruiter before
  planning around it", because until that month the job does stand.

The rescission month itself is the first closed month, not the last open one:
a section printed "(Rescind) 202610" is withdrawn as of 202610, so 15E and 15W
are counted in September 2026 and not in October. `Mos.retiredAt` owns that
comparison and nothing else re-derives it.

What the app does now: `Mos.rescindOn` carries the month, the row shows that
sentence instead of a verdict (a retired MOS never reads "Qualified" or "8 pts
short"), the detail sheet opens on a callout naming the pamphlet's own date and
withholds the "You qualify" and "what it would take" cards, and the onboarding
picker marks the entry too.

The counts follow the same rule, in one place. `MosRepository` splits the roster
into `enlistableAsOf(now)` and `retiredAsOf(now)` - two lists that partition
`all` - and `EligibilityEngine.summarise(report, now: ...)` reads only the
first. A retired MOS therefore reaches no bucket: not qualified, not near miss,
not further out. The summary carries the retired entries separately
(`retired`, `retiredCount`, `retiredNote`) so the headline can say "N of 153
jobs open to enlistment today" and name what the denominator leaves out instead
of shrinking it silently. The clock is a parameter, never `DateTime.now()` inside
the engine, so `test/eligibility_count_test.dart` pins October 2025, October 2026
and 2027 and holds all three screens to the same answer. `test/mos_rescind_test.dart`
reads `docs/research/_raw/ch10c.txt` back, extracts every marked heading, prints
the list it found, and fails if the data carries a rescission the pamphlet does
not show or misses one it does.

## 4. The 59 added

Family by family (gate shown as the app now carries it, `&` = both required,
`|` = either path):

| MOS | Title | Gate |
|---|---|---|
| 08H | Army Equestrian | ST 91 |
| 12C | Bridge Crewmember | CO 82 |
| 12H | Construction Engineering Supervisor | GM 93 |
| 12Q | Powerline Distribution Specialist | EL 93 |
| 14E | Patriot Fire Control Enhanced Operator/Maintainer | MM 92 |
| 14G | Air Defense Battle Management System Operator | MM 91 & GT 90 |
| 14H | Air Defense Enhanced Early Warning System Operator | MM 91 & GT 90 |
| 14P | Air and Missile Defense Crewmember | OF 87 |
| 14T | Patriot Launching Station Enhanced Operator/Maintainer | OF 87 |
| 15C | MQ-1 Operator | SC 102 |
| 15D | Aircraft Powertrain Repairer | MM 104 |
| 15G | Aircraft Structural Repairer | MM 104 |
| 15H | Aircraft Pneudraulics Repairer | MM 104 |
| 15M | MQ-1 Repairer | EL 93 & MM 104 |
| 15X | TUAS Specialist | EL 93 & MM 99 & SC 102 |
| 15Y | AH-64 Armament/Electrical/Avionics Systems Repairer | EL 98 & MM 104 |
| 18E | Special Forces Communications Sergeant | GT 110 & CO 100 |
| 18F | Special Forces Intelligence Sergeant | **no requirement published (N/A)** |
| 25S | Satellite Communication Systems Specialist | EL 107 |
| 31K | Working Dog Handler | ST 91 |
| 38R | Civil Reconnaissance Sergeant | GT 107 & CO 100 |
| 38W | Civil Affairs Medical Sergeant | GT 110 & ST 101 |
| 40D | Space Operations Specialist | EL 110 |
| 42T | Talent Acquisition Specialist | GT 110 |
| 46T | Visual Information Equipment Operator-Maintainer | EL 93 & ST 91 & GT 97 |
| 68B | Orthopedic Specialist | ST 101 |
| 68D | Operating Room Specialist | ST 101 |
| 68F | Physical Therapy Specialist | ST 101 |
| 68H | Optical Laboratory Specialist | GM 98 |
| 68L | Occupational Therapy Specialist | ST 101 |
| 68M | Nutrition Care Specialist | OF 95 |
| 68Q | Pharmacy Specialist | ST 95 |
| 68R | Veterinary Food Inspection Specialist | ST 95 |
| 68Y | Eye Specialist | ST 101 |
| 79S | Career Counselor | GT 100 & ST 96 |
| 79T | Recruiting and Retention NCO | GT 110 |
| 79V | Army Reserve Career Counselor | GT 100 |
| 88P | Railway Equipment Repairer | MM 97 |
| 88U | Railway Specialist | MM 92 |
| 89A | Ammunition Stock Control and Accounting Specialist | ST 91 |
| 91A | M1 Abrams Tank System Maintainer | MM 99, or MM 88 & GT 90 |
| 91C | Utilities Equipment Repairer | GM 93, or GM 88 & GT 85 |
| 91D | Tactical Power Generation Specialist | GM 93, or GM 88 & GT 85 |
| 91F | Small Arms/Towed Artillery Repairer | GM 93, or GM 87 & GT 85 |
| 91H | Tracked Vehicle Repairer | MM 90, or MM 85 & GT 85 |
| 91J | Quartermaster and Chemical Equipment Repairer | MM 87, or MM 82 & GT 85 |
| 91L | Construction Equipment Repairer | MM 87, or MM 82 & GT 85 |
| 91M | Bradley Fighting Vehicle System Maintainer | MM 99, or MM 88 & GT 90 |
| 91P | Self-Propelled Artillery Systems Mechanic | MM 99, or MM 88 & GT 90 |
| 94A | Land Combat Electronic Missile System Repairer | EL 102, or EL 97 & ST 90 |
| 94D | Air Traffic Control Equipment Repairer | EL 102, or EL 97 & ST 90 |
| 94F | Computer/Detection Systems Repairer | EL 102, or EL 97 & ST 90 |
| 94H | TMDE Maintenance Support Specialist | EL 107, or EL 102 & ST 90 |
| 94M | Radar Repairer | EL 107, or EL 102 & ST 90 |
| 94P | MLRS Repairer | EL 93, or EL 88 & ST 85 |
| 94R | Avionics and Survivability Equipment Repairer | EL 98 |
| 94S | Patriot System Repairer | EL 107, or EL 102 & ST 90 |
| 94T | Short Range Air Defense System Repairer | EL 98 (see below) |
| 94Y | Automatic Test Systems Operator/Maintainer | EL 107, or EL 102 & ST 90 |

Two of these need a word of warning:

- **94T** prints a second path of "EL 93 with 85 in aptitude area **ET**". ET is
  not one of the ten aptitude areas the pamphlet defines anywhere else, and no
  other MOS references it. The app carries the EL 98 path, evaluates only that,
  and says in the entry that it does not guess what ET means. The most likely
  reading is a typographical error for ST; that is a guess, so it is not in the
  gate.
- **88P** is dated: MM 100 for tests taken before 2 January 2002, MM 97 from
  that date. The app carries MM 97 (the rule for anyone testing now) and records
  the older tier in the note.

## 5. Warrant officer MOS: closed on 26 October 2026

The app carries nine officer and warrant **routes** (OCS, ARNG OCS, ROTC, West
Point, direct commission, WOCS, WOFT, Green to Gold, 09S/09W) with their GT 110
gate. Until this pass it carried **no** individual warrant officer occupation
(153A, 155A, 170A, 180A, 255A, 350F and the rest), and the earlier edition of
this section said so and said why. That gap is now closed, on the terms this
section used to set out.

### 5a. The authority, and which build of it

| Build | URL | Use |
|---|---|---|
| 04 Dec 2025 | `api.army.mil/e2/c/downloads/2025/12/04/eed6f526/chapter-8-wo-base-chapter.pdf` | chapter 8 front matter (8-1 to 8-4), 1 page |
| 04 Dec 2025 | `api.army.mil/e2/c/downloads/2025/12/04/720183c2/chapter-8b-wo-specifications.pdf` | **the authority for this diff** - chapter 8 section B, 161 pages |

Both are the same build the enlisted roster was verified from (04 December
2025), so the two halves of the catalogue cite one edition of one pamphlet. The
files were read from the Internet Archive snapshot of those exact URLs
- and the `/web/20260510211025/` playback shape of the capture is the one that
served the bytes: the same capture addressed as `/web/20260510211025id_/` answered
HTTP 429 on every attempt, which is a rate limit and not a missing document.
`docs/research/extract_ch8b.py` fetches and extracts it; the extracted text lands
in `docs/research/_raw/wo/`, which is gitignored because it is 430 KB.

`recruiting.army.mil/ISO/AWOR/153A/` and the AWOR MOS index answer HTTP 403 to
anything that is not a browser, and the `army.mil` chapter files do too. As with
chapter 10 section C, the archive is the only route.

### 5b. The arithmetic

| | Count |
|---|---|
| `8-XXXX` section headings in chapter 8 section B | **65** (62 distinct section numbers - 8-155, 8-280A and 8-420T are each printed twice) |
| Warrant officer occupation codes in those headings (aviation headings list several each) | **76** |
| Carried by the app | **71** |
| Recorded as deliberately excluded, with the reason | **5** |
| Of the 71, printing a line-score gate | **2** (280A, 490B) |
| Of the 71, printing prerequisites instead | **69** |
| Described in plain language | **70** |
| Left with no description | **1** (351Y) |

Verified on **26 October 2026** against that build. The app carries the date as
`mosWarrantVerifiedAsOf` beside the enlisted roster's own, and shows both in the
jobs screen.

### 5c. Does a warrant occupation carry the same gate as an enlisted MOS? No.

This was the question the earlier edition of this section refused to answer by
guessing, and chapter 8 section B answers it plainly. A section prints, in order:
licensing and certification requirements, prerequisites, accession status and
feeder MOSs, associated SQI/ASI codes, the qualifications for each grade (course,
clearance, physical, security), the duties, the physical demands category, and
finally `Qualifying scores` - which are **OPAT physical benchmarks**, standing
long jump, seated power throw, strength deadlift and interval aerobic run.

There is no aptitude-area paragraph and no ASVAB line score anywhere in the
chapter **except in two sections**: 280A (Software Operations Technician) and
490B (Artificial Intelligence and Machine Learning Operations Technician) each
require "ASVAB GT Score of 110 (No waivers)". That is the whole of it.

So the model carries two things rather than forcing one into the other:

- `Mos.gate` - an aptitude gate, filled for 280A and 490B and empty for the other
  69, whose `gateStatus` is `MosGateStatus.noRequirement`;
- `Mos.prerequisites` - the authority's own prerequisite list: feeder MOS,
  accession status, course, clearance, physical, board. This is what stands in
  place of a gate, and the jobs screen prints it under the heading the pamphlet
  gives it, never as a number.

`Mos.gateSummary` says the difference out loud: an enlisted MOS with no gate
reads "No aptitude gate published", a warrant occupation with no gate reads "No
line-score gate - appointed against prerequisites, not a score".

### 5d. What was excluded, and why (the 5)

- **011A and 011M** are branch- and MOS-immaterial **duty positions**, not
  occupations: their sections describe where such positions sit ("Chief, Leader
  Development Branch, WO Division, HRC"; "positions serving in the Army Software
  Factory"). They are the warrant analogue of the 00-series position reporting
  codes excluded from the enlisted roster.
- **255Z, 915E and 948E** are CW5 capstone codes - the warrant counterpart of the
  E7-E9 supervisory codes the enlisted roster also excludes. Each is
  non-accession and each defers its warrant-officer duties to its feeders: 255Z
  prints "WO1/CW2/CW3/CW4 does not apply", 915E is marked "(CW5 only)" and says
  "see feeder MOS qualifications", 948E says "see MOS 948B or MOS 948D".

They are recorded in `mosWarrantExcluded` with those reasons rather than
dropped, and `test/warrant_mos_test.dart` reads the chapter back and fails if any
section-B code is neither carried nor recorded there.

### 5e. What could still mislead someone, and what the app does about it

**A warrant occupation is not an enlistment option.** This is the one that could
actively mislead a candidate, so it is enforced in the data rather than in a
sentence: `Mos.appointment` is `MosAppointment.warrantOfficer`, `Mos
.requiresPriorService` is true for every one of the 71, the list lives in
`MosRepository.warrant` and **not** in `MosRepository.all`, and every count in
the app - "156 enlisted MOS", "N of 153 jobs open to enlistment today" - is
computed from `all` and therefore cannot see them. The eligibility engine is
never asked about one: no bucket of an `EligibilitySummary` can hold a warrant
entry, and the jobs screen renders them in their own section, under a callout
that says you cannot enlist into one, with no "Qualified" verdict and no line
score to raise.

**One section contradicts itself.** 153E is listed as an accession MOS and, in
the next sentence, as a non-accession MOS. The app records the contradiction in
the entry's note rather than picking the reading it prefers.

**One section prints no duties.** 351Y's duties paragraph says "see AR 614-115".
That regulation was not fetched here, so 351Y carries prerequisites and **no
description** - the only one of the 71 without one. An invented sentence about
the work was the alternative, and it is worse.

**Two sections are superseded inside the same chapter.** 420T is printed twice
(effective 202508 and 202710); the app carries the current one and says the other
exists. 280A is printed twice as well and the two are the same specification.

## 6. National Guard availability: what is verified and what is not

**Verified.** The pamphlet prints component restrictions in the entry itself
("(National Guard Only)", "(USAR only)", "(Active Component Only)", "(Reserve
Components)"). Every one of those that appears against a substantive MOS is now
carried in the data, shown on the row and repeated in the detail sheet. 12G is
marked Guard-only; 79T is the Guard recruiting specialty; nine are marked as not
Guard jobs (section 3c).

**Not verified.** Per-MOS availability **inside the Guard** - a job the Guard
fields in principle may not exist in a candidate's State, and the Guard fields a
subset of the Army roster. Two attempts to cross-check were made and both failed
for reasons worth recording:

- `https://nationalguard.com/mos-jobs` returns a 4.8 KB JavaScript shell with no
  MOS data in the HTML (the list is fetched client-side).
- `https://jobs.nationalguard.com/jobs/` returns HTTP 403 to a non-browser
  client.

So the app deliberately does **not** claim "this job is available in your State".
It says what the pamphlet says and tells the candidate to confirm the rest with a
Guard recruiter. Closing the gap needs either a browser-driven crawl of
`jobs.nationalguard.com` recorded with a date, or a State-by-State list from a
recruiter, both of which are outside what this session could verify.

## 7. What this does and does not claim

Verified on 26 October 2026:

- every substantive enlisted MOS in chapter 10 section C is in the catalogue
  (156 of 156), with its title, its career field, and its aptitude gate or an
  explicit statement that it has none;
- every gate carries every OR alternative the pamphlet prints;
- every entry cites the section it came from (`Mos.source`), so the working is
  visible in the app;
- component restrictions the pamphlet prints are carried and shown;
- every rescission the pamphlet marks in a section heading is carried, with the
  month it takes effect, and is shown as retired or retiring rather than as a job
  to aim at;
- the 97 legacy ids are stable, tested, and still resolve;
- every warrant officer occupation the chapter specifies is either carried (71)
  or recorded with a reason (5), with its title, its feeder MOS, its accession
  status and the prerequisites the section prints;
- the two warrant occupations that publish an ASVAB score carry it (GT 110, no
  waivers), and no other warrant entry claims a gate it does not have;
- 70 of the 71 warrant occupations carry a pamphlet-cited description of the
  work, and 351Y carries none;
- no warrant occupation is reachable from an enlisted count, an enlisted filter,
  an enlistment search or an eligibility verdict, and every one of them states
  that appointment requires prior service.

**Not** claimed, and not verifiable from this repo:

- that a gate is current today. The pamphlet is revised; the build date inside
  the app is 04 Dec 2025 and the check date is 26 Oct 2026. A recruiter has the
  live accession criteria.
- Guard availability in a given State (section 6).
- that these are the Army's real exam items. They are not, and the app says so.
- physical qualification. Every entry in the pamphlet also carries a physical
  demands rating, a PULHES profile and an OPAT benchmark. The app carries none of
  those numbers; a qualifying line score alone does not qualify anyone and the
  jobs screen says so.
- warrant officer selection. The prerequisite lists are the pamphlet's own and
  a board applies them: a soldier who meets every printed line is a candidate,
  not an appointment. The app models no board, no evaluation file and no
  proponent waiver. The ASVAB part is complete for the two occupations that
  publish one and absent for the rest, which is exactly what the authority says;
- clearance adjudication. `securityClearance: true` records that the pamphlet
  requires eligibility for SECRET or TS/SCI; it is not a prediction that a
  candidate will get one.

## 8. How to re-verify

```bash
# 1. pull the current chapter 10 section C (api.army.mil 403s to scripts; use the
#    archive snapshot of the newest build directory)
python docs/research/extract_ch10c.py
# 2. compare with the extract committed here
#    docs/research/mos-roster-2025-12.json holds, per code, the pamphlet's own
#    qualifying-score sentence next to the gate the app carries
# 3. pull chapter 8 section B (the warrant occupations) the same way
python docs/research/extract_ch8b.py
#    -> writes docs/research/_raw/wo/chapter-8b-wo-specifications.txt
#    -> prints the code count, what is carried, what is excluded and what is gated
# 4. the tests enforce the invariants
flutter test test/mos_roster_test.dart test/warrant_mos_test.dart
```

`test/warrant_mos_test.dart` reads the chapter-8 extract back when it is on
disk, extracts every `8-XXXX` heading, and fails if a code the chapter specifies
is neither carried nor recorded as excluded - or if the app carries or excludes a
code the chapter does not print. It also re-derives which sections print an ASVAB
score and fails if that set is anything other than 280A and 490B.

`docs/research/mos-roster-2025-12.json` is the machine-readable companion to this
report: the authority's counts, the exclusion lists, and for each of the 156
codes the pamphlet's qualifying-score text beside the app's transcription.

## 9. Residual risk

What a recruiter could still tell a candidate that this app gets wrong:

1. **A gate has moved.** Highest risk, because it is invisible: the pamphlet is
   revised and the Army re-issues single sections between revisions. The app now
   shows the date it was checked, which is the honest mitigation - but a number
   with a date on it is still a number that can be out of date.
2. **State-level availability.** "The Guard fields 68D" and "your State has a
   slot for 68D" are different facts. The app knows only the first, and only in
   the sense the pamphlet states it.
3. **Waivers.** Several gates are waiverable in practice (79R and 79T print an
   explicit CG USAREC waiver). The app shows the published number and the waiver
   note where the pamphlet prints one. It does not model a waiver being granted.
4. **In-service-only MOS.** 12H, 18B-F, 25D, 31D, 79S and the special-duty codes
   are marked in their notes, but the app still evaluates them against a
   candidate's line scores, because a line score is genuinely part of the
   requirement. A candidate could read "qualified" on 31D and think they can
   enlist into CID.
5. **The 94T "ET" path.** If ET really means ST, one alternative path is missing
   from that one gate. Documented rather than guessed.
6. **Physical, medical and clearance gates** are not modelled at all. This is the
   largest class of "but you are not qualified" a recruiter can say to a
   candidate the app called eligible.
7. **The warrant prerequisites move faster than the chapter.** Proponents change
   feeder MOS lists, grade bands and certification requirements between pamphlet
   revisions, and two of the sections in this build were superseded inside the
   same chapter. The date beside them is the mitigation, not a guarantee.
8. **A candidate can still read a warrant occupation as a destination and stop
   planning the enlistment that would get them there.** The app says, on the card
   and in the section heading, that you cannot enlist into one and that the feeder
   MOS is printed with each entry - but the honest summary is that the app can
   only remove the ambiguity, not the wishful reading.
