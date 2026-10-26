/// Plain-language duty descriptions for one slice of the MOS roster.
///
/// What this file is: the sentences a candidate reads on the jobs screen under
/// "What the job is", for the 39 codes at indices 117 to 155 of the 156-code
/// roster sorted alphabetically - 88M through 94Y, the transportation,
/// ammunition, mechanical maintenance, quartermaster and signal-test specialties.
/// The slice split exists so the data pass could be done in parallel without two
/// people writing the same MOS; [mosDescriptionSlice4] is keyed by MOS code and
/// merged by whoever assembles the slices.
///
/// Where every sentence comes from: DA Pam 611-21, chapter 10, section C (Enlisted
/// MOS specifications), 04 December 2025 build, the same authority the aptitude
/// gates in lib/data/repos/mos_data.dart are transcribed from. Each entry
/// paraphrases that section's "a. Major duties" paragraph for what the work is,
/// and the formal-training sentence of the same section's paragraph b for where
/// it is trained - the proponent school, named where the pamphlet names one.
/// Nothing here is a copied sentence: the pamphlet's phrasing is compressed and
/// turned into plain language, and no detail appears that the section does not
/// state. The 04 December 2025 chapter file is cited as one URL rather than a
/// per-MOS page because the pamphlet is published as a single chapter PDF.
///
/// Why the citation is a field and not a footnote: a plausible-sounding sentence
/// about a job is indistinguishable from an invention, and this is the field a
/// candidate planning an enlistment is most likely to act on. Every entry carries
/// [SourcedText]'s URL, retrieval date and kind, and
/// test/mos_description_slice_4_test.dart holds it to the provenance rules of
/// test/mos_provenance_test.dart.
///
/// Coverage: 39 of the 39 codes in this slice. Nothing was omitted: the pamphlet
/// section for each one carries both a duties paragraph and a training sentence,
/// so no entry needed to be guessed at or left out.
library;

import '../models/mos.dart';

/// The day every description in [mosDescriptionSlice4] was read.
///
/// A date, not a timestamp: it records when the pamphlet section was read, not
/// when the MOS changed. Compare it at day granularity.
final DateTime mosDescriptionSlice4RetrievedOn = DateTime(2026, 10, 26);

/// DA Pam 611-21 chapter 10 section C, the enlisted MOS specifications.
///
/// The 04 December 2025 build, which is the authority lib/data/repos/mos_data.dart
/// was diffed against - see docs/MOS_GAP.md. Published as one chapter file, so
/// every section cited here shares it. api.army.mil answers a non-browser client
/// with HTTP 403; the file opens normally in a browser.
const String _chapter10cUrl =
    'https://api.army.mil/e2/c/downloads/2025/12/04/20612de5/'
    'chapter-10c-enlisted-mos-specifications.pdf';

