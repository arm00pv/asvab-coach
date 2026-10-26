# MOS -> civilian occupation, from the O*NET MOC crosswalk

**What this answers.** A candidate looking at a job wants to know what the work
is worth outside the Army, without the app inventing a career. Every line below
is a row of the O*NET Military Occupational Classification (MOC) crosswalk,
joined to an MOS code this app carries. No title is paraphrased, merged or
guessed; where the crosswalk has no active Army enlisted record for a code, the
code is **left out** of lib/data/repos/mos_civilian_data.dart and named in
section 4.

| | |
|---|---|
| Crosswalk | O*NET Military Occupational Classification (MOC), **milx0724 (updated August 2024)** |
| File used | military_crosswalk/milx0724.xlsx, inside military_crosswalk.zip |
| Downloaded from | <https://www.onetcenter.org/crosswalks.html> on **26 October 2026** |
| SHA-256 of the ZIP | ee7381411644fd39adaf93e7f3a8814773b28f4e8a5b2c00c7ad6b775b01d747 |
| Licence | **CC BY 4.0** |
| MOS codes carried by the app | **156** |
| Codes the crosswalk maps | **150** (96.2%) |
| Codes omitted | **6** |
| Codes mapping to a single occupation only | 133 |
| Codes whose only O*NET-SOC match is a military occupation | 22 |

## 1. Licence and the required attribution

O*NET content is published under a Creative Commons Attribution 4.0
International licence (CC BY 4.0), which obliges this app to credit the
source, link the licence, and state what it changed. Three pages apply, all
read on 26 October 2026:

- O*NET Resource Center Content License, which covers the crosswalks page
  itself: <https://www.onetcenter.org/license.html>
- O*NET Database Content License, which covers the O*NET content carried
  inside the crosswalk: <https://www.onetcenter.org/license_db.html>
- the licence text: <https://creativecommons.org/licenses/by/4.0/>

**The attribution string, verbatim**, is `mosCivilianAttribution` in
lib/data/repos/mos_civilian_data.dart and `MosCivilian.attribution` in
lib/data/repos/mos_civilian.dart:

