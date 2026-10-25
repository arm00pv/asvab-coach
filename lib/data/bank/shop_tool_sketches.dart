import '../models/sketch.dart';

/// Line-art drawings of hand tools, for Auto & Shop tool identification.
///
/// The real subtest prints an outline drawing and asks the examinee to name the
/// tool or to say what it is for. Text-only tool items measure vocabulary, not
/// shop knowledge, so these drawings make the items behave like the real ones.
///
/// Every drawing is in normalised sketch space with a **2.6** aspect. That
/// matters when authoring: one y-unit is 2.6 times as many pixels as one x-unit,
/// so long tools are laid out horizontally and a feature that should look round
/// is 2.6 times taller in y-units than it is wide in x-units. Circles are
/// exempt because the painter scales their radius by the shorter side.
///
/// The set is chosen so that near-miss families can be tested against each
/// other: two hammers, two gripping tools, and a punch that is easy to confuse
/// with a cold chisel.

/// Claw hammer: heavy head, curved forked claw, long grip to the right.
const Sketch clawHammerSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool with a long straight handle, a heavy '
      'block at the other end, a flat face on one side of the block and a '
      'curved two-pronged hook on the other',
  prims: <SketchPrim>[
    // Handle, tapering slightly toward the head.
    SketchPrim.poly(<Pt>[
      Pt(0.36, 0.44),
      Pt(0.90, 0.43),
      Pt(0.95, 0.50),
      Pt(0.90, 0.57),
      Pt(0.36, 0.56),
    ]),
    // Grip ridges near the free end.
    SketchPrim.line(Pt(0.80, 0.432), Pt(0.80, 0.562)),
    SketchPrim.line(Pt(0.87, 0.430), Pt(0.87, 0.566)),
    // Head block.
    SketchPrim.box(Pt(0.24, 0.18), Pt(0.37, 0.72)),
    // Where the handle enters the head.
    SketchPrim.line(Pt(0.24, 0.44), Pt(0.37, 0.44)),
    SketchPrim.line(Pt(0.24, 0.56), Pt(0.37, 0.56)),
    // Striking face, flared above the block.
    SketchPrim.poly(<Pt>[
      Pt(0.24, 0.18),
      Pt(0.21, 0.12),
      Pt(0.22, 0.075),
      Pt(0.39, 0.075),
      Pt(0.40, 0.12),
      Pt(0.37, 0.18),
    ]),
    // Curved claw: sweeps out of the bottom of the head and hooks back toward
    // the handle, with a split cut into the tip.
    SketchPrim.poly(<Pt>[
      Pt(0.24, 0.72),
      Pt(0.28, 0.83),
      Pt(0.36, 0.90),
      Pt(0.47, 0.92),
      Pt(0.56, 0.895),
      Pt(0.60, 0.845),
      Pt(0.535, 0.835),
      Pt(0.565, 0.795),
      Pt(0.49, 0.805),
      Pt(0.40, 0.795),
      Pt(0.37, 0.72),
    ]),
  ],
);

/// Ball-peen hammer: the same grip, but one end of the head is a sphere.
const Sketch ballPeenHammerSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool with a long straight handle, a heavy '
      'block at the other end, a flat face on one side of the block and a round '
      'knob on the other',
  prims: <SketchPrim>[
    // Handle.
    SketchPrim.poly(<Pt>[
      Pt(0.36, 0.44),
      Pt(0.90, 0.43),
      Pt(0.95, 0.50),
      Pt(0.90, 0.57),
      Pt(0.36, 0.56),
    ]),
    SketchPrim.line(Pt(0.80, 0.432), Pt(0.80, 0.562)),
    SketchPrim.line(Pt(0.87, 0.430), Pt(0.87, 0.566)),
    // Head block.
    SketchPrim.box(Pt(0.24, 0.20), Pt(0.37, 0.68)),
    SketchPrim.line(Pt(0.24, 0.44), Pt(0.37, 0.44)),
    SketchPrim.line(Pt(0.24, 0.56), Pt(0.37, 0.56)),
    // Flat striking face above the block.
    SketchPrim.poly(<Pt>[
      Pt(0.24, 0.20),
      Pt(0.21, 0.14),
      Pt(0.21, 0.095),
      Pt(0.40, 0.095),
      Pt(0.40, 0.14),
      Pt(0.37, 0.20),
    ]),
    // Round peen below the block.
    SketchPrim.circle(Pt(0.305, 0.775), 0.095),
  ],
);

