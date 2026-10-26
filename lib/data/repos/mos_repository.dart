import '../models/career_field.dart';
import '../models/catalog.dart';
import '../models/line_score.dart';
import '../models/mos.dart';
import 'mos_data.dart';

/// Access to the MOS catalogue and the officer pathways.
abstract final class MosRepository {
  static List<Mos> get all => allMos;

  static List<Mos> byCategory(String category) =>
      allMos.where((m) => m.category == category).toList(growable: false);

  static Mos? byCode(String code) {
    for (final m in allMos) {
      if (m.code.toUpperCase() == code.toUpperCase()) return m;
    }
    return null;
  }

  static List<Mos> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where(
          (m) =>
              m.code.toLowerCase().contains(q) ||
              m.title.toLowerCase().contains(q) ||
              m.category.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  static List<String> get categories {
    final present = all.map((m) => m.category).toSet();
    return MosCategory.ordered.where(present.contains).toList(growable: false);
  }

  /// Officer and warrant officer pathways, all of which hinge on the GT score.
  static List<OfficerPathway> get officerPathways => officerPathwaysData;

  /// The career fields the catalogue actually covers, in code order.
  static List<CareerField> get careerFields {
    final present = <String>{
      for (final m in allMos) ?CareerField.of(m)?.prefix,
    };
    return CareerField.all
        .where((f) => present.contains(f.prefix))
        .toList(growable: false);
  }

  /// Everything in one career field, e.g. all medical MOS for prefix "68".
  static List<Mos> byCareerField(String prefix) => allMos
      .where((m) => CareerField.of(m)?.prefix == prefix)
      .toList(growable: false);

  /// The commissioning routes grouped by how they are taken.
  static List<OfficerTrack> get officerTracks {
    final present = <String>{
      for (final p in officerPathwaysData) ?OfficerTrack.of(p)?.id,
    };
    return OfficerTrack.all
        .where((t) => present.contains(t.id))
        .toList(growable: false);
  }

  static List<OfficerPathway> officerPathwaysFor(OfficerTrack track) =>
      officerPathwaysData
          .where((p) => OfficerTrack.of(p)?.id == track.id)
          .toList(growable: false);

  /// MOS that require a security clearance.
  static List<Mos> get clearanceRequired =>
      all.where((m) => m.securityClearance).toList(growable: false);

  /// MOS that require an additional selection test beyond the ASVAB.
  static List<Mos> get extraTestRequired =>
      all.where((m) => m.extraTest != null).toList(growable: false);
}

/// Parses a compact gate string into an [AptitudeGate].
///
/// '|' separates OR alternatives, '&' separates ANDed requirements inside one
/// alternative, and every requirement is 'ABBR MIN':
///   _g('CO 87|ST 88')      -> CO >= 87, or ST >= 88
///   _g('OF 105&ST 95')     -> OF >= 105 AND ST >= 95
AptitudeGate g(String spec) {
  final alternatives = <List<LineScoreRequirement>>[];
  if (spec.trim().isEmpty) {
    return const AptitudeGate(<List<LineScoreRequirement>>[]);
  }
  for (final alt in spec.split('|')) {
    final parts = <LineScoreRequirement>[];
    for (final req in alt.split('&')) {
      final bits = req.trim().split(RegExp(r'\s+'));
      if (bits.length != 2) {
        throw FormatException('Bad gate requirement: "$req"');
      }
      final score = lineScoreByAbbr(bits[0]);
      parts.add(LineScoreRequirement(score, int.parse(bits[1])));
    }
    alternatives.add(parts);
  }
  return AptitudeGate(alternatives);
}

/// Looks a line score up by its two-letter abbreviation.
LineScore lineScoreByAbbr(String abbr) {
  final upper = abbr.toUpperCase();
  for (final ls in LineScore.values) {
    if (ls.abbr == upper) return ls;
  }
  throw ArgumentError('Unknown line score: $abbr');
}
