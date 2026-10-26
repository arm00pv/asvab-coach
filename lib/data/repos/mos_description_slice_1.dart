/// Plain-language duty descriptions for slice 1 of the MOS roster.
///
/// **Slice 1 is a computed assignment, not a choice.** The 156 MOS codes in
/// `mos_data.dart` were sorted alphabetically and indices 0..38 inclusive were
/// taken, giving the 39 codes keyed below. Nobody else writes these keys, so a
/// description here cannot collide with a parallel pass working the same roster.
///
/// Every sentence is a paraphrase of the "Major duties" paragraph - and, where
/// the pamphlet prints one, the "Formal training" sentence - of that MOS's own
/// section of DA Pam 611-21, chapter 10, section C. The pamphlet is the same
/// authority the gates in `mos_data.dart` come from, so the duties a candidate
/// reads and the score they need are cited to one document rather than two that
/// could disagree. Each entry says what the work is and, when the pamphlet says
/// so, where it is trained or performed - "typically assigned to Aviation Field
/// or Sustainment maintenance units", "formal training ... under the auspices of
/// the U.S. Army Engineer School", "attend mandatory formal training at
/// Goodfellow AFB, TX".
///
/// Nothing else is here. No civilian outlook, no pay, no clearance, no deployment
/// tempo, and no detail that is not on the page cited.
///
/// House rules, the same ones the rest of the catalogue follows:
///
///  * Two sentences, 40-320 characters. `test/mos_provenance_test.dart` holds
///    any description that reaches the roster to that, and
///    `test/mos_description_slice_1_test.dart` holds this map to it as well.
///  * Paraphrase, never a copied sentence, and never a sentence the pamphlet does
///    not support. Where a section was too thin to describe, the code is left out
///    of this map rather than filled with something that sounds right: a missing
///    description renders as nothing, which is honest, and an invented one is the
///    failure the provenance model exists to prevent.
///  * The citation is the chapter file itself rather than a per-MOS summary page,
///    because that is the page these words were read from.
library;

import '../models/mos.dart';

/// The authority: DA Pam 611-21, chapter 10, section C, 04 December 2025 build
/// - the same document `mosRosterAuthority` in `mos_data.dart` names - as the
/// chapter file the MOS Smartbook publishes.
const String _chapter10cUrl =
    'https://api.army.mil/e2/c/downloads/2025/12/04/20612de5/'
    'chapter-10c-enlisted-mos-specifications.pdf';

/// The day every entry below was read out of that chapter file.
///
/// Not `const`: [DateTime] has no const constructor, so the map carrying it is a
/// `final` top-level. The value is a date, not a timestamp - the field means "the
/// day this was read", and every entry shares the day the pass was done.
final DateTime _retrievedOn = DateTime(2026, 10, 26);

/// One pamphlet-cited description. Nothing about the citation is optional, so a
/// value cannot be added here without its URL, its date and its kind.
SourcedText _pam(String text) => SourcedText(
  text: text,
  sourceUrl: _chapter10cUrl,
  retrievedOn: _retrievedOn,
  sourceKind: MosSourceKind.pamphlet,
);

