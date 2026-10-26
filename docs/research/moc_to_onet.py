#!/usr/bin/env python3
"""Join the O*NET MOC crosswalk to the MOS codes this app carries.

What this does
--------------
The O*NET Military Occupational Classification (MOC) crosswalk links every US
military occupation code to one or more O*NET-SOC occupations. This script reads
the crosswalk XLSX, keeps the Army enlisted records that are still active, joins
them to the MOS codes in lib/data/repos/mos_data.dart, and emits:

  * lib/data/repos/mos_civilian_data.dart - the const map the app renders;
  * docs/MOS_CIVILIAN.md                 - the licence note and the coverage;
  * docs/research/moc-onet-join.json     - the raw join, for re-checking.

Nothing is inferred. A code the crosswalk does not cover is left out of the map
and named in the report, rather than given a plausible-looking title.

Which crosswalk records count
-----------------------------
The crosswalk's own Read Me defines the columns this script selects on:

  * SVC == 'A'      Army branch/AOC/MOS/reporting codes - not Navy, USMC etc.
  * MPC == 'E'      Military Personnel Category: Enlisted - not officer or
                    warrant, which is a different career question.
  * STATUS == 'A'   "Active (current) record". 'O' means "Obsolete (rescinded)",
                    so an obsolete row is another job that once held the same
                    code, not a description of today's one.

O*NET-SOC codes and titles come from the ONET1..4 / ONET1..4_TITLE column pairs,
in crosswalk order, de-duplicated. Titles are copied verbatim; they are never
rewritten, shortened or merged.

Licence
-------
O*NET content is CC BY 4.0. The required attribution string is written into the
generated Dart file and into docs/MOS_CIVILIAN.md; see ATTRIBUTION below.

Getting the input
-----------------
    https://www.onetcenter.org/crosswalks.html
      -> "Military Occupational Classification (MOC) in MS Access, XLSX, CSV
         formats (ZIP) - updated August 2024"
    -> docs/research/_raw/moc_crosswalk/military_crosswalk.zip
    -> unzip; the file used is military_crosswalk/milx0724.xlsx

docs/research/_raw/ is gitignored: the 2.6 MB XLSX is not committed, the
generated Dart file is. Re-running this script needs the download, and the
checksum below is what makes a re-download checkable.

Usage
-----
    python docs/research/moc_to_onet.py
    dart format lib/data/repos/mos_civilian.dart lib/data/repos/mos_civilian_data.dart
"""

from __future__ import annotations

import hashlib
import json
import re
import shutil
import subprocess
import sys
import zipfile
from collections import Counter
from pathlib import Path
import xml.etree.ElementTree as ET

# Markdown and inline-code punctuation, built here so this source file stays
# free of fence characters that would confuse a diff.
FENCE = chr(96) * 3
TICK = chr(96)

# --- what was read -----------------------------------------------------------

# The crosswalk build. "milx0724" is the file name inside the ZIP; the download
# page dates it "updated August 2024".
CROSSWALK_FILE = "milx0724.xlsx"
CROSSWALK_VERSION = "milx0724 (updated August 2024)"
CROSSWALK_ZIP_URL = "https://www.onetcenter.org/dl_files/2019/military_crosswalk.zip"
CROSSWALK_PAGE = "https://www.onetcenter.org/crosswalks.html"
CROSSWALK_SHA256 = (
    "ee7381411644fd39adaf93e7f3a8814773b28f4e8a5b2c00c7ad6b775b01d747"
)

# The day the ZIP was downloaded. Bump it when the file is re-downloaded, so the
# app never shows a date older than the data behind it.
RETRIEVED_ON = "26 October 2026"
RETRIEVED_ON_ISO = "2026-10-26"

