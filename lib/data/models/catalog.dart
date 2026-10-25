/// The nine ASVAB subtests (VE is derived, not administered).
///
/// Item counts and time limits follow the current CAT-ASVAB fact sheet
/// (officialasvab.com, 2025-04 edition): 135 items over 197 minutes. The
/// computer form splits Auto & Shop into a 10-item Auto Information half and a
/// 10-item Shop Information half, which is modelled here as one 20-item AS
/// section with a combined 13 minutes.
///
/// The paper-and-pencil form (and the PiCAT) is longer: 225 items over 149
/// minutes, recorded in [Subtest.paperQuestionCount] / [Subtest.paperMinutes].
///
/// One behavioural difference is worth telling candidates about: the CAT
/// scores an unfinished item as though it were guessed at random, while the
/// paper form has no guessing penalty. Never leave a CAT item blank.
enum Subtest {
  gs(
    'GS',
    'General Science',
    'General Science',
    minutes: 12,
    questionCount: 15,
    paperQuestionCount: 25,
    paperMinutes: 11,
    icon: 'science',
    blurb: 'Biology, chemistry, physics, earth and space science.',
  ),
  ar(
    'AR',
    'Arithmetic Reasoning',
    'Word Problems',
    minutes: 55,
    questionCount: 15,
    paperQuestionCount: 30,
    paperMinutes: 36,
    icon: 'math',
    blurb: 'Multi-step word problems. The single biggest AFQT lever.',
  ),
  wk(
    'WK',
    'Word Knowledge',
    'Vocabulary',
    minutes: 9,
    questionCount: 15,
    paperQuestionCount: 35,
    paperMinutes: 11,
    icon: 'book',
    blurb: 'Synonyms and word meaning in context. Feeds VE and the AFQT.',
  ),
  pc(
    'PC',
    'Paragraph Comprehension',
    'Reading',
    minutes: 27,
    questionCount: 10,
    paperQuestionCount: 15,
    paperMinutes: 13,
    icon: 'read',
    blurb: 'Main idea, detail, inference and author purpose. Feeds VE.',
  ),
  mk(
    'MK',
    'Mathematics Knowledge',
    'Math Knowledge',
    minutes: 31,
    questionCount: 15,
    paperQuestionCount: 25,
    paperMinutes: 24,
    icon: 'functions',
    blurb: 'Algebra, geometry, exponents and number properties.',
  ),
  ei(
    'EI',
    'Electronics Information',
    'Electronics',
    minutes: 10,
    questionCount: 15,
    paperQuestionCount: 20,
    paperMinutes: 9,
    icon: 'bolt',
    blurb: 'Circuits, Ohm\'s law, components and electrical safety.',
  ),
  as(
    'AS',
    'Auto & Shop Information',
    'Auto & Shop',
    minutes: 13,
    questionCount: 20,
    paperQuestionCount: 25,
    paperMinutes: 11,
    icon: 'build',
    blurb:
        'Engines, hand tools, materials, welding and shop practice. '
        'The computer form splits this into a 10-item Auto and a 10-item Shop half.',
  ),
  mc(
    'MC',
    'Mechanical Comprehension',
    'Mechanical',
    minutes: 22,
    questionCount: 15,
    paperQuestionCount: 25,
    paperMinutes: 19,
    icon: 'gear',
    blurb: 'Levers, pulleys, gears, pressure, structure and friction.',
  ),
  ao(
    'AO',
    'Assembling Objects',
    'Assembling Objects',
    minutes: 18,
    questionCount: 15,
    paperQuestionCount: 25,
    paperMinutes: 15,
    icon: 'puzzle',
    blurb: 'Spatial reasoning: which assembly can be built from the pieces.',
  );

  const Subtest(
    this.abbr,
    this.label,
    this.shortLabel, {
    required this.minutes,
    required this.questionCount,
    required this.paperQuestionCount,
    required this.paperMinutes,
    required this.icon,
    required this.blurb,
  });

  final String abbr;
  final String label;
  final String shortLabel;
  final int minutes;
  final int questionCount;
  final int paperQuestionCount;
  final int paperMinutes;
  final String icon;
  final String blurb;

  /// Order the subtests are administered in the CAT-ASVAB.
  static const List<Subtest> administrationOrder = <Subtest>[
    Subtest.gs,
    Subtest.ar,
    Subtest.wk,
    Subtest.pc,
    Subtest.mk,
    Subtest.ei,
    Subtest.as,
    Subtest.mc,
    Subtest.ao,
  ];

