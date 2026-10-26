import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/exam.dart';
import '../data/models/exam_snapshot.dart';
import '../data/models/score.dart';
import '../data/repos/mos_repository.dart';
import '../screens/exam_screen.dart';
import '../screens/glossary_screen.dart';
import '../screens/lesson_screen.dart';
import '../screens/recruiter_sheet_screen.dart';
import '../screens/review_screen.dart';
import '../screens/results_screen.dart';
import '../screens/settings_screen.dart';
import '../state/app_state.dart';

/// Thin routing helpers so screens can navigate without hard-coding page
/// transitions in a dozen places.
abstract final class AppRoutes {
  static Future<T?> _push<T>(BuildContext context, Widget page) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  static Future<void> exam(BuildContext context, Exam exam) =>
      _push<void>(context, ExamScreen(exam: exam));

  /// Carries on an attempt that was interrupted, at the question it stopped on.
  static Future<void> resumeExam(
    BuildContext context,
    Exam exam,
    ExamSnapshot snapshot,
  ) => _push<void>(context, ExamScreen(exam: exam, snapshot: snapshot));

  static Future<void> results(BuildContext context, Attempt attempt) =>
      _push<void>(context, ResultsScreen(attempt: attempt));

  /// Replaces the current route with the report.
  ///
  /// The runner submits from inside its own route, so the report has to replace
  /// it. Pushing the report on top instead left the back button pointing at the
  /// runner's exit screen, which is a spinner no longer connected to anything:
  /// the candidate finished the exam, read the report, pressed back, and landed
  /// on a blank screen.
  static Future<void> resultsReplacing(BuildContext context, Attempt attempt) =>
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => ResultsScreen(attempt: attempt),
        ),
      );

  static Future<void> review(BuildContext context, Attempt attempt) =>
      _push<void>(context, ReviewScreen(attempt: attempt));

  /// The recruiter-ready page for [attempt] (ROADMAP Phase 4).
  ///
  /// Everything the page prints is passed in here, including the date and the
  /// catalogue, so the screen itself reads no clock, no repository and no
  /// state - which is what makes the page reproducible in a test.
  static Future<void> recruiterSheet(BuildContext context, Attempt attempt) =>
      _push<void>(
        context,
        RecruiterSheetScreen(
          report: attempt.report,
          jobs: MosRepository.all,
          generatedOn: DateTime.now(),
          candidateName: context.read<AppState>().goal?.displayName,
        ),
      );

  static Future<void> lesson(BuildContext context, String skillId) =>
      _push<void>(context, LessonScreen(skillId: skillId));

  static Future<void> settings(BuildContext context) =>
      _push<void>(context, const SettingsScreen());

  /// The plain-language explanation of every abbreviation the app prints.
  static Future<void> glossary(BuildContext context) =>
      _push<void>(context, const GlossaryScreen());
}

/// Convenience access to the shared app state.
AppState get appState => throw UnsupportedError('Use context.read<AppState>()');

extension AppStateX on BuildContext {
  AppState get app => read<AppState>();
}