# The attribution the CC BY 4.0 licence on O*NET content requires: the credit,
# the licence and its link, the trademark note, and a statement of what changed.
# Source of the wording: https://www.onetcenter.org/license.html ("If you make
# edits or additions to O*NET information").
# Kept as one string, with no apostrophes, so that the generated Dart literal
# and the markdown both contain it verbatim and a test can grep for it.
ATTRIBUTION = (
    "Includes information from O*NET Resource Center by the U.S. Department "
    "of Labor, Employment and Training Administration (USDOL/ETA). Used "
    "under the CC BY 4.0 license "
    "(https://creativecommons.org/licenses/by/4.0/). O*NET\u00ae is a "
    "trademark of USDOL/ETA. ASVAB Coach has modified all or some of this "
    "information: the O*NET Military Occupational Classification (MOC) "
    "crosswalk (milx0724, updated August 2024) was joined to the MOS codes "
    "this app carries and reformatted as Dart constants. USDOL/ETA has not "
    "approved, endorsed, or tested these modifications."
)

# --- where things live -------------------------------------------------------

ROOT = Path(__file__).resolve().parents[2]
XLSX = (
    ROOT
    / "docs"
    / "research"
    / "_raw"
    / "moc_crosswalk"
    / "extracted"
    / "military_crosswalk"
    / CROSSWALK_FILE
)
ZIP = ROOT / "docs" / "research" / "_raw" / "moc_crosswalk" / "military_crosswalk.zip"
ROSTER = ROOT / "lib" / "data" / "repos" / "mos_data.dart"
DART_OUT = ROOT / "lib" / "data" / "repos" / "mos_civilian_data.dart"
DOCS_OUT = ROOT / "docs" / "MOS_CIVILIAN.md"
JSON_OUT = ROOT / "docs" / "research" / "moc-onet-join.json"

# 200 characters is the app's ceiling for a one-line note, asserted by
# test/mos_civilian_test.dart.
NOTE_LIMIT = 200

NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"


# --- reading the crosswalk ---------------------------------------------------


def col_of(ref: str) -> str:
    """'AD12' -> 'AD'. Cells are sparse, so position in the row is not enough."""
    m = re.match(r"([A-Z]+)", ref or "")
    return m.group(1) if m else ""


def read_xlsx(path: Path) -> list[dict[str, str]]:
    """Rows of the first sheet, keyed by column letter, built with stdlib only.

    No openpyxl or pandas: the crosswalk is one sheet of ~40,000 rows, and a
    re-verifier should not have to install anything to check this file.
    """
    with zipfile.ZipFile(path) as z:
        shared = [
            "".join(t.text or "" for t in si.iter(NS + "t"))
            for si in ET.fromstring(z.read("xl/sharedStrings.xml"))
        ]
        sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
    rows: list[dict[str, str]] = []
    for row in sheet.iter(NS + "row"):
        cells: dict[str, str] = {}
        for c in row.iter(NS + "c"):
            kind, v = c.get("t"), c.find(NS + "v")
            if kind == "s" and v is not None:
                val = shared[int(v.text)]
            elif kind == "inlineStr":
                val = "".join(t.text or "" for t in c.iter(NS + "t"))
            else:
                val = v.text if v is not None else ""
            cells[col_of(c.get("r", ""))] = (val or "").strip()
        rows.append(cells)
    return rows


def roster_codes() -> list[str]:
    """The MOS codes the app carries, in file order, out of mos_data.dart."""
    src = ROSTER.read_text(encoding="utf-8")
    return re.findall(r"^\s*code: '([^']+)',", src, flags=re.MULTILINE)


