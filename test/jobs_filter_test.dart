import 'package:asvab_guard_coach/data/models/career_field.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Filtering the job catalogue.
///
/// The value of a filter is that nothing falls through it. These tests hold
/// three promises: every job belongs to exactly one career field, every
/// commissioning route belongs to exactly one track, and a filter never invents
/// or loses a job.
void main() {
  group('career fields', () {
    test('every MOS maps to a field', () {
      final unclassified = <String>[
        for (final m in MosRepository.all)
          if (CareerField.of(m) == null) '${m.code} ${m.title}',
      ];
      expect(
        unclassified,
        isEmpty,
        reason:
            'these jobs have no career field, so no filter could ever show '
            'them: ${unclassified.join(", ")}',
      );
    });

    test('the field catalogue and the field list agree', () {
      final prefixes = <String>{
        for (final m in MosRepository.all) m.code.substring(0, 2),
      };
      final declared = <String>{for (final f in CareerField.all) f.prefix};
      expect(
        prefixes.difference(declared),
        isEmpty,
        reason: 'a job uses a prefix that CareerField does not name',
      );
      // The reference table may name codes this catalogue has no job for yet.
      // What must never appear is an empty *filter*, so that is asserted on the
      // list the UI actually offers.
      for (final field in MosRepository.careerFields) {
        expect(
          MosRepository.byCareerField(field.prefix),
          isNotEmpty,
          reason: '${field.label} would show as an empty filter',
        );
      }
    });

    test('fields partition the catalogue', () {
      var total = 0;
      for (final field in MosRepository.careerFields) {
        final jobs = MosRepository.byCareerField(field.prefix);
        expect(jobs, isNotEmpty, reason: '${field.label} is empty');
        for (final job in jobs) {
          expect(CareerField.of(job)?.prefix, field.prefix);
        }
        total += jobs.length;
      }
      expect(total, MosRepository.all.length);
    });

    test('a known code lands in the field a soldier would expect', () {
      expect(CareerField.of(MosRepository.byCode('68W')!)?.label, 'Medical');
      expect(CareerField.of(MosRepository.byCode('25U')!)?.label, 'Signal');
      expect(CareerField.of(MosRepository.byCode('12B')!)?.label, 'Engineer');
      expect(CareerField.ofCode('11B')?.label, 'Infantry');
      // An unnumbered specialty is not classified rather than misclassified.
      expect(CareerField.ofCode('X1'), isNull);
      expect(CareerField.ofCode(''), isNull);
    });
  });

  group('officer routes', () {
    test('every pathway belongs to a track', () {
      final orphans = <String>[
        for (final p in MosRepository.officerPathways)
          if (OfficerTrack.of(p) == null) '${p.id} ${p.title}',
      ];
      expect(
        orphans,
        isEmpty,
        reason:
            'these commissioning routes have no track, so the officer filter '
            'would hide them: ${orphans.join(", ")}',
      );
    });

    test('tracks partition the pathways', () {
      var total = 0;
      for (final track in MosRepository.officerTracks) {
        final routes = MosRepository.officerPathwaysFor(track);
        expect(routes, isNotEmpty, reason: '${track.label} is empty');
        total += routes.length;
      }
      expect(total, MosRepository.officerPathways.length);
    });

    test('the warrant routes are not filed as officer candidate school', () {
      // The two are different commitments: WOCS commissions a specialist who
      // stays technical, OCS commissions a conventional officer.
      final warrant = MosRepository.officerPathwaysFor(OfficerTrack.warrant);
      expect(warrant.map((p) => p.id), containsAll(<String>['wocs', 'woft']));
      final ocs = MosRepository.officerPathwaysFor(OfficerTrack.ocs);
      expect(ocs.map((p) => p.id), containsAll(<String>['ocs', 'arng-ocs']));
    });
  });

  group('search and filters compose', () {
    test('a field filter narrows without losing the search', () {
      final medical = MosRepository.byCareerField('68');
      expect(medical.length, greaterThan(3));
      final searched = MosRepository.search('medic')
          .where((m) => CareerField.of(m)?.prefix == '68')
          .toList();
      expect(searched, isNotEmpty);
      expect(searched.every((m) => CareerField.of(m)?.prefix == '68'), isTrue);
    });

    test('an unknown search returns nothing rather than everything', () {
      expect(MosRepository.search('zzzz-nothing'), isEmpty);
    });

    test('an empty search returns the whole catalogue', () {
      expect(MosRepository.search('   ').length, MosRepository.all.length);
    });
  });
}
