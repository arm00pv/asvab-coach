/// GENERATED FILE - do not edit by hand.
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
/// Coverage: 150 of the 156 MOS codes the app carries
/// (96.2%), from the O*NET MOC crosswalk milx0724 (updated August 2024), retrieved
/// 26 October 2026. Omitted, because the crosswalk does not cover them:
/// 19C, 08H, 15X, 40D, 42T, 88P.
///
/// LICENCE. O*NET content is CC BY 4.0. [mosCivilianAttribution] is the
/// attribution the licence requires; it has to travel with the data wherever
/// this is shown or redistributed.
library;

/// One occupation the crosswalk links an MOS to.
typedef CivilianOccupation = ({String onetSocCode, String title});

/// What the crosswalk says one MOS transfers to.
///
/// A record rather than a class: three fields, no behaviour, so the map below
/// can be a compile-time constant. [note] is the sentence a screen prints after
/// "In civilian life:" - under 200 characters, asserted by
/// test/mos_civilian_test.dart. [mocTitle] is the crosswalk's own title for the
/// code, which is how a re-verifier matches a row without trusting this file.
typedef MosCivilianOutlook = ({
  String mocTitle,
  List<CivilianOccupation> occupations,
  String note,
});

/// The attribution the O*NET licence requires (CC BY 4.0), verbatim.
const String mosCivilianAttribution =
    'Includes information from O*NET Resource Center by the U.S. Department of Labor, Employment and Training Administration (USDOL/ETA). Used under the CC BY 4.0 license (https://creativecommons.org/licenses/by/4.0/). O*NET® is a trademark of USDOL/ETA. ASVAB Coach has modified all or some of this information: the O*NET Military Occupational Classification (MOC) crosswalk (milx0724, updated August 2024) was joined to the MOS codes this app carries and reformatted as Dart constants. USDOL/ETA has not approved, endorsed, or tested these modifications.';

/// The licence the crosswalk data is used under.
const String mosCivilianLicence =
    'CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/)';

/// Where the crosswalk came from, in enough detail to re-do the work.
const String mosCivilianSource =
    'O*NET Military Occupational Classification (MOC) crosswalk, '
    'milx0724 (updated August 2024)';

/// The download page the crosswalk was taken from.
const String mosCivilianSourceUrl =
    'https://www.onetcenter.org/crosswalks.html';

/// The exact file inside the ZIP the join was made from.
const String mosCivilianSourceFile = 'milx0724.xlsx';

/// SHA-256 of that ZIP, so a re-download can be checked.
const String mosCivilianSourceSha256 =
    'ee7381411644fd39adaf93e7f3a8814773b28f4e8a5b2c00c7ad6b775b01d747';

/// The day the crosswalk file was downloaded.
const String mosCivilianRetrievedOn = '26 October 2026';

/// The same date, in the form a data file wants.
const String mosCivilianRetrievedOnIso = '2026-10-26';