def join(rows: list[dict[str, str]], codes: list[str]):
    """Army + Enlisted + Active rows -> {MOS: [(O*NET-SOC code, title), ...]}."""
    active: dict[str, list[dict[str, str]]] = {}
    for r in rows[1:]:
        if r.get("A") != "A" or r.get("B") != "E" or r.get("I") != "A":
            continue
        active.setdefault(r.get("C", ""), []).append(r)

    mapped: dict[str, dict] = {}
    omitted: dict[str, str] = {}
    for code in codes:
        hits = active.get(code, [])
        if not hits:
            omitted[code] = absence_reason(rows, code)
            continue
        pairs: list[tuple[str, str]] = []
        for r in hits:
            for c_col, t_col in (("Z", "AD"), ("AA", "AE"), ("AB", "AF"), ("AC", "AG")):
                onet, title = r.get(c_col, ""), r.get(t_col, "")
                if onet and onet != "-" and (onet, title) not in pairs:
                    pairs.append((onet, title))
        if not pairs:
            omitted[code] = (
                "the crosswalk's active Army enlisted record names no O*NET-SOC "
                "occupation"
            )
            continue
        mapped[code] = {"mocTitle": hits[0].get("D", ""), "pairs": pairs}
    return mapped, omitted


MPC_LABEL = {"E": "enlisted", "O": "officer", "W": "warrant officer"}


def ym(value: str) -> str:
    """'201610' -> '2016-10': a date a reader does not have to decode."""
    if re.fullmatch(r"\d{6}", value or ""):
        return value[:4] + "-" + value[4:]
    return value or "an unstated date"


def absence_reason(rows: list[dict[str, str]], code: str) -> str:
    """Why a carried code has no usable crosswalk record - stated, not guessed."""
    every = [r for r in rows[1:] if r.get("C") == code]
    if not every:
        return "the crosswalk carries no record for this code at all"
    if all(r.get("I") != "A" for r in every):
        what = sorted({MPC_LABEL.get(r.get("B", "?"), r.get("B", "?")) for r in every})
        ended = sorted({ym(r.get("K", "")) for r in every})
        return (
            "the crosswalk has only obsolete "
            + " / ".join(what)
            + " records for this code; the newest ended "
            + ended[-1]
        )
    what = sorted({MPC_LABEL.get(r.get("B", "?"), r.get("B", "?")) for r in every})
    return (
        "the crosswalk carries this code only as "
        + " / ".join(what)
        + ", and that record is not enlisted"
    )


# --- deciding what a MOS transfers to ---------------------------------------


def is_military(onet: str) -> bool:
    """O*NET-SOC 55-xxxx is O*NET's military block, not a civilian occupation."""
    return onet.startswith("55-")


def note_for(pairs: list[tuple[str, str]]) -> str:
    """One line for the screen, built from crosswalk titles and nothing else.

    Civilian titles are joined in crosswalk order. Where every O*NET-SOC code is
    in O*NET's military block (11B -> "Infantry", 55-3016.00), the note says so
    rather than implying a civilian job the crosswalk does not name.
    """
    titles = "; ".join(t for _, t in pairs)
    if all(is_military(onet) for onet, _ in pairs):
        codes = ", ".join(onet for onet, _ in pairs)
        return f"{titles} (O*NET-SOC {codes}; military occupation)"
    return titles


def dq(s: str) -> str:
    """A Dart single-quoted string literal for an arbitrary crosswalk title."""
    escaped = s.replace(chr(92), chr(92) * 2).replace("'", chr(92) + "'")
    return "'" + escaped.replace("$", chr(92) + "$") + "'"


# --- writing the outputs -----------------------------------------------------


def attribution_dart() -> str:
    return "    " + dq(ATTRIBUTION)


