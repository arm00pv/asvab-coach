/// The warrant officer occupations, transcribed from DA Pam 611-21 chapter 8.
///
/// **Why this file exists, and why it is separate from `mos_data.dart`.** The
/// enlisted roster in [allMos] was diffed against chapter 10 section C, and that
/// diff said so in its own report (docs/MOS_GAP.md section 5): the warrant officer
/// occupations were missing, deliberately, because they are a different kind of
/// thing. This file is the honest close of that gap. It carries them as
/// [MosAppointment.warrantOfficer] entries, in their own list, so that:
///
///  * the 156 enlisted entries are untouched in count and in content - a warrant
///    entry is not in [allMos] and cannot reach an enlisted filter, an enlisted
///    count, or an eligibility verdict;
///  * a candidate who has not served is never offered one. Warrant appointment is
///    made from the ranks (see [Mos.requiresPriorService]) and every screen that
///    shows these entries says so.
///
/// **What the authority publishes for a warrant occupation is not a line score.**
/// A chapter 8 section prints, in this order: licensing and certification
/// requirements, prerequisites, the accession status and the feeder MOSs, the
/// associated SQI and ASI codes, the grade-by-grade qualifications (course,
/// clearance, physical, security), the duties, and - as "qualifying scores" - the
/// OPAT physical benchmarks. It prints no aptitude-area requirement at all except
/// in two sections: 280A and 490B, which each require an ASVAB GT score of 110 with
/// no waivers. Those two carry a [Mos.gate]; every other entry here carries
/// [MosGateStatus.noRequirement] and the section's own prerequisites instead,
/// which is a different fact from "no requirement" on a musician MOS: the
/// requirement exists, and it is a grade band, a feeder MOS, a course, a physical
/// and a board.
///
/// **What was left out, and why** (see [mosWarrantExcluded]): 011A and 011M are
/// branch- and MOS-immaterial duty positions with no occupation behind them - the
/// warrant analogue of the 00-series position reporting codes the enlisted roster
/// excludes - and 255Z, 915E and 948E are CW5 capstone codes, the warrant
/// counterpart of the E7-E9 supervisory codes the enlisted roster also excludes.
/// They are recorded rather than dropped, so nobody rediscovers them as a gap.
///
/// House rules, the same ones the enlisted data keeps:
///
///  * a prerequisite is a transcription, and the section it came from is in
///    [Mos.source];
///  * a description is a paraphrase of that section's duties paragraph, cited with
///    the chapter-8 URL and the day it was read, or it is null - 351Y's duties are
///    not in this chapter at all (they are "see AR 614-115"), so it has none;
///  * nothing is invented to fill a space, and `test/warrant_mos_test.dart` holds
///    every value here to the same provenance rules the enlisted descriptions meet.
///
/// Requirements change. The Army re-issues single sections between revisions, and
/// a warrant officer recruiter or a proponent has the live prerequisites.
library;

import '../models/catalog.dart';
import '../models/line_score.dart';
import '../models/mos.dart';
import 'mos_repository.dart';

/// When this list was worked through against the authority. Shown to a candidate
/// beside the enlisted roster's date, because both are claims that can go stale.
const String mosWarrantVerifiedAsOf = '26 October 2026';

/// What it was verified against: the warrant chapter of the same pamphlet, from
/// the same build as the enlisted chapter.
const String mosWarrantAuthority =
    'DA Pam 611-21, chapter 8, section B (Warrant officer MOS specifications), '
    '04 December 2025 build';

/// The sentence that has to travel with the prerequisites, in the same shape as
/// the enlisted roster's caveat.
const String mosWarrantCaveat =
    'Transcribed from the pamphlet, not from a warrant officer recruiter. These '
    'are the published prerequisites and a board applies them; the live list is '
    'with the proponent and USAREC.';

/// The chapter file these entries were read out of, as published by the MOS
/// Smartbook build of the pamphlet.
const String _chapter8bUrl =
    'https://api.army.mil/e2/c/downloads/2025/12/04/720183c2/'
    'chapter-8b-wo-specifications.pdf';

/// The day every entry below was read out of that chapter file.
final DateTime _retrievedOn = DateTime(2026, 10, 26);

/// One pamphlet-cited sentence about a warrant occupation, with the citation
/// that makes it showable. Nothing about the citation is optional.
SourcedText _pam(String text) => SourcedText(
  text: text,
  sourceUrl: _chapter8bUrl,
  retrievedOn: _retrievedOn,
  sourceKind: MosSourceKind.pamphlet,
);

/// A section reference, so every entry says where in the chapter it came from.
String _sec(String section) => 'DA Pam 611-21 ch.8 sec.B, section $section';

/// Codes section B specifies that this roster deliberately does not carry, with
/// the reason, so an absence is a recorded decision rather than a hole.
///
/// A test asserts that each of these is absent from [warrantMosData] and that no
/// other section-B code is missing from it.
const Map<String, String> mosWarrantExcluded = <String, String>{
  '011A':
      'Branch/MOS immaterial duty position, not an occupation: the section '
      'describes where such positions sit, not a specialty an applicant is '
      'appointed into.',
  '011M':
      'Branch/MOS immaterial, grade immaterial duty position (Army Software '
      'Factory posts): a position code, not an occupation.',
  '255Z':
      'CW5 capstone of 255A/255N/255S. Non-accession, and its own section prints '
      'no WO1-CW2 duties: "WO1/CW2/CW3/CW4 does not apply".',
  '915E':
      'CW5 capstone of the 91-series maintenance warrant occupations, "CW5 only", '
      'non-accession; the section defers its warrant-officer duties to the feeder '
      'MOSs.',
  '948E':
      'CW5 capstone of 948B and 948D, non-accession; its WO1-CW4 duties are "see '
      'MOS 948B or MOS 948D".',
};

