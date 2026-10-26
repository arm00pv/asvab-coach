/// Plain-language duty descriptions for one slice of the enlisted MOS roster.
///
/// SLICE: indices 39..77 of the 156 codes in allMos, sorted alphabetically -
/// 39 codes from 15T through 38W. Computed from the roster, not chosen by hand,
/// so it cannot overlap another slice.
///
/// WHAT THIS IS. One `SourcedText` per MOS saying, in our own words, what the
/// work actually is and where it is trained or performed. Every sentence is a
/// paraphrase of the MOS's "Major duties" paragraph in DA Pam 611-21, chapter
/// 10, section C - the same section of the same build the aptitude gates in
/// mos_data.dart were transcribed from. Nothing here is copied verbatim and
/// nothing is added from outside that paragraph: where the paragraph names the
/// school that runs the course, the second sentence names it, and where it
/// names the kind of unit the soldier is assigned to, the second sentence says
/// that instead.
///
/// WHY THE PAMPHLET AND NOT A RECRUITING SITE. The recruiting sites write duty
/// summaries that are marketing copy for the same job. The pamphlet is the
/// authority the app already cites for the gates, so a candidate reading the
/// description and the gate is reading one document, and the description can be
/// re-checked against a page that is a US Government work.
///
/// HOW IT WAS READ. The 04 December 2025 build of chapter 10 section C, the
/// build named by mosRosterAuthority, as the extracted text in
/// docs/research/_raw/ch10c.txt that docs/MOS_GAP.md documents. The PDF itself
/// is cited as [mosDescriptionSlice2SourceUrl], which opens in a browser;
/// api.army.mil answers 403 to scripts, which is why the text was extracted
/// through the Internet Archive copy of that same URL.
///
/// COVERAGE: 39 of 39. Nothing in the slice was omitted, because every one of
/// the 39 sections carries a duties paragraph that supports a description. A
/// code with no description would have been left out of this map rather than
/// filled with a plausible sentence; test/mos_description_slice_2_test.dart
/// names any code still missing.
library;

import '../models/mos.dart';

/// The day these pages were read. A date, not a timestamp, because the claim is
/// about a day's reading and not about a time of day.
final DateTime mosDescriptionSlice2RetrievedOn = DateTime(2026, 10, 26);

/// The pamphlet chapter every description in this slice was read from: DA Pam
/// 611-21, chapter 10, section C, enlisted MOS specifications, 04 December 2025
/// build.
const String mosDescriptionSlice2SourceUrl =
    'https://api.army.mil/e2/c/downloads/2025/12/04/20612de5/'
    'chapter-10c-enlisted-mos-specifications.pdf';

/// One description, cited to the pamphlet. A function rather than a literal so
/// that the URL and the date cannot drift apart between entries, and so the
/// kind is set once: every sentence in this slice came from the same document.
SourcedText _duties(String text) => SourcedText(
  text: text,
  sourceUrl: mosDescriptionSlice2SourceUrl,
  retrievedOn: mosDescriptionSlice2RetrievedOn,
  sourceKind: MosSourceKind.pamphlet,
);