def dart_file(mapped: dict[str, dict], omitted: dict[str, str], total: int) -> str:
    entries = []
    for code, rec in mapped.items():
        occupations = "\n".join(
            "      (onetSocCode: {}, title: {}),".format(dq(onet), dq(title))
            for onet, title in rec["pairs"]
        )
        entries.append(
            "  {}: (\n"
            "    mocTitle: {},\n"
            "    occupations: <CivilianOccupation>[\n{}\n    ],\n"
            "    note: {},\n"
            "  ),".format(
                dq(code), dq(rec["mocTitle"]), occupations, dq(note_for(rec["pairs"]))
            )
        )
    lines = "\n".join(entries)
    pct = 100.0 * len(mapped) / total

    return f"""/// GENERATED FILE - do not edit by hand.
///
/// Regenerate with:
///
///     python docs/research/moc_to_onet.py
///     dart format lib/data/repos/mos_civilian.dart lib/data/repos/mos_civilian_data.dart
///
/// What this file is: what the O*NET Military Occupational Classification (MOC)
/// crosswalk records for each Army MOS this app carries, in civilian terms. The
/// join is done by docs/research/moc_to_onet.py; docs/MOS_CIVILIAN.md carries
/// the licence, the coverage and the codes the crosswalk does not cover.
///
/// Where the titles come from: the crosswalk's ONET1..ONET4_TITLE columns,
/// copied verbatim. Nothing here is written by hand and nothing is paraphrased.
/// Where the crosswalk names only an O*NET-SOC military occupation (55-xxxx,
/// e.g. 11B -> "Infantry"), [MosCivilianOutlook.note] says so instead of
/// inventing a civilian job title.
///
/// Which crosswalk records count: SVC=A (Army), MPC=E (enlisted), STATUS=A
/// (active). An obsolete row describes a different job that once held the same
/// code, so it is not used here.
///
/// Coverage: {len(mapped)} of the {total} MOS codes the app carries
/// ({pct:.1f}%), from the O*NET MOC crosswalk {CROSSWALK_VERSION}, retrieved
/// {RETRIEVED_ON}. Omitted, because the crosswalk does not cover them:
/// {", ".join(omitted)}.
///
/// LICENCE. O*NET content is CC BY 4.0. [mosCivilianAttribution] is the
/// attribution the licence requires; it has to travel with the data wherever
/// this is shown or redistributed.
library;

/// One occupation the crosswalk links an MOS to.
typedef CivilianOccupation = ({{String onetSocCode, String title}});

/// What the crosswalk says one MOS transfers to.
///
/// A record rather than a class: three fields, no behaviour, so the map below
/// can be a compile-time constant. [note] is the sentence a screen prints after
/// "In civilian life:" - under {NOTE_LIMIT} characters, asserted by
/// test/mos_civilian_test.dart. [mocTitle] is the crosswalk's own title for the
/// code, which is how a re-verifier matches a row without trusting this file.
typedef MosCivilianOutlook = ({{
  String mocTitle,
  List<CivilianOccupation> occupations,
  String note,
}});

/// The attribution the O*NET licence requires (CC BY 4.0), verbatim.
const String mosCivilianAttribution =
{attribution_dart()};

/// The licence the crosswalk data is used under.
const String mosCivilianLicence =
    'CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/)';

/// Where the crosswalk came from, in enough detail to re-do the work.
const String mosCivilianSource =
    'O*NET Military Occupational Classification (MOC) crosswalk, '
    '{CROSSWALK_VERSION}';

/// The download page the crosswalk was taken from.
const String mosCivilianSourceUrl = '{CROSSWALK_PAGE}';

/// The exact file inside the ZIP the join was made from.
const String mosCivilianSourceFile = '{CROSSWALK_FILE}';

/// SHA-256 of that ZIP, so a re-download can be checked.
const String mosCivilianSourceSha256 =
    '{CROSSWALK_SHA256}';

/// The day the crosswalk file was downloaded.
const String mosCivilianRetrievedOn = '{RETRIEVED_ON}';

/// The same date, in the form a data file wants.
const String mosCivilianRetrievedOnIso = '{RETRIEVED_ON_ISO}';

/// MOS code -> what the crosswalk says it transfers to.
///
/// {len(mapped)} of the {total} codes the app carries. A code missing from this map is
/// missing because the crosswalk has no active Army enlisted record for it -
/// docs/MOS_CIVILIAN.md lists them with the reason for each.
const Map<String, MosCivilianOutlook> mosCivilianByCode =
    <String, MosCivilianOutlook>{{
{lines}
}};"""


