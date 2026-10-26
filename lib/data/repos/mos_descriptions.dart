/// What a job is, in plain language, for every code on the roster.
///
/// The 156 descriptions were written in four slices, one file each, because the
/// slices were worked in parallel and a single 1,500-line map is the one place
/// four passes would all collide. A slice is a good unit to write in and a bad
/// unit to read from: a job sheet holds one code and needs the one description
/// that belongs to it, without knowing which alphabetically-cut share of the
/// roster it landed in.
///
/// So this library is the read side of those four maps - the union, the lookup
/// by code, and the coverage line - the way `mos_civilian.dart` is the read
/// side of the O*NET crosswalk. A screen should not import a slice.
///
/// Three rules, the same ones the rest of the catalogue keeps:
///
///  * **The union verifies itself as it is built.** A code written in two
///    slices, a code the roster does not carry, or a union whose size is not the
///    sum of the slices is a false statement about what the app holds, and it
///    throws instead of being served. See [_unionOfSlices] for why that is a
///    `throw` and not an `assert`, and `test/mos_descriptions_test.dart` for
///    the evidence that the committed data satisfies all three.
///  * **Lookup forgives case and surrounding whitespace.** A code reaches a
///    screen from stored state and from a search field, and "68w" is the same
///    job as "68W" - reading it as "no description" would be a different fact
///    from the one that is true.
///  * **An undescribed code returns null, never a guess.** A missing description
///    renders as nothing, which is honest; an invented one is the failure the
///    provenance model exists to prevent. Today the four slices cover all 156
///    codes, and [MosDescriptions.coverageLine] is where that stops being
///    invisible.
library;

import '../models/mos.dart';
import 'mos_description_slice_1.dart';
import 'mos_description_slice_2.dart';
import 'mos_description_slice_3.dart';
import 'mos_description_slice_4.dart';
import 'mos_repository.dart';

/// The four slices, in the order the roster was cut: indices 0..38, 39..77,
/// 78..116 and 117..155 of the 156 roster codes sorted alphabetically.
///
/// A list rather than four inline spreads so the union below is one loop that
/// can say which slice a duplicate came from, which is the whole value of the
/// message when a duplicate turns up.
final List<Map<String, SourcedText>> _slices = <Map<String, SourcedText>>[
  mosDescriptionSlice1,
  mosDescriptionSlice2,
  mosDescriptionSlice3,
  mosDescriptionSlice4,
];

/// The four slices unioned into one map, built once on first use.
final Map<String, SourcedText> _byCode = _unionOfSlices();

/// The union of [_slices], keyed by MOS code, checked as it is built.
///
/// Three things are refused here, and they are the three ways a set of
/// hand-written slices can stop describing what this library claims it holds: a
/// code in two slices (one of the two sentences is silently lost), a code the
/// roster does not carry (a description nobody can ever be shown), and a union
/// whose size is not the sum of the slices (something was dropped on the way in
/// without either of the first two firing).
///
/// Written as a plain `throw` rather than an `assert` on purpose: asserts are
/// stripped from a release build, and this is the check that decides whether the
/// app's own description data is coherent. What a release phone would otherwise
/// show is the quiet failure - a slice's sentence silently dropped, or prose for
/// a code the catalogue does not field - so it fails loudly instead. The data is
/// static, so the cost is one pass over 156 entries the first time a sheet asks.
Map<String, SourcedText> _unionOfSlices() {
  final Set<String> rosterCodes = <String>{
    for (final Mos mos in MosRepository.all) mos.code,
  };
  final Map<String, SourcedText> union = <String, SourcedText>{};
  final Map<String, int> sliceOf = <String, int>{};
  final List<String> collisions = <String>[];
  final List<String> strays = <String>[];
  var sliceEntries = 0;

  for (var i = 0; i < _slices.length; i++) {
    final Map<String, SourcedText> slice = _slices[i];
    sliceEntries += slice.length;
    for (final MapEntry<String, SourcedText> entry in slice.entries) {
      final String code = entry.key;
      final int? earlier = sliceOf[code];
      if (earlier != null) {
        collisions.add(
          '$code is in slice $earlier and again in slice ${i + 1}',
        );
        continue;
      }
      sliceOf[code] = i + 1;
      if (!rosterCodes.contains(code)) strays.add(code);
      union[code] = entry.value;
    }
  }

  if (collisions.isNotEmpty) {
    throw StateError(
      'the description slices are not disjoint, so one sentence per code is '
      'being thrown away: ${collisions.join('; ')}',
    );
  }
  if (strays.isNotEmpty) {
    throw StateError(
      'these descriptions are keyed to codes the roster does not carry, so no '
      'candidate could ever see them: ${strays.join(', ')}',
    );
  }
  if (union.length != sliceEntries) {
    throw StateError(
      'the union holds ${union.length} descriptions but the four slices hold '
      '$sliceEntries, so at least one was dropped on the way in',
    );
  }
  return Map<String, SourcedText>.unmodifiable(union);
}