/// The aviation physical every pilot section prints in the same words.
const String _flightPhysical =
    'Class I flight physical: physical profile 111121, red/green colour '
    'vision, correctable to 20/50 distant and 20/20 near.';

/// The physical benchmark the sections print under "qualifying scores". OPAT is
/// a physical assessment, not an aptitude area, which is why it is a
/// prerequisite here and not a [Mos.gate].
const String _opatGold =
    'OPAT in Physical Demand Category Moderate (Gold): long jump 120 cm, seated '
    'power throw 350 cm, deadlift 120 lb, 36-shuttle run.';

/// The warrant officer occupations, in code order.
///
/// Every entry is [MosAppointment.warrantOfficer] and therefore
/// [Mos.requiresPriorService]: a candidate who has not served is not short of
/// these requirements, they are outside their premise.
final List<Mos> warrantMosData = <Mos>[
  Mos(
    code: '120A',
    title: 'Construction Engineering Technician',
    category: MosCategory.combatSupportEngineer,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 12H, 12K, 12N, 12P, 12Q, 12R, 12T and 12W, plus Air Force 3E0xx and USMC 1169, 1361 and 1141.',
      'Construction Engineering Technician Warrant Officer Basic Course.',
      'SECRET eligibility; vision and hearing per AR 40-501 for Engineer Branch, normal colour discrimination and full use of both hands.',
      'Physical demands Moderate (Gold) and the matching OPAT score.',
    ],
    description: _pam(
      'Leads construction operations for the commander: supervises base camps and '
      'vertical construction, prepares bills of materials and work schedules, and '
      'inspects projects against drawings, specifications and local codes.',
    ),
    source: _sec('8-120A'),
  ),
  Mos(
    code: '125D',
    title: 'Geospatial Engineering Technician',
    category: MosCategory.combatSupportEngineer,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 12Y and 35G, plus USMC 0261.',
      'Geospatial Engineering Technician Warrant Officer Basic Course.',
      'SECRET eligibility and the engineer assignment physical standard the section cites from AR 40-501.',
    ],
    description: _pam(
      'Directs geospatial engineering operations: finds the gaps in geospatial '
      'coverage, coordinates collection and production of the foundation data '
      'commanders plan on, and manages the geospatial architecture.',
    ),
    source: _sec('8-125D'),
  ),
  Mos(
    code: '131A',
    title: 'Targeting Technician',
    category: MosCategory.combatArms,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202410',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 11B, 11C, 19D, 19K and any CMF 13 MOS.',
      'Targeting Technician Warrant Officer Basic Course; 20/40 correctable vision and hearing per AR 40-501.',
      _opatGold,
    ],
    description: _pam(
      'Target acquisition and fire support work: plans and runs field artillery '
      'radar operations, advises on the technical and tactical employment of those '
      'radars, and trains the crews that operate them.',
    ),
    source: _sec('8-131A'),
  ),
  Mos(
    code: '140A',
    title: 'Air and Missile Defense Systems Integrator',
    category: MosCategory.airDefense,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; primary feeder MOSs 14G and 14H.',
      'AMD Systems Integrator Warrant Officer Basic Course; SECRET eligibility.',
      'Vision correctable to 20/20 with normal colour discrimination and normal hearing; a profile that allows assignment to remote locations.',
      _opatGold,
    ],
    description: _pam(
      'Technical advisor on how air and missile defence systems are employed and '
      'linked: interprets engagement and communications data across the services '
      'and advises on system capability and configuration.',
    ),
    source: _sec('8-140A'),
  ),
  Mos(
    code: '140K',
    title: 'Air and Missile Defense Systems Tactician',
    category: MosCategory.airDefense,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 14E, 14G, 14H, 14P and 14T.',
      'The AMD Systems Tactician warrant officer course the section names; SECRET eligibility.',
      _opatGold,
    ],
    description: _pam(
      'Runs the battery fire control crew and the air battle: identifies and '
      'engages tracks under published rules, weighs the risk to defended assets and '
      'keeps battery and battalion fire control in step.',
    ),
    source: _sec('8-140K'),
  ),
  Mos(
    code: '140L',
    title: 'Air and Missile Defense Systems Technician',
    category: MosCategory.airDefense,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 14E, 14G, 14H, 14P, 14T, 91D, 94M, 94S, 94T and 94Y.',
      'The AMD Systems Technician warrant officer course the section names; SECRET eligibility.',
      _opatGold,
    ],
    description: _pam(
      'Leads the maintenance side of air and missile defence: installs, repairs, '
      'tests and modifies the systems, their ancillary equipment and test sets, and '
      'advises the commander on readiness.',
    ),
    source: _sec('8-140L'),
  ),
  Mos(
    code: '150A',
    title: 'Air Traffic and Air Space Management Technician',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202405',
    prerequisites: <String>[
      'Accession MOS; feeder MOS 15Q.',
      'Graduate of a military air traffic control school, and holder of an FAA Form 7220-1 or Air Traffic Safety Oversight Service credential with a tower or approach rating.',
      'Aviation Warrant Officer Basic Course; SECRET eligibility; vision, hearing and colour per AR 40-501, full use of both hands.',
    ],
    description: _pam(
      'Manages air traffic control and the airspace itself: supervises enlisted '
      'controllers, develops and reviews terminal and en-route procedures, and sets '
      'control zones and special use airspace.',
    ),
    source: _sec('8-150A'),
  ),
  Mos(
    code: '150U',
    title: 'Unmanned Aircraft Systems Operations Technician',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 15W and 15E. A 15W applicant must already be a qualified air vehicle or mission payload operator on Hunter, Shadow or ERMP.',
      'Aviation Warrant Officer Basic Course; vision, hearing and colour per AR 40-501, full use of both hands.',
      _opatGold,
    ],
    description: _pam(
      'Leads unmanned aircraft operations: plans the mission, manages the launch, '
      'recovery and payload crews, and advises the commander on how the system is '
      'best employed.',
    ),
    source: _sec('8-150'),
  ),
  Mos(
    code: '151A',
    title: 'Aviation Maintenance Technician',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every CMF 15 soldier is a feeder.',
      'Aviation Warrant Officer Basic Course; SECRET eligibility; vision, hearing and colour per AR 40-501, full use of both hands.',
      _opatGold,
    ],
    description: _pam(
      'Manages aircraft maintenance end to end: power plants, powertrains, '
      'electrical and avionics systems, armament and pneudraulics, the technical '
      'publication libraries, and the soldiers who do the work.',
    ),
    source: _sec('8-151'),
  ),
  Mos(
    code: '152B',
    title: 'OH-58A/C Scout Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the OH-58A/C scout helicopter on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-152'),
  ),
  Mos(
    code: '152C',
    title: 'OH-6 Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'The section marks 152C as a non-accession MOS.',
    prerequisites: <String>[
      'Non-accession MOS: appointed from a serving aviator.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the OH-6 light observation helicopter on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-152'),
  ),
  Mos(
    code: '152D',
    title: 'OH-58D Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the OH-58D Kiowa Warrior on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-152'),
  ),
  Mos(
    code: '152E',
    title: 'AH-64E Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the AH-64E Apache on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-152'),
  ),
  Mos(
    code: '152F',
    title: 'AH-64A Attack Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the AH-64A Apache on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-152'),
  ),
  Mos(
    code: '152H',
    title: 'AH-64D Attack Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the AH-64D Apache Longbow on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-152'),
  ),
  Mos(
    code: '153A',
    title: 'Rotary Wing Aviator (Aircraft Nonspecific)',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Non-accession MOS: the section marks 153A as one, appointed from a serving aviator.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands assigned rotary-wing aircraft on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-153'),
  ),
  Mos(
    code: '153D',
    title: 'UH-60 Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the UH-60 Black Hawk on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-153'),
  ),
  Mos(
    code: '153E',
    title: 'MH-60 Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'The section contradicts itself on accession status: "MOS 153D, 153E, 153L and 153M are accession MOS" and then "MOS 153A and 153E are non-accession MOS". The app records the contradiction rather than picking one.',
    prerequisites: <String>[
      'Listed as an accession MOS and, in the next sentence, as a non-accession MOS; confirm which with a recruiter.',
      _flightPhysical,
      'TOP SECRET eligibility, which this code alone of the 153 series requires. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the MH-60 on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-153'),
  ),
  Mos(
    code: '153L',
    title: 'UH-72A Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Reserve Component only, as printed in the section heading.',
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the UH-72A Lakota on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-153'),
  ),
  Mos(
    code: '153M',
    title: 'UH-60M Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the UH-60M Black Hawk on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-153'),
  ),
  Mos(
    code: '154C',
    title: 'CH-47D Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the CH-47D Chinook on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-154'),
  ),
  Mos(
    code: '154E',
    title: 'MH-47 Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Non-accession MOS: appointed from a serving aviator.',
      _flightPhysical,
      'TOP SECRET eligibility, which this code alone of the 154 series requires. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the MH-47 on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-154'),
  ),
  Mos(
    code: '154F',
    title: 'CH-47F Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS is a feeder MOS.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the CH-47F Chinook on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-154'),
  ),
  Mos(
    code: '155A',
    title: 'Fixed Wing Aviator (Aircraft Nonspecific)',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Non-accession MOS; the feeder is any WO1 or CW2 already qualified in AOC 152, 153 or 154.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands assigned fixed-wing aircraft on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-155'),
  ),
  Mos(
    code: '155E',
    title: 'C-12 Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Non-accession MOS; the feeder is any WO1 or CW2 already qualified in AOC 152, 153 or 154.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the C-12 Huron on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-155'),
  ),
  Mos(
    code: '155F',
    title: 'Jet Aircraft Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Non-accession MOS; the feeder is any WO1 or CW2 already qualified in AOC 152, 153 or 154.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the jet aircraft on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-155'),
  ),
  Mos(
    code: '155G',
    title: 'O-5A/EO-5B/RC-7 Pilot',
    category: MosCategory.aviation,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Non-accession MOS; the feeder is any WO1 or CW2 already qualified in AOC 152, 153 or 154.',
      _flightPhysical,
      'SECRET eligibility. Aviation Warrant Officer Basic Course.',
      _opatGold,
    ],
    description: _pam(
      'Flies and commands the O-5A, EO-5B or RC-7 on tactical and non-tactical missions: plans the flight, calculates load, fuel and route, supervises loading and briefs before and after.',
    ),
    source: _sec('8-155'),
  ),
  Mos(
    code: '170A',
    title: 'Cyber Warfare Technician',
    category: MosCategory.cyberEw,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202507',
    prerequisites: <String>[
      'Accession MOS; the preferred feeders are the 17, 25 and 35 series, and any other enlisted MOS with documented operational experience and education may apply.',
      'TOP SECRET clearance, fully adjudicated, with SCI eligibility, held before Warrant Officer Candidate School.',
      'Counterintelligence scope polygraph; refusing or failing it reclassifies the soldier. Cyber Warfare Technician Warrant Officer Basic Course.',
    ],
    description: _pam(
      'Leads cyberspace operations teams: plans and integrates offensive and '
      'defensive missions, sets collection, exploitation and reporting priorities, '
      'and advises commanders on cyber effects.',
    ),
    source: _sec('8-170A'),
  ),
  Mos(
    code: '170B',
    title: 'Electromagnetic Warfare Technician',
    category: MosCategory.cyberEw,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202507',
    prerequisites: <String>[
      'Accession MOS; the preferred feeders are 17E, 25E, 25S, 35N and 35S, and any other enlisted MOS with documented electronic-warfare experience may apply.',
      'TOP SECRET clearance with SCI eligibility before Warrant Officer Candidate School.',
      'Electromagnetic Warfare Technician Warrant Officer Basic Course.',
    ],
    description: _pam(
      'Organises and evaluates electromagnetic warfare: advises on the attack, '
      'support and protection employment of assigned and supporting systems, and '
      'keeps the unit able to maintain them.',
    ),
    source: _sec('8-170'),
  ),
  Mos(
    code: '170D',
    title: 'Cyber Capability Developer Technician',
    category: MosCategory.cyberEw,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202507',
    prerequisites: <String>[
      'Accession MOS; any MOS is a feeder, and applicants from the other services are encouraged to apply with evaluations, awards and certificates as evidence.',
      'Intermediate programming ability and a basic command of data structures, algorithms, object-oriented design, operating systems, x86 assembly and SQL.',
      'The section prints no clearance, course or physical line in its WO1-CW2 paragraph; it states the technical level instead.',
    ],
    description: _pam(
      'Writes and maintains the software cyber teams operate: works a task list '
      'at basic level across secure design, data structures, algorithms and SQL, and '
      'hands work on to senior developers.',
    ),
    source: _sec('8-170D'),
  ),
  Mos(
    code: '180A',
    title: 'Special Forces Warrant Officer',
    category: MosCategory.specialOps,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 18B, 18C, 18D, 18E, 18F and 18Z.',
      'TOP SECRET with SCI eligibility; Special Forces Warrant Officer Technical and Tactical Certification Course.',
      'Parachute duty, the Special Forces swim test, a language rating of 2/2 on a current DA Form 330, and the Special Forces medical standards of AR 40-501 including SERE and free-fall.',
    ],
    description: _pam(
      'Commands a Special Forces Operational Detachment Alpha, or half of one in '
      'split-team operations, and advises on Special Forces operations, '
      'intelligence, logistics and civil-military work.',
    ),
    source: _sec('8-180A'),
  ),
  Mos(
    code: '255A',
    title: 'Data Operations Warrant Officer',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; any MOS is a feeder, including other services, with evaluations, awards and certificates in information systems work as evidence.',
      'CompTIA Security+ CE, or the DoD 8570.01-M IAT Level II and IAM Level I certifications.',
      'The section sets no aptitude gate; it sets the certification line above.',
    ],
    description: _pam(
      'Designs, configures and sustains the information systems and services the '
      'Army runs on the DoD information networks, and advises the commander or '
      'signal officer on how they are run and secured.',
    ),
    source: _sec('8-255A'),
  ),
  Mos(
    code: '255N',
    title: 'Network Systems Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; any MOS is a feeder, with documented experience in voice and data internetworking as the evidence.',
      'CompTIA Security+ CE, or the DoD 8570.01-M IAT Level II and IAM Level I certifications.',
      'The section sets no aptitude gate; it sets the certification line above.',
    ],
    description: _pam(
      'Designs and sustains voice, video and data networks: implements '
      'cybersecurity and key policy, monitors assigned networks and sub-networks, '
      'and advises the signal officer on their status.',
    ),
    source: _sec('8-255N'),
  ),
  Mos(
    code: '255S',
    title: 'Cyberspace Defense Warrant Officer',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; any MOS is a feeder, with documented experience in cyber security and computer network defence as the evidence.',
      'TOP SECRET clearance with SCI access, and the MOS 255S Warrant Officer Basic Course.',
      'CompTIA Security+ CE; vision and hearing per AR 40-501 for Signal Corps, normal colour discrimination, full use of both hands.',
    ],
    description: _pam(
      'Defends the network: builds the architecture, enumerates and eradicates '
      'threats, and responds to intrusions, data exfiltration and other activity '
      'against the DoD information networks.',
    ),
    source: _sec('8-255S'),
  ),
  Mos(
    code: '270A',
    title: 'Legal Administrator',
    category: MosCategory.legal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 27D. The Judge Advocate General certifies warrant officers to serve in the JAGC.',
      'No conviction by special or general court-martial, or of the offences in AR 27-10 chapter 24.',
      'Judge Advocate Warrant Officer Basic Course and the resident Legal Administrators Course at the Judge Advocate General\'s School.',
    ],
    description: _pam(
      'Runs legal office administration across the JAGC disciplines: systems and '
      'knowledge management, the legal budget and contracts, personnel training and '
      'readiness, force management and office security.',
    ),
    source: _sec('8-270A'),
  ),
  Mos(
    code: '280A',
    title: 'Software Operations Technician',
    category: MosCategory.cyberEw,
    appointment: MosAppointment.warrantOfficer,
    gate: g('GT 110'),
    note: 'The section requires an ASVAB GT score of 110 with no waivers, SGT or above, and the Warrior Leaders Course. Effective 202507.',
    prerequisites: <String>[
      'Accession MOS; any MOS is a feeder. SGT (E-5) or above, Warrior Leaders Course complete.',
      'ASVAB GT score of 110, no waivers - the only aptitude figure in the chapter outside 490B.',
      'U.S. citizenship and the administrative requirements for warrant officer appointment.',
    ],
    description: _pam(
      'Writes and sustains Army software: applies software development, secure '
      'design, product management and platform engineering practice to deliver and '
      'maintain operational systems.',
    ),
    source: _sec('8-280A'),
  ),
  Mos(
    code: '311A',
    title: 'CID Special Agent',
    category: MosCategory.militaryPolice,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 31D, and acceptance into the Special Agent program under AR 195-3.',
      'No conviction by special or general court-martial, or of the offences in AR 27-10 chapter 24.',
      'The prerequisites are AR 195-3 and DA Cir 601 series; the section sets no aptitude gate.',
    ],
    description: _pam(
      'Investigates felony and other significant crime: plans and runs overt and '
      'covert investigations, processes crime scenes, collects evidence, interviews '
      'witnesses and subjects, and executes arrest and search warrants.',
    ),
    source: _sec('8-311A'),
  ),
  Mos(
    code: '350F',
    title: 'All Source Intelligence Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 35F.',
      'TOP SECRET with SCI eligibility; All-Source Intelligence Technician Military Intelligence Warrant Officer Basic Course.',
      'The section sets no aptitude gate and no physical beyond the chapter standard.',
    ],
    description: _pam(
      'Serves as the command\'s all-source expert: turns reporting from every '
      'intelligence discipline into finished intelligence for the commander and '
      'advises on planning and collection.',
    ),
    source: _sec('8-350F'),
  ),
  Mos(
    code: '350G',
    title: 'Geospatial-Intelligence Imagery Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 35G.',
      'TOP SECRET with SCI eligibility; Geospatial-Intelligence Imagery Technician Military Intelligence Warrant Officer Basic Course.',
      'GPC-F certification is desired at this level, not required.',
    ],
    description: _pam(
      'Directs geospatial-intelligence operations: sets requirements, runs '
      'tasking, collection, processing, exploitation and dissemination in support of '
      'joint targeting, and advises the command.',
    ),
    source: _sec('8-350G'),
  ),
  Mos(
    code: '351L',
    title: 'Counterintelligence Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 35L. Prerequisites are DA Pam 611-21 and AR 381-20; AR 381-14 governs SQI W.',
      'TOP SECRET with SCI eligibility; Counterintelligence Technician Military Intelligence Warrant Officer Basic Course.',
      'The section sets no aptitude gate.',
    ],
    description: _pam(
      'Directs counterintelligence operations and investigations as the '
      'command\'s principal CI advisor, manages CI support to military decision '
      'making, and conducts the work within the law and policy.',
    ),
    source: _sec('8-351L'),
  ),
  Mos(
    code: '351M',
    title: 'Human Intelligence Collection Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202410',
    prerequisites: <String>[
      'Accession MOS; feeder MOS 35M, and USMC 0211.',
      'TOP SECRET with SCI eligibility; Human Intelligence Collector Technician Military Intelligence Warrant Officer Basic Course.',
      'A language-capable MOS under AR 11-6 paragraph 7-2b(2).',
    ],
    description: _pam(
      'Plans and directs interrogation, source, debriefing, screening and liaison '
      'operations and HUMINT analysis, and advises the command on HUMINT policy, '
      'training and procedure.',
    ),
    source: _sec('8-351M'),
  ),
  Mos(
    code: '351Y',
    title: 'Area Intelligence Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Not an accession MOS and it has no enlisted feeder. Its duties are not printed in this chapter - the section says "see AR 614-115" - which is why this entry carries no description.',
    prerequisites: <String>[
      'Not an accession MOS; there is no enlisted feeder MOS. Prerequisites are DA Pam 611-21 and AR 614-115.',
      'TOP SECRET with SCI eligibility; Military Intelligence Warrant Officer Basic Course including the appropriate track course.',
      'AR 381-14 governs ASI 9L. The section sets no aptitude gate.',
    ],
    description: null,
    source: _sec('8-351Y'),
  ),
  Mos(
    code: '351Z',
    title: 'Attache Intelligence Operations Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; every enlisted MOS holding SQI 7 (Attache) may apply, and applicants must have Defense Attache Service experience. Prerequisites are DA Pam 611-21 and AR 611-60.',
      'TOP SECRET with SCI eligibility; Attache Intelligence Operations Technician Military Intelligence Warrant Officer Basic Course.',
      'The section sets no aptitude gate.',
    ],
    description: _pam(
      'Leads the joint operations and administrative support team in a Defense '
      'Attache Office abroad: advises the senior defense official, represents the '
      'Department of Defense and liaises with host-nation officials.',
    ),
    source: _sec('8-351Z'),
  ),
  Mos(
    code: '352N',
    title: 'Signals Intelligence Analysis Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 35N, 35P and 35S.',
      'TOP SECRET with SCI eligibility, a counterintelligence scope polygraph before the MOS is awarded and eligibility for NSA system and facility access.',
      'The section sets no aptitude gate.',
    ],
    description: _pam(
      'Manages the soldiers and equipment that collect, process, exploit and '
      'report signals intelligence, setting collection and reporting priorities '
      'across tactical, operational and strategic requirements.',
    ),
    source: _sec('8-352N'),
  ),
  Mos(
    code: '352S',
    title: 'Signals Collector Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202211',
    prerequisites: <String>[
      'Accession MOS; feeder MOS 35S. Holders must be graduates of the Intermediate Communications Signals Analysis Course or the Intermediate Technical Electronic Intelligence Analysis Course, or have completed the Military Cryptologic Signals Analyst course.',
      'TOP SECRET with SCI eligibility, a counterintelligence scope polygraph and eligibility for NSA system and facility access.',
      'The section sets no aptitude gate.',
    ],
    description: _pam(
      'Manages signals collection crews and their training, coordinates the staff '
      'work that meets the commander\'s intelligence requirements, and reports what '
      'the collection produces.',
    ),
    source: _sec('8-352S'),
  ),
  Mos(
    code: '353T',
    title: 'Intelligence Systems Integration and Maintenance Technician',
    category: MosCategory.intelSignal,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 35T.',
      'TOP SECRET with SCI eligibility; Intelligence Systems Integration and Maintenance Technician Military Intelligence Warrant Officer Basic Course.',
      'SEC+ and NET+ certifications are desired, not required.',
    ],
    description: _pam(
      'Advises on the management and maintenance of intelligence, surveillance and '
      'reconnaissance systems and networks, and oversees shop and facility work for '
      'ground and airborne systems.',
    ),
    source: _sec('8-353'),
  ),
  Mos(
    code: '390A',
    title: 'Robotics Technician',
    category: MosCategory.specialOps,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202510',
    prerequisites: <String>[
      'Accession MOS; the enlisted and officer feeder is any MOS.',
      'TOP SECRET with SCI eligibility; Special Operations Robotics Technician Warrant Officer Basic Course and the Warrant Officer Intermediate Course.',
      'Physical standards per AR 40-501 chapter 2.',
    ],
    description: _pam(
      'Designs, builds, employs and maintains robotics and autonomous systems, '
      'plans their integration into training and operations, and advises the '
      'battalion commander and staff on their use.',
    ),
    source: _sec('8-390A'),
  ),
  Mos(
    code: '420A',
    title: 'Human Resources Technician',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; the feeder MOSs are the 42 series.',
      'Human Resources Technician Warrant Officer Basic Course and the prerequisite studies for the advanced course.',
      'SECRET eligibility. The section sets no aptitude gate.',
    ],
    description: _pam(
      'Manages the personnel system at command level: readiness, information, '
      'strength accounting, casualty reporting, replacements and the awards '
      'program, plus the soldiers who run them.',
    ),
    source: _sec('8-420A'),
  ),
  Mos(
    code: '420C',
    title: 'Bandmaster',
    category: MosCategory.band,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 42R.',
      'Army Music Warrant Officer Basic Course; SECRET eligibility.',
      'The section sets no aptitude gate: the qualification is musical, as it is for the two enlisted musicians it appoints from.',
    ],
    description: _pam(
      'Conducts or leads Army bands and music performance teams for military and '
      'civilian ceremonies, selects the music, directs rehearsals and represents the '
      'Army in the community.',
    ),
    source: _sec('8-420C'),
  ),
  Mos(
    code: '420T',
    title: 'Talent Acquisition Technician',
    category: MosCategory.recruiting,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202508. The chapter also prints a revision effective 202710, which the app does not carry yet.',
    prerequisites: <String>[
      'Attribute-based selection accession MOS; any MOS is a feeder, and applicants complete an assessment and selection event.',
      'SECRET eligibility, a Department of the Army suitability screening, the Recruiter Candidate Assessment Screening and Talent Acquisition Certification.',
      'Talent Acquisition Technician Warrant Officer Basic Course.',
    ],
    description: _pam(
      'Recruits: reads local market data, plans and runs marketing and outreach, '
      'works the Human Resources and recruiting systems, and assesses the people who '
      'want to join.',
    ),
    source: _sec('8-420T'),
  ),
  Mos(
    code: '490B',
    title: 'Artificial Intelligence and Machine Learning Operations Technician',
    category: MosCategory.cyberEw,
    appointment: MosAppointment.warrantOfficer,
    gate: g('GT 110'),
    note: 'The section requires an ASVAB GT score of 110 with no waivers, SGT or above, and the Warrior Leaders Course. Effective 202610.',
    prerequisites: <String>[
      'Accession MOS; any MOS is a feeder. SGT (E-5) or above, Warrior Leaders Course complete.',
      'ASVAB GT score of 110, no waivers - the only other aptitude figure in the chapter.',
      'U.S. citizenship with no waivers, and the administrative requirements for warrant officer appointment.',
    ],
    description: _pam(
      'Puts artificial intelligence into service: applies cloud-native development, '
      'data engineering, DevSecOps and model deployment, and secures the result on '
      'DoD networks.',
    ),
    source: _sec('8-490B'),
  ),
  Mos(
    code: '640A',
    title: 'Food Safety Officer',
    category: MosCategory.medical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 68R and 68S. The NCOES, grade and time-in-service requirements can be waived for an applicant with a BS or MS in food science, food technology, food chemistry, food microbiology, food quality assurance or a related field.',
      'The section names DA Cir 601 series as the prerequisite authority.',
      'The section sets no aptitude gate.',
    ],
    description: _pam(
      'Runs the Army\'s food safety and quality assurance program: conducts '
      'sanitation audits and inspections of the facilities that handle subsistence, '
      'and assigns the compliance ratings.',
    ),
    source: _sec('8-640'),
  ),
  Mos(
    code: '670A',
    title: 'Health Services Maintenance Technician',
    category: MosCategory.medical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 68A.',
      'No conviction by special or general court-martial, or of the offences in AR 27-10 chapter 24.',
      'Health Services Maintenance Technician Warrant Officer Basic Course; SECRET eligibility.',
    ],
    description: _pam(
      'Supervises the maintenance of medical and dental diagnostic and treatment '
      'equipment and laboratory equipment, allocates the workload, inspects the work '
      'and advises hospital staff on maintenance.',
    ),
    source: _sec('8-670A'),
  ),
  Mos(
    code: '740A',
    title: 'Chemical, Biological, Radiological and Nuclear Warrant Officer',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; the primary feeder is 74D.',
      'CBRN Warrant Officer Basic Course; 20/20 correctable vision with normal colour discrimination and normal hearing.',
      'SECRET eligibility. The section sets no aptitude gate.',
    ],
    description: _pam(
      'Manages chemical, biological, radiological and nuclear operations and '
      'training, runs the unit hazardous-material certification program, and sets the '
      'requirement for CBRN equipment and its repair.',
    ),
    source: _sec('8-740'),
  ),
  Mos(
    code: '880A',
    title: 'Marine Deck Officer',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 88K.',
      'Licensed per AR 56-9 to the U.S. Army marine licence annotated "Master of Class A-1" for the vessel class.',
      'Marine Deck Officer Warrant Officer Basic Course; physical profile not less than 222221; vision correctable to 20/20 one eye, 20/40 the other; SECRET eligibility.',
    ],
    description: _pam(
      'Commands Army Class A1 vessels on lakes, bays, sounds and coastal waters: '
      'navigates by chart, bearing and electronic aid, keeps the vessel seaworthy and '
      'the crew in order.',
    ),
    source: _sec('8-880A'),
  ),
  Mos(
    code: '881A',
    title: 'Marine Engineering Officer',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 21P and 88L with ASI S2.',
      'Licensed per AR 56-9 to the U.S. Army marine licence annotated "Chief Engineer" for the vessel class.',
      'Physical profile not less than 222221; the same vision and colour standard as 880A; SECRET eligibility.',
    ],
    description: _pam(
      'Directs the operation, maintenance, repair and overhaul of machinery aboard '
      'Army watercraft: propulsion, power plant, heating and ventilation, and the '
      'plumbing and electrical equipment.',
    ),
    source: _sec('8-881A'),
  ),
  Mos(
    code: '882A',
    title: 'Mobility Officer',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 88N. Prerequisites are AR 56-9 and DA Cir 601 series.',
      'Physical profile not less than 222221; the vision and colour standard of the marine occupations.',
      'SECRET eligibility and the OPAT benchmark the section prints.',
    ],
    description: _pam(
      'Runs the movement systems that move units and cargo: implements the '
      'transportation, load-planning, manifesting and tracking systems and coordinates '
      'deployment and distribution.',
    ),
    source: _sec('8-882A'),
  ),
  Mos(
    code: '890A',
    title: 'Ammunition Warrant Officer',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 20211001',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 89A, 89B and 89D. Prerequisites are AR 135-100 and DA Pam 601-6.',
      'Ammunition Warrant Officer Basic Course; correctable vision, normal colour discrimination, normal hearing and full use of the extremities.',
      'Personnel Reliability Program requirements under AR 50-6 where the position calls for them.',
    ],
    description: _pam(
      'Directs ammunition supply: receipt, storage, issue, surveillance testing, '
      'maintenance, modification, destruction and demilitarization of conventional '
      'ammunition and explosive components.',
    ),
    source: _sec('8-890A'),
  ),
  Mos(
    code: '913A',
    title: 'Armament Systems Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202010',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 91A, 91F, 91M, 91P and 91X or 91Z with feeder MOS experience. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Warrant Officer Armament Systems Maintenance Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Manages field-level maintenance of small arms, field artillery and armament '
      'systems: directs fault-finding in electrical, hydraulic, fire-control and '
      'instrument items and sets evacuation and replacement rules.',
    ),
    source: _sec('8-913A'),
  ),
  Mos(
    code: '914A',
    title: 'Allied Trades Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202010',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 91E, or 91X/91Z with 91E experience. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Allied Trades Warrant Officer Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Directs the machine, welding and body shops: sets up and runs machine tools, '
      'CNC and welding equipment, and manages body, frame, paint, glass, radiator, '
      'canvas and woodworking work.',
    ),
    source: _sec('8-914A'),
  ),
  Mos(
    code: '915A',
    title: 'Automotive Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202510',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 91A, 91B, 91C, 91D, 91H, 91J, 91L, 91M, 91P, 91S, 91X and 91Z. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Automotive Maintenance Warrant Officer Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Plans and allocates the shops that maintain wheeled vehicles, construction '
      'equipment, generators, armament systems and ground support equipment, and '
      'inspects the work they turn out.',
    ),
    source: _sec('8-915A'),
  ),
  Mos(
    code: '915S',
    title: 'Stryker Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202510',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 91B, 91S, 91X and 91Z. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Stryker Maintenance Warrant Officer Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'The same maintenance management aimed at Stryker formations: plans and '
      'allocates resources to repair Stryker combat vehicles and the equipment that '
      'supports them.',
    ),
    source: _sec('8-915S'),
  ),
  Mos(
    code: '915T',
    title: 'Track Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202510',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 91A, 91H, 91M, 91P, 91L, 91X and 91Z. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Track Maintenance Warrant Officer Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Maintenance management for tracked fleets: allocates the shops and resources '
      'that repair tracked combat vehicles, tracked and wheeled construction '
      'equipment and the armament on them.',
    ),
    source: _sec('8-915T'),
  ),
  Mos(
    code: '919A',
    title: 'Engineer Equipment Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    note: 'Effective 202510',
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 91B, 91C, 91D, 91H, 91J, 91L, 91X and 91Z. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Engineer Equipment Maintenance Warrant Officer Basic Course; SECRET eligibility.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Supervises the soldiers who maintain engineer and ground support equipment: '
      'earthmoving, shaping, lifting, loading, crushing, mixing, water purification, '
      'refrigeration and bridging sets.',
    ),
    source: _sec('8-919A'),
  ),
  Mos(
    code: '920A',
    title: 'Property Accounting Technician',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; the primary feeder is 92Y, and 92A may serve as a feeder depending on the individual\'s experience.',
      'Property Accounting Technician Warrant Officer Basic Course; SECRET eligibility.',
      '20/20 correctable vision, normal colour discrimination and normal hearing; OPAT Moderate (Gold).',
    ],
    description: _pam(
      'Keeps the property books: works as the technical manager of accountability at '
      'battalion or as a property book team chief, in the standard property book '
      'system.',
    ),
    source: _sec('8-920'),
  ),
  Mos(
    code: '920B',
    title: 'Supply Systems Technician',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; the primary feeder is 92A.',
      'Supply Systems Warrant Officer Basic Course; SECRET eligibility.',
      '20/20 correctable vision, normal colour discrimination and normal hearing; OPAT Moderate (Gold).',
    ],
    description: _pam(
      'Runs the supply support activity: the stocking, issuing and accounting that '
      'gives a unit its parts and supplies, often as the only supply technician in '
      'the organisation.',
    ),
    source: _sec('8-920B'),
  ),
  Mos(
    code: '921A',
    title: 'Airdrop Systems Technician',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 92R.',
      'Airdrop Systems Technician Warrant Officer Basic Course; able to perform parachute duty and to hold certification under AR 750-32.',
      '20/20 correctable vision, normal colour discrimination and normal hearing; SECRET eligibility; OPAT Moderate (Gold).',
    ],
    description: _pam(
      'Runs airdrop and rigging: approves the plans for parachute and airdrop '
      'equipment repair, establishes the rigging sites that support airborne '
      'operations and supervises the riggers.',
    ),
    source: _sec('8-921'),
  ),
  Mos(
    code: '922A',
    title: 'Food Service Technician',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOS 92G.',
      'Food Service Technician Warrant Officer Basic Course; SECRET eligibility.',
      '20/20 correctable vision, normal colour discrimination and normal hearing; OPAT Moderate (Gold).',
    ],
    description: _pam(
      'Runs field feeding: manages the people, equipment and facilities that '
      'implement the Army field feeding system in training and mobilisation, and '
      'advises the commander on the program.',
    ),
    source: _sec('8-922'),
  ),
  Mos(
    code: '923A',
    title: 'Petroleum Systems Technician',
    category: MosCategory.combatService,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; the primary feeders are 92F and 92L.',
      'Petroleum Technician Warrant Officer Basic Course; SECRET eligibility.',
      '20/20 correctable vision, normal colour discrimination and normal hearing; OPAT Moderate (Gold).',
    ],
    description: _pam(
      'Manages petroleum operations: the technical side of fuel receipt, storage, '
      'issue and testing, and the soldiers and equipment of a petroleum supply '
      'company.',
    ),
    source: _sec('8-923'),
  ),
  Mos(
    code: '948B',
    title: 'Electronic Systems Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 25S with a waiver, 94D, 94E, 94F, 94H, 94M, 94R, 94W, 94Y and 94Z. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Electronic Systems Maintenance Officer Warrant Officer Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Manages the maintenance of radio, radar, computer, cryptographic, television '
      'and fibre-optic systems: the shops, the soldiers, the safety and security '
      'programs and the repair itself.',
    ),
    source: _sec('8-948B'),
  ),
  Mos(
    code: '948D',
    title: 'Electronic Missile Systems Maintenance Warrant Officer',
    category: MosCategory.mechanical,
    appointment: MosAppointment.warrantOfficer,
    gate: AptitudeGate.none,
    gateStatus: MosGateStatus.noRequirement,
    prerequisites: <String>[
      'Accession MOS; feeder MOSs 94A, 94M, 94P, 94S, 94T, 94W and 94Z. Prerequisites are AR 135-100, DA Pam 601-6 and DA Pam 611-21.',
      'Electronic Missile Systems Maintenance Warrant Officer Basic Course.',
      'Correctable vision, normal colour discrimination, normal hearing and full use of the extremities per AR 40-501.',
    ],
    description: _pam(
      'Runs missile-system maintenance: applies digital switching and infrared '
      'theory to the Army\'s missile systems, leads the support teams and monitors '
      'unit status reporting for the missile units.',
    ),
    source: _sec('8-948D'),
  ),
];
