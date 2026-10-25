import '../models/lesson.dart';

/// Reinforcement lessons for the skills added in the fidelity upgrade.
const List<Lesson> lessonsD = <Lesson>[
  Lesson(
    skillId: 'pc.vocabulary',
    title: 'The sentence decides what the word means',
    hook: 'A dictionary definition is the wrong answer whenever the passage is using the word some other way.',
    whyItMatters: 'Paragraph Comprehension feeds Verbal Expression, and VE is weighted double inside the AFQT composite, so a context item you clean up here is worth two ordinary points.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Find the job the word is doing',
        'A word inside a passage is working: naming something, describing somebody, or turning the sentence against what came before. Read the sentence before it and the sentence after it, then name that job. The job tells you which sense of the word is live.',
        bullets: <String>[
          'Read one sentence on each side of the word before you look at the choices.',
          'Read the part of speech from the position: a word sitting right after the is a noun or an adjective, not a verb.',
          'Substitute your candidate meaning back into the sentence and check that nothing in it now contradicts.',
        ],
      ),
      LessonSection(
        'The familiar sense is the bait',
        'Most tested words carry a common sense and a passage sense. The passage writer chose the less common one deliberately, because the common one makes such a comfortable distractor.',
        bullets: <String>[
          'If a choice matches the first definition you remember instantly, treat it as suspect until the sentence agrees.',
          'Passages describing a person are usually testing a word about character, not about objects.',
          'Keep the meaning that could be swapped in with no change to what the passage says.',
        ],
      ),
      LessonSection(
        'The neighbours often define the word for you',
        'Writers restate a hard word in plainer language close by, after a dash, after a comma, or behind the phrase that is. That restatement is one of the answer choices in different clothes.',
        bullets: <String>[
          'A clause beginning with that is or in other words is a definition handed to you.',
          'Contrast connectors such as but and although mean the word runs opposite to the nearby description.',
          'Cause and effect connectors let you reason backwards from the outcome to the meaning.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The supply sergeant was SPARING in his praise, offering a single sentence after a flawless inspection. As used here, SPARING most nearly means which of: generous, limited, hostile, rehearsed.',
        steps: <String>[
          'Use the outcome: a flawless inspection still earned one sentence of praise, which is very little.',
          'Test the tempting dictionary sense: generous would predict a long speech, and the passage reports the opposite.',
          'Limited fits the small amount of praise and leaves the sentence intact.',
        ],
        answer: 'limited',
      ),
      WorkedExample(
        prompt: 'The new procedure was CUMBERSOME, requiring three signatures and a separate trip to each office. As used here, CUMBERSOME most nearly means which of: heavy, complicated, expensive, optional.',
        steps: <String>[
          'Read the restatement after the comma: three signatures and separate trips describe a burden.',
          'Heavy is the dictionary sense, but the passage never mentions weight or lifting.',
          'Complicated matches the listed burdens without adding anything the passage did not say.',
        ],
        answer: 'complicated',
      ),
    ],
    quickRules: <String>[
      'Define the word in the situation the passage describes, not in the abstract.',
      'Read a sentence on each side before you read the four choices.',
      'Substitute every choice back in and keep the one that changes nothing.',
      'Treat the most familiar meaning as a distractor until the sentence confirms it.',
    ],
    pitfalls: <String>[
      'Answering the dictionary sense: a sparing sergeant described as generous when the passage meant that his praise was limited.',
      'Answering a mood: hostile for a sergeant who was merely brief, which imports an attitude the passage never shows.',
      'Answering something true about the scene but not about the word, such as expensive for a cumbersome procedure.',
    ],
  ),
  Lesson(
    skillId: 'pc.sequence',
    title: 'Order, cause, and how the author builds a point',
    hook: 'A large share of these items turn on a single word: before, after, because or therefore.',
    whyItMatters: 'Paragraph Comprehension builds Verbal Expression, which is weighted double inside the AFQT composite, so sequence and technique items are double-value reading points.',
    minutes: 7,
    sections: <LessonSection>[
      LessonSection(
        'Timeline words carry the answer',
        'Sequence items are decided by the order words, not by the size of the events. Underline first, then, before, after, finally and once, then lay the events out on a line.',
        bullets: <String>[
          'Before and after reverse the two clauses they join, so check which clause each one governs.',
          'A phrase like once the valve closed marks the starting point, not the action the question asks about.',
          'When no order word appears, the order of the sentences is the order of events.',
        ],
      ),
      LessonSection(
        'Cause is not the same as sequence',
        'Two things mentioned next to each other are not automatically cause and effect. The writer has to say so with because, so, therefore, as a result or led to.',
        bullets: <String>[
          'Because introduces the cause; so and therefore introduce the result.',
          'A question asking why wants a cause, which usually sits after the event it explains.',
          'At the same time and meanwhile mark sequence only, and they are planted where a cause is wanted.',
        ],
      ),
      LessonSection(
        'Technique: how the paragraph is built',
        'Some items ask how the author makes the point rather than what happened. Name the structure of the paragraph and the answer follows.',
        bullets: <String>[
          'A general claim followed by a list of cases is a paragraph built on examples.',
          'On the other hand and unlike signal a comparison and contrast structure.',
          'A fault named and then a remedy offered is a problem and solution structure.',
          'The closing sentence of a built paragraph usually states the point the structure was serving.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'The crew drained the lines first. After the pressure gauge read zero, they loosened the fitting. Only then did they replace the gasket. Which step came immediately before the gasket was replaced?',
        steps: <String>[
          'Lay the events on a line using first, after and only then: drain the lines, loosen the fitting, replace the gasket.',
          'Note where the gauge reading belongs: after connects it to loosening the fitting, so it is earlier still and is not the step being asked about.',
          'The event directly in front of the replacement is loosening the fitting.',
        ],
        answer: 'They loosened the fitting.',
      ),
      WorkedExample(
        prompt: 'A paragraph says the shop switched to a new coolant, notes that radiator failures fell the following quarter, and states that the change was made because the old coolant corroded aluminum. What does the paragraph give as the cause of the switch?',
        steps: <String>[
          'Find the causal connector: because introduces the reason for the change.',
          'The corrosion of aluminum is that reason; the fall in failures is a later result, not the cause.',
          'Report the cause as stated, without promoting the result into a cause.',
        ],
        answer: 'The old coolant corroded aluminum.',
      ),
    ],
    quickRules: <String>[
      'Underline first, then, before, after and finally before you answer anything.',
      'Before and after reverse the two clauses they join, so read which side each one rules.',
      'A cause needs a signal word: because, so, therefore or as a result.',
      'At the same time and meanwhile order events; they do not connect them as cause and effect.',
    ],
    pitfalls: <String>[
      'Reversing the pair joined by before, which hands you the event that came afterwards instead of the one asked about.',
      'Reading the later result as the cause: answering that the fall in failures caused the coolant change, when the corrosion did.',
      'Treating two events mentioned side by side as cause and effect when the passage only says they happened together.',
    ],
  ),
  Lesson(
    skillId: 'ei.systems',
    title: 'Generators, motors, batteries and the house circuit',
    hook: 'A generator and a motor are the same machine, run in opposite directions.',
    whyItMatters: 'Electronics Information does not feed your AFQT, but it does feed Army line scores, so every systems item you convert is still a point that counts for you.',
    minutes: 9,
    sections: <LessonSection>[
      LessonSection(
        'One machine, two jobs',
        'A generator turns motion into voltage. A motor turns voltage into motion. Both are a coil and a magnetic field, and the only difference is which end of the energy chain you start from.',
        bullets: <String>[
          'Spin a coil through a magnetic field and you have a generator; feed the same coil a current and it spins.',
          'Generator output rises with the speed of rotation and with the strength of the magnetic field.',
          'A direct current generator needs a commutator to keep the output in one direction; an alternator uses slip rings and produces alternating current.',
        ],
      ),
      LessonSection(
        'Batteries: series adds volts, parallel adds capacity',
        'Series means one path through every cell, so the voltages add. Parallel means every cell sees the same two terminals, so the voltage stays put and the capacity adds.',
        bullets: <String>[
          'Four 1.5 volt cells in series give 6 volts; the same four in parallel still give 1.5 volts.',
          'Two 12 volt batteries in series give 24 volts, the usual heavy truck and aircraft supply.',
          'Parallel batteries share the load, so run time adds while the voltage does not change.',
          'In a series string the current is identical everywhere and the resistances add.',
        ],
      ),
      LessonSection(
        'Transformers and house wiring',
        'A transformer trades voltage for current at the same power, and it only works on alternating current because it needs a changing field. Household circuits are wired in parallel so each outlet sees the full supply voltage.',
        bullets: <String>[
          'A step-down transformer has more turns on the primary winding than on the secondary.',
          'Power in equals power out, so halving the voltage doubles the current available at the lower voltage.',
          'House outlets are in parallel, so switching off one lamp does not break the path to the others.',
          'The neutral wire carries the return current; the ground wire is a safety path that carries none in normal operation.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A 120 volt circuit draws 5 amps. A transformer steps the voltage down to 24 volts. Ignoring losses, what current can the secondary deliver?',
        steps: <String>[
          'Power in equals volts times amps: 120 x 5 = 600 watts.',
          'Power out equals power in, so the secondary handles 600 watts at 24 volts.',
          'Divide: 600 / 24 = 25 amps.',
        ],
        answer: '25 amps',
      ),
      WorkedExample(
        prompt: 'A lantern takes four 1.5 volt cells in series. What is the total voltage, and what happens if one cell is installed backwards?',
        steps: <String>[
          'Series voltages add: 1.5 + 1.5 + 1.5 + 1.5 = 6 volts.',
          'A reversed cell subtracts instead of adding, so the total becomes 1.5 + 1.5 + 1.5 - 1.5 = 3 volts.',
          'Because a series string has one path, the whole string is affected rather than just one cell.',
        ],
        answer: '6 volts normally, 3 volts with one cell reversed.',
      ),
    ],
    quickRules: <String>[
      'Generator: motion in, voltage out. Motor: voltage in, motion out.',
      'Series adds voltage and keeps one current path; parallel adds capacity and keeps the voltage.',
      'A transformer changes voltage and current together and needs alternating current to work.',
      'House outlets are parallel, so each one receives the full supply voltage.',
    ],
    pitfalls: <String>[
      'Wiring cells in parallel and adding the voltages anyway: four 1.5 volt cells answered as 6 volts instead of 1.5.',
      'Adding the currents in a series string, so two lamps that each carry 5 amps are answered as 10 amps.',
      'Expecting a transformer to work on a steady direct current, where the field never changes and the output is zero volts.',
    ],
  ),
  Lesson(
    skillId: 'as.drivetrain',
    title: 'From crank to wheel: what each part does',
    hook: 'The engine makes spin; the drivetrain decides how much of that spin reaches the road and in which direction.',
    whyItMatters: 'Auto and Shop Information does not feed the AFQT, but it does feed Army line scores, so drivetrain items are points you are allowed to keep.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Clutch or converter: disconnecting the engine',
        'The engine has to keep turning while the wheels stand still. A manual car uses a clutch, a friction disc pressed against the flywheel. An automatic uses a torque converter, two fan shaped halves facing each other inside a fluid.',
        bullets: <String>[
          'The clutch pedal separates the disc from the flywheel, which breaks the drive without stopping the engine.',
          'A worn clutch slips under load, so the engine revs while the car barely speeds up.',
          'A torque converter multiplies torque at low speed, which is why an automatic pulls away smoothly with no pedal.',
        ],
      ),
      LessonSection(
        'Transmission, driveshaft and differential',
        'The transmission swaps gear ratios: a low gear gives torque, a high gear gives speed. The driveshaft carries the spin to the axle, and the differential splits it between the two wheels.',
        bullets: <String>[
          'Lower gears multiply torque and reduce speed, which is why first gear climbs a grade.',
          'A rear wheel drive car sends power down a driveshaft to a differential on the rear axle.',
          'On a front engine rear drive layout the differential also turns the drive through ninety degrees.',
          'In a turn the outside wheel travels farther, and the differential allows that difference without dragging a tire.',
        ],
      ),
      LessonSection(
        'Brakes and suspension',
        'Brakes turn motion into heat by friction. Suspension holds the wheels to the road and the body off the axle, using springs, dampers and the steering linkage.',
        bullets: <String>[
          'Disc brakes squeeze pads onto a spinning rotor; drum brakes push shoes outward against a drum.',
          'Brake fluid is hydraulic, so pedal force reaches the wheels through sealed lines rather than a cable.',
          'Shock absorbers do not carry weight; they damp the bounce the springs would otherwise keep going.',
          'Camber, caster and toe are alignment angles, and the wrong camber wears one edge of the tire.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'An engine turns at 2,400 revolutions per minute in a gear with a 4 to 1 reduction, followed by a differential with a 3 to 1 reduction. What is the axle speed?',
        steps: <String>[
          'Multiply the two reductions: 4 x 3 = 12, so the axle turns once for every twelve engine turns.',
          'Divide the engine speed by the total reduction: 2,400 / 12 = 200.',
        ],
        answer: '200 revolutions per minute',
      ),
      WorkedExample(
        prompt: 'A car corners with both rear wheels on one differential. The engine side of the differential turns at 600 revolutions per minute and the inside wheel turns at 500. What is the outside wheel doing?',
        steps: <String>[
          'An open differential makes the average of the two wheel speeds equal the speed it receives.',
          'Twice that received speed is 2 x 600 = 1,200.',
          'Subtract the inside wheel: 1,200 - 500 = 700, so the outside wheel is faster as the car turns.',
        ],
        answer: '700 revolutions per minute',
      ),
    ],
    quickRules: <String>[
      'Clutch and torque converter both couple the engine to the transmission and both allow slip at low speed.',
      'Low gear means more torque and less speed; a tall gear means the reverse.',
      'The differential splits the drive and lets the wheels turn at different speeds in a turn.',
      'Brakes make heat, so a soft pedal after hard use is a fluid or heat problem, not a mystery.',
    ],
    pitfalls: <String>[
      'Multiplying instead of dividing the gear reduction: 2,400 x 12 answered as 28,800 revolutions per minute at the axle.',
      'Assuming both rear wheels turn at the same speed through a turn, which would make a car scrub its tires on dry pavement.',
      'Blaming the shock absorbers for a sagging car, when it is the springs that carry the weight.',
    ],
  ),
  Lesson(
    skillId: 'as.electrical',
    title: 'Battery, alternator, starter, and the circuit between them',
    hook: 'Three parts move the current that starts a car, and each kind of failure sounds different when you turn the key.',
    whyItMatters: 'Auto and Shop Information does not feed your AFQT, but it does feed Army line scores, and fault tracing items are the ones most candidates leave on the table.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Three parts, three jobs',
        'The battery stores energy and supplies it on demand. The starter motor cranks the engine. The alternator spins with the running engine and recharges the battery while carrying the electrical loads.',
        bullets: <String>[
          'The battery does the starting work; the alternator does the running work.',
          'A slow laboured crank that speeds up once the engine catches points at the battery or at its cables.',
          'A single loud click with no crank usually means the starter solenoid or a poor connection at the cable ends.',
          'A charging system in good order holds roughly 13.5 to 14.5 volts across the battery with the engine running.',
        ],
      ),
      LessonSection(
        'The circuit needs a return path',
        'Current leaves the positive post, travels through the switch, the coil and the distributor to the plugs, then returns through the engine block to the negative post. Every connection in that loop can break the whole thing.',
        bullets: <String>[
          'The negative cable grounds the block, so a loose ground produces exactly the symptoms of a flat battery.',
          'The coil steps 12 volts up to the thousands of volts a plug needs to jump its gap.',
          'A fouled plug still receives voltage and still fails, so voltage at the plug is not proof of a spark.',
          'Points or an electronic module control when the coil fires, and that timing decides when the spark arrives.',
        ],
      ),
      LessonSection(
        'Timing, and tracing a fault',
        'Spark has to arrive just before top dead center on the compression stroke. Too early and the engine knocks; too late and it runs hot and weak. Fault finding works backwards from the part that does not function.',
        bullets: <String>[
          'Timing is measured in degrees before top dead center, not in seconds.',
          'Trace backwards: at the plug, then at the coil, then at the switch, then at the battery.',
          'A test light or a voltmeter shows where the current stops, which beats replacing parts and hoping.',
          'Corrosion at a terminal adds resistance, so voltage is lost before the current ever reaches the load.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A battery reads 12.4 volts with the engine off and 12.1 volts with the engine running and the headlights on. What does the pair of readings tell you?',
        steps: <String>[
          'A working charging system should read higher with the engine running than with it off.',
          'Here the reading fell by 12.4 - 12.1 = 0.3 volts instead of rising.',
          'The alternator is not keeping up with the load, so the battery is being drained while the car runs.',
        ],
        answer: 'The alternator, its belt or its wiring is not charging.',
      ),
      WorkedExample(
        prompt: 'A starter draws 200 amps from a 12 volt battery while cranking. What power is the starter using, and why does a corroded ground cable make the crank slow?',
        steps: <String>[
          'Power is volts times amps: 12 x 200 = 2,400 watts.',
          'The ground cable is part of the same circuit, so any resistance in it sits in series with the starter.',
          'That added resistance drops voltage before the current reaches the starter, so less voltage arrives and the crank is slow.',
        ],
        answer: '2,400 watts, and the bad ground steals voltage from the starter before it can use it.',
      ),
    ],
    quickRules: <String>[
      'Battery for starting, alternator for running, starter for cranking.',
      'With the engine running the battery should read higher than with it stopped.',
      'Every circuit needs a return path, and for the starter it runs through the engine block.',
      'Trace a fault backwards from the part that does not work.',
    ],
    pitfalls: <String>[
      'Replacing the battery when the alternator is at fault: a 12.1 volt running reading answered as a bad battery.',
      'Calling a plug good because it has voltage at the tip, when a fouled plug passes voltage and still misfires.',
      'Overlooking the ground cable because it carries no voltage of its own, which leaves a slow crank unexplained.',
    ],
  ),
  Lesson(
    skillId: 'as.construction',
    title: 'Framing, concrete and reading the plans',
    hook: 'A building goes together in a fixed order: dig, pour, frame, cover, finish.',
    whyItMatters: 'Auto and Shop Information does not feed the AFQT, but it does feed Army line scores, so construction items count even though they sit outside the composite.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'The order of the work is not optional',
        'Footings come first, then the foundation walls, then the frame, then the roof, then the utilities and finally the finish. Each trade hands the site to the next one, so a step out of order means work to undo.',
        bullets: <String>[
          'Footings spread the load over enough soil that the ground does not fail beneath the foundation.',
          'A slab poured on grade needs a vapor barrier underneath to stop moisture rising into the floor.',
          'Framing goes up before the roof sheathing, and the sheathing is what stiffens the frame.',
          'Rough plumbing and wiring go in before the wall coverings, never after them.',
        ],
      ),
      LessonSection(
        'Concrete is a mix, not a single material',
        'Concrete is cement, sand, gravel and water. The cement is the glue and it is the smallest part by volume. More water makes the mix easier to place and weaker once it cures.',
        bullets: <String>[
          'A richer mix carries more cement per volume and reaches a higher strength.',
          'Concrete gains most of its strength in the first 28 days, which is why test cylinders are broken then.',
          'Concrete is strong in compression and weak in tension, so reinforcing steel is placed to carry the tension.',
          'Control joints are cut so the slab cracks in a chosen straight line instead of anywhere it likes.',
        ],
      ),
      LessonSection(
        'Reading a set of plans',
        'Plans are drawn to scale, so the scale note turns a measurement on paper into a real distance. Elevations give heights, sections give the layers, and the schedule names the materials.',
        bullets: <String>[
          'Solid lines are visible edges; dashed lines are hidden edges or features above the cut.',
          'A door drawn with an arc swings that way, and the hinge side is where the arc begins.',
          'A wall section lists the layers from outside face to inside face in order.',
          'Ceiling height is written as an elevation, and it is not the same thing as floor area.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A floor plan is drawn at a scale of one quarter inch to one foot. A wall measures 3 inches on the drawing. How long is the real wall?',
        steps: <String>[
          'Count how many quarter inches fit inside 3 inches: 3 / 0.25 = 12.',
          'Each quarter inch stands for one foot, so multiply 12 x 1 = 12 feet.',
        ],
        answer: '12 feet',
      ),
      WorkedExample(
        prompt: 'A concrete slab measures 20 feet by 30 feet and is 4 inches thick. How many cubic yards of concrete does it need?',
        steps: <String>[
          'Convert the thickness to feet: 4 inches is 4 / 12 = 1/3 foot.',
          'Find the area, then the volume: 20 x 30 = 600 square feet, and 600 x 1/3 = 200 cubic feet.',
          'A cubic yard holds 27 cubic feet, so divide: 200 / 27 = 7.4.',
        ],
        answer: 'About 7.4 cubic yards',
      ),
    ],
    quickRules: <String>[
      'Footings, foundation, frame, roof, rough utilities, finish: the sequence does not change.',
      'Concrete is strong in compression and weak in tension, which is what the steel is for.',
      'Extra water makes concrete easier to place and weaker when it cures.',
      'A scale of one quarter inch to one foot means four quarter inches to every foot.',
    ],
    pitfalls: <String>[
      'Multiplying by the scale instead of dividing: 3 inches of wall answered as 0.75 feet instead of 12 feet.',
      'Forgetting the 27 cubic feet in a cubic yard, so a 200 cubic foot slab is ordered as 200 cubic yards.',
      'Reading a dashed line as a visible edge when it marks something hidden inside the wall.',
    ],
  ),
  Lesson(
    skillId: 'mc.motion',
    title: 'Speed, acceleration, inertia and friction',
    hook: 'Nothing changes its motion on its own, and friction is the something that always does.',
    whyItMatters: 'Mechanical Comprehension does not feed the AFQT, but it does feed Army line scores, so motion items are worth working even outside the composite.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Speed, velocity, acceleration',
        'Speed is distance over time. Velocity is speed with a direction attached. Acceleration is the change in velocity divided by the time it took, so slowing down counts as acceleration too.',
        bullets: <String>[
          'Acceleration equals change in velocity divided by time, and its units carry a per second twice, such as feet per second squared.',
          'A car reaching 60 miles per hour in 12 seconds gains 5 miles per hour every second.',
          'Deceleration is negative acceleration, and the same formula handles it without a special rule.',
          'A car on a curve at steady speed is still accelerating, because its direction keeps changing.',
        ],
      ),
      LessonSection(
        'Inertia, and the laws of motion',
        'Mass resists any change in motion. That is why a loaded truck needs more road to stop than an empty one. Force equals mass times acceleration, so doubling the mass doubles the force required.',
        bullets: <String>[
          'Inertia is mass, and it is why a passenger keeps moving forward when the brakes grab.',
          'Twice the mass needs twice the force for the same acceleration.',
          'An object at rest stays at rest until an outside force acts on it.',
          'Every action has an equal and opposite reaction, which is why the tires push the road backwards to move the car forwards.',
        ],
      ),
      LessonSection(
        'Friction and lubrication',
        'Friction opposes motion between surfaces in contact and turns motion into heat. It depends on the materials and on how hard they are pressed together. A film of oil or grease replaces metal on metal with fluid on fluid.',
        bullets: <String>[
          'Starting friction is greater than sliding friction, which is why a stuck part lets go all at once.',
          'Friction produces heat, which is why bearings are lubricated and sometimes cooled.',
          'A heavier load presses the surfaces harder, so more force is needed to slide it.',
          'Rolling friction is far lower than sliding friction, which is the whole reason the wheel exists.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'A truck goes from rest to 60 miles per hour in 12 seconds. What is its average acceleration?',
        steps: <String>[
          'Acceleration is the change in velocity divided by the time taken.',
          'The change is 60 - 0 = 60 miles per hour.',
          'Divide: 60 / 12 = 5.',
        ],
        answer: '5 miles per hour per second',
      ),
      WorkedExample(
        prompt: 'A truck at 20 miles per hour needs 40 feet to stop on dry pavement. How much road does the same truck need at 40 miles per hour?',
        steps: <String>[
          'Stopping distance grows with the square of the speed, not with the speed itself.',
          'Doubling the speed squares the factor: 2 x 2 = 4 times the distance.',
          'Multiply: 40 x 4 = 160.',
        ],
        answer: 'About 160 feet',
      ),
    ],
    quickRules: <String>[
      'Acceleration is change in velocity over time, in either direction.',
      'Force equals mass times acceleration, so more mass or more acceleration means more force.',
      'Friction opposes motion and produces heat; lubrication puts a fluid layer between the surfaces.',
      'Stopping distance grows with the square of the speed, so double the speed means four times the distance.',
    ],
    pitfalls: <String>[
      'Dividing the time by the speed: 12 / 60 answered as 0.2 instead of the 5 miles per hour per second that the truck actually gains.',
      'Treating a braking truck as having no acceleration, when it has a large negative one.',
      'Assuming a doubled speed doubles the stopping distance, so 40 miles per hour is answered as 80 feet instead of 160.',
    ],
  ),
  Lesson(
    skillId: 'mc.materials',
    title: 'Strength, hardness, elasticity and density',
    hook: 'The right material is not the strongest one; it is the one whose weakness does not matter for the job.',
    whyItMatters: 'Mechanical Comprehension does not feed your AFQT, but it does feed Army line scores, so the material items are yours to collect.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'Four properties answer four different questions',
        'Strength resists breaking under load. Hardness resists scratching and wear. Elasticity is the ability to return to the original shape. Ductility is the ability to be drawn out without cracking.',
        bullets: <String>[
          'A file is hard so it can cut steel; a hammer head is hard, but the handle behind it has to be tough.',
          'Toughness is the opposite of brittleness: a tough part bends before it breaks.',
          'Elastic deformation springs back; plastic deformation stays after the load is removed.',
          'Ductile means it can be drawn into wire, malleable means it can be hammered into sheet.',
        ],
      ),
      LessonSection(
        'Density decides weight for a given size',
        'Density is mass divided by volume. A cubic foot of steel weighs far more than a cubic foot of aluminum, which is why aircraft and trailers use aluminum and its alloys.',
        bullets: <String>[
          'Density equals mass divided by volume, so it carries units like pounds per cubic foot.',
          'Aluminum is roughly a third as dense as steel, so the same part weighs about a third as much.',
          'A lighter material gives a lighter part, at a cost in strength or stiffness.',
          'Buoyancy depends on density relative to the fluid, not on the total weight of the object.',
        ],
      ),
      LessonSection(
        'Heat and repeated load change a material',
        'Heating expands a material and softens it. Repeated flexing can crack a part while every single load stays far below what would break it once, and that is fatigue.',
        bullets: <String>[
          'Metals expand when heated, which is why rails and bridge decks carry expansion joints.',
          'Quenching hardened steel makes it harder and more brittle in the same operation.',
          'Fatigue cracks start at a stress concentration such as a sharp inside corner or a deep scratch.',
          'A material that is strong in compression can be weak in tension, which is why concrete carries steel.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Two blocks have the same volume of 2 cubic feet. One weighs 40 pounds and the other weighs 100 pounds. What is the density of each?',
        steps: <String>[
          'Density is mass divided by volume.',
          'First block: 40 / 2 = 20 pounds per cubic foot.',
          'Second block: 100 / 2 = 50 pounds per cubic foot.',
          'The second is two and a half times as dense, because 50 / 20 = 2.5.',
        ],
        answer: '20 and 50 pounds per cubic foot',
      ),
      WorkedExample(
        prompt: 'A steel bar is 10 feet long at 60 degrees Fahrenheit and expands 0.0000065 inches per inch for every degree Fahrenheit. How much longer is it at 100 degrees Fahrenheit?',
        steps: <String>[
          'Convert the length to inches: 10 x 12 = 120 inches.',
          'Find the temperature change: 100 - 60 = 40 degrees.',
          'Multiply the three together: 120 x 0.0000065 x 40 = 0.0312.',
        ],
        answer: 'About 0.031 inches, which is close to one thirty-second of an inch',
      ),
    ],
    quickRules: <String>[
      'Strength resists breaking, hardness resists wear, elasticity returns to shape, toughness resists cracking.',
      'Density is mass divided by volume, and it decides how heavy a given size will be.',
      'Heating expands a material and softens it, so a hot part is longer and weaker.',
      'Hardening usually trades toughness for hardness, so the hardest part is often the most brittle.',
    ],
    pitfalls: <String>[
      'Choosing the hardest material for a part that must absorb a shock, so a hardened handle cracks instead of bending.',
      'Dividing volume by mass, which turns 40 pounds over 2 cubic feet into 0.05 instead of 20 pounds per cubic foot.',
      'Forgetting to convert feet to inches, so the 10 foot bar is answered as growing 0.0026 inches instead of 0.0312.',
    ],
  ),
  Lesson(
    skillId: 'ao.connection',
    title: 'Join the pieces where the letters match',
    hook: 'The pieces join in one place and only that place, and the letters tell you which place it is.',
    whyItMatters: 'Assembling Objects does not feed your AFQT, but it does feed Army line scores, and connection items are the fastest points on that subtest once the letter rule is automatic.',
    minutes: 8,
    sections: <LessonSection>[
      LessonSection(
        'What a lettered connection means',
        'Each lettered point is half of a joint. Point A on one piece has to meet A on another piece, or meet the single A socket in the answer figure. Two edges that happen to be the same length are not a connection.',
        bullets: <String>[
          'Match the letters first and the outline second, because the letters are the hard constraint.',
          'A duplicate letter appears once on each piece that must touch there, not twice on one piece.',
          'If an answer figure shows a joint where nothing on either piece could reach, that figure is wrong.',
          'Count the joints in the answer figure and compare the total with the letters you were given.',
        ],
      ),
      LessonSection(
        'Ignore the tempting edges',
        'Distractors are built from real edges of the pieces, placed somewhere they cannot actually reach. Touching is not joining, and the letters are what separate the two ideas.',
        bullets: <String>[
          'The pieces may be rotated but never stretched, bent or trimmed.',
          'An edge fits only when the lettered points at its two ends both line up.',
          'A mirror image is not a rotation, so a flipped piece is always the wrong piece.',
          'A notch meeting a notch leaves a gap, and closing that gap by sliding one piece through another is impossible.',
        ],
      ),
      LessonSection(
        'Rotate first, then place',
        'Turn both pieces in your mind until the letters face each other, then look for the outlines crossing. Track the rotation on one small feature, such as a tab or a notch, rather than on the whole shape.',
        bullets: <String>[
          'Follow one distinctive feature, such as the longest straight edge, all the way through the turn.',
          'A right angle stays a right angle, so an answer figure that turns it into a sharp corner is out.',
          'Compare the finished silhouette with the choices last, once the joints are already satisfied.',
          'If two choices both join correctly, the one showing an extra unmatched joint is the wrong one.',
        ],
      ),
    ],
    examples: <WorkedExample>[
      WorkedExample(
        prompt: 'Piece 1 is an L shaped bracket with point A at the end of its short leg and point B on its long leg. Piece 2 is a straight strap with point A at one end and point B at the other. How must the two pieces be arranged?',
        steps: <String>[
          'Point A appears once on each piece, so the end of the strap marked A must meet the short leg end marked A.',
          'Point B also appears once on each piece, so the far end of the strap must reach the B point on the long leg.',
          'That makes the bracket bend the strap around its corner: A at the short leg, B on the long leg, with the strap passing outside the corner.',
        ],
        answer: 'Join A to A at the short leg and B to B on the long leg, so the strap wraps the corner.',
      ),
      WorkedExample(
        prompt: 'An answer figure shows a T made from two flat rectangles with a single joint marked C. The pieces given are a long rectangle with C at its midpoint and a short rectangle with C at one end. Which arrangement builds the figure, and what rules out the version with the short piece joined at its own centre?',
        steps: <String>[
          'Check the joint count: the figure needs one joint, and the pieces offer one lettered point each, so they can meet exactly once.',
          'The long rectangle carries C at its midpoint, so the short piece must attach there and stick out to one side, which is a T.',
          'The centred version cannot be built, because the short piece carries C at its end and has no point at its middle to join.',
        ],
        answer: 'Attach the short rectangle at C on the midpoint of the long one; the centred version is impossible.',
      ),
    ],
    quickRules: <String>[
      'Match the letters before you match the outlines.',
      'Rotate only; a flipped piece is a mirror image and it is always wrong.',
      'Count the joints in the answer figure against the letters you were given.',
      'An edge that touches without a shared letter is not a connection.',
    ],
    pitfalls: <String>[
      'Joining two long straight edges because they look flush, which produces a figure with a joint where no letter ever appeared.',
      'Flipping a piece to make it fit, so the assembled shape is the mirror image of the one that can actually be built.',
      'Ignoring a second lettered point, which leaves one joint in the answer figure unmatched and makes that figure impossible.',
    ],
  ),
];