/// Adjustable wrench: a slot-mouthed head with a knurled worm screw under the
/// moving jaw.
const Sketch adjustableWrenchSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool with a long handle and a head carrying '
      'two parallel jaws that open sideways to a narrow slot, with a small '
      'knurled wheel set in the head behind the slot',
  prims: <SketchPrim>[
    // Handle.
    SketchPrim.poly(<Pt>[
      Pt(0.42, 0.455),
      Pt(0.90, 0.44),
      Pt(0.95, 0.50),
      Pt(0.90, 0.56),
      Pt(0.42, 0.545),
    ]),
    // Head with the jaw slot cut into its left side. One closed outline, so
    // the slot reads as an opening rather than as a line drawn on the head.
    SketchPrim.poly(<Pt>[
      Pt(0.30, 0.22),
      Pt(0.44, 0.28),
      Pt(0.44, 0.66),
      Pt(0.32, 0.70),
      Pt(0.15, 0.63),
      Pt(0.15, 0.535),
      Pt(0.30, 0.505),
      Pt(0.325, 0.475),
      Pt(0.325, 0.435),
      Pt(0.17, 0.415),
      Pt(0.14, 0.335),
      Pt(0.175, 0.245),
    ]),
    // Knurled worm screw, sitting in the head behind the slot.
    SketchPrim.circle(Pt(0.385, 0.525), 0.085),
    SketchPrim.line(Pt(0.372, 0.452), Pt(0.372, 0.598)),
    SketchPrim.line(Pt(0.412, 0.452), Pt(0.412, 0.598)),
  ],
);

/// Hacksaw: C frame, fine-toothed blade under tension, pistol grip, wing nut.
const Sketch hacksawSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool with a squarish C-shaped frame, a thin '
      'toothed strip stretched across the open side of the frame, a handle at '
      'the back and a small winged nut at the front',
  prims: <SketchPrim>[
    // Frame as one closed outline: top bar and two posts.
    SketchPrim.poly(<Pt>[
      Pt(0.14, 0.58),
      Pt(0.20, 0.58),
      Pt(0.20, 0.32),
      Pt(0.58, 0.32),
      Pt(0.58, 0.58),
      Pt(0.64, 0.58),
      Pt(0.64, 0.26),
      Pt(0.14, 0.26),
    ]),
    // Blade stretched between the post ends.
    SketchPrim.poly(<Pt>[
      Pt(0.145, 0.555),
      Pt(0.635, 0.555),
      Pt(0.635, 0.615),
      Pt(0.145, 0.615),
    ]),
    // Teeth.
    SketchPrim.dashed(Pt(0.16, 0.622), Pt(0.62, 0.622)),
    // Pistol grip off the back post.
    SketchPrim.poly(<Pt>[
      Pt(0.64, 0.375),
      Pt(0.86, 0.43),
      Pt(0.90, 0.70),
      Pt(0.64, 0.60),
    ]),
    SketchPrim.line(Pt(0.70, 0.44), Pt(0.73, 0.635)),
    SketchPrim.line(Pt(0.78, 0.46), Pt(0.80, 0.665)),
    // Wing nut on the front post, where blade tension is adjusted.
    SketchPrim.circle(Pt(0.17, 0.40), 0.055),
    SketchPrim.line(Pt(0.13, 0.40), Pt(0.21, 0.40)),
  ],
);

