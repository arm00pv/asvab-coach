import 'mos.dart';

/// A career field, identified by the two-digit prefix of the MOS code.
///
/// The Army's own numbering already answers "what kind of job is this": every
/// 68 MOS is medical, every 25 is signal, every 12 is engineer. Deriving the
/// field from the code means the whole catalogue can be grouped without
/// hand-labelling 97 entries - and a test asserts no job is left unclassified,
/// so a new MOS cannot arrive without a field.
class CareerField {
  const CareerField(this.prefix, this.label);

  /// The two-digit MOS prefix, e.g. "68".
  final String prefix;

  /// What the field is called in plain words.
  final String label;

  static const List<CareerField> all = <CareerField>[
    CareerField('08', 'Ceremonial'),
    CareerField('11', 'Infantry'),
    CareerField('12', 'Engineer'),
    CareerField('13', 'Field Artillery'),
    CareerField('14', 'Air Defence Artillery'),
    CareerField('15', 'Aviation'),
    CareerField('17', 'Cyber'),
    CareerField('18', 'Special Forces'),
    CareerField('19', 'Armor'),
    CareerField('25', 'Signal'),
    CareerField('27', 'Judge Advocate'),
    CareerField('31', 'Military Police'),
    CareerField('35', 'Military Intelligence'),
    CareerField('36', 'Finance'),
    CareerField('37', 'Psychological Operations'),
    CareerField('38', 'Civil Affairs'),
    CareerField('40', 'Space Operations'),
    CareerField('42', 'Adjutant General'),
    CareerField('46', 'Public Affairs'),
    CareerField('51', 'Acquisition'),
    CareerField('56', 'Chaplain'),
    CareerField('60', 'Medical Corps (officer)'),
    CareerField('65', 'Finance (officer)'),
    CareerField('68', 'Medical'),
    CareerField('70', 'Information Operations'),
    CareerField('74', 'Chemical'),
    CareerField('79', 'Recruiting'),
    CareerField('88', 'Transportation'),
    CareerField('89', 'Ammunition'),
    CareerField('91', 'Ordnance'),
    CareerField('92', 'Quartermaster'),
    CareerField('94', 'Electronic Maintenance'),
    CareerField('98', 'Electronic Warfare'),
  ];

  /// The field an MOS belongs to, or null when the code is not a two-digit
  /// numbered specialty.
  static CareerField? ofCode(String code) {
    if (code.length < 2) return null;
    final prefix = code.substring(0, 2);
    for (final field in all) {
      if (field.prefix == prefix) return field;
    }
    return null;
  }

  static CareerField? of(Mos mos) => ofCode(mos.code);

  @override
  String toString() => 'CareerField($prefix, $label)';
}

/// How a commissioning route is taken, rather than what it commissions into.
///
/// Every route answers the same question - how do I become an officer - but they
/// are wildly different commitments: a four-year academy, a college programme, a
/// federal school after enlisting, or a direct commission for a lawyer or a
/// doctor. Grouping them is what makes the list usable.
class OfficerTrack {
  const OfficerTrack(this.id, this.label);

  final String id;
  final String label;

  static const OfficerTrack ocs = OfficerTrack(
    'ocs',
    'Officer candidate school',
  );
  static const OfficerTrack rotc = OfficerTrack('rotc', 'College programme');
  static const OfficerTrack academy = OfficerTrack(
    'academy',
    'Service academy',
  );
  static const OfficerTrack direct = OfficerTrack(
    'direct',
    'Direct commission',
  );
  static const OfficerTrack warrant = OfficerTrack(
    'warrant',
    'Warrant officer',
  );
  static const OfficerTrack enlistFirst = OfficerTrack(
    'enlist-first',
    'Enlist, then commission',
  );

  static const List<OfficerTrack> all = <OfficerTrack>[
    ocs,
    rotc,
    academy,
    direct,
    warrant,
    enlistFirst,
  ];

  /// The track each published pathway belongs to. Explicit rather than guessed
  /// from the title, and a test fails if a pathway is added without an entry.
  static const Map<String, OfficerTrack> _byPathway = <String, OfficerTrack>{
    'ocs': ocs,
    'arng-ocs': ocs,
    'rotc': rotc,
    'green-to-gold': rotc,
    'usma': academy,
    'direct-commission': direct,
    'wocs': warrant,
    'woft': warrant,
    '09s-09w': enlistFirst,
  };

  static OfficerTrack? of(OfficerPathway pathway) => _byPathway[pathway.id];

  static OfficerTrack? ofId(String id) => _byPathway[id];

  @override
  String toString() => 'OfficerTrack($id, $label)';
}