/// MOS code -> what the crosswalk says it transfers to.
///
/// 150 of the 156 codes the app carries. A code missing from this map is
/// missing because the crosswalk has no active Army enlisted record for it -
/// docs/MOS_CIVILIAN.md lists them with the reason for each.
const Map<String, MosCivilianOutlook>
mosCivilianByCode = <String, MosCivilianOutlook>{
  '11B': (
    mocTitle: 'Infantryman',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3016.00', title: 'Infantry'),
    ],
    note: 'Infantry (O*NET-SOC 55-3016.00; military occupation)',
  ),
  '11C': (
    mocTitle: 'Indirect Fire Infantryman',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3016.00', title: 'Infantry'),
    ],
    note: 'Infantry (O*NET-SOC 55-3016.00; military occupation)',
  ),
  '12B': (
    mocTitle: 'Combat Engineer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-4099.00',
        title: 'Construction and Related Workers, All Other',
      ),
    ],
    note: 'Construction and Related Workers, All Other',
  ),
  '13B': (
    mocTitle: 'Cannon Crewmember',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '13F': (
    mocTitle: 'Joint Fire Support Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '13J': (
    mocTitle: 'Fire Control Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '13M': (
    mocTitle: 'Multiple Launch Rocket System (MLRS)/High Mobility Artillery Rocket System (HIMARS) Crewmember',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '13R': (
    mocTitle: 'Field Artillery (FA) Weapons Locating Radar (WLR) Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '17-3029.00',
        title: 'Engineering Technologists and Technicians, Except Drafters, All Other',
      ),
    ],
    note:
        'Engineering Technologists and Technicians, Except Drafters, All Other',
  ),
  '19D': (
    mocTitle: 'Cavalry Scout',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '55-3013.00',
        title: 'Armored Assault Vehicle Crew Members',
      ),
    ],
    note: 'Armored Assault Vehicle Crew Members (O*NET-SOC 55-3013.00; military occupation)',
  ),
  '19K': (
    mocTitle: 'M1 Armor Crewman',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '55-3013.00',
        title: 'Armored Assault Vehicle Crew Members',
      ),
    ],
    note: 'Armored Assault Vehicle Crew Members (O*NET-SOC 55-3013.00; military occupation)',
  ),
  '18B': (
    mocTitle: 'Special Forces Weapons Sergeant',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3018.00', title: 'Special Forces'),
    ],
    note: 'Special Forces (O*NET-SOC 55-3018.00; military occupation)',
  ),
  '18C': (
    mocTitle: 'Special Forces Engineer Sergeant',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3018.00', title: 'Special Forces'),
    ],
    note: 'Special Forces (O*NET-SOC 55-3018.00; military occupation)',
  ),
  '18D': (
    mocTitle: 'Special Forces Medical Sergeant',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3018.00', title: 'Special Forces'),
    ],
    note: 'Special Forces (O*NET-SOC 55-3018.00; military occupation)',
  ),
  '12D': (
    mocTitle: 'Diver',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-9092.00', title: 'Commercial Divers'),
    ],
    note: 'Commercial Divers',
  ),
  '12G': (
    mocTitle: 'Quarrying Specialist (RC)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '47-5051.00', title: 'Rock Splitters, Quarry'),
    ],
    note: 'Rock Splitters, Quarry',
  ),
  '12K': (
    mocTitle: 'Plumber',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-2152.00',
        title: 'Plumbers, Pipefitters, and Steamfitters',
      ),
    ],
    note: 'Plumbers, Pipefitters, and Steamfitters',
  ),
  '12M': (
    mocTitle: 'Firefighter',
    occupations: <CivilianOccupation>[
      (onetSocCode: '33-2011.00', title: 'Firefighters'),
    ],
    note: 'Firefighters',
  ),
  '12N': (
    mocTitle: 'Horizontal Construction Engineer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-1011.00',
        title: 'First-Line Supervisors of Construction Trades and Extraction Workers',
      ),
    ],
    note:
        'First-Line Supervisors of Construction Trades and Extraction Workers',
  ),
  '12P': (
    mocTitle: 'Prime Power Production Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '51-8021.00',
        title: 'Stationary Engineers and Boiler Operators',
      ),
    ],
    note: 'Stationary Engineers and Boiler Operators',
  ),
  '12R': (
    mocTitle: 'Interior Electrician',
    occupations: <CivilianOccupation>[
      (onetSocCode: '47-2111.00', title: 'Electricians'),
    ],
    note: 'Electricians',
  ),
  '12T': (
    mocTitle: 'Technical Engineer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '17-3022.00',
        title: 'Civil Engineering Technologists and Technicians',
      ),
    ],
    note: 'Civil Engineering Technologists and Technicians',
  ),
  '12W': (
    mocTitle: 'Carpentry and Masonry Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '47-2031.00', title: 'Carpenters'),
    ],
    note: 'Carpenters',
  ),
  '12Y': (
    mocTitle: 'Geospatial Engineer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '17-1021.00', title: 'Cartographers and Photogrammetrists'),
    ],
    note: 'Cartographers and Photogrammetrists',
  ),
  '88H': (
    mocTitle: 'Cargo Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-7199.00', title: 'Material Moving Workers, All Other'),
    ],
    note: 'Material Moving Workers, All Other',
  ),
  '88K': (
    mocTitle: 'Watercraft Operator',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '53-5021.00',
        title: 'Captains, Mates, and Pilots of Water Vessels',
      ),
    ],
    note: 'Captains, Mates, and Pilots of Water Vessels',
  ),
  '88L': (
    mocTitle: 'Watercraft Engineer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-5031.00', title: 'Ship Engineers'),
    ],
    note: 'Ship Engineers',
  ),
  '88M': (
    mocTitle: 'Motor Transport Operator',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '53-3032.00',
        title: 'Heavy and Tractor-Trailer Truck Drivers',
      ),
    ],
    note: 'Heavy and Tractor-Trailer Truck Drivers',
  ),
  '88N': (
    mocTitle: 'Transportation Management Coordinator',
    occupations: <CivilianOccupation>[
      (onetSocCode: '43-5011.00', title: 'Cargo and Freight Agents'),
    ],
    note: 'Cargo and Freight Agents',
  ),
  '89B': (
    mocTitle: 'Ammunition Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-5032.00',
        title: 'Explosives Workers, Ordnance Handling Experts, and Blasters',
      ),
    ],
    note: 'Explosives Workers, Ordnance Handling Experts, and Blasters',
  ),
  '89D': (
    mocTitle: 'Explosive Ordnance Disposal (EOD) Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-5032.00',
        title: 'Explosives Workers, Ordnance Handling Experts, and Blasters',
      ),
    ],
    note: 'Explosives Workers, Ordnance Handling Experts, and Blasters',
  ),
  '92A': (
    mocTitle: 'Automated Logistical Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-7065.00', title: 'Stockers and Order Fillers'),
    ],
    note: 'Stockers and Order Fillers',
  ),
  '92F': (
    mocTitle: 'Petroleum Supply Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '53-7072.00',
        title: 'Pump Operators, Except Wellhead Pumpers',
      ),
    ],
    note: 'Pump Operators, Except Wellhead Pumpers',
  ),
  '92G': (
    mocTitle: 'Culinary Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '35-2012.00', title: 'Cooks, Institution and Cafeteria'),
      (onetSocCode: '35-2021.00', title: 'Food Preparation Workers'),
    ],
    note: 'Cooks, Institution and Cafeteria; Food Preparation Workers',
  ),
  '92L': (
    mocTitle: 'Petroleum Laboratory Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '19-4043.00',
        title: 'Geological Technicians, Except Hydrologic Technicians',
      ),
    ],
    note: 'Geological Technicians, Except Hydrologic Technicians',
  ),
  '92M': (
    mocTitle: 'Mortuary Affairs Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '39-9099.00',
        title: 'Personal Care and Service Workers, All Other',
      ),
    ],
    note: 'Personal Care and Service Workers, All Other',
  ),
  '92R': (
    mocTitle: 'Parachute Rigger',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-9099.00',
        title: 'Installation, Maintenance, and Repair Workers, All Other',
      ),
    ],
    note: 'Installation, Maintenance, and Repair Workers, All Other',
  ),
  '92S': (
    mocTitle: 'Shower and Laundry Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '51-6011.00', title: 'Laundry and Dry-Cleaning Workers'),
      (
        onetSocCode: '49-9099.00',
        title: 'Installation, Maintenance, and Repair Workers, All Other',
      ),
    ],
    note: 'Laundry and Dry-Cleaning Workers; Installation, Maintenance, and Repair Workers, All Other',
  ),
  '92W': (
    mocTitle: 'Water Treatment Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '51-8031.00',
        title: 'Water and Wastewater Treatment Plant and System Operators',
      ),
    ],
    note: 'Water and Wastewater Treatment Plant and System Operators',
  ),
  '92Y': (
    mocTitle: 'Unit Supply Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-7065.00', title: 'Stockers and Order Fillers'),
    ],
    note: 'Stockers and Order Fillers',
  ),
  '74D': (
    mocTitle:
        'Chemical, Biological, Radiological, and Nuclear (CBRN) Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '47-4041.00', title: 'Hazardous Materials Removal Workers'),
    ],
    note: 'Hazardous Materials Removal Workers',
  ),
  '36B': (
    mocTitle: 'Financial Management Technician',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-3031.00',
        title: 'Bookkeeping, Accounting, and Auditing Clerks',
      ),
    ],
    note: 'Bookkeeping, Accounting, and Auditing Clerks',
  ),
  '42A': (
    mocTitle: 'Human Resources Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-4161.00',
        title: 'Human Resources Assistants, Except Payroll and Timekeeping',
      ),
    ],
    note: 'Human Resources Assistants, Except Payroll and Timekeeping',
  ),
  '51C': (
    mocTitle: 'Contracting Noncommissioned Officer (NCO)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '43-3061.00', title: 'Procurement Clerks'),
    ],
    note: 'Procurement Clerks',
  ),
  '91B': (
    mocTitle: 'Wheeled Vehicle Mechanic',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3023.00',
        title: 'Automotive Service Technicians and Mechanics',
      ),
      (
        onetSocCode: '49-3031.00',
        title: 'Bus and Truck Mechanics and Diesel Engine Specialists',
      ),
    ],
    note: 'Automotive Service Technicians and Mechanics; Bus and Truck Mechanics and Diesel Engine Specialists',
  ),
  '91E': (
    mocTitle: 'Allied Trades Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '51-4041.00', title: 'Machinists'),
    ],
    note: 'Machinists',
  ),
  '91S': (
    mocTitle: 'STRYKER Systems Maintainer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3031.00',
        title: 'Bus and Truck Mechanics and Diesel Engine Specialists',
      ),
      (
        onetSocCode: '49-3042.00',
        title: 'Mobile Heavy Equipment Mechanics, Except Engines',
      ),
      (
        onetSocCode: '49-3023.00',
        title: 'Automotive Service Technicians and Mechanics',
      ),
    ],
    note: 'Bus and Truck Mechanics and Diesel Engine Specialists; Mobile Heavy Equipment Mechanics, Except Engines; Automotive Service Technicians and Mechanics',
  ),
  '94E': (
    mocTitle: 'Radio Equipment Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2021.00',
        title: 'Radio, Cellular, and Tower Equipment Installers and Repairers',
      ),
    ],
    note: 'Radio, Cellular, and Tower Equipment Installers and Repairers',
  ),
  '68A': (
    mocTitle: 'Biomedical Equipment Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-9062.00', title: 'Medical Equipment Repairers'),
    ],
    note: 'Medical Equipment Repairers',
  ),
  '68C': (
    mocTitle: 'Practical Nursing Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '29-2061.00',
        title: 'Licensed Practical and Licensed Vocational Nurses',
      ),
    ],
    note: 'Licensed Practical and Licensed Vocational Nurses',
  ),
  '68E': (
    mocTitle: 'Dental Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '31-9091.00', title: 'Dental Assistants'),
      (onetSocCode: '29-1292.00', title: 'Dental Hygienists'),
    ],
    note: 'Dental Assistants; Dental Hygienists',
  ),
  '68G': (
    mocTitle: 'Patient Administration Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '29-2072.00', title: 'Medical Records Specialists'),
    ],
    note: 'Medical Records Specialists',
  ),
  '68J': (
    mocTitle: 'Medical Logistics Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-5071.00',
        title: 'Shipping, Receiving, and Inventory Clerks',
      ),
    ],
    note: 'Shipping, Receiving, and Inventory Clerks',
  ),
  '68K': (
    mocTitle: 'Medical Laboratory Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '29-2011.00',
        title: 'Medical and Clinical Laboratory Technologists',
      ),
    ],
    note: 'Medical and Clinical Laboratory Technologists',
  ),
  '68P': (
    mocTitle: 'Radiology Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '29-2034.00',
        title: 'Radiologic Technologists and Technicians',
      ),
    ],
    note: 'Radiologic Technologists and Technicians',
  ),
  '68S': (
    mocTitle: 'Preventive Medicine Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '19-5012.00',
        title: 'Occupational Health and Safety Technicians',
      ),
    ],
    note: 'Occupational Health and Safety Technicians',
  ),
  '68T': (
    mocTitle: 'Animal Care Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '31-9096.00',
        title: 'Veterinary Assistants and Laboratory Animal Caretakers',
      ),
    ],
    note: 'Veterinary Assistants and Laboratory Animal Caretakers',
  ),
  '68V': (
    mocTitle: 'Respiratory Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '29-2099.00',
        title: 'Health Technologists and Technicians, All Other',
      ),
    ],
    note: 'Health Technologists and Technicians, All Other',
  ),
  '68W': (
    mocTitle: 'Combat Medic Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '29-2043.00', title: 'Paramedics'),
    ],
    note: 'Paramedics',
  ),
  '68X': (
    mocTitle: 'Behavioral Health Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '29-2053.00', title: 'Psychiatric Technicians'),
    ],
    note: 'Psychiatric Technicians',
  ),
  '17C': (
    mocTitle: 'Cyber Operations Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '15-1212.00', title: 'Information Security Analysts'),
    ],
    note: 'Information Security Analysts',
  ),
  '17E': (
    mocTitle: 'Electronic Warfare Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '15-1212.00', title: 'Information Security Analysts'),
    ],
    note: 'Information Security Analysts',
  ),
  '25B': (
    mocTitle: 'Information Technology Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '15-1299.00', title: 'Computer Occupations, All Other'),
    ],
    note: 'Computer Occupations, All Other',
  ),
  '25D': (
    mocTitle: 'Cyber Network Defender',
    occupations: <CivilianOccupation>[
      (onetSocCode: '15-1212.00', title: 'Information Security Analysts'),
      (
        onetSocCode: '15-1244.00',
        title: 'Network and Computer Systems Administrators',
      ),
    ],
    note: 'Information Security Analysts; Network and Computer Systems Administrators',
  ),
  '25E': (
    mocTitle: 'Electromagnetic Spectrum Manager',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-2099.00',
        title: 'Communications Equipment Operators, All Other',
      ),
    ],
    note: 'Communications Equipment Operators, All Other',
  ),
  '25H': (
    mocTitle: 'Network Communication Systems Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '15-1244.00',
        title: 'Network and Computer Systems Administrators',
      ),
    ],
    note: 'Network and Computer Systems Administrators',
  ),
  '25U': (
    mocTitle: 'Signal Operations Support Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-2099.00',
        title: 'Communications Equipment Operators, All Other',
      ),
      (onetSocCode: '27-4012.00', title: 'Broadcast Technicians'),
      (
        onetSocCode: '49-2021.00',
        title: 'Radio, Cellular, and Tower Equipment Installers and Repairers',
      ),
    ],
    note: 'Communications Equipment Operators, All Other; Broadcast Technicians; Radio, Cellular, and Tower Equipment Installers and Repairers',
  ),
  '35F': (
    mocTitle: 'Intelligence Analyst',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '55-3019.00',
        title: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other',
      ),
    ],
    note: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other (O*NET-SOC 55-3019.00; military occupation)',
  ),
  '35G': (
    mocTitle: 'Geospatial Intelligence Imagery Analyst',
    occupations: <CivilianOccupation>[
      (onetSocCode: '17-1021.00', title: 'Cartographers and Photogrammetrists'),
      (onetSocCode: '17-3031.00', title: 'Surveying and Mapping Technicians'),
    ],
    note: 'Cartographers and Photogrammetrists; Surveying and Mapping Technicians',
  ),
  '35L': (
    mocTitle: 'Counter Intelligence Agent',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '55-3019.00',
        title: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other',
      ),
    ],
    note: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other (O*NET-SOC 55-3019.00; military occupation)',
  ),
  '35M': (
    mocTitle: 'Human Intelligence Collector',
    occupations: <CivilianOccupation>[
      (onetSocCode: '27-3091.00', title: 'Interpreters and Translators'),
    ],
    note: 'Interpreters and Translators',
  ),
  '35N': (
    mocTitle: 'Signals Intelligence Analyst',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-2099.00',
        title: 'Communications Equipment Operators, All Other',
      ),
    ],
    note: 'Communications Equipment Operators, All Other',
  ),
  '35P': (
    mocTitle: 'Signals Intelligence (SIGINT) Voice Interceptor',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '43-2099.00',
        title: 'Communications Equipment Operators, All Other',
      ),
      (onetSocCode: '27-3091.00', title: 'Interpreters and Translators'),
    ],
    note: 'Communications Equipment Operators, All Other; Interpreters and Translators',
  ),
  '35S': (
    mocTitle: 'Signals Acquisition/Exploitation Analyst',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '55-3019.00',
        title: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other',
      ),
    ],
    note: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other (O*NET-SOC 55-3019.00; military occupation)',
  ),
  '35T': (
    mocTitle: 'Military Intelligence (MI) Systems Maintainer/Integrator',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '15B': (
    mocTitle: 'Aircraft Powerplant Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15E': (
    mocTitle: 'RQ-7 Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15F': (
    mocTitle: 'Aircraft Electrician',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-2091.00', title: 'Avionics Technicians'),
    ],
    note: 'Avionics Technicians',
  ),
  '15N': (
    mocTitle: 'Avionic Mechanic',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-2091.00', title: 'Avionics Technicians'),
    ],
    note: 'Avionics Technicians',
  ),
  '15P': (
    mocTitle: 'Aviation Operations Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-2022.00', title: 'Airfield Operations Specialists'),
    ],
    note: 'Airfield Operations Specialists',
  ),
  '15Q': (
    mocTitle: 'Air Traffic Control (ATC) Operator',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-2021.00', title: 'Air Traffic Controllers'),
    ],
    note: 'Air Traffic Controllers',
  ),
  '15R': (
    mocTitle: 'AH-64 Attack Helicopter Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15T': (
    mocTitle: 'UH-60 Helicopter Repairer /Aircrew Member',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15U': (
    mocTitle: 'CH-47 Helicopter Repairer /Aircrew Member',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15W': (
    mocTitle: 'RQ-7 Operator',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '17-3024.00',
        title:
            'Electro-Mechanical and Mechatronics Technologists and Technicians',
      ),
    ],
    note: 'Electro-Mechanical and Mechatronics Technologists and Technicians',
  ),
  '27D': (
    mocTitle: 'Paralegal Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '23-2011.00', title: 'Paralegals and Legal Assistants'),
    ],
    note: 'Paralegals and Legal Assistants',
  ),
  '31B': (
    mocTitle: 'Military Police',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '33-3051.00',
        title: 'Police and Sheriff\'s Patrol Officers',
      ),
    ],
    note: 'Police and Sheriff\'s Patrol Officers',
  ),
  '31D': (
    mocTitle: 'CID Special Agent',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '33-3021.00',
        title: 'Detectives and Criminal Investigators',
      ),
    ],
    note: 'Detectives and Criminal Investigators',
  ),
  '31E': (
    mocTitle: 'Corrections and Detention Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '33-3012.00', title: 'Correctional Officers and Jailers'),
    ],
    note: 'Correctional Officers and Jailers',
  ),
  '37F': (
    mocTitle: 'Psychological Operations Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '55-3019.00',
        title: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other',
      ),
    ],
    note: 'Military Enlisted Tactical Operations and Air/Weapons Specialists and Crew Members, All Other (O*NET-SOC 55-3019.00; military occupation)',
  ),
  '38B': (
    mocTitle: 'Civil Affairs Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1199.04', title: 'Business Continuity Planners'),
    ],
    note: 'Business Continuity Planners',
  ),
  '42R': (
    mocTitle: 'Musician',
    occupations: <CivilianOccupation>[
      (onetSocCode: '27-2042.00', title: 'Musicians and Singers'),
    ],
    note: 'Musicians and Singers',
  ),
  '42S': (
    mocTitle: 'Special Band Musician',
    occupations: <CivilianOccupation>[
      (onetSocCode: '27-2042.00', title: 'Musicians and Singers'),
    ],
    note: 'Musicians and Singers',
  ),
  '46S': (
    mocTitle: 'Public Affairs Mass Communication Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '27-3031.00', title: 'Public Relations Specialists'),
    ],
    note: 'Public Relations Specialists',
  ),
  '46V': (
    mocTitle: 'Visual Information Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '27-4031.00',
        title: 'Camera Operators, Television, Video, and Film',
      ),
      (onetSocCode: '27-4012.00', title: 'Broadcast Technicians'),
    ],
    note:
        'Camera Operators, Television, Video, and Film; Broadcast Technicians',
  ),
  '56M': (
    mocTitle: 'Religious Affairs Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '21-2099.00', title: 'Religious Workers, All Other'),
    ],
    note: 'Religious Workers, All Other',
  ),
  '79R': (
    mocTitle: 'Recruiter',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1071.00', title: 'Human Resources Specialists'),
    ],
    note: 'Human Resources Specialists',
  ),
  '12C': (
    mocTitle: 'Bridge Crewmember',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-4099.00',
        title: 'Construction and Related Workers, All Other',
      ),
    ],
    note: 'Construction and Related Workers, All Other',
  ),
  '12H': (
    mocTitle: 'Construction Engineering Supervisor',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-1011.00',
        title: 'First-Line Supervisors of Construction Trades and Extraction Workers',
      ),
    ],
    note:
        'First-Line Supervisors of Construction Trades and Extraction Workers',
  ),
  '12Q': (
    mocTitle: 'Powerline Distribution Specialist (RC)',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-9051.00',
        title: 'Electrical Power-Line Installers and Repairers',
      ),
    ],
    note: 'Electrical Power-Line Installers and Repairers',
  ),
  '14E': (
    mocTitle: 'PATRIOT Fire Control Enhanced Operator/Maintainer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '14G': (
    mocTitle: 'Air Defense (AD) Battle Management System Operator',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '14H': (
    mocTitle: 'Air Defense (AD) Enhanced Early Warning System Operator',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '14P': (
    mocTitle: 'Air and Missile Defense (AMD) Crewmember',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '14T': (
    mocTitle: 'PATRIOT Launching Station Enhanced Operator/Maintainer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3014.00', title: 'Artillery and Missile Crew Members'),
    ],
    note: 'Artillery and Missile Crew Members (O*NET-SOC 55-3014.00; military occupation)',
  ),
  '15C': (
    mocTitle: 'MQ-1 Operator',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '17-3024.00',
        title:
            'Electro-Mechanical and Mechatronics Technologists and Technicians',
      ),
    ],
    note: 'Electro-Mechanical and Mechatronics Technologists and Technicians',
  ),
  '15D': (
    mocTitle: 'Aircraft Powertrain Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15G': (
    mocTitle: 'Aircraft Structural Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15H': (
    mocTitle: 'Aircraft Pneudraulics Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15M': (
    mocTitle: 'MQ-1 Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3011.00',
        title: 'Aircraft Mechanics and Service Technicians',
      ),
    ],
    note: 'Aircraft Mechanics and Service Technicians',
  ),
  '15Y': (
    mocTitle: 'AH-64 Armament/Electrical/Avionics Systems Repairer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-2091.00', title: 'Avionics Technicians'),
    ],
    note: 'Avionics Technicians',
  ),
  '18E': (
    mocTitle: 'Special Forces Communications Sergeant',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3018.00', title: 'Special Forces'),
    ],
    note: 'Special Forces (O*NET-SOC 55-3018.00; military occupation)',
  ),
  '18F': (
    mocTitle: 'Special Forces Intelligence Sergeant',
    occupations: <CivilianOccupation>[
      (onetSocCode: '55-3018.00', title: 'Special Forces'),
    ],
    note: 'Special Forces (O*NET-SOC 55-3018.00; military occupation)',
  ),
  '25S': (
    mocTitle: 'Satellite Communications Systems Operator-Maintainer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2021.00',
        title: 'Radio, Cellular, and Tower Equipment Installers and Repairers',
      ),
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
      (
        onetSocCode: '43-2099.00',
        title: 'Communications Equipment Operators, All Other',
      ),
    ],
    note: 'Radio, Cellular, and Tower Equipment Installers and Repairers; Electrical and Electronics Repairers, Commercial and Industrial Equipment; Communications Equipment Operators, All Other',
  ),
  '31K': (
    mocTitle: 'Working Dog Handler',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '33-3051.00',
        title: 'Police and Sheriff\'s Patrol Officers',
      ),
    ],
    note: 'Police and Sheriff\'s Patrol Officers',
  ),
  '38R': (
    mocTitle: 'Civil Reconnaissance Sergeant (CR SGT)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1199.04', title: 'Business Continuity Planners'),
    ],
    note: 'Business Continuity Planners',
  ),
  '38W': (
    mocTitle: 'Civil Affairs Medical Sergeant (CA Medical SGT)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1199.04', title: 'Business Continuity Planners'),
    ],
    note: 'Business Continuity Planners',
  ),
  '46T': (
    mocTitle: 'Visual Information Equipment Operator-Maintainer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '27-4011.00', title: 'Audio and Video Technicians'),
      (
        onetSocCode: '49-2097.00',
        title: 'Audiovisual Equipment Installers and Repairers',
      ),
    ],
    note: 'Audio and Video Technicians; Audiovisual Equipment Installers and Repairers',
  ),
  '68B': (
    mocTitle: 'Orthopedic Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '29-2099.00',
        title: 'Health Technologists and Technicians, All Other',
      ),
    ],
    note: 'Health Technologists and Technicians, All Other',
  ),
  '68D': (
    mocTitle: 'Operating Room Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '29-2055.00', title: 'Surgical Technologists'),
    ],
    note: 'Surgical Technologists',
  ),
  '68F': (
    mocTitle: 'Physical Therapy Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '31-2021.00', title: 'Physical Therapist Assistants'),
    ],
    note: 'Physical Therapist Assistants',
  ),
  '68H': (
    mocTitle: 'Optical Laboratory Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '51-9083.00', title: 'Ophthalmic Laboratory Technicians'),
    ],
    note: 'Ophthalmic Laboratory Technicians',
  ),
  '68L': (
    mocTitle: 'Occupational Therapy Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '31-2011.00', title: 'Occupational Therapy Assistants'),
    ],
    note: 'Occupational Therapy Assistants',
  ),
  '68M': (
    mocTitle: 'Nutrition Care Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '35-2012.00', title: 'Cooks, Institution and Cafeteria'),
    ],
    note: 'Cooks, Institution and Cafeteria',
  ),
  '68Q': (
    mocTitle: 'Pharmacy Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '29-2052.00', title: 'Pharmacy Technicians'),
    ],
    note: 'Pharmacy Technicians',
  ),
  '68R': (
    mocTitle: 'Veterinary Food Inspection Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '45-2011.00', title: 'Agricultural Inspectors'),
    ],
    note: 'Agricultural Inspectors',
  ),
  '68Y': (
    mocTitle: 'Eye Specialist',
    occupations: <CivilianOccupation>[
      (onetSocCode: '29-2099.05', title: 'Ophthalmic Medical Technologists'),
    ],
    note: 'Ophthalmic Medical Technologists',
  ),
  '79S': (
    mocTitle: 'Career Counselor',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1071.00', title: 'Human Resources Specialists'),
    ],
    note: 'Human Resources Specialists',
  ),
  '79T': (
    mocTitle: 'Recruiting and Retention NCO (Army National Guard of the United States)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1071.00', title: 'Human Resources Specialists'),
    ],
    note: 'Human Resources Specialists',
  ),
  '79V': (
    mocTitle: 'Army Reserve Career Counselor (Army Reserve)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '13-1071.00', title: 'Human Resources Specialists'),
    ],
    note: 'Human Resources Specialists',
  ),
  '88U': (
    mocTitle: 'Railway Specialist (USAR only)',
    occupations: <CivilianOccupation>[
      (onetSocCode: '53-4011.00', title: 'Locomotive Engineers'),
    ],
    note: 'Locomotive Engineers',
  ),
  '89A': (
    mocTitle: 'Ammunition Stock Control and Accounting Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '47-5032.00',
        title: 'Explosives Workers, Ordnance Handling Experts, and Blasters',
      ),
    ],
    note: 'Explosives Workers, Ordnance Handling Experts, and Blasters',
  ),
  '91A': (
    mocTitle: 'M1 Abrams Tank System Maintainer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3042.00',
        title: 'Mobile Heavy Equipment Mechanics, Except Engines',
      ),
      (
        onetSocCode: '49-3031.00',
        title: 'Bus and Truck Mechanics and Diesel Engine Specialists',
      ),
    ],
    note: 'Mobile Heavy Equipment Mechanics, Except Engines; Bus and Truck Mechanics and Diesel Engine Specialists',
  ),
  '91C': (
    mocTitle: 'Utilities Equipment Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-9021.00',
        title: 'Heating, Air Conditioning, and Refrigeration Mechanics and Installers',
      ),
    ],
    note:
        'Heating, Air Conditioning, and Refrigeration Mechanics and Installers',
  ),
  '91D': (
    mocTitle: 'Tactical Power Generation Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3031.00',
        title: 'Bus and Truck Mechanics and Diesel Engine Specialists',
      ),
    ],
    note: 'Bus and Truck Mechanics and Diesel Engine Specialists',
  ),
  '91F': (
    mocTitle: 'Small Arms/Towed Artillery Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-9099.00',
        title: 'Installation, Maintenance, and Repair Workers, All Other',
      ),
    ],
    note: 'Installation, Maintenance, and Repair Workers, All Other',
  ),
  '91H': (
    mocTitle: 'Tracked Vehicle Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3042.00',
        title: 'Mobile Heavy Equipment Mechanics, Except Engines',
      ),
      (
        onetSocCode: '49-3031.00',
        title: 'Bus and Truck Mechanics and Diesel Engine Specialists',
      ),
    ],
    note: 'Mobile Heavy Equipment Mechanics, Except Engines; Bus and Truck Mechanics and Diesel Engine Specialists',
  ),
  '91J': (
    mocTitle: 'Quartermaster and Chemical Equipment Repairer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-9041.00', title: 'Industrial Machinery Mechanics'),
    ],
    note: 'Industrial Machinery Mechanics',
  ),
  '91L': (
    mocTitle: 'Construction Equipment Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3042.00',
        title: 'Mobile Heavy Equipment Mechanics, Except Engines',
      ),
    ],
    note: 'Mobile Heavy Equipment Mechanics, Except Engines',
  ),
  '91M': (
    mocTitle: 'BRADLEY Fighting Vehicle System Maintainer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3042.00',
        title: 'Mobile Heavy Equipment Mechanics, Except Engines',
      ),
      (
        onetSocCode: '49-3031.00',
        title: 'Bus and Truck Mechanics and Diesel Engine Specialists',
      ),
    ],
    note: 'Mobile Heavy Equipment Mechanics, Except Engines; Bus and Truck Mechanics and Diesel Engine Specialists',
  ),
  '91P': (
    mocTitle: 'Self Propelled Artillery Systems Mechanic',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-3042.00',
        title: 'Mobile Heavy Equipment Mechanics, Except Engines',
      ),
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Mobile Heavy Equipment Mechanics, Except Engines; Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94A': (
    mocTitle: 'Land Combat Electronic Missile System Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94D': (
    mocTitle: 'Air Traffic Control Equipment Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94F': (
    mocTitle: 'Computer/Detection Systems Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2011.00',
        title: 'Computer, Automated Teller, and Office Machine Repairers',
      ),
      (
        onetSocCode: '49-2098.00',
        title: 'Security and Fire Alarm Systems Installers',
      ),
    ],
    note: 'Computer, Automated Teller, and Office Machine Repairers; Security and Fire Alarm Systems Installers',
  ),
  '94H': (
    mocTitle: 'Test, Measurement, and Diagnostic Equipment (TMDE) Maintenance Support Specialist',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-9069.00',
        title: 'Precision Instrument and Equipment Repairers, All Other',
      ),
    ],
    note: 'Precision Instrument and Equipment Repairers, All Other',
  ),
  '94M': (
    mocTitle: 'Radar Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94P': (
    mocTitle: 'Multiple Launch Rocket System (MLRS) Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94R': (
    mocTitle: 'Avionic and Survivability Equipment Repairer',
    occupations: <CivilianOccupation>[
      (onetSocCode: '49-2091.00', title: 'Avionics Technicians'),
    ],
    note: 'Avionics Technicians',
  ),
  '94S': (
    mocTitle: 'PATRIOT System Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94T': (
    mocTitle: 'Short Range Air Defense System Repairer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
  '94Y': (
    mocTitle: 'Automatic Test Systems Operator/Maintainer',
    occupations: <CivilianOccupation>[
      (
        onetSocCode: '49-2094.00',
        title: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
      ),
    ],
    note: 'Electrical and Electronics Repairers, Commercial and Industrial Equipment',
  ),
};