/// Center punch: round shank, sharp hardened cone, knurled band.
const Sketch centerPunchSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool with a round body with a knurled band '
      'around it, a rounded struck end and a sharp narrow tapering point at the '
      'other end',
  prims: <SketchPrim>[
    SketchPrim.poly(<Pt>[
      Pt(0.30, 0.365),
      Pt(0.85, 0.355),
      Pt(0.85, 0.645),
      Pt(0.30, 0.635),
    ]),
    // Rounded struck end.
    SketchPrim.poly(<Pt>[
      Pt(0.85, 0.355),
      Pt(0.92, 0.41),
      Pt(0.935, 0.50),
      Pt(0.92, 0.59),
      Pt(0.85, 0.645),
    ]),
    // Hardened point: a shallow cone, which is what keeps the tip from
    // mushrooming, and what separates it from a nail set.
    SketchPrim.poly(<Pt>[Pt(0.30, 0.365), Pt(0.165, 0.50), Pt(0.30, 0.635)]),
    // Knurled band.
    SketchPrim.line(Pt(0.40, 0.362), Pt(0.40, 0.638)),
    SketchPrim.line(Pt(0.45, 0.360), Pt(0.45, 0.640)),
    SketchPrim.line(Pt(0.50, 0.359), Pt(0.50, 0.641)),
    SketchPrim.line(Pt(0.55, 0.358), Pt(0.55, 0.642)),
  ],
);

/// Slip-joint pliers: two crossed arms, a pivot rivet, short serrated jaws.
const Sketch slipJointPliersSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool made of two crossed arms joined by a rivet '
      'near one end, with short gripping jaws on one side of the rivet and two '
      'handles on the other',
  prims: <SketchPrim>[
    // Upper jaw running down into the lower handle.
    SketchPrim.poly(<Pt>[
      Pt(0.11, 0.395),
      Pt(0.22, 0.345),
      Pt(0.42, 0.44),
      Pt(0.88, 0.66),
      Pt(0.91, 0.78),
      Pt(0.44, 0.56),
      Pt(0.30, 0.48),
      Pt(0.14, 0.455),
    ]),
    // Lower jaw running up into the upper handle.
    SketchPrim.poly(<Pt>[
      Pt(0.11, 0.605),
      Pt(0.22, 0.655),
      Pt(0.42, 0.56),
      Pt(0.88, 0.34),
      Pt(0.91, 0.22),
      Pt(0.44, 0.44),
      Pt(0.30, 0.52),
      Pt(0.14, 0.545),
    ]),
    // Pivot rivet where the two arms cross.
    SketchPrim.circle(Pt(0.425, 0.50), 0.055),
    // Jaw serrations.
    SketchPrim.line(Pt(0.185, 0.392), Pt(0.185, 0.468)),
    SketchPrim.line(Pt(0.245, 0.358), Pt(0.245, 0.442)),
    SketchPrim.line(Pt(0.185, 0.608), Pt(0.185, 0.532)),
    SketchPrim.line(Pt(0.245, 0.642), Pt(0.245, 0.558)),
  ],
);

/// Try square: thin blade joined to a thick stock at a right angle.
const Sketch trySquareSketch = Sketch(
  aspect: 2.6,
  caption:
      'Outline drawing of a hand tool made of two flat pieces joined at a right '
      'angle, one long and thin and one short and thick, with two rivets in the '
      'short piece',
  prims: <SketchPrim>[
    // Blade.
    SketchPrim.poly(<Pt>[
      Pt(0.24, 0.468),
      Pt(0.92, 0.460),
      Pt(0.92, 0.518),
      Pt(0.24, 0.526),
    ]),
    // Stock.
    SketchPrim.poly(<Pt>[
      Pt(0.20, 0.235),
      Pt(0.36, 0.240),
      Pt(0.36, 0.755),
      Pt(0.20, 0.760),
    ]),
    // Rivets through the stock.
    SketchPrim.circle(Pt(0.28, 0.335), 0.042),
    SketchPrim.circle(Pt(0.28, 0.660), 0.042),
  ],
);

/// Every tool drawing, in one place so tests and the visual harness can reach
/// them without importing individual constants.
const List<Sketch> shopToolSketches = <Sketch>[
  clawHammerSketch,
  ballPeenHammerSketch,
  adjustableWrenchSketch,
  hacksawSketch,
  centerPunchSketch,
  slipJointPliersSketch,
  trySquareSketch,
];

/// Display names, in the same order as [shopToolSketches]. Used by the audit to
/// prove a caption never prints the answer.
const List<String> shopToolNames = <String>[
  'claw hammer',
  'ball-peen hammer',
  'adjustable wrench',
  'hacksaw',
  'center punch',
  'slip-joint pliers',
  'try square',
];