  /// The four subtests that produce the AFQT.
  static const List<Subtest> afqtSubtests = <Subtest>[
    Subtest.ar,
    Subtest.wk,
    Subtest.pc,
    Subtest.mk,
  ];

  /// Subtests that make up the Verbal Expression (VE) composite.
  static const List<Subtest> veSubtests = <Subtest>[Subtest.wk, Subtest.pc];

  bool get feedsAfqt => afqtSubtests.contains(this);
  bool get feedsVe => veSubtests.contains(this);
  bool get isMath => this == Subtest.ar || this == Subtest.mk;

  String get afqtNote {
    if (this == Subtest.ar) return 'Weighted x1 in the AFQT composite';
    if (this == Subtest.mk) return 'Weighted x1 in the AFQT composite';
    if (this == Subtest.wk || this == Subtest.pc) {
      return 'Weighted x2 via VE in the AFQT composite';
    }
    return 'Does not affect your AFQT, but does affect line scores';
  }
}

/// Difficulty bands used by the scoring model to weight a correct answer.
enum Difficulty {
  easy('Easy', 0.85),
  medium('Medium', 1.0),
  hard('Hard', 1.2);

  const Difficulty(this.label, this.weight);
  final String label;
  final double weight;
}

/// A named, testable skill. Every question carries 1-3 skill ids; the
/// reinforcement engine groups mistakes by skill so feedback is specific
/// rather than "study math more".
class Skill {
  const Skill({
    required this.id,
    required this.subtest,
    required this.label,
    required this.summary,
  });

  final String id;
  final Subtest subtest;
  final String label;
  final String summary;
}

