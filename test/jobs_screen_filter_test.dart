import 'package:asvab_guard_coach/core/theme/app_theme.dart';
import 'package:asvab_guard_coach/data/repos/mos_repository.dart';
import 'package:asvab_guard_coach/screens/jobs_screen.dart';
import 'package:asvab_guard_coach/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The job screen's filter bar, at the widths it has to work at.
///
/// What each filter selects is unit-tested against the catalogue in
/// jobs_filter_test; this is the guard that the bar renders, offers all three
/// types, and overflows nowhere.
Future<void> launch(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final state = AppState();
  await state.init();
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: AppTheme.build(Brightness.light),
        home: const JobsScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  for (final size in <Size>[const Size(390, 1400), const Size(800, 1280)]) {
    testWidgets('the filter bar renders at width ${size.width.toInt()}', (
      tester,
    ) async {
      await launch(tester, size);

      expect(tester.takeException(), isNull);
      expect(find.text('Every type'), findsOneWidget);
      expect(find.textContaining('Enlisted ('), findsOneWidget);
      expect(find.textContaining('Officer & warrant'), findsOneWidget);
      expect(find.text('All fields'), findsOneWidget);
      expect(find.text('Becoming an officer'), findsOneWidget);
      expect(MosRepository.careerFields, isNotEmpty);
      expect(MosRepository.officerTracks, isNotEmpty);
    });
  }
}