> Includes information from O*NET Resource Center by the U.S. Department of Labor, Employment and Training Administration (USDOL/ETA). Used under the CC BY 4.0 license (https://creativecommons.org/licenses/by/4.0/). O*NET® is a trademark of USDOL/ETA. ASVAB Coach has modified all or some of this information: the O*NET Military Occupational Classification (MOC) crosswalk (milx0724, updated August 2024) was joined to the MOS codes this app carries and reformatted as Dart constants. USDOL/ETA has not approved, endorsed, or tested these modifications.

The wording is the "If you make edits or additions to O*NET information"
variant from the O*NET Resource Center Content License, with this app named
as the party that modified the material. It is one string rather than three
fragments so that a screen cannot print half of it: a screen that shows a
civilian occupation prints the credit line with it, under "In civilian
life: ...".

What was changed, as the licence requires us to state: the crosswalk's Army
enlisted rows were filtered to the active records, joined to this app's 156 MOS
codes, and reformatted as Dart constants. The occupation titles themselves are
copied verbatim and are unedited. USDOL/ETA has not approved, endorsed or tested
any of this.

## 2. Which crosswalk records count, and why

The crosswalk's own Read Me defines the columns this join selects on:

| Column | Value kept | Why |
|---|---|---|
| `SVC` | `A` | Army MOS/AOC/reporting codes. `N`, `M`, `F` and the rest are other services. |
| `MPC` | `E` | Enlisted. `O` and `W` are officer and warrant, a different career question. |
| `STATUS` | `A` | "Active (current) record". `O` is "Obsolete (rescinded)". |

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
| 11B | Infantryman | 55-3016.00 | Infantry |
| 11C | Indirect Fire Infantryman | 55-3016.00 | Infantry |
| 12B | Combat Engineer | 47-4099.00 | Construction and Related Workers, All Other |
| 13B | Cannon Crewmember | 55-3014.00 | Artillery and Missile Crew Members |
| 13F | Joint Fire Support Specialist | 55-3014.00 | Artillery and Missile Crew Members |
| 13J | Fire Control Specialist | 55-3014.00 | Artillery and Missile Crew Members |
| 13M | Multiple Launch Rocket System (MLRS)/High Mobility Artillery Rocket System (HIMARS) Crewmember | 55-3014.00 | Artillery and Missile Crew Members |
| 13R | Field Artillery (FA) Weapons Locating Radar (WLR) Specialist | 17-3029.00 | Engineering Technologists and Technicians, Except Drafters, All Other |
| 19D | Cavalry Scout | 55-3013.00 | Armored Assault Vehicle Crew Members |
| 19K | M1 Armor Crewman | 55-3013.00 | Armored Assault Vehicle Crew Members |
| 18B | Special Forces Weapons Sergeant | 55-3018.00 | Special Forces |
| 18C | Special Forces Engineer Sergeant | 55-3018.00 | Special Forces |
| 18D | Special Forces Medical Sergeant | 55-3018.00 | Special Forces |
| 12D | Diver | 49-9092.00 | Commercial Divers |
| 12G | Quarrying Specialist (RC) | 47-5051.00 | Rock Splitters, Quarry |
| 12K | Plumber | 47-2152.00 | Plumbers, Pipefitters, and Steamfitters |
| 12M | Firefighter | 33-2011.00 | Firefighters |
| 12N | Horizontal Construction Engineer | 47-1011.00 | First-Line Supervisors of Construction Trades and Extraction Workers |
| 12P | Prime Power Production Specialist | 51-8021.00 | Stationary Engineers and Boiler Operators |
| 12R | Interior Electrician | 47-2111.00 | Electricians |
| 12T | Technical Engineer | 17-3022.00 | Civil Engineering Technologists and Technicians |
| 12W | Carpentry and Masonry Specialist | 47-2031.00 | Carpenters |
| 12Y | Geospatial Engineer | 17-1021.00 | Cartographers and Photogrammetrists |
| 88H | Cargo Specialist | 53-7199.00 | Material Moving Workers, All Other |
| 88K | Watercraft Operator | 53-5021.00 | Captains, Mates, and Pilots of Water Vessels |
| 88L | Watercraft Engineer | 53-5031.00 | Ship Engineers |
| 88M | Motor Transport Operator | 53-3032.00 | Heavy and Tractor-Trailer Truck Drivers |
| 88N | Transportation Management Coordinator | 43-5011.00 | Cargo and Freight Agents |
| 89B | Ammunition Specialist | 47-5032.00 | Explosives Workers, Ordnance Handling Experts, and Blasters |
| 89D | Explosive Ordnance Disposal (EOD) Specialist | 47-5032.00 | Explosives Workers, Ordnance Handling Experts, and Blasters |
| 92A | Automated Logistical Specialist | 53-7065.00 | Stockers and Order Fillers |
| 92F | Petroleum Supply Specialist | 53-7072.00 | Pump Operators, Except Wellhead Pumpers |
| 92G | Culinary Specialist | 35-2012.00, 35-2021.00 | Cooks, Institution and Cafeteria; Food Preparation Workers |
| 92L | Petroleum Laboratory Specialist | 19-4043.00 | Geological Technicians, Except Hydrologic Technicians |
| 92M | Mortuary Affairs Specialist | 39-9099.00 | Personal Care and Service Workers, All Other |
| 92R | Parachute Rigger | 49-9099.00 | Installation, Maintenance, and Repair Workers, All Other |
| 92S | Shower and Laundry Specialist | 51-6011.00, 49-9099.00 | Laundry and Dry-Cleaning Workers; Installation, Maintenance, and Repair Workers, All Other |
| 92W | Water Treatment Specialist | 51-8031.00 | Water and Wastewater Treatment Plant and System Operators |
| 92Y | Unit Supply Specialist | 53-7065.00 | Stockers and Order Fillers |
| 74D | Chemical, Biological, Radiological, and Nuclear (CBRN) Specialist | 47-4041.00 | Hazardous Materials Removal Workers |
| 36B | Financial Management Technician | 43-3031.00 | Bookkeeping, Accounting, and Auditing Clerks |
| 42A | Human Resources Specialist | 43-4161.00 | Human Resources Assistants, Except Payroll and Timekeeping |
| 51C | Contracting Noncommissioned Officer (NCO) | 43-3061.00 | Procurement Clerks |
| 91B | Wheeled Vehicle Mechanic | 49-3023.00, 49-3031.00 | Automotive Service Technicians and Mechanics; Bus and Truck Mechanics and Diesel Engine Specialists |
| 91E | Allied Trades Specialist | 51-4041.00 | Machinists |
| 91S | STRYKER Systems Maintainer | 49-3031.00, 49-3042.00, 49-3023.00 | Bus and Truck Mechanics and Diesel Engine Specialists; Mobile Heavy Equipment Mechanics, Except Engines; Automotive Service Technicians and Mechanics |
| 94E | Radio Equipment Repairer | 49-2021.00 | Radio, Cellular, and Tower Equipment Installers and Repairers |
| 68A | Biomedical Equipment Specialist | 49-9062.00 | Medical Equipment Repairers |
| 68C | Practical Nursing Specialist | 29-2061.00 | Licensed Practical and Licensed Vocational Nurses |
| 68E | Dental Specialist | 31-9091.00, 29-1292.00 | Dental Assistants; Dental Hygienists |
| 68G | Patient Administration Specialist | 29-2072.00 | Medical Records Specialists |
| 68J | Medical Logistics Specialist | 43-5071.00 | Shipping, Receiving, and Inventory Clerks |
| 68K | Medical Laboratory Specialist | 29-2011.00 | Medical and Clinical Laboratory Technologists |
| 68P | Radiology Specialist | 29-2034.00 | Radiologic Technologists and Technicians |
| 68S | Preventive Medicine Specialist | 19-5012.00 | Occupational Health and Safety Technicians |
| 68T | Animal Care Specialist | 31-9096.00 | Veterinary Assistants and Laboratory Animal Caretakers |
| 68V | Respiratory Specialist | 29-2099.00 | Health Technologists and Technicians, All Other |
| 68W | Combat Medic Specialist | 29-2043.00 | Paramedics |
| 68X | Behavioral Health Specialist | 29-2053.00 | Psychiatric Technicians |
| 17C | Cyber Operations Specialist | 15-1212.00 | Information Security Analysts |
| 17E | Electronic Warfare Specialist | 15-1212.00 | Information Security Analysts |
| 25B | Information Technology Specialist | 15-1299.00 | Computer Occupations, All Other |
| 25D | Cyber Network Defender | 15-1212.00, 15-1244.00 | Information Security Analysts; Network and Computer Systems Administrators |
| 25E | Electromagnetic Spectrum Manager | 43-2099.00 | Communications Equipment Operators, All Other |
| 25H | Network Communication Systems Specialist | 15-1244.00 | Network and Computer Systems Administrators |
| 25U | Signal Operations Support Specialist | 43-2099.00, 27-4012.00, 49-2021.00 | Communications Equipment Operators, All Other; Broadcast Technicians; Radio, Cellular, and Tower Equipment Installers and Repairers |
| 35F | Intelligence Analyst | 55-3019.00 | Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other |
| 35G | Geospatial Intelligence Imagery Analyst | 17-1021.00, 17-3031.00 | Cartographers and Photogrammetrists; Surveying and Mapping Technicians |
| 35L | Counter Intelligence Agent | 55-3019.00 | Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other |
| 35M | Human Intelligence Collector | 27-3091.00 | Interpreters and Translators |
| 35N | Signals Intelligence Analyst | 43-2099.00 | Communications Equipment Operators, All Other |
| 35P | Signals Intelligence (SIGINT) Voice Interceptor | 43-2099.00, 27-3091.00 | Communications Equipment Operators, All Other; Interpreters and Translators |
| 35S | Signals Acquisition/Exploitation Analyst | 55-3019.00 | Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other |
| 35T | Military Intelligence (MI) Systems Maintainer/Integrator | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 15B | Aircraft Powerplant Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15E | RQ-7 Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15F | Aircraft Electrician | 49-2091.00 | Avionics Technicians |
| 15N | Avionic Mechanic | 49-2091.00 | Avionics Technicians |
| 15P | Aviation Operations Specialist | 53-2022.00 | Airfield Operations Specialists |
| 15Q | Air Traffic Control (ATC) Operator | 53-2021.00 | Air Traffic Controllers |
| 15R | AH-64 Attack Helicopter Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15T | UH-60 Helicopter Repairer /Aircrew Member | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15U | CH-47 Helicopter Repairer /Aircrew Member | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15W | RQ-7 Operator | 17-3024.00 | Electro-Mechanical and Mechatronics Technologists and Technicians |
| 27D | Paralegal Specialist | 23-2011.00 | Paralegals and Legal Assistants |
| 31B | Military Police | 33-3051.00 | Police and Sheriff's Patrol Officers |
| 31D | CID Special Agent | 33-3021.00 | Detectives and Criminal Investigators |
| 31E | Corrections and Detention Specialist | 33-3012.00 | Correctional Officers and Jailers |
| 37F | Psychological Operations Specialist | 55-3019.00 | Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other |
| 38B | Civil Affairs Specialist | 13-1199.04 | Business Continuity Planners |
| 42R | Musician | 27-2042.00 | Musicians and Singers |
| 42S | Special Band Musician | 27-2042.00 | Musicians and Singers |
| 46S | Public Affairs Mass Communication Specialist | 27-3031.00 | Public Relations Specialists |
| 46V | Visual Information Specialist | 27-4031.00, 27-4012.00 | Camera Operators, Television, Video, and Film; Broadcast Technicians |
| 56M | Religious Affairs Specialist | 21-2099.00 | Religious Workers, All Other |
| 79R | Recruiter | 13-1071.00 | Human Resources Specialists |
| 12C | Bridge Crewmember | 47-4099.00 | Construction and Related Workers, All Other |
| 12H | Construction Engineering Supervisor | 47-1011.00 | First-Line Supervisors of Construction Trades and Extraction Workers |
| 12Q | Powerline Distribution Specialist (RC) | 49-9051.00 | Electrical Power-Line Installers and Repairers |
| 14E | PATRIOT Fire Control Enhanced Operator/Maintainer | 55-3014.00 | Artillery and Missile Crew Members |
| 14G | Air Defense (AD) Battle Management System Operator | 55-3014.00 | Artillery and Missile Crew Members |
| 14H | Air Defense (AD) Enhanced Early Warning System Operator | 55-3014.00 | Artillery and Missile Crew Members |
| 14P | Air and Missile Defense (AMD) Crewmember | 55-3014.00 | Artillery and Missile Crew Members |
| 14T | PATRIOT Launching Station Enhanced Operator/Maintainer | 55-3014.00 | Artillery and Missile Crew Members |
| 15C | MQ-1 Operator | 17-3024.00 | Electro-Mechanical and Mechatronics Technologists and Technicians |
| 15D | Aircraft Powertrain Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15G | Aircraft Structural Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15H | Aircraft Pneudraulics Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15M | MQ-1 Repairer | 49-3011.00 | Aircraft Mechanics and Service Technicians |
| 15Y | AH-64 Armament/Electrical/Avionics Systems Repairer | 49-2091.00 | Avionics Technicians |
| 18E | Special Forces Communications Sergeant | 55-3018.00 | Special Forces |
| 18F | Special Forces Intelligence Sergeant | 55-3018.00 | Special Forces |
| 25S | Satellite Communications Systems Operator-Maintainer | 49-2021.00, 49-2094.00, 43-2099.00 | Radio, Cellular, and Tower Equipment Installers and Repairers; Electrical and Electronics Repairers, Commercial and Industrial Equipment; Communications Equipment Operators, All Other |
| 31K | Working Dog Handler | 33-3051.00 | Police and Sheriff's Patrol Officers |
| 38R | Civil Reconnaissance Sergeant (CR SGT) | 13-1199.04 | Business Continuity Planners |
| 38W | Civil Affairs Medical Sergeant (CA Medical SGT) | 13-1199.04 | Business Continuity Planners |
| 46T | Visual Information Equipment Operator-Maintainer | 27-4011.00, 49-2097.00 | Audio and Video Technicians; Audiovisual Equipment Installers and Repairers |
| 68B | Orthopedic Specialist | 29-2099.00 | Health Technologists and Technicians, All Other |
| 68D | Operating Room Specialist | 29-2055.00 | Surgical Technologists |
| 68F | Physical Therapy Specialist | 31-2021.00 | Physical Therapist Assistants |
| 68H | Optical Laboratory Specialist | 51-9083.00 | Ophthalmic Laboratory Technicians |
| 68L | Occupational Therapy Specialist | 31-2011.00 | Occupational Therapy Assistants |
| 68M | Nutrition Care Specialist | 35-2012.00 | Cooks, Institution and Cafeteria |
| 68Q | Pharmacy Specialist | 29-2052.00 | Pharmacy Technicians |
| 68R | Veterinary Food Inspection Specialist | 45-2011.00 | Agricultural Inspectors |
| 68Y | Eye Specialist | 29-2099.05 | Ophthalmic Medical Technologists |
| 79S | Career Counselor | 13-1071.00 | Human Resources Specialists |
| 79T | Recruiting and Retention NCO (Army National Guard of the United States) | 13-1071.00 | Human Resources Specialists |
| 79V | Army Reserve Career Counselor (Army Reserve) | 13-1071.00 | Human Resources Specialists |
| 88U | Railway Specialist (USAR only) | 53-4011.00 | Locomotive Engineers |
| 89A | Ammunition Stock Control and Accounting Specialist | 47-5032.00 | Explosives Workers, Ordnance Handling Experts, and Blasters |
| 91A | M1 Abrams Tank System Maintainer | 49-3042.00, 49-3031.00 | Mobile Heavy Equipment Mechanics, Except Engines; Bus and Truck Mechanics and Diesel Engine Specialists |
| 91C | Utilities Equipment Repairer | 49-9021.00 | Heating, Air Conditioning, and Refrigeration Mechanics and Installers |
| 91D | Tactical Power Generation Specialist | 49-3031.00 | Bus and Truck Mechanics and Diesel Engine Specialists |
| 91F | Small Arms/Towed Artillery Repairer | 49-9099.00 | Installation, Maintenance, and Repair Workers, All Other |
| 91H | Tracked Vehicle Repairer | 49-3042.00, 49-3031.00 | Mobile Heavy Equipment Mechanics, Except Engines; Bus and Truck Mechanics and Diesel Engine Specialists |
| 91J | Quartermaster and Chemical Equipment Repairer | 49-9041.00 | Industrial Machinery Mechanics |
| 91L | Construction Equipment Repairer | 49-3042.00 | Mobile Heavy Equipment Mechanics, Except Engines |
| 91M | BRADLEY Fighting Vehicle System Maintainer | 49-3042.00, 49-3031.00 | Mobile Heavy Equipment Mechanics, Except Engines; Bus and Truck Mechanics and Diesel Engine Specialists |
| 91P | Self Propelled Artillery Systems Mechanic | 49-3042.00, 49-2094.00 | Mobile Heavy Equipment Mechanics, Except Engines; Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94A | Land Combat Electronic Missile System Repairer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94D | Air Traffic Control Equipment Repairer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94F | Computer/Detection Systems Repairer | 49-2011.00, 49-2098.00 | Computer, Automated Teller, and Office Machine Repairers; Security and Fire Alarm Systems Installers |
| 94H | Test, Measurement, and Diagnostic Equipment (TMDE) Maintenance Support Specialist | 49-9069.00 | Precision Instrument and Equipment Repairers, All Other |
| 94M | Radar Repairer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94P | Multiple Launch Rocket System (MLRS) Repairer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94R | Avionic and Survivability Equipment Repairer | 49-2091.00 | Avionics Technicians |
| 94S | PATRIOT System Repairer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94T | Short Range Air Defense System Repairer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |
| 94Y | Automatic Test Systems Operator/Maintainer | 49-2094.00 | Electrical and Electronics Repairers, Commercial and Industrial Equipment |

## 4. The 6 codes the crosswalk does not cover

These are in the app's roster and **not** in mosCivilianByCode. They are omitted
rather than filled in with a plausible title:

| MOS | Why there is no mapping |
|---|---|
| 19C | the crosswalk has only obsolete officer records for this code; the newest ended 2016-10 |
| 08H | the crosswalk carries no record for this code at all |
| 15X | the crosswalk has only obsolete enlisted records for this code; the newest ended 2015-10 |
| 40D | the crosswalk carries no record for this code at all |
| 42T | the crosswalk carries no record for this code at all |
| 88P | the crosswalk has only obsolete enlisted records for this code; the newest ended 2016-10 |

The gap has a dated explanation, not a data-entry excuse. 08H, 40D and 42T
were added to DA Pam 611-21 after the milx0724 (updated August 2024) build, so no
crosswalk this app could download today would carry them. 19C exists in the
crosswalk only as an obsolete *officer* code ("Cavalry", ended 2016-10), and
15X and 88P only as obsolete enlisted codes, so none of the three describes
the job the app now lists under that code - a mapping taken from them would
name the wrong work.

Re-download the crosswalk and re-run the join when DMDC publishes a newer
build; the omitted list is the thing that should shrink.

## 5. What this does and does not claim

**Claims:** for 150 of the 156 codes, the O*NET-SOC occupations the crosswalk
records against that code, with their titles verbatim.

**Does not claim:**

- that a title is an exhaustive list of what a soldier can do afterwards. It is
  what the crosswalk records, which for 133 codes is a single occupation;
- that a military-titled O*NET-SOC code is a civilian job. 22 codes map only to
  O*NET's military block (55-xxxx), for example 11B -> "Infantry" (55-3016.00).
  The app's note says so; the civilian equivalent for those is not something the
  crosswalk states, so it is not stated here either;
- that the crosswalk is current. It is the milx0724 (updated August 2024) build,
  retrieved 26 October 2026, and DMDC revises it; the retrieved date travels
  with the data for exactly that reason;
- that this is career advice. It is a sourced list of occupations; whether the
  work is open to a given candidate is a different question.

## 6. How to re-verify

```bash
# 1. download the crosswalk (docs/research/_raw/ is gitignored)
#    https://www.onetcenter.org/crosswalks.html -> MOC crosswalk ZIP
#    unzip to docs/research/_raw/moc_crosswalk/extracted/
# 2. check the ZIP against the SHA-256 above, then rebuild the join
python docs/research/moc_to_onet.py
dart format lib/data/repos/mos_civilian.dart lib/data/repos/mos_civilian_data.dart
# 3. the invariants are tested
flutter test test/mos_civilian_test.dart
```

docs/research/moc-onet-join.json is the machine-readable companion: per code,
the crosswalk MOC title, the O*NET-SOC codes and titles, the note as rendered,
and the omitted codes with their reasons.