def docs_file(mapped: dict[str, dict], omitted: dict[str, str], total: int) -> str:
    rows = []
    for code, rec in mapped.items():
        titles = "; ".join(title for _, title in rec["pairs"])
        codes = ", ".join(onet for onet, _ in rec["pairs"])
        rows.append(f"| {code} | {rec['mocTitle']} | {codes} | {titles} |")
    omit_rows = [f"| {code} | {reason} |" for code, reason in omitted.items()]
    pct = 100.0 * len(mapped) / total
    mil = [c for c, r in mapped.items() if all(is_military(o) for o, _ in r["pairs"])]
    single = sum(1 for r in mapped.values() if len(r["pairs"]) == 1)
    mapped_rows = "\n".join(rows)
    omit_block = "\n".join(omit_rows)

    return f"""# MOS -> civilian occupation, from the O*NET MOC crosswalk

**What this answers.** A candidate looking at a job wants to know what the work
is worth outside the Army, without the app inventing a career. Every line below
is a row of the O*NET Military Occupational Classification (MOC) crosswalk,
joined to an MOS code this app carries. No title is paraphrased, merged or
guessed; where the crosswalk has no active Army enlisted record for a code, the
code is **left out** of lib/data/repos/mos_civilian_data.dart and named in
section 4.

| | |
|---|---|
| Crosswalk | O*NET Military Occupational Classification (MOC), **{CROSSWALK_VERSION}** |
| File used | military_crosswalk/{CROSSWALK_FILE}, inside military_crosswalk.zip |
| Downloaded from | <{CROSSWALK_PAGE}> on **{RETRIEVED_ON}** |
| SHA-256 of the ZIP | {CROSSWALK_SHA256} |
| Licence | **CC BY 4.0** |
| MOS codes carried by the app | **{total}** |
| Codes the crosswalk maps | **{len(mapped)}** ({pct:.1f}%) |
| Codes omitted | **{len(omitted)}** |
| Codes mapping to a single occupation only | {single} |
| Codes whose only O*NET-SOC match is a military occupation | {len(mil)} |

## 1. Licence and the required attribution

O*NET content is published under a Creative Commons Attribution 4.0
International licence (CC BY 4.0), which obliges this app to credit the
source, link the licence, and state what it changed. Three pages apply, all
read on {RETRIEVED_ON}:

- O*NET Resource Center Content License, which covers the crosswalks page
  itself: <https://www.onetcenter.org/license.html>
- O*NET Database Content License, which covers the O*NET content carried
  inside the crosswalk: <https://www.onetcenter.org/license_db.html>
- the licence text: <https://creativecommons.org/licenses/by/4.0/>

**The attribution string, verbatim**, is {TICK}mosCivilianAttribution{TICK} in
lib/data/repos/mos_civilian_data.dart and {TICK}MosCivilian.attribution{TICK} in
lib/data/repos/mos_civilian.dart:

> {ATTRIBUTION}

The wording is the "If you make edits or additions to O*NET information"
variant from the O*NET Resource Center Content License, with this app named
as the party that modified the material. It is one string rather than three
fragments so that a screen cannot print half of it: a screen that shows a
civilian occupation prints the credit line with it, under "In civilian
life: ...".

What was changed, as the licence requires us to state: the crosswalk's Army
enlisted rows were filtered to the active records, joined to this app's {total} MOS
codes, and reformatted as Dart constants. The occupation titles themselves are
copied verbatim and are unedited. USDOL/ETA has not approved, endorsed or tested
any of this.

## 2. Which crosswalk records count, and why

The crosswalk's own Read Me defines the columns this join selects on:

| Column | Value kept | Why |
|---|---|---|
| {TICK}SVC{TICK} | {TICK}A{TICK} | Army MOS/AOC/reporting codes. {TICK}N{TICK}, {TICK}M{TICK}, {TICK}F{TICK} and the rest are other services. |
| {TICK}MPC{TICK} | {TICK}E{TICK} | Enlisted. {TICK}O{TICK} and {TICK}W{TICK} are officer and warrant, a different career question. |
| {TICK}STATUS{TICK} | {TICK}A{TICK} | "Active (current) record". {TICK}O{TICK} is "Obsolete (rescinded)". |

The STATUS filter is the one that matters most. Codes get reused: 35F is now
"Intelligence Analyst", but the crosswalk still carries two obsolete 35F rows
(1965-1984 "Nuclear Weapons Electronics Specialist", 1995-2009 "Special
Electronic Devices Repairer"). Joining without the filter would tell a candidate
that an intelligence analyst's transferable job is precision-instrument repair.

O*NET-SOC codes and titles come from ONET1..ONET4 and ONET1..ONET4_TITLE, in
crosswalk order, de-duplicated. This is the DMDC-sourced MOC crosswalk that
O*NET OnLine's Military Transition Search is itself built on.

## 3. The mapped codes

"O*NET-SOC" is the code the crosswalk prints; "crosswalk title" is its
ONET*_TITLE, verbatim.

| MOS | Crosswalk MOC title | O*NET-SOC | Crosswalk title |
|---|---|---|---|
{mapped_rows}

## 4. The {len(omitted)} codes the crosswalk does not cover

These are in the app's roster and **not** in mosCivilianByCode. They are omitted
rather than filled in with a plausible title:

| MOS | Why there is no mapping |
|---|---|
{omit_block}

The gap has a dated explanation, not a data-entry excuse. 08H, 40D and 42T
were added to DA Pam 611-21 after the {CROSSWALK_VERSION} build, so no
crosswalk this app could download today would carry them. 19C exists in the
crosswalk only as an obsolete *officer* code ("Cavalry", ended 2016-10), and
15X and 88P only as obsolete enlisted codes, so none of the three describes
the job the app now lists under that code - a mapping taken from them would
name the wrong work.

Re-download the crosswalk and re-run the join when DMDC publishes a newer
build; the omitted list is the thing that should shrink.

## 5. What this does and does not claim

**Claims:** for {len(mapped)} of the {total} codes, the O*NET-SOC occupations the crosswalk
records against that code, with their titles verbatim.

**Does not claim:**

- that a title is an exhaustive list of what a soldier can do afterwards. It is
  what the crosswalk records, which for {single} codes is a single occupation;
- that a military-titled O*NET-SOC code is a civilian job. {len(mil)} codes map only to
  O*NET's military block (55-xxxx), for example 11B -> "Infantry" (55-3016.00).
  The app's note says so; the civilian equivalent for those is not something the
  crosswalk states, so it is not stated here either;
- that the crosswalk is current. It is the {CROSSWALK_VERSION} build,
  retrieved {RETRIEVED_ON}, and DMDC revises it; the retrieved date travels
  with the data for exactly that reason;
- that this is career advice. It is a sourced list of occupations; whether the
  work is open to a given candidate is a different question.

## 6. How to re-verify

{FENCE}bash
# 1. download the crosswalk (docs/research/_raw/ is gitignored)
#    https://www.onetcenter.org/crosswalks.html -> MOC crosswalk ZIP
#    unzip to docs/research/_raw/moc_crosswalk/extracted/
# 2. check the ZIP against the SHA-256 above, then rebuild the join
python docs/research/moc_to_onet.py
dart format lib/data/repos/mos_civilian.dart lib/data/repos/mos_civilian_data.dart
# 3. the invariants are tested
flutter test test/mos_civilian_test.dart
{FENCE}

docs/research/moc-onet-join.json is the machine-readable companion: per code,
the crosswalk MOC title, the O*NET-SOC codes and titles, the note as rendered,
and the omitted codes with their reasons.
"""


