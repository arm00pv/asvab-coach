import '../data/bank/question_bank.dart';
import '../data/models/exam.dart';
import '../data/models/exam_snapshot.dart';

/// Rebuilds a runnable [Exam] from a persisted [ExamSnapshot].
///
/// Everything is resolved by id against the current [QuestionBank] and every
/// invariant is checked, because this data has been through a file on the
/// device: a snapshot that no longer matches the bank must be refused, never
/// silently replaced with different questions.
abstract final class ExamRestore {
  static Exam? examOf(ExamSnapshot snapshot) {
    if (snapshot.isEmpty) return null;
    final sections = <ExamSection>[];
    for (final section in snapshot.sections) {
      final served = <ServedQuestion>[];
      for (var i = 0; i < section.questionIds.length; i++) {
        final question = QuestionBank.byId(section.questionIds[i]);
        if (question == null) return null;
        if (!_isValidOrder(section.orders[i], question.choices.length)) {
          return null;
        }
        served.add(ServedQuestion(base: question, order: section.orders[i]));
      }
      if (served.isEmpty) return null;
      sections.add(
        ExamSection(
          subtest: section.subtest,
          questions: served,
          minutes: section.minutes,
          label: section.label,
        ),
      );
    }
    return Exam(
      id: snapshot.examId,
      kind: snapshot.kind,
      sections: sections,
      title: snapshot.title,
    );
  }

  /// True when [order] is a permutation of 0..[length]-1.
  static bool _isValidOrder(List<int> order, int length) {
    if (order.length != length) return false;
    final seen = List<bool>.filled(length, false);
    for (final index in order) {
      if (index < 0 || index >= length) return false;
      if (seen[index]) return false;
      seen[index] = true;
    }
    return true;
  }
}