/// The complete skill taxonomy. Kept intentionally tight (3-4 skills per
/// subtest) so diagnoses stay actionable instead of scattering across 60
/// micro-tags nobody acts on.
abstract final class Skills {
  static const List<Skill> all = <Skill>[
    // Arithmetic Reasoning
    Skill(
      id: 'ar.percent',
      subtest: Subtest.ar,
      label: 'Percents & percent change',
      summary: 'Translating "of", "more than" and discount problems into a single multiplication.',
    ),
    Skill(
      id: 'ar.ratio',
      subtest: Subtest.ar,
      label: 'Ratios & proportions',
      summary: 'Scaling recipes, maps and part-to-whole splits with cross-multiplication.',
    ),
    Skill(
      id: 'ar.rate',
      subtest: Subtest.ar,
      label: 'Rates, speed & work',
      summary: 'd = r x t, combined work rates, and unit conversion inside word problems.',
    ),
    Skill(
      id: 'ar.average',
      subtest: Subtest.ar,
      label: 'Averages & totals',
      summary: 'Working backwards from an average to a total, and weighted averages.',
    ),
    Skill(
      id: 'ar.algebra',
      subtest: Subtest.ar,
      label: 'Words into equations',
      summary: 'Assigning a variable to the unknown and building the equation the wording describes.',
    ),
    Skill(
      id: 'ar.geometry',
      subtest: Subtest.ar,
      label: 'Applied geometry',
      summary: 'Area, perimeter and volume appearing as a story problem rather than a diagram.',
    ),

    // Mathematics Knowledge
    Skill(
      id: 'mk.prealgebra',
      subtest: Subtest.mk,
      label: 'Numbers & order of operations',
      summary:
          'Signed arithmetic, absolute value and PEMDAS without a calculator.',
    ),
    Skill(
      id: 'mk.fractions',
      subtest: Subtest.mk,
      label: 'Fractions & decimals',
      summary: 'Adding unlike denominators, mixed numbers and decimal/fraction conversion.',
    ),
    Skill(
      id: 'mk.exponents',
      subtest: Subtest.mk,
      label: 'Exponents & radicals',
      summary: 'Product, quotient and power rules, negative exponents and simplifying roots.',
    ),
    Skill(
      id: 'mk.algebra',
      subtest: Subtest.mk,
      label: 'Linear equations & factoring',
      summary:
          'Solving for x, systems, and turning a quadratic into two binomials.',
    ),
    Skill(
      id: 'mk.geometry',
      subtest: Subtest.mk,
      label: 'Geometry',
      summary: 'Angles, triangle rules, circle formulas and the Pythagorean theorem.',
    ),
    Skill(
      id: 'mk.probability',
      subtest: Subtest.mk,
      label: 'Probability & counting',
      summary:
          'Simple probability, independent events and counting arrangements.',
    ),

    // Word Knowledge
    Skill(
      id: 'wk.synonym',
      subtest: Subtest.wk,
      label: 'Direct synonym recall',
      summary:
          'Recognising the closest meaning when the stem is a single word.',
    ),
    Skill(
      id: 'wk.context',
      subtest: Subtest.wk,
      label: 'Meaning in context',
      summary: 'Choosing the sense of a word that fits the sentence provided.',
    ),
    Skill(
      id: 'wk.roots',
      subtest: Subtest.wk,
      label: 'Roots, prefixes & suffixes',
      summary: 'Decoding unfamiliar words from morphemes instead of memorising them.',
    ),
    Skill(
      id: 'wk.academic',
      subtest: Subtest.wk,
      label: 'Academic vocabulary',
      summary: 'The high-frequency "school English" word list that shows up repeatedly.',
    ),

    // Paragraph Comprehension
    Skill(
      id: 'pc.mainidea',
      subtest: Subtest.pc,
      label: 'Main idea & theme',
      summary: 'Separating the point of a passage from its supporting detail.',
    ),
    Skill(
      id: 'pc.detail',
      subtest: Subtest.pc,
      label: 'Stated detail',
      summary: 'Locating an answer that is literally on the page instead of inferred.',
    ),
    Skill(
      id: 'pc.inference',
      subtest: Subtest.pc,
      label: 'Inference',
      summary: 'Drawing the only conclusion the passage actually supports.',
    ),
    Skill(
      id: 'pc.purpose',
      subtest: Subtest.pc,
      label: "Author's purpose & tone",
      summary: 'Why the author wrote it and how the wording signals attitude.',
    ),
    Skill(
      id: 'pc.vocabulary',
      subtest: Subtest.pc,
      label: 'Vocabulary in context',
      summary: 'What a word means as it is used in this passage, not in a dictionary.',
    ),
    Skill(
      id: 'pc.sequence',
      subtest: Subtest.pc,
      label: 'Sequence & technique',
      summary: 'Order of events, cause and effect, and how the author builds the point.',
    ),

    // General Science
    Skill(
      id: 'gs.biology',
      subtest: Subtest.gs,
      label: 'Biology & life science',
      summary:
          'Cells, genetics, body systems, photosynthesis and classification.',
    ),
    Skill(
      id: 'gs.chemistry',
      subtest: Subtest.gs,
      label: 'Chemistry',
      summary:
          'Atoms, the periodic table, bonding, reactions, acids and bases.',
    ),
    Skill(
      id: 'gs.physics',
      subtest: Subtest.gs,
      label: 'Physics',
      summary: 'Force, motion, energy, waves, electricity and simple machines.',
    ),
    Skill(
      id: 'gs.earth',
      subtest: Subtest.gs,
      label: 'Earth & space science',
      summary: 'Weather, plate tectonics, the solar system and the rock cycle.',
    ),

    // Electronics Information
    Skill(
      id: 'ei.ohms',
      subtest: Subtest.ei,
      label: "Ohm's law & power",
      summary: 'V = IR and P = VI applied to find an unknown quantity.',
    ),
    Skill(
      id: 'ei.circuits',
      subtest: Subtest.ei,
      label: 'Series & parallel circuits',
      summary:
          'How resistance, voltage and current behave in each arrangement.',
    ),
    Skill(
      id: 'ei.components',
      subtest: Subtest.ei,
      label: 'Components & symbols',
      summary:
          'Resistors, capacitors, diodes, transistors and reading a schematic.',
    ),
    Skill(
      id: 'ei.safety',
      subtest: Subtest.ei,
      label: 'Electrical safety & tools',
      summary: 'Meters, grounding, insulation and shop safety practice.',
    ),
    Skill(
      id: 'ei.systems',
      subtest: Subtest.ei,
      label: 'Electrical systems',
      summary:
          'Generators, motors, transformers, batteries in series and parallel, '
          'and household wiring.',
    ),

    // Auto & Shop
    Skill(
      id: 'as.engine',
      subtest: Subtest.as,
      label: 'Engine & drivetrain',
      summary: 'Four-stroke cycle, cooling, lubrication, ignition and transmissions.',
    ),
    Skill(
      id: 'as.tools',
      subtest: Subtest.as,
      label: 'Hand & power tools',
      summary:
          'Naming a tool by its job, and picking the right one for a task.',
    ),
    Skill(
      id: 'as.materials',
      subtest: Subtest.as,
      label: 'Materials & fasteners',
      summary: 'Wood, steel, concrete, bolts, threads and measuring practice.',
    ),
    Skill(
      id: 'as.welding',
      subtest: Subtest.as,
      label: 'Welding, cutting & safety',
      summary:
          'Arc and gas welding, brazing, and the safety rules that follow.',
    ),
    Skill(
      id: 'as.drivetrain',
      subtest: Subtest.as,
      label: 'Drivetrain, brakes & suspension',
      summary: 'Clutch, transmission, differential, brakes, steering and suspension.',
    ),
    Skill(
      id: 'as.electrical',
      subtest: Subtest.as,
      label: 'Automotive electrical & ignition',
      summary:
          'Battery, alternator, starter, ignition timing and tracing a fault.',
    ),
    Skill(
      id: 'as.construction',
      subtest: Subtest.as,
      label: 'Construction & building',
      summary:
          'Framing, foundations, concrete, roofing and reading a set of plans.',
    ),

    // Mechanical Comprehension
    Skill(
      id: 'mc.levers',
      subtest: Subtest.mc,
      label: 'Levers & moments',
      summary: 'Class 1/2/3 levers and the balance of force times distance.',
    ),
    Skill(
      id: 'mc.pulleys',
      subtest: Subtest.mc,
      label: 'Pulleys, gears & ratios',
      summary: 'Mechanical advantage, rope sections, meshed gears and belt direction.',
    ),
    Skill(
      id: 'mc.pressure',
      subtest: Subtest.mc,
      label: 'Fluids & pressure',
      summary:
          'Hydraulics, Pascal\'s principle, buoyancy and pressure versus area.',
    ),
    Skill(
      id: 'mc.structure',
      subtest: Subtest.mc,
      label: 'Structural support & loads',
      summary:
          'Beams in tension and compression, trusses, and how load reaches the '
          'ground.',
    ),
    Skill(
      id: 'mc.motion',
      subtest: Subtest.mc,
      label: 'Motion & friction',
      summary: 'Velocity, acceleration, inertia, friction and lubrication.',
    ),
    Skill(
      id: 'mc.materials',
      subtest: Subtest.mc,
      label: 'Properties of materials',
      summary:
          'Strength, elasticity, hardness, density and why material choice '
          'matters.',
    ),

    // Assembling Objects
    Skill(
      id: 'ao.rotation',
      subtest: Subtest.ao,
      label: 'Mental rotation',
      summary: "Tracking how a piece's outline changes when it turns.",
    ),
    Skill(
      id: 'ao.connection',
      subtest: Subtest.ao,
      label: 'Matching connection points',
      summary:
          'Joining pieces at the matching lettered attachment points, not merely '
          'at any edge that happens to touch.',
    ),
    Skill(
      id: 'ao.pieces',
      subtest: Subtest.ao,
      label: 'Piece inventory',
      summary: 'Counting exactly which pieces belong, and spotting a substituted one.',
    ),
    Skill(
      id: 'ao.assembly',
      subtest: Subtest.ao,
      label: 'Assembly fit',
      summary: 'Building the whole figure from the parts without overlap gaps.',
    ),
  ];

