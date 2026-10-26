import '../models/catalog.dart';
import '../models/question.dart';

/// Mechanical Comprehension, second pool: 18 items weighted the way the real
/// subtest is weighted, with simple machines and gear trains carrying the bulk
/// of it. Every setup is described in words rather than drawn, and every
/// numeric answer has been recomputed by hand.
const List<Question> mechanicalExtraBank = <Question>[
  Question(
    id: 'mc-x01',
    subtest: Subtest.mc,
    stem:
        'A six foot pry bar is used to raise a rock. The bar pivots on a block that sits one '
        'foot from the rock, and the full length of the bar is used. What effort at the far end '
        'raises a 400 lb rock?',
    choices: <String>['67 lb', '80 lb', '100 lb', '400 lb'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Sixty-seven pounds uses the whole six foot bar as the effort arm, counting the foot beyond the block twice.',
      'The effort arm is the remaining five feet, so 400 lb divided by an advantage of 5 gives 80 lb.',
      'One hundred pounds fits an effort arm of four feet, a foot short of the five the block leaves.',
      'Four hundred pounds leaves the bar no advantage, as if the push went on at the block itself.',
    ],
    explanation:
        'The fulcrum sits one foot from the rock, so the load arm is 1 ft and the effort arm '
        'is the remaining 5 ft. The mechanical advantage is 5, and 400 lb divided by 5 is 80 lb '
        'of effort. Using the whole 6 ft as the effort arm gives 67 lb, and forgetting to '
        'subtract the load arm gives 100 lb, so neither wrong answer balances the moments around '
        'the block.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.levers'],
    figure: Sketch(
      caption:
          'A six foot pry bar lifting a 400 pound rock, with a block acting as '
          'fulcrum 1 foot from the rock and the effort applied at the far end, '
          'both arms marked underneath.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.06, 0.66), Pt(0.94, 0.66), weight: 3),
        SketchPrim.box(Pt(0.06, 0.46), Pt(0.20, 0.66)),
        SketchPrim.text('400 lb rock', Pt(0.17, 0.38)),
        SketchPrim.line(Pt(0.20, 0.46), Pt(0.92, 0.46), weight: 5),
        SketchPrim.box(Pt(0.27, 0.46), Pt(0.37, 0.66)),
        SketchPrim.text('fulcrum', Pt(0.36, 0.37)),
        SketchPrim.arrow(Pt(0.90, 0.20), Pt(0.90, 0.44)),
        SketchPrim.text('? effort', Pt(0.86, 0.13)),
        SketchPrim.dashed(Pt(0.20, 0.80), Pt(0.92, 0.80)),
        SketchPrim.dashed(Pt(0.20, 0.68), Pt(0.20, 0.80)),
        SketchPrim.dashed(Pt(0.32, 0.68), Pt(0.32, 0.80)),
        SketchPrim.dashed(Pt(0.92, 0.68), Pt(0.92, 0.80)),
        SketchPrim.text('1 ft', Pt(0.26, 0.89)),
        SketchPrim.text('5 ft', Pt(0.62, 0.89)),
      ],
    ),
  ),
  Question(
    id: 'mc-x02',
    subtest: Subtest.mc,
    stem:
        'A lever 12 ft long is to lift a 150 lb load with 50 lb of effort. How far from the '
        'load must the fulcrum be placed?',
    choices: <String>['3 ft', '4 ft', '6 ft', '9 ft'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Three feet balances 150 lb times the load arm against 50 lb times the remaining nine feet.',
      'Four feet leaves an 8 ft effort arm, which raises 150 lb only when the effort is 75 lb.',
      'Six feet is the midpoint of the bar, where the arms are equal and the lever gives no advantage.',
      'Nine feet from the load leaves only 3 ft of effort arm, so the lever works against you.',
    ],
    explanation:
        'Balance the moments: 150 lb times the load arm equals 50 lb times the effort arm, and '
        'the two arms together make 12 ft. Writing the load arm as a gives 150a = 50(12 - a), so '
        '200a = 600 and a = 3 ft, which leaves 9 ft of effort arm and an advantage of 3. A '
        'fulcrum 6 ft out is the midpoint and gives no advantage at all, while 9 ft from the '
        'load leaves only 3 ft of effort arm and cannot lift the load.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.levers'],
  ),
  Question(
    id: 'mc-x03',
    subtest: Subtest.mc,
    stem:
        'A 200 lb barrel is pushed up a 10 ft ramp onto a dock 2.5 ft high. Ignoring friction, '
        'what force along the ramp is needed?',
    choices: <String>['20 lb', '25 lb', '50 lb', '80 lb'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Twenty pounds divides the 200 lb weight by the 10 ft ramp and ignores the 2.5 ft rise altogether.',
      'Twenty-five pounds halves the push, which follows from measuring the ramp from its middle rather than its full length.',
      'The 500 foot-pounds of work spread over 10 ft of ramp takes 50 lb of push along the slope.',
      'Eighty pounds divides 200 by 2.5, treating the rise as the ratio and inflating the effort.',
    ],
    explanation:
        'The work is the same either way. Lifting the barrel straight up takes 200 lb through '
        '2.5 ft, which is 500 foot-pounds, and spreading that same work over 10 ft of ramp takes '
        '500 divided by 10, or 50 lb of push. The ramp length divided by the rise, 4 to 1 here, '
        'is the mechanical advantage, and you pay for it by pushing four times as far as you '
        'would lift. Dividing the weight by the ramp length gives 20 lb and ignores the rise '
        'entirely, which is the usual inclined plane slip.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A 200 pound barrel being pushed up a 10 foot ramp that rises 2.5 '
          'feet to a dock, with the effort along the ramp marked with a '
          'question mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.08, 0.80), Pt(0.94, 0.80), weight: 4),
        SketchPrim.line(Pt(0.14, 0.80), Pt(0.80, 0.52), weight: 4),
        SketchPrim.box(Pt(0.80, 0.52), Pt(0.94, 0.80)),
        SketchPrim.box(Pt(0.31, 0.60), Pt(0.41, 0.694)),
        SketchPrim.text('200 lb', Pt(0.36, 0.54)),
        SketchPrim.arrow(Pt(0.62, 0.641), Pt(0.44, 0.718)),
        SketchPrim.text('?', Pt(0.66, 0.625)),
        SketchPrim.dashed(Pt(0.14, 0.84), Pt(0.80, 0.84)),
        SketchPrim.text('10 ft', Pt(0.47, 0.91)),
        SketchPrim.text('2.5 ft', Pt(0.87, 0.64)),
      ],
    ),
  ),
  Question(
    id: 'mc-x04',
    subtest: Subtest.mc,
    stem:
        'A block and tackle has four rope sections pulling upward on the movable block. How '
        'much rope must be pulled through to raise the load 2 ft?',
    choices: <String>['2 ft', '4 ft', '6 ft', '8 ft'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Two feet is the distance the load rises, and it takes no account of the hauling the tackle demands.',
      'Four feet fits a two-section tackle, where each foot of lift pulls two feet of rope.',
      'Six feet fits a three-section tackle, one section short of the four the drawing shows.',
      'Raising the block 2 ft shortens each of the four sections by 2 ft, so 8 ft of rope comes through your hands.',
    ],
    explanation:
        'Four supporting sections share the load, so the effort is one quarter of the weight '
        'and the distance is multiplied by the same four. Raising the block 2 ft means '
        'shortening all four sections by 2 ft each, which draws 8 ft of rope through your hands. '
        'Picking 2 ft ignores the trade completely, and 4 ft or 6 ft would match only a '
        'two-section or three-section tackle.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A block and tackle with a fixed block at the top and a movable '
          'block joined by four rope sections, the load labelled with its 2 '
          'foot lift and the rope to haul marked with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.24, 0.10), Pt(0.76, 0.10), weight: 4),
        SketchPrim.line(Pt(0.50, 0.10), Pt(0.50, 0.14)),
        SketchPrim.box(Pt(0.36, 0.14), Pt(0.64, 0.30)),
        SketchPrim.box(Pt(0.36, 0.56), Pt(0.64, 0.72)),
        SketchPrim.line(Pt(0.42, 0.30), Pt(0.42, 0.56)),
        SketchPrim.line(Pt(0.48, 0.30), Pt(0.48, 0.56)),
        SketchPrim.line(Pt(0.54, 0.30), Pt(0.54, 0.56)),
        SketchPrim.line(Pt(0.60, 0.30), Pt(0.60, 0.56)),
        SketchPrim.box(Pt(0.43, 0.72), Pt(0.57, 0.86)),
        SketchPrim.text('load', Pt(0.50, 0.79)),
        SketchPrim.arrow(Pt(0.71, 0.88), Pt(0.71, 0.74)),
        SketchPrim.text('2 ft', Pt(0.80, 0.81)),
        SketchPrim.line(Pt(0.64, 0.22), Pt(0.78, 0.22)),
        SketchPrim.arrow(Pt(0.78, 0.22), Pt(0.78, 0.46)),
        SketchPrim.text('?', Pt(0.78, 0.56)),
      ],
    ),
  ),
  Question(
    id: 'mc-x05',
    subtest: Subtest.mc,
    stem:
        'A screw jack has 10 threads per inch. How far does the jack rise when the handle is '
        'turned 30 complete turns?',
    choices: <String>['0.3 inch', '3 inches', '10 inches', '30 inches'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Three tenths of an inch would follow from ten turns at this pitch, not from thirty.',
      'Each turn advances the screw by one pitch of 0.1 inch, so thirty turns raise the jack 3 inches.',
      'Ten inches treats the ten threads per inch as a length instead of a rate of climb.',
      'Thirty inches assumes a full inch of rise per turn, which is a pitch of one rather than one tenth.',
    ],
    explanation:
        'One turn of the screw advances it by exactly one thread pitch, and with 10 threads in '
        'each inch the pitch is 0.1 inch. Thirty turns therefore lift the jack 30 times 0.1 '
        'inch, which is 3 inches. Multiplying 30 by 10 treats the thread count as a length '
        'instead of a rate, and a screw with more threads per inch would climb the load even '
        'more slowly.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A screw jack with 10 threads per inch: a threaded body on a base, a '
          'load on top and a handle across the screw, with the rise marked '
          'with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.box(Pt(0.24, 0.82), Pt(0.62, 0.92)),
        SketchPrim.box(Pt(0.30, 0.56), Pt(0.56, 0.82)),
        SketchPrim.line(Pt(0.30, 0.62), Pt(0.56, 0.62)),
        SketchPrim.line(Pt(0.30, 0.68), Pt(0.56, 0.68)),
        SketchPrim.line(Pt(0.30, 0.74), Pt(0.56, 0.74)),
        SketchPrim.line(Pt(0.43, 0.28), Pt(0.43, 0.56), weight: 5),
        SketchPrim.line(Pt(0.14, 0.34), Pt(0.72, 0.34), weight: 4),
        SketchPrim.disc(Pt(0.72, 0.34), 0.022),
        SketchPrim.box(Pt(0.32, 0.14), Pt(0.54, 0.28)),
        SketchPrim.text('load', Pt(0.43, 0.21)),
        SketchPrim.text('handle', Pt(0.20, 0.27)),
        SketchPrim.line(Pt(0.62, 0.66), Pt(0.578, 0.66)),
        SketchPrim.text('10 threads per inch', Pt(0.76, 0.66)),
        SketchPrim.text('? rise', Pt(0.76, 0.42)),
      ],
    ),
  ),
  Question(
    id: 'mc-x06',
    subtest: Subtest.mc,
    stem:
        'A 40 tooth gear turning at 60 rpm drives a 10 tooth gear. How fast does the 10 tooth '
        'gear turn?',
    choices: <String>['15 rpm', '60 rpm', '240 rpm', '480 rpm'],
    answerIndex: 2,
    choiceNotes: <String>[
      'Fifteen divides 60 by the four to one ratio, where a smaller driven gear should multiply by it.',
      'Sixty assumes two equal gears, yet the driven gear has a quarter of the teeth and must turn faster.',
      'The tooth ratio of 40 to 10 is four, so sixty rpm becomes 240 rpm with torque cut by the same four.',
      'Four hundred eighty would take an eight to one ratio, and forty against ten teeth gives only four.',
    ],
    explanation:
        'A small gear driving a large one slows the output down, so the reverse of that pair '
        'must speed it up by the tooth ratio of 40 to 10, which is 4. Sixty rpm times 4 is 240 '
        'rpm, and the torque carried by the small gear falls by that same factor of four. The '
        '15 rpm option divides instead of multiplying, and 480 rpm would take an 8 to 1 ratio '
        'that these two gears do not have.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A 40 tooth gear turning at 60 rpm meshed with a 10 tooth gear whose '
          'speed is marked with a question mark.',
      prims: <SketchPrim>[
        SketchPrim.circle(Pt(0.32, 0.50), 0.30, weight: 4),
        SketchPrim.disc(Pt(0.32, 0.50), 0.018),
        SketchPrim.text('40 T', Pt(0.32, 0.64)),
        SketchPrim.circle(Pt(0.5405, 0.50), 0.075, weight: 4),
        SketchPrim.disc(Pt(0.5405, 0.50), 0.015),
        SketchPrim.line(Pt(0.568, 0.47), Pt(0.64, 0.42)),
        SketchPrim.text('10 T', Pt(0.72, 0.38)),
        SketchPrim.text('? rpm', Pt(0.72, 0.50)),
        SketchPrim.text('driver 60 rpm', Pt(0.32, 0.90)),
      ],
    ),
  ),
  Question(
    id: 'mc-x07',
    subtest: Subtest.mc,
    stem:
        'A driving gear turns clockwise and drives an idler gear, which in turn drives an '
        'output gear the same size as the driving gear. What does the output gear do?',
    choices: <String>[
      'It turns at the same speed and in the same direction',
      'It turns at the same speed and in the opposite direction',
      'It turns at half the speed and in the same direction',
      'It turns at twice the speed and in the opposite direction',
    ],
    answerIndex: 0,
    choiceNotes: <String>[
      'Two meshes reverse the direction twice, and dropping the idler is what would leave the output reversed.',
      'Half speed needs an output gear with twice the teeth, and the drawing shows two gears of the same size.',
      'Twice speed needs an output gear with half the teeth, and the two end gears match tooth for tooth.',
      'Each mesh reverses the turn and the second reverses it back, while equal tooth counts leave the speed alone.',
    ],
    explanation:
        'Every mesh reverses the direction, and a second mesh reverses it back again, so two '
        'meshes leave the output turning the same way as the driving gear. Speed depends only on '
        'the tooth counts of the driver and the output, and those are equal here, so the speed '
        'is unchanged as well. Dropping the idler and meshing the two gears directly is what '
        'would reverse the output, and an idler cannot change the ratio because whatever it adds '
        'on the way in it gives back on the way out.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
    figure: Sketch(
      caption:
          'A driving gear turning clockwise that drives an idler gear, which '
          'in turn drives an output gear of the same size, marked with a '
          'question mark.',
      prims: <SketchPrim>[
        SketchPrim.circle(Pt(0.231, 0.52), 0.22, weight: 4),
        SketchPrim.circle(Pt(0.490, 0.52), 0.22, weight: 4),
        SketchPrim.circle(Pt(0.749, 0.52), 0.22, weight: 4),
        SketchPrim.disc(Pt(0.231, 0.52), 0.016),
        SketchPrim.disc(Pt(0.490, 0.52), 0.016),
        SketchPrim.disc(Pt(0.749, 0.52), 0.016),
        SketchPrim.arrow(Pt(0.18, 0.34), Pt(0.29, 0.34)),
        SketchPrim.text('A', Pt(0.231, 0.64)),
        SketchPrim.text('idler', Pt(0.490, 0.64)),
        SketchPrim.text('B', Pt(0.749, 0.64)),
        SketchPrim.text('clockwise', Pt(0.231, 0.20)),
        SketchPrim.text('?', Pt(0.749, 0.84)),
      ],
    ),
  ),
  Question(
    id: 'mc-x08',
    subtest: Subtest.mc,
    stem:
        'A 12 tooth gear running at 900 rpm drives a 36 tooth gear. That 36 tooth gear is fixed '
        'to a shaft carrying a 10 tooth gear, which drives a 30 tooth gear. At what speed does '
        'the final 30 tooth gear turn?',
    choices: <String>['33 rpm', '150 rpm', '300 rpm', '100 rpm'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Thirty-three divides 100 by three again, applying a third ratio this train does not contain.',
      'One hundred fifty halves the final speed, which neither the twelve to thirty-six nor the ten to thirty mesh gives.',
      'Three hundred rpm stops after the first mesh and forgets the ten tooth gear driving the thirty tooth.',
      'The first mesh takes 900 rpm down to 300, and the second takes 300 down by three again to 100 rpm.',
    ],
    explanation:
        'Work through one mesh at a time. The first pair reduces speed by 12 over 36, so the 36 '
        'tooth gear turns at 300 rpm. The shaft carries the 10 tooth gear at that same 300 rpm, '
        'and the second mesh reduces again by 10 over 30, giving 300 divided by 3, which is 100 '
        'rpm. The 300 rpm option stops after the first mesh and forgets the second, while 33 rpm '
        'and 150 rpm do not come from either ratio.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.pulleys'],
  ),
  Question(
    id: 'mc-x09',
    subtest: Subtest.mc,
    stem:
        'The shaft of a 15 tooth gear carries 20 pound-feet of torque, and that gear drives a '
        '45 tooth gear. Ignoring losses, what torque does the driven shaft carry?',
    choices: <String>[
      '7 pound-feet',
      '60 pound-feet',
      '20 pound-feet',
      '180 pound-feet',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'Seven pound-feet divides 20 by the three to one ratio, but a slower driven gear gains torque instead of losing it.',
      'Three times the teeth turns a third as fast and carries three times the torque, so 20 becomes 60 pound-feet.',
      'Twenty pound-feet would be the output only if the two gears carried equal tooth counts.',
      'One hundred eighty would need a nine to one tooth ratio, and fifteen against forty-five is only three to one.',
    ],
    explanation:
        'A gear pair trades speed for torque, and the torque is multiplied by exactly the ratio '
        'that divides the speed. The driven gear has three times as many teeth, so it turns one '
        'third as fast and carries three times the torque: 20 times 3 is 60 pound-feet. Dividing '
        'instead of multiplying gives about 7 pound-feet, and 180 pound-feet would need a ratio '
        'of 9 to 1 between the teeth.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pulleys'],
  ),
  Question(
    id: 'mc-x10',
    subtest: Subtest.mc,
    stem: 'Why is a roof truss framed out of triangles rather than rectangles?',
    choices: <String>[
      'Triangles use fewer pieces, so the truss weighs less',
      'Triangles spread the load into the foundation more evenly',
      'A triangle cannot change shape unless a side changes length',
      'Triangles let the joints be nailed instead of bolted',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'A braced rectangle can use fewer pieces than a trussed triangle, so saving weight is not why trusses are triangular.',
      'Spreading load into the foundation is the footing job, and the truss shape is about holding itself rigid.',
      'Once its three sides are fixed, all three angles are fixed with them, so the shape cannot fold over.',
      'Nailing or bolting is a joining choice, and a triangle holds its shape through geometry rather than fastening.',
    ],
    explanation:
        'A rectangle hinged at its corners folds over into a parallelogram under a sideways '
        'push, while a triangle has no such freedom: once its three sides are fixed, all three '
        'angles are fixed with them. That is why one diagonal brace turns a shaky frame into a '
        'rigid one, and why braces are added to walls, gates and trusses. Saving weight, '
        'spreading load and the choice of nail or bolt have nothing to do with a shape holding '
        'itself rigid.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.structure'],
  ),
  Question(
    id: 'mc-x11',
    subtest: Subtest.mc,
    stem:
        'In a simple roof truss, what kind of stress does the bottom horizontal member carry '
        'as it holds the two rafter feet together?',
    choices: <String>['Compression', 'Shear', 'Torsion', 'Tension'],
    answerIndex: 3,
    choiceNotes: <String>[
      'Compression squeezes a member lengthwise, and the rafters near the ridge feel that rather than the bottom member.',
      'Shear acts across a section to slide one part past another, and this member is being pulled end to end.',
      'Torsion twists a member about its own axis, and nothing in this truss twists the bottom member.',
      'The roof load pushes the rafter feet outward, so the member holding them apart is stretched end to end.',
    ],
    explanation:
        'The weight of the roof pushes the rafter feet outward, and the bottom member is what '
        'stops them from spreading, so it is being pulled apart end to end and is in tension. '
        'Shorten it and the rafters would splay further out; remove it and the walls would be '
        'shoved apart. Compression squeezes a member lengthwise, which is what the rafters '
        'themselves feel near the ridge, while shear acts across a section and torsion twists '
        'about an axis.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.structure'],
    figure: Sketch(
      caption:
          'A simple roof truss: two rafters meeting at the ridge, with the '
          'bottom horizontal member between their feet marked with a question '
          'mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.18, 0.72), Pt(0.50, 0.24), weight: 4),
        SketchPrim.line(Pt(0.50, 0.24), Pt(0.82, 0.72), weight: 4),
        SketchPrim.line(Pt(0.18, 0.72), Pt(0.82, 0.72), weight: 5),
        SketchPrim.line(Pt(0.285, 0.45), Pt(0.355, 0.468)),
        SketchPrim.text('rafter', Pt(0.23, 0.42)),
        SketchPrim.text('?', Pt(0.50, 0.81)),
        SketchPrim.text('bottom member', Pt(0.50, 0.90)),
      ],
    ),
  ),
  Question(
    id: 'mc-x12',
    subtest: Subtest.mc,
    stem:
        'A steel rod is used as a tie and is pulled straight along its axis, with a load hanging '
        'on each end. What kind of stress does the rod carry?',
    choices: <String>['Tension', 'Compression', 'Bending', 'Torsion'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Compression is what the rod would feel if its ends were pushed together instead of pulled apart.',
      'Bending would put one side in tension and the other in compression, and this rod is pulled straight.',
      'Torsion would twist the rod about its axis, and a load hung on each end does not twist it.',
      'A straight pull along the axis stretches the rod, so it is in tension while stopping the ends from spreading.',
    ],
    explanation:
        'A straight pull along the axis stretches the rod, so it is in tension, and the job of '
        'the rod is to stop two points from moving apart. Push the same rod instead and it '
        'would be in compression, and a long slender rod would buckle sideways rather than take '
        'the load. Bending puts one side of a member in tension and the other in compression at '
        'the same time, and torsion twists a shaft about its own axis.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.structure'],
  ),
  Question(
    id: 'mc-x13',
    subtest: Subtest.mc,
    stem:
        'A vehicle starts from rest and reaches 30 ft per second in 6 seconds. What is its '
        'average acceleration?',
    choices: <String>['0.2 ft/s^2', '5 ft/s^2', '24 ft/s^2', '180 ft/s^2'],
    answerIndex: 1,
    choiceNotes: <String>[
      'Two tenths is six divided by thirty, which turns the division upside down.',
      'Thirty feet per second climbed over six seconds is five feet per second gained in each second.',
      'Twenty-four subtracts the time from the speed, where acceleration calls for a division.',
      'One hundred eighty multiplies the speed by the time instead of dividing one by the other.',
    ],
    explanation:
        'Acceleration is the change in velocity divided by the time the change took. The '
        'velocity climbs by 30 ft per second in 6 seconds, so 30 divided by 6 gives 5 ft per '
        'second per second, written ft/s^2. Turning the division upside down gives 0.2, and 24 '
        'and 180 come from subtracting or from multiplying the two numbers instead of dividing '
        'them.',
    difficulty: Difficulty.easy,
    skills: <String>['mc.motion'],
  ),
  Question(
    id: 'mc-x14',
    subtest: Subtest.mc,
    stem:
        'Why is a heavy crate moved on a wheeled dolly with far less effort than the same crate '
        'dragged across the same floor?',
    choices: <String>[
      'The loaded dolly presses on the floor with less weight',
      'The wheels are made of a smoother material than the crate',
      'The dolly spreads the load over a larger floor area',
      'Rolling friction is much smaller than sliding friction',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'The dolly presses down with the full weight of the crate, so the load on the floor never changes.',
      'Rolling wins over sliding with the same materials, so a smoother wheel surface is not the reason.',
      'Spreading the load over a larger area does not reduce sliding friction, and the contact type is what changes.',
      'A wheel turns the contact into rolling, and rolling resistance is a small fraction of sliding friction.',
    ],
    explanation:
        'A wheel replaces sliding contact with rolling contact, and rolling resistance is only '
        'a small fraction of the sliding friction that the whole bottom of a dragged crate '
        'presents. That is why one person can move on a dolly a load that would hardly budge '
        'behind a rope. The dolly still presses down with the full weight of the crate, so '
        'spreading the load or smoothing the material is not the reason; what changes is the '
        'kind of contact and not the size of the load.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.motion'],
  ),
  Question(
    id: 'mc-x15',
    subtest: Subtest.mc,
    stem:
        'A steel block is dragged across a concrete floor. The same block is then turned onto '
        'one of its other faces, so the same weight presses on a much larger area. The force '
        'needed to keep it sliding:',
    choices: <String>[
      'Rises in proportion to the new area',
      'Falls to about half the old force',
      'Stays about the same as before',
      'Falls to one quarter of the old force',
    ],
    answerIndex: 2,
    choiceNotes: <String>[
      'Friction follows how hard the surfaces press, so the larger footprint does not raise the force.',
      'Halving would need the pressing weight halved, and the block presses just as hard on its wide face.',
      'Dry sliding friction follows the pressed weight and the materials, not the area carrying that weight.',
      'A quarter would need the block to weigh a quarter as much, and it weighs the same turned any way.',
    ],
    explanation:
        'Dry sliding friction depends on how hard the two surfaces are pressed together and on '
        'what the materials are, not on how much area carries that pressure. Spreading the same '
        'weight over a bigger footprint leaves the total friction about the same, which is why '
        'dragging a block on its wide face feels no easier than dragging it on its narrow one. '
        'The other options scale the force by the change in area, which is the intuition that '
        'usually fails on this question.',
    difficulty: Difficulty.hard,
    skills: <String>['mc.motion'],
  ),
  Question(
    id: 'mc-x16',
    subtest: Subtest.mc,
    stem:
        'In a hydraulic press the small piston has an area of 4 square inches and the large '
        'piston 24 square inches. If the small piston is pushed down 3 inches, how far does the '
        'large piston rise?',
    choices: <String>['0.5 inch', '3 inches', '12 inches', '18 inches'],
    answerIndex: 0,
    choiceNotes: <String>[
      'Six times the area means one sixth of the travel, so 3 inches becomes half an inch with the force up six times.',
      'Three inches would move the large piston the same distance, which would make work out of nothing.',
      'Twelve inches quadruples the travel, the reverse of what the six to one area ratio does.',
      'Eighteen inches multiplies by the area ratio instead of dividing, so the large piston would travel six times as far.',
    ],
    explanation:
        'A hydraulic press multiplies force but it cannot multiply work. The large piston has '
        'six times the area, so the same pressure gives it six times the force while it moves '
        'only one sixth as far: 3 inches divided by 6 is 0.5 inch. The fluid displaced on one '
        'side has to fit into the other, so the volumes must match. Multiplying the areas '
        'instead of dividing gives 18 inches, which would create energy out of nothing.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pressure'],
    figure: Sketch(
      caption:
          'A hydraulic press with a 4 square inch piston driven 3 inches down '
          'and a 24 square inch piston whose rise is marked with a question '
          'mark.',
      prims: <SketchPrim>[
        SketchPrim.line(Pt(0.14, 0.26), Pt(0.14, 0.82), weight: 3),
        SketchPrim.line(Pt(0.28, 0.26), Pt(0.28, 0.68), weight: 3),
        SketchPrim.line(Pt(0.28, 0.68), Pt(0.58, 0.68), weight: 3),
        SketchPrim.line(Pt(0.58, 0.26), Pt(0.58, 0.68), weight: 3),
        SketchPrim.line(Pt(0.86, 0.26), Pt(0.86, 0.82), weight: 3),
        SketchPrim.line(Pt(0.14, 0.82), Pt(0.86, 0.82), weight: 3),
        SketchPrim.line(Pt(0.14, 0.42), Pt(0.28, 0.42), weight: 4),
        SketchPrim.dashed(Pt(0.14, 0.50), Pt(0.28, 0.50)),
        SketchPrim.line(Pt(0.21, 0.42), Pt(0.21, 0.26), weight: 3),
        SketchPrim.arrow(Pt(0.21, 0.12), Pt(0.21, 0.24)),
        SketchPrim.text('3 in', Pt(0.34, 0.46)),
        SketchPrim.text('4 sq in', Pt(0.21, 0.60)),
        SketchPrim.line(Pt(0.58, 0.38), Pt(0.86, 0.38), weight: 4),
        SketchPrim.line(Pt(0.72, 0.38), Pt(0.72, 0.24), weight: 3),
        SketchPrim.text('?', Pt(0.72, 0.15)),
        SketchPrim.text('24 sq in', Pt(0.72, 0.54)),
        SketchPrim.text('fluid', Pt(0.43, 0.75)),
      ],
    ),
  ),
  Question(
    id: 'mc-x17',
    subtest: Subtest.mc,
    stem:
        'A narrow pipe holds water 8 ft deep and a wide open barrel holds water 2 ft deep. The '
        'pressure at the bottom of the pipe is:',
    choices: <String>[
      'Twice as great as at the bottom of the barrel',
      'Four times as great as at the bottom of the barrel',
      'The same, because both hold water',
      'Half as great, because the pipe holds less water',
    ],
    answerIndex: 1,
    choiceNotes: <String>[
      'Twice would match a 4 ft head, but the pipe water stands 8 ft deep against 2 ft in the barrel.',
      'Pressure depends on depth and density alone, so four times the depth gives four times the pressure.',
      'Depth rather than the liquid sets the pressure, and the pipe holds a column four times as deep.',
      'Half looks at how little water the pipe holds, and volume plays no part in pressure at depth.',
    ],
    explanation:
        'Pressure at the bottom of a column of liquid depends only on the depth of the liquid '
        'and on its density, so four times the depth means four times the pressure. The pipe '
        'holds far less water in total than the barrel, but the pressure at the bottom has '
        'nothing to do with the volume or with the width of the container, only with how far '
        'down the free surface is. That is why a tall standpipe can split a fitting that a wide, '
        'shallow tank would never trouble.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.pressure'],
    figure: Sketch(
      caption:
          'A narrow pipe holding water 8 feet deep standing beside a wide '
          'barrel holding water only 2 feet deep, with both depths marked.',
      prims: <SketchPrim>[
        SketchPrim.box(Pt(0.14, 0.16), Pt(0.22, 0.86)),
        SketchPrim.dashed(Pt(0.14, 0.20), Pt(0.22, 0.20)),
        SketchPrim.text('8 ft', Pt(0.18, 0.52)),
        SketchPrim.box(Pt(0.46, 0.52), Pt(0.76, 0.86)),
        SketchPrim.dashed(Pt(0.46, 0.70), Pt(0.76, 0.70)),
        SketchPrim.text('2 ft', Pt(0.61, 0.78)),
        SketchPrim.text('pipe', Pt(0.18, 0.92)),
        SketchPrim.text('barrel', Pt(0.61, 0.92)),
      ],
    ),
  ),
  Question(
    id: 'mc-x18',
    subtest: Subtest.mc,
    stem:
        'A cast iron bracket snaps with almost no warning when it is overloaded, while a mild '
        'steel bracket of the same shape bends and stays bent. Which property explains the '
        'difference?',
    choices: <String>[
      'Mild steel is denser than cast iron',
      'Cast iron is harder than mild steel',
      'Cast iron has a higher melting point',
      'Mild steel is ductile and cast iron is brittle',
    ],
    answerIndex: 3,
    choiceNotes: <String>[
      'Density does not decide how a part fails, and mild steel is not notably denser than cast iron.',
      'Hardness describes resistance to scratching, while this bracket difference is about bending before breaking.',
      'Melting point matters only near working temperature, which an overloaded bracket never approaches.',
      'Ductile steel stretches and yields with warning, while brittle cast iron fractures with almost no stretch.',
    ],
    explanation:
        'A ductile metal stretches and yields before it separates, so an overload shows up as '
        'a permanent bend that gives plenty of warning. Cast iron is brittle: it carries load '
        'until it reaches its limit and then fractures straight across the section with almost '
        'no stretching first. That is why cast parts are kept away from shock loads and why '
        'ductile iron and steel are chosen where a part must survive abuse. Density, hardness '
        'and melting point do not decide whether a part bends or snaps.',
    difficulty: Difficulty.medium,
    skills: <String>['mc.materials'],
  ),
];