/// What each MOS in this slice actually does, with the page it was read from.
///
/// Keyed by MOS code, one entry per code in the slice. A code with no entry is
/// left undescribed on purpose rather than filled in; here there are none, but a
/// future edit that cannot source a sentence must delete the entry rather than
/// soften it.
final Map<String, SourcedText> mosDescriptionSlice4 = <String, SourcedText>{
  '88M': SourcedText(
    // Motor Transport Operator
    text: 'Motor transport operators drive the Army\'s wheeled vehicles and trailers over highways, back roads and open ground to move soldiers and cargo, and they check that loads are tied down and protected. Most of the work happens in unit motor pools, truck terminals and convoys supporting field operations.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '88N': SourcedText(
    // Transportation Management Coordinator
    text: 'Transportation management coordinators plan, document and track the movement of people, equipment and cargo by air, rail, road and water, choosing the most efficient way to move a shipment. Most of the day is paperwork: routing requests, labelling freight and keeping movement records straight.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '88P': SourcedText(
    // Railway Equipment Repairer
    text: 'Railway equipment repairers service and repair diesel-electric locomotives and railway cars, working on airbrakes, fuel, cooling and lubrication systems, electrical parts, frames, running gear and couplers. The U.S. Army Transportation School trains them, and the pamphlet fields the specialty in the Army Reserve only.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '88U': SourcedText(
    // Railway Specialist
    text: 'Railway specialists run military rail movements: reading train orders, overseeing coupling and uncoupling, inspecting and bracing cars, and recording where every car has gone. Training is at the U.S. Army Transportation School at Fort Gregg-Adams, Virginia; the specialty is Army Reserve only.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '89A': SourcedText(
    // Ammunition Stock Control and Accounting Specialist
    text: 'Ammunition stock control and accounting specialists keep the books on ammunition, using the Standard Ammunition and Accounting System and manual records to show what arrived, what was issued and what is left on hand. The U.S. Army Ordnance School at Fort Gregg-Adams, Virginia trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '89B': SourcedText(
    // Ammunition Specialist
    text: 'Ammunition specialists receive, store and issue conventional ammunition, guided missiles, rockets and related items, and they also maintain, modify, destroy and demilitarize ammunition and its explosive components. Training runs through the U.S. Army Ordnance School, with a second phase for Reserve Component soldiers.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '89D': SourcedText(
    // Explosive Ordnance Disposal Specialist
    text: 'Explosive ordnance disposal specialists locate, identify, make safe and dispose of conventional, chemical, biological or nuclear ordnance and improvised explosive devices, including vehicle bombs. They complete Phase I of the EOD Specialist Course at Fort Lee and Phase II at NAVSCOLEOD on Eglin Air Force Base.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91A': SourcedText(
    // M1 Abrams Tank System Maintainer
    text: 'M1 Abrams tank system maintainers diagnose faults and repair the tank\'s suspension, steering, hydraulics, auxiliary power, fire suppression, armament and fire-control systems in the field. The U.S. Army Ordnance School provides the training.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91B': SourcedText(
    // Wheeled Vehicle Mechanic
    text: 'Wheeled vehicle mechanics inspect, service and repair the Army\'s trucks, trailers and material handling equipment, from engines, transmissions, brakes and steering to wiring, hydraulics, winches and cranes, and they recover vehicles that break down. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91C': SourcedText(
    // Utilities Equipment Repairer
    text: 'Utilities equipment repairers keep air conditioners, refrigeration units, portable heaters, fire extinguishers and recharging equipment working, inspecting, testing, adjusting and repairing them at field level. They are trained at the U.S. Army Ordnance School.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91D': SourcedText(
    // Tactical Power Generation Specialist
    text: 'Tactical power generation specialists maintain generators and power distribution equipment from the smallest sets up to 500-kilowatt units, and they coach operators on using that equipment correctly. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91E': SourcedText(
    // Allied Trades Specialist
    text: 'Allied trades specialists make, repair and modify metal and non-metal parts on lathes, grinders, presses, drills and welding sets, and they run the machine shop that does it. Training is at the U.S. Army Ordnance School at Fort Gregg-Adams, Virginia.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91F': SourcedText(
    // Small Arms/Towed Artillery Repairer
    text: 'Small arms and towed artillery repairers maintain rifles, machine guns and other infantry weapons along with towed howitzers, including the sights, periscopes, mounts and fire-control support gear that go with them. The U.S. Army Ordnance School provides the training.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91H': SourcedText(
    // Tracked Vehicle Repairer
    text: 'Tracked vehicle repairers keep tracked vehicles running, working on diesel power packs, engine fuel and air systems, cooling, hull wiring, transmissions, brakes and steering. They cover everything tracked outside the M1, M2 and M109 families, and the U.S. Army Ordnance School at Fort Gregg-Adams trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91J': SourcedText(
    // Quartermaster and Chemical Equipment Repairer
    text: 'Quartermaster and chemical equipment repairers fix the gear that cleans, heats and pumps: water purification units, decontamination systems, protective filters, smoke generators, laundry equipment and fuel-burning heaters. The U.S. Army Ordnance School provides the training.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91L': SourcedText(
    // Construction Equipment Repairer
    text: 'Construction equipment repairers maintain the Army\'s earthmovers, cranes, loaders, rock crushers, asphalt and concrete plants, pumps, air compressors and bridging equipment, working on engines, hydraulics, brakes and drive lines. They train at the U.S. Army Ordnance School at Fort Gregg-Adams, Virginia.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91M': SourcedText(
    // Bradley Fighting Vehicle System Maintainer
    text: 'Bradley Fighting Vehicle system maintainers troubleshoot and repair the M2 and M3 Bradley\'s suspension, steering, fire suppression, gas particulate, armament and fire-control systems, swapping out major assemblies and line replaceable units in the field. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91P': SourcedText(
    // Self-Propelled Artillery Systems Mechanic
    text: 'Self-propelled artillery systems mechanics repair and recover the M109-series howitzer, the M992 ammunition carrier and the M88 medium recovery vehicle, covering automotive, turret, armament, fire-control and chemical-protection systems. Training is at the U.S. Army Ordnance School.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '91S': SourcedText(
    // Stryker Systems Maintainer
    text: 'Stryker systems maintainers keep the whole Stryker family of vehicles moving, diagnosing and repairing engines, transmissions, drivetrain assemblies, suspensions, hydraulics, environmental control units and mounted armament. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92A': SourcedText(
    // Automated Logistical Specialist
    text: 'Automated logistical specialists keep stock records and supply paperwork straight in Army enterprise resource planning systems, and they receive, inspect, store, pack, crate and issue the parts and equipment units ask for. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92F': SourcedText(
    // Petroleum Supply Specialist
    text: 'Petroleum supply specialists take in, account for and dispense fuel and water, run the pumps, hose lines and pipelines that push them forward, and fuel and defuel vehicles, aircraft and generators. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92G': SourcedText(
    // Culinary Specialist
    text: 'Culinary specialists cook and serve meals in tactical field kitchens and garrison dining facilities, order and store food, help plan menus and hold the kitchen to food-safety and sanitation standards. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92L': SourcedText(
    // Petroleum Laboratory Specialist
    text: 'Petroleum laboratory specialists collect fuel, oil and lubricant samples and test them in a laboratory for properties such as viscosity, flash point and water content, then record the results and brief commanders on fuel quality. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92M': SourcedText(
    // Fatality Management Specialist
    text: 'Fatality management specialists search for and recover the dead, establish tentative identification, document and safeguard personal effects, and prepare and ship remains, including for mass-casualty burials. The Mortuary Affairs Course run by the U.S. Army Quartermaster School is the entry training.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92R': SourcedText(
    // Parachute Rigger
    text: 'Parachute riggers inspect, repair and pack parachutes and other aerial delivery equipment, and they rig vehicles, containers and other heavy cargo for airdrop. The pamphlet makes the Basic Airborne Training Course and the Parachute Rigger Course mandatory entry training.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92S': SourcedText(
    // Shower and Laundry Specialist
    text: 'Shower and laundry specialists take in bulk and individual laundry, sort and mark it, run mobile laundry systems, shower units and sewing machines, and get clean clothing back to the soldiers who handed it in. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92W': SourcedText(
    // Water Treatment Specialist
    text: 'Water treatment specialists set up and run water purification equipment, test water for contaminants, keep treated water stored and available, and check facilities and food suppliers for hazards to health. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '92Y': SourcedText(
    // Unit Supply Specialist
    text: 'Unit supply specialists handle a unit\'s property end to end: receiving, counting, storing, issuing, delivering and turning in equipment, keeping the automated supply records accurate, and securing and accounting for weapons and sensitive items. The U.S. Army Quartermaster School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94A': SourcedText(
    // Land Combat Electronic Missile System Repairer
    text: 'Land combat electronic missile system repairers maintain the electronics of the TOW and Javelin missile systems and of the Bradley Fighting Vehicle System, tracing faults through electrical, mechanical, optical and infrared assemblies and replacing failed parts. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94D': SourcedText(
    // Air Traffic Control Equipment Repairer
    text: 'Air traffic control equipment repairers install and maintain the radio, navigational aid and landing systems an airfield depends on, using test sets and technical manuals to find faults, then aligning, adjusting or replacing the faulty parts. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94E': SourcedText(
    // Radio Equipment Repairer
    text: 'Radio equipment repairers troubleshoot and repair receivers, transmitters and the equipment that works with them, testing each set to specification after the repair and passing along anything beyond field-level repair. Training is at the U.S. Army Ordnance School.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94F': SourcedText(
    // Computer/Detection Systems Repairer
    text: 'Computer and detection systems repairers maintain microcomputers, GPS receivers, switchboards, telephones and wire gear, night vision and laser devices, fiber optics, mine detection and dispensing systems, and chemical and biological warning equipment. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94H': SourcedText(
    // TMDE Maintenance Support Specialist
    text: 'Test, measurement and diagnostic equipment specialists calibrate and repair the instruments the Army measures with, against standards traceable to the National Institute of Standards and Technology, and they handle radiation detection gear. The U.S. Army Ordnance School at Fort Gregg-Adams, Virginia trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94M': SourcedText(
    // Radar Repairer
    text: 'Radar repairers troubleshoot and repair the electronics inside SENTINEL ground surveillance sensors, FIREFINDER radars and meteorological equipment, testing assemblies to tight tolerances and replacing failed components. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94P': SourcedText(
    // Multiple Launch Rocket System Repairer
    text: 'Multiple Launch Rocket System repairers keep the M270, M270A1 and HIMARS launcher-loaders working, tracing electrical, electronic, hydraulic and mechanical faults through the launcher module and its interconnecting cables. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94R': SourcedText(
    // Avionics and Survivability Equipment Repairer
    text: 'Avionics and survivability equipment repairers maintain the navigation, flight-control and stabilization systems fitted to aircraft, along with the radar-based equipment and aircraft survivability gear that protects the crew. Training is at the U.S. Army Ordnance School.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94S': SourcedText(
    // Patriot System Repairer
    text: 'Patriot system repairers maintain the missile system\'s radar set, engagement control station, launching stations, antenna mast group and communications relay group, isolating faults with diagnostic software and built-in test equipment. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94T': SourcedText(
    // Short Range Air Defense System Repairer
    text: 'Short range air defense system repairers maintain the Avenger system\'s electronic, electrical and cryogenic assemblies and its servomotor and azimuth gear assembly, inspecting and testing to tolerance and swapping defective line replaceable units. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
  '94Y': SourcedText(
    // Automatic Test Systems Operator/Maintainer
    text: 'Automatic test systems operators and maintainers emplace and run the Army\'s automatic test sets, hook up the weapon system under test, isolate faults down to circuit boards and components, and then perform the alignments and adjustments. The U.S. Army Ordnance School trains them.',
    sourceUrl: _chapter10cUrl,
    retrievedOn: mosDescriptionSlice4RetrievedOn,
    sourceKind: MosSourceKind.pamphlet,
  ),
};
