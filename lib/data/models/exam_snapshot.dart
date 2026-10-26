import 'catalog.dart';
import 'question.dart';
import 'score.dart';

/// One section of a persisted attempt: the bank ids the candidate was served
/// and the option order each one was shown in.
class SnapshotSection {
  const SnapshotSection({
    required this.subtest,
    required this.minutes,
    required this.questionIds,
    required this.orders,
    this.label,
  });

  final Subtest subtest;
  final int minutes;
  final String? label;
  final List<String> questionIds;

  /// order[i] is the permutation of question [i]'s options in display order.
  final List<List<int>> orders;

  int get seconds => minutes * 60;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sub': subtest.name,
    'min': minutes,
    if (label != null) 'label': label,
    'q': questionIds,
    'o': orders,
  };

  static SnapshotSection fromJson(Map<String, dynamic> j) {
    final name = j['sub'] as String;
    final subtest = Subtest.values.firstWhere((s) => s.name == name);
    final ids = <String>[for (final id in (j['q'] as List)) id as String];
    final orders = <List<int>>[
      for (final order in (j['o'] as List))
        <int>[for (final i in (order as List)) (i as num).toInt()],
    ];
    if (ids.length != orders.length) {
      throw const FormatException('section has a mismatched question count');
    }
    return SnapshotSection(
      subtest: subtest,
      minutes: (j['min'] as num).toInt(),
      label: j['label'] as String?,
      questionIds: ids,
      orders: orders,
    );
  }
}

/// A mid-attempt snapshot, written after every change so an interrupted exam
/// can be resumed instead of lost.
///
/// The whole section plan travels with it - question ids and option orders -
/// rather than a seed to rebuild from. That way resuming shows exactly the
/// questions in exactly the order and arrangement they were seen in, even if
/// the question bank has been edited since. [ExamRestore] refuses a snapshot
/// whose items no longer exist, instead of quietly serving a different exam.
class ExamSnapshot {
  const ExamSnapshot({
    required this.examId,
    required this.title,
    required this.kind,
    required this.sections,
    required this.sectionIndex,
    required this.questionIndex,
    required this.remainingSeconds,
    required this.elapsedSeconds,
    required this.startedAt,
    required this.responses,
  });

  final String examId;
  final String title;
  final ExamKind kind;
  final List<SnapshotSection> sections;

  /// Section and question the candidate was looking at.
  final int sectionIndex;
  final int questionIndex;

  /// Time left on the live section when the snapshot was taken.
  final int remainingSeconds;

  /// Whole-attempt seconds already spent.
  final int elapsedSeconds;

  final DateTime startedAt;
  final List<QuestionResponse> responses;

  /// Bumped when the on-disk shape changes, so an older file is ignored rather
  /// than misread.
  static const int version = 1;

  int get questionCount =>
      sections.fold(0, (sum, s) => sum + s.questionIds.length);

  int get answered => responses.where((r) => r.isAnswered).length;

  bool get isEmpty => sections.isEmpty || questionCount == 0;

  /// "Section 3 of 10 - question 12 of 16", for the resume card.
  String get progressLabel {
    if (sections.isEmpty) return 'No questions';
    final total = sections[sectionIndex.clamp(0, sections.length - 1)];
    return 'Section ${sectionIndex + 1} of ${sections.length} - '
        'question ${questionIndex + 1} of ${total.questionIds.length}';
  }

  String get answeredLabel => '$answered of $questionCount answered';

  Map<String, dynamic> toJson() => <String, dynamic>{
    'v': version,
    'id': examId,
    'title': title,
    'kind': kind.name,
    'sections': <Map<String, dynamic>>[for (final s in sections) s.toJson()],
    'at': sectionIndex,
    'qi': questionIndex,
    'rem': remainingSeconds,
    'el': elapsedSeconds,
    'started': startedAt.toIso8601String(),
    'r': <Map<String, dynamic>>[for (final r in responses) responseToJson(r)],
  };

  /// Returns null when the file was written by another version of the app.
  static ExamSnapshot? fromJson(Map<String, dynamic> j) {
    if ((j['v'] as num?)?.toInt() != version) return null;
    final kindName = j['kind'] as String;
    final kind = ExamKind.values.firstWhere(
      (k) => k.name == kindName,
      orElse: () => ExamKind.section,
    );
    return ExamSnapshot(
      examId: j['id'] as String,
      title: j['title'] as String? ?? 'Attempt',
      kind: kind,
      sections: <SnapshotSection>[
        for (final s in (j['sections'] as List))
          SnapshotSection.fromJson((s as Map).cast<String, dynamic>()),
      ],
      sectionIndex: (j['at'] as num?)?.toInt() ?? 0,
      questionIndex: (j['qi'] as num?)?.toInt() ?? 0,
      remainingSeconds: (j['rem'] as num?)?.toInt() ?? 0,
      elapsedSeconds: (j['el'] as num?)?.toInt() ?? 0,
      startedAt:
          DateTime.tryParse(j['started'] as String? ?? '') ?? DateTime.now(),
      responses: <QuestionResponse>[
        for (final r in (j['r'] as List? ?? const <dynamic>[]))
          responseFromJson((r as Map).cast<String, dynamic>()),
      ],
    );
  }

  static Map<String, dynamic> responseToJson(QuestionResponse r) =>
      <String, dynamic>{
        'q': r.questionId,
        's': r.selectedIndex,
        't': r.secondsSpent,
        'f': r.flagged,
      };

  static QuestionResponse responseFromJson(Map<String, dynamic> j) =>
      QuestionResponse(
        questionId: j['q'] as String,
        selectedIndex: (j['s'] as num?)?.toInt(),
        secondsSpent: (j['t'] as num?)?.toInt() ?? 0,
        flagged: (j['f'] as bool?) ?? false,
      );
}