/// The plain-language description of an MOS, read by code.
///
/// Usage, in a screen or a widget:
///
///     final SourcedText? description = MosDescriptions.forMos(mos);
///     if (description != null) MosDescriptionCard(mos: mos);
///
/// The map is read-only: a description is a sourced value with a citation on
/// it. It is replaced by a data pass and a slice file, never by assignment from
/// the code that displays it.
abstract final class MosDescriptions {
  /// Every description the catalogue holds, keyed by MOS code.
  ///
  /// Unmodifiable and built once. [count] is its size, which is not the same
  /// number as the roster: a code can be carried and undescribed, and that is a
  /// fact about the source material rather than a defect.
  static Map<String, SourcedText> get all => _byCode;

  /// How many codes are described.
  static int get count => _byCode.length;

  /// The described codes, in slice order - the alphabetically sorted roster
  /// order the slices were cut in, not the order `mos_data.dart` lists them.
  static List<String> get codes => _byCode.keys.toList(growable: false);

  /// The description for [code], or null when the catalogue has none.
  ///
  /// Lookup is case-insensitive and ignores surrounding whitespace, because MOS
  /// codes reach a screen from stored state and from a search field. An empty
  /// code is null rather than a scan: nothing is keyed to it, and a search field
  /// the candidate has just cleared should cost nothing.
  static SourcedText? forCode(String code) {
    final String key = code.trim().toUpperCase();
    if (key.isEmpty) return null;
    final SourcedText? direct = _byCode[key];
    if (direct != null) return direct;
    // Belt and braces: a code stored in some other case would otherwise read as
    // "no description", which is a different fact from the one that is true.
    for (final MapEntry<String, SourcedText> entry in _byCode.entries) {
      if (entry.key.toUpperCase() == key) return entry.value;
    }
    return null;
  }

  /// True when the catalogue describes [code].
  static bool covers(String code) => forCode(code) != null;

  /// The sentence a screen renders for [code], or null when there is nothing
  /// sourced.
  static String? textFor(String code) => forCode(code)?.text;

  /// The description a screen should print for [mos], or null when there is
  /// none.
  ///
  /// [Mos.description] wins when an entry carries one: the model's own field is
  /// the more specific record of the same transcription, and a value put there
  /// deliberately should not be shadowed by the merged map. In today's catalogue
  /// every entry's field is null, so this is the map lookup.
  static SourcedText? forMos(Mos mos) => mos.description ?? forCode(mos.code);

  /// The codes this app carries that the slices describe, in roster order.
  static List<String> get describedCodes => <String>[
    for (final Mos mos in MosRepository.all)
      if (_byCode.containsKey(mos.code)) mos.code,
  ];

  /// The codes this app carries that no slice describes, in roster order.
  ///
  /// Named rather than hidden: a gap is a fact, not a silence. It is empty
  /// today, and [coverageLine] says so.
  static List<String> get omittedCodes => <String>[
    for (final Mos mos in MosRepository.all)
      if (!_byCode.containsKey(mos.code)) mos.code,
  ];

  /// How many MOS codes the app carries.
  static int get carriedCount => MosRepository.enlistedCount;

  /// How many of them are described.
  static int get describedCount => describedCodes.length;

  /// How many are not.
  static int get omittedCount => carriedCount - describedCount;

  /// One line a test, a log or a settings row can print.
  ///
  /// The authority is named because every entry in the slices cites the same
  /// page: DA Pam 611-21 chapter 10 section C, the document the aptitude gates
  /// come from too.
  static String get coverageLine {
    final int described = describedCount;
    final int carried = carriedCount;
    final String pct = carried == 0
        ? '0.0'
        : (100.0 * described / carried).toStringAsFixed(1);
    final List<String> gaps = omittedCodes;
    return 'Job descriptions (DA Pam 611-21 ch.10 sec.C): $described of '
        '$carried MOS codes described ($pct%), ${gaps.length} omitted: '
        '${gaps.isEmpty ? 'none' : gaps.join(', ')}';
  }
}