/// Duty descriptions for slice 1: the 39 alphabetically-first MOS codes of the
/// 156-code roster.
///
/// Keyed by MOS code, matching `Mos.code`. One file per slice on purpose: the
/// slices are worked in parallel and a single 1,500-line list is the one place
/// they would all collide.
final Map<String, SourcedText> mosDescriptionSlice1 = <String, SourcedText>{
  '08H': _pam(
    'Cares for military working horses - feeding, grooming, tacking and hauling '
    'them - and rides in ceremonial work such as military funerals, color '
    'guards and public outreach. New soldiers train through the U.S. Army '
    'Equestrian Center of Excellence.',
  ),
  '11B': _pam(
    'Fights on foot or from an infantry fighting vehicle: carries a rifle or '
    'crew-served weapon, patrols, digs in, calls for indirect fire and '
    'processes prisoners of war. Initial training runs through the U.S. Army '
    'Infantry School.',
  ),
  '11C': _pam(
    'Crews a mortar: lays the tube, loads and fires, keeps the fire control '
    'equipment working and hauls the ammunition, as part of a mortar squad in '
    'an infantry platoon. Trained at the U.S. Army Infantry School.',
  ),
  '12B': _pam(
    'Builds and clears the way for the rest of the force - demolition, '
    'minefields, wire obstacles and field fortifications - and opens gaps '
    'through enemy obstacles. Trained at the U.S. Army Engineer School.',
  ),
  '12C': _pam(
    'Rigs, launches and recovers military bridges and rafts so vehicles and '
    'troops can cross rivers and other gaps, working from bridge boats, cranes '
    'and bridge trucks. Trained at the U.S. Army Engineer School.',
  ),
  '12D': _pam(
    'Dives on scuba or surface-supplied air for underwater reconnaissance, '
    'demolition, salvage, hydrographic survey and port repair, down to 190 feet '
    'of seawater. The work is done in harbors, ports, rivers and under ships.',
  ),
  '12G': _pam(
    'Runs the crushing, screening and washing plant, drills and blasts rock, '
    'and produces the gravel and stone that military construction is built '
    'from. Training is through the Engineer Center and School or certified '
    'civilian quarry skills.',
  ),
  '12H': _pam(
    'Leads the crews that build and repair buildings, warehouses, fixed '
    'bridges, port facilities and fuel pipelines and tanks, and oversees the '
    'plumbing, carpentry and electrical trades that do the work. Awarded at '
    'supervisory level to soldiers already qualified in one of those trades.',
  ),
  '12K': _pam(
    'Installs and repairs the water, waste and fuel piping in Army buildings - '
    'closets, urinals, heaters, showers, drains - grades sewer lines and clears '
    'stoppages. Training is at the U.S. Army Engineer School or through '
    'certified civilian plumbing skills.',
  ),
  '12M': _pam(
    'Fights structural, aircraft, vehicle and wildland fires, rescues people '
    'trapped in buildings and answers hazardous material calls on Army '
    'installations. Entry training is at Goodfellow Air Force Base in Texas, or '
    'through certified civilian firefighter skills.',
  ),
  '12N': _pam(
    'Operates bulldozers, scrapers, graders and loaders to clear ground, dig '
    'and backfill, cut ditches and build roads, airfields and fighting '
    'positions, then leads the crew that runs them. Trained at the U.S. Army '
    'Engineer Center and School.',
  ),
  '12P': _pam(
    "Runs, installs and repairs the Army's big generating plants - 500 "
    "kilowatts and up - and the switchgear, instrumentation and distribution "
    "around them, from startup testing to depot-level maintenance. Training is "
    "at the U.S. Army Prime Power School.",
  ),
  '12Q': _pam(
    'Erects utility poles and installs, connects and repairs the overhead and '
    'underground power lines that feed Army sites, testing circuits to find the '
    'fault. Works on exterior lines and service drops as part of a transmission '
    'and distribution crew.',
  ),
  '12R': _pam(
    'Installs and maintains the electrical systems inside Army buildings up to '
    '600 volts - conduit, cable, switches, receptacles, fixtures, panels and '
    'grounding - and traces faults when a circuit fails. Trained at the U.S. '
    'Army Engineer School.',
  ),
  '12T': _pam(
    'Surveys construction and airfield sites, sets permanent survey control, '
    'drafts the construction plans and tests building materials in the field '
    'and the laboratory for quality. Trained at the U.S. Army Engineer School.',
  ),
  '12W': _pam(
    'Frames and finishes buildings - floors, stairs, roofs, walls, doors and '
    'windows - and pours concrete slabs and walls and lays masonry units for '
    'Army structures. Trained at the U.S. Army Engineer Center and School.',
  ),
  '12Y': _pam(
    "Builds and maintains the Army's geospatial databases from satellite, "
    "sensor and field data, and turns them into digital products and printed "
    "maps commanders plan on. Trained at the U.S. Army Engineer School.",
  ),
  '13B': _pam(
    "Loads, aims and fires the howitzer, sets fuses and propellant charges, "
    "hauls the ammunition and drives the gun's truck, as one member of a cannon "
    "crew. Trained at the U.S. Army Field Artillery School.",
  ),
  '13F': _pam(
    'Works inside infantry, armor and special operations units to find targets '
    'and bring in artillery, mortars, naval gunfire and aircraft, running the '
    'radios and digital targeting gear that connect them. Trained at the U.S. '
    'Army Field Artillery School.',
  ),
  '13J': _pam(
    'Feeds target data into the automated fire direction computers that turn a '
    'call for fire into a firing solution for the guns, rockets and missiles of '
    'the force. Trained at the U.S. Army Field Artillery School.',
  ),
  '13M': _pam(
    'Drives and fights a rocket launcher - the tracked M270 or the wheeled '
    'HIMARS - reloading pods, maintaining the launcher and resupply vehicle and '
    'firing on targets sent from fire control. Trained at the U.S. Army Field '
    'Artillery School.',
  ),
  '13R': _pam(
    'Employs radar that tracks incoming artillery and rocket rounds, works out '
    'where they were fired from and predicts where they will land so friendly '
    'guns can answer and enemy launchers can be found. Trained at the U.S. Army '
    'Field Artillery School.',
  ),
  '14E': _pam(
    'Runs the Patriot fire control station: emplaces and starts it, detects and '
    'engages aircraft and missiles, and performs crew-level maintenance and '
    'diagnostics on the system. Trained at the U.S. Army Air Defense Artillery '
    'School.',
  ),
  '14G': _pam(
    'Manages the air picture for a brigade or an air defense command, linking '
    'sensors and airspace users, passing early warning and helping write the '
    'air defense plan. Trained at the U.S. Army Air Defense Artillery School.',
  ),
  '14H': _pam(
    'Operates the early warning systems that detect aircraft and missiles and '
    'pass the warning to Patriot and other air defense units, and keeps that '
    'equipment emplaced, running and repaired at crew level. Trained at the '
    'U.S. Army Air Defense Artillery School.',
  ),
  '14P': _pam(
    'Crews short-range air defense: prepares, fires and reloads the Avenger '
    'launcher and shoulder-fired missiles, evaluates targets and keeps the '
    'carrier and weapon working. Trained at the U.S. Army Air Defense Artillery '
    'School.',
  ),
  '14T': _pam(
    'Sets up, aligns and maintains the Patriot launching station, loads and '
    'unloads missile canisters and keeps the station ready to fire with '
    'crew-level repairs and diagnostics. Trained at the U.S. Army Air Defense '
    'Artillery School.',
  ),
  '15B': _pam(
    'Removes, tears down, inspects and rebuilds the turbine engines that power '
    'Army aircraft, then tests the rebuilt systems and keeps the maintenance '
    'records; usually assigned to an aviation field or sustainment maintenance '
    'unit. Trained at the U.S. Army Aviation Center of Excellence.',
  ),
  '15C': _pam(
    'Remotely pilots the MQ-1 unmanned aircraft and flies reconnaissance, '
    'surveillance and target acquisition missions, from preflight checks '
    'through launch, flight and recovery. Trained at the U.S. Army Aviation '
    'Center of Excellence.',
  ),
  '15D': _pam(
    'Repairs what carries power from the engine to the rotor or propeller - '
    'transmissions, drive shafts, gearboxes and rotor hubs - and the '
    'lubrication that keeps them running, in an aviation field or sustainment '
    'maintenance unit. Trained at the U.S. Army Aviation Center of Excellence.',
  ),
  '15E': _pam(
    'Keeps the tactical unmanned aircraft flying: troubleshoots and repairs its '
    'electrical, avionics, radio, engine, fuel and landing systems, plus the '
    'ground control station and support equipment. Trained at the U.S. Army '
    'Aviation Center of Excellence.',
  ),
  '15F': _pam(
    'Diagnoses and repairs the electrical and electronic systems aboard Army '
    'aircraft - instruments, wiring, generators and solid-state components - '
    'and tests them against the technical manuals in a field or sustainment '
    'aviation unit. Trained at the U.S. Army Aviation Center of Excellence.',
  ),
  '15G': _pam(
    'Repairs the airframe itself - skin, stringers, beams and bulkheads - '
    'shaping and riveting metal, laying fiberglass, patching windows and '
    'applying corrosion control and paint, in an aviation field or sustainment '
    'unit. Trained at the U.S. Army Aviation Center of Excellence.',
  ),
  '15H': _pam(
    'Repairs the hydraulic and pneumatic systems that move aircraft parts, '
    'removing, testing and replacing lines, valves, actuators and assemblies in '
    'an aviation field or sustainment maintenance unit. Trained at the U.S. '
    'Army Aviation Center of Excellence.',
  ),
  '15M': _pam(
    'Maintains and repairs the MQ-1 unmanned aircraft - electrical, avionics, '
    'radio, propulsion, fuel, optical payload and weapons systems - plus its '
    'ground control station and ground data terminal. Trained at the U.S. Army '
    'Aviation Center of Excellence.',
  ),
  '15N': _pam(
    'Diagnoses and repairs aircraft flight controls, stabilization systems, '
    'avionics and cryptographic identification gear, using test sets, bench '
    'stock and technical manuals in an aviation field or sustainment unit. '
    'Trained at the U.S. Army Aviation Center of Excellence.',
  ),
  '15P': _pam(
    "Runs the flight desk for an aviation unit: builds mission plans, files "
    "flight clearances, keeps aircrew flight records, posts notices to airmen "
    "and interprets weather reports. Also provides air traffic advisory service "
    "to the unit's aircraft.",
  ),
  '15Q': _pam(
    'Clears aircraft to land and take off under visual and instrument rules '
    'from a control tower, ground control radar or airspace information center, '
    'sequencing traffic and keeping the airspace picture current. Trained at '
    'the U.S. Army Aviation Center of Excellence.',
  ),
  '15R': _pam(
    'Removes, services and reinstalls the assemblies that keep an AH-64 flying '
    '- engines, rotors, gearboxes, transmissions and mechanical flight controls '
    '- and performs scheduled inspections in a field or sustainment aviation '
    'unit. Trained at the U.S. Army Aviation Center of Excellence.',
  ),
};