  static final Map<String, Skill> _byId = <String, Skill>{
    for (final s in all) s.id: s,
  };

  static Skill byId(String id) =>
      _byId[id] ?? (throw StateError('Unknown skill id: $id'));

  static Skill? maybeById(String id) => _byId[id];

  static List<Skill> forSubtest(Subtest s) =>
      all.where((x) => x.subtest == s).toList(growable: false);
}

/// Categories used to group MOS in the jobs explorer.
abstract final class MosCategory {
  static const combatArms = 'Combat Arms';
  static const combatSupportEngineer = 'Combat Support (Engineer)';
  static const combatService = 'Combat Service Support';
  static const intelSignal = 'Intelligence & Signal';
  static const cyberEw = 'Cyber & EW';
  static const aviation = 'Aviation';
  static const mechanical = 'Mechanical Maintenance';
  static const medical = 'Medical';
  static const militaryPolice = 'Military Police';
  static const specialOps = 'Special Operations';
  static const publicAffairs = 'Public Affairs';
  static const legal = 'Legal';
  static const religious = 'Religious';
  static const band = 'Band';
  static const recruiting = 'Recruiting';

  static const List<String> ordered = <String>[
    combatArms,
    combatSupportEngineer,
    combatService,
    intelSignal,
    cyberEw,
    aviation,
    mechanical,
    medical,
    militaryPolice,
    specialOps,
    publicAffairs,
    legal,
    religious,
    band,
    recruiting,
  ];
}