/// Duty descriptions by MOS code, for the codes in slice 2.
///
/// Keyed by the code exactly as mos_data.dart spells it. A screen that finds no
/// entry here shows no description: the absence is the honest answer, and the
/// test lists it.
final Map<String, SourcedText> mosDescriptionSlice2 = <String, SourcedText>{
  '15T': _duties(
    'Repairs and services the UH-60 helicopter: scheduled inspections, subsystem and engine work, lubrication, and the maintenance records that go with it. The Army Aviation Center of Excellence trains this job, and most assignments are aviation maintenance units.',
  ),
  '15U': _duties(
    'Repairs and services the CH-47 helicopter: inspections, subsystem and engine work, lubrication, and maintenance paperwork, with the option of flying as a crew chief. Training comes from the Army Aviation Center of Excellence and assignments are usually aviation maintenance units.',
  ),
  '15W': _duties(
    'Remotely pilots the tactical unmanned aircraft system, handling pre-flight, in-flight and post-flight checks, air vehicle and ground station set-up, launch and recovery crews, and limited unit-level maintenance. Operators are trained by the Army Aviation Center of Excellence.',
  ),
  '15X': _duties(
    'Employs, repairs and services unmanned aircraft systems and their ground equipment for the small systems used at brigade level and below, plans reconnaissance flights and adjusts control and video frequencies against interference. The Army Aviation Center of Excellence or its certified instructors train this MOS.',
  ),
  '15Y': _duties(
    'Repairs the AH-64\'s armament, electrical and avionics systems, including the missile fire control system, and tests and fixes the test sets and diagnostic gear that keep them working. The Army Aviation Center of Excellence runs the resident course.',
  ),
  '17C': _duties(
    'Carries out cyberspace operations for the Army, using software, firmware and hardware to reach adversary activities and networks as part of the national cyber workforce. New soldiers attend the Cyber Operations Specialist course at the U.S. Army Cyber School.',
  ),
  '17E': _duties(
    'The commander\'s expert on the electromagnetic spectrum, planning electronic attack, electronic protection and electronic warfare support, and feeding all of it into the military decision-making process. The U.S. Army Cyber School runs the mandatory course.',
  ),
  '18B': _duties(
    'Special Forces weapons advisor who handles U.S. and foreign small arms, crew-served, air defence and anti-armor weapons, plans how they are used in the fight and coordinates supporting fires. Entry is through the Special Forces Qualification Course.',
  ),
  '18C': _duties(
    'Special Forces engineer for demolitions, mines and countermine work, field defences, bridging and construction, who also teaches those skills to partner troops and does target analysis. Qualification runs through the Special Forces Qualification Course.',
  ),
  '18D': _duties(
    'Special Forces medic who keeps a detachment medically ready, sets up medical care for allied and local people in austere settings, and manages medicines, supplies, records and preventive medicine. Entry is through the Special Forces Qualification Course.',
  ),
  '18E': _duties(
    'Special Forces communicator who runs a detachment\'s HF, VHF and UHF radio nets, writes the communications and security plans, and trains partner forces on the equipment. Qualification runs through the Special Forces Qualification Course.',
  ),
  '18F': _duties(
    'Special Forces intelligence sergeant who prepares the intelligence estimate for a mission, runs collection with allied and local partners, and handles detainees, security plans and threat assessments. Entry is through the Special Forces Qualification Course.',
  ),
  '19C': _duties(
    'Crews the M2 Bradley fighting vehicle as driver, gunner or vehicle commander, firing the Bushmaster cannon, machine gun and TOW missiles while holding position in formation. New soldiers train in a course run by the U.S. Army Armor School.',
  ),
  '19D': _duties(
    'Cavalry scout who carries out reconnaissance and security missions mounted or on foot, navigating, occupying observation posts, calling in indirect fire and reporting what the team finds. The U.S. Army Armor School runs the training.',
  ),
  '19K': _duties(
    'Crews the Abrams main battle tank or the M10 Booker as loader, driver or gunner, handling ammunition, moving the vehicle in formation and putting the main gun on targets. New soldiers train with the U.S. Army Armor School.',
  ),
  '25B': _duties(
    'Installs, runs and repairs Army computers, information technology networks and cable systems, administering servers and routers and applying cybersecurity policy. The mandatory course is run by the U.S. Army Signal School.',
  ),
  '25D': _duties(
    'Defends Army networks: deploys and administers network defence tools, analyses alerts and traffic, contains and eradicates intrusions, and assesses the damage afterwards. The Cyber Network Defender course at the U.S. Army Signal School is mandatory.',
  ),
  '25E': _duties(
    'Manages the electromagnetic spectrum for a command, building and issuing signal operating instructions, tracking frequency requests and hunting down interference. The mandatory course is run by the U.S. Army Signal School.',
  ),
  '25H': _duties(
    'Installs and runs commercial and tactical fibre, cabling and IP-based network systems, keeps network control and management equipment working, and handles communications security devices. The U.S. Army Signal School trains this MOS.',
  ),
  '25S': _duties(
    'Installs and operates satellite communications ground terminals, networks and large earth terminal complexes from tactical to strategic level, testing circuits and isolating faults. Training is run by the U.S. Army Signal School.',
  ),
  '25U': _duties(
    'Supports Army radios and IP-based radio networks, configuring local area networks and routers, setting up field antennas and retransmission sites, and keeping communications security gear working. The U.S. Army Signal School runs the course.',
  ),
  '27D': _duties(
    'Paralegal on the commander\'s legal team, handling military justice paperwork, legal assistance, claims, administrative and operational law questions alongside the attorneys. The ten-week course is run by the U.S. Army Quartermaster School.',
  ),
  '31B': _duties(
    'Military police who keep law and order on post and in the field, secure critical resources, run crime prevention programmes and help the force move. The U.S. Army Military Police School trains this MOS.',
  ),
  '31D': _duties(
    'Special agent who supervises or conducts investigations into incidents, offences or allegations of criminality affecting Army and Defence Department personnel, property or facilities. The course is run by the U.S. Army Military Police School.',
  ),
  '31E': _duties(
    'Runs detention and corrections work: custody and control of military prisoners and detainees, tower and compound guard duty, escorts, and treatment programmes. The U.S. Army Military Police School trains this MOS.',
  ),
  '31K': _duties(
    'Handles a military working dog, keeping it healthy and sharp at finding narcotics or explosives, and works the team in police operations and installation security. The U.S. Army Military Police School runs the course.',
  ),
  '35F': _duties(
    'All-source intelligence analyst who builds the threat picture, writes and briefs intelligence products, and supports planning and targeting for a commander. The U.S. Army Intelligence Center of Excellence at Fort Huachuca trains this MOS.',
  ),
  '35G': _duties(
    'Reads satellite and airborne imagery to identify and report targets, working the task, collect, process and exploit cycle and pushing imagery and mapping products to ground units. Training is at Fort Huachuca with the Intelligence Center of Excellence.',
  ),
  '35L': _duties(
    'Counterintelligence agent who investigates and operates against foreign intelligence and terrorist threats to Army forces, inside the law and Army policy. The Counterintelligence Special Agents Course at Fort Huachuca is mandatory.',
  ),
  '35M': _duties(
    'Human intelligence collector who interviews prisoners, deserters, local people and contacts to learn the enemy\'s intentions and capabilities, then writes and disseminates the reports. Training is at Fort Huachuca with the Intelligence Center of Excellence.',
  ),
  '35N': _duties(
    'Signals intelligence analyst who analyses and reports intercepted foreign communications and other signals, produces tactical through strategic intelligence and helps manage collection. The Intelligence Center of Excellence at Fort Huachuca runs the course.',
  ),
  '35P': _duties(
    'Signals intelligence voice interceptor who detects, identifies and listens to foreign communications, then copies, translates and summarises them for analysts. Training is at Fort Huachuca with the Intelligence Center of Excellence.',
  ),
  '35S': _duties(
    'Signals acquisition and exploitation analyst who tasks, surveys and exploits foreign signals, using technical and communications intelligence analysis to support operations at every echelon. The Intelligence Center of Excellence at Fort Huachuca trains this MOS.',
  ),
  '35T': _duties(
    'Keeps Army intelligence systems running, installing, configuring, integrating and repairing the computers and networks they depend on in deployed and fixed facilities. The U.S. Army Intelligence Center of Excellence runs the course.',
  ),
  '36B': _duties(
    'Financial management technician working budgets, payments to soldiers and vendors, travel pay, accounting for government money and internal controls. The resident course is run by the U.S. Army Finance and Comptroller School.',
  ),
  '37F': _duties(
    'Psychological operations specialist who studies target audiences, advises commanders, plans influence activities and develops the products that carry them, then assesses the result. Trained at the John F. Kennedy Special Warfare Center and School.',
  ),
  '38B': _duties(
    'Civil affairs specialist who works with local populations, institutions and partner organisations, assesses the civil situation and supports military government operations. Army Reserve soldiers train at the John F. Kennedy Special Warfare Center and School.',
  ),
  '38R': _duties(
    'Civil reconnaissance sergeant on a four-person civil affairs team, working in hostile or politically sensitive areas to gather civil information and build local networks. Training runs through the John F. Kennedy Special Warfare Center and School.',
  ),
  '38W': _duties(
    'Civil affairs medical sergeant on a civil affairs team: plans medical missions, gives advanced emergency care and prolonged field care in austere places, and assesses local health systems. Trained at the John F. Kennedy Special Warfare Center and School.',
  ),
};