def main() -> int:
    if not XLSX.exists():
        print(f"missing crosswalk file: {XLSX}", file=sys.stderr)
        print(f"download {CROSSWALK_ZIP_URL} and unzip it there", file=sys.stderr)
        return 1

    digest = hashlib.sha256(ZIP.read_bytes()).hexdigest()
    print(f"crosswalk: {CROSSWALK_VERSION}  ({CROSSWALK_FILE})")
    print(f"zip sha256: {digest}")
    if digest != CROSSWALK_SHA256:
        print("WARNING: the ZIP does not match the recorded checksum", file=sys.stderr)

    rows = read_xlsx(XLSX)
    seen = [rows[0].get(c, "") for c in ("A", "B", "C", "I", "Z", "AD")]
    print(f"sheet: {len(rows) - 1} data rows, columns {seen}")

    codes = roster_codes()
    if len(codes) != len(set(codes)):
        print("roster has duplicate codes; a map would drop one silently", file=sys.stderr)
        return 1

    mapped, omitted = join(rows, codes)

    # The invariants the Dart test asserts, checked here so that a bad join never
    # reaches the app in the first place.
    for code, rec in mapped.items():
        note = note_for(rec["pairs"])
        assert note.strip(), f"{code}: empty note"
        assert len(note) < NOTE_LIMIT, f"{code}: note is {len(note)} characters"
        assert rec["mocTitle"].strip(), f"{code}: empty crosswalk title"
        for onet, title in rec["pairs"]:
            assert re.fullmatch(r"\d\d-\d{4}\.\d\d", onet), f"{code}: odd code {onet}"
            assert title.strip(), f"{code}: {onet} has no title"

    total = len(codes)
    DART_OUT.write_text(dart_file(mapped, omitted, total), encoding="utf-8", newline="\n")
    DOCS_OUT.write_text(docs_file(mapped, omitted, total), encoding="utf-8", newline="\n")
    JSON_OUT.write_text(
        json.dumps(
            {
                "source": {
                    "name": "O*NET Military Occupational Classification (MOC) crosswalk",
                    "version": CROSSWALK_VERSION,
                    "page": CROSSWALK_PAGE,
                    "file": CROSSWALK_FILE,
                    "zipSha256": CROSSWALK_SHA256,
                    "retrievedOn": RETRIEVED_ON_ISO,
                    "licence": "CC BY 4.0",
                    "attribution": ATTRIBUTION,
                },
                "selection": {"SVC": "A", "MPC": "E", "STATUS": "A"},
                "counts": {
                    "carried": total,
                    "mapped": len(mapped),
                    "omitted": len(omitted),
                },
                "mapped": {
                    code: {
                        "mocTitle": rec["mocTitle"],
                        "occupations": [
                            {
                                "onetSocCode": onet,
                                "title": title,
                                "militaryOnly": is_military(onet),
                            }
                            for onet, title in rec["pairs"]
                        ],
                        "note": note_for(rec["pairs"]),
                    }
                    for code, rec in mapped.items()
                },
                "omitted": omitted,
            },
            indent=1,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
        newline="\n",
    )

    # The emitted Dart is layout-stable except for record literals that the
    # formatter splits, so format it here: it keeps a regenerated file
    # byte-identical to the committed one.
    formatter = shutil.which("dart")
    if formatter:
        subprocess.run(
            [formatter, "format", str(DART_OUT), str(ROOT / "lib/data/repos/mos_civilian.dart")],
            cwd=ROOT,
            check=False,
        )
    else:
        print("dart not on PATH: run 'dart format lib' before committing")

    per_code = Counter(len(r["pairs"]) for r in mapped.values())
    print(f"wrote {DART_OUT.relative_to(ROOT).as_posix()}")
    print(f"wrote {DOCS_OUT.relative_to(ROOT).as_posix()}")
    print(f"wrote {JSON_OUT.relative_to(ROOT).as_posix()}")
    print(
        "occupations per code: "
        + ", ".join(f"{n} title(s) x{per_code[n]}" for n in sorted(per_code))
    )
    print(
        f"coverage: {len(mapped)} of {total} MOS codes mapped "
        f"({100.0 * len(mapped) / total:.1f}%), {len(omitted)} omitted: "
        + ", ".join(omitted)
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
