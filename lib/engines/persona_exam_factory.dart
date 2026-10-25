import '../data/models/exam.dart';
import 'exam_builder.dart';

/// Indirection so the persona harness can build a full mock without the UI
/// layer importing screens. Kept separate purely to keep the dependency graph
/// clean and testable.
abstract final class PersonaExamFactory {
  static Exam fullMock({int seed = 20260101}) =>
      ExamBuilder.fullMock(seed: seed);

  static Exam diagnostic({int seed = 20260101}) =>
      ExamBuilder.diagnostic(seed: seed);
}
