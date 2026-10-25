/// One question in the spaced-repetition queue.
///
/// A study app that lets you forget everything you got wrong is only half a
/// coach. Every missed or flagged question is scheduled here, and the interval
/// it comes back at grows with each successful retrieval, which is the
/// best-evidenced study technique there is: spaced retrieval practice.
class ReviewItem {
  const ReviewItem({
    required this.questionId,
    required this.dueAt,
    this.streak = 0,
    this.lastSeenAt,
    this.timesMissed = 1,
  });

  final String questionId;

  /// When this question should next be attempted.
  final DateTime dueAt;

  /// Consecutive successful reviews. Drives the next interval.
  final int streak;

  final DateTime? lastSeenAt;

  /// How many attempts have got this wrong, for triage.
  final int timesMissed;

  /// Retrieval intervals in days, indexed by streak.
  static const List<int> intervals = <int>[1, 3, 7, 21];

  /// After this many consecutive correct retrievals the question graduates and
  /// leaves the queue.
  static const int graduationStreak = 4;

  bool isDue(DateTime now) => !dueAt.isAfter(now);

  int get nextIntervalDays => intervals[streak.clamp(0, intervals.length - 1)];

  ReviewItem answeredCorrectly(DateTime now) {
    final nextStreak = streak + 1;
    return ReviewItem(
      questionId: questionId,
      dueAt: now.add(
        Duration(days: intervals[nextStreak.clamp(0, intervals.length - 1)]),
      ),
      streak: nextStreak,
      lastSeenAt: now,
      timesMissed: timesMissed,
    );
  }

  ReviewItem answeredWrong(DateTime now) => ReviewItem(
    questionId: questionId,
    dueAt: now.add(Duration(days: intervals.first)),
    streak: 0,
    lastSeenAt: now,
    timesMissed: timesMissed + 1,
  );

  bool get graduated => streak >= graduationStreak;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'q': questionId,
    'due': dueAt.toIso8601String(),
    's': streak,
    'seen': lastSeenAt?.toIso8601String(),
    'miss': timesMissed,
  };

  static ReviewItem? fromJson(Map<String, dynamic> j) {
    final id = j['q'] as String?;
    final due = DateTime.tryParse((j['due'] as String?) ?? '');
    if (id == null || due == null) return null;
    final seen = DateTime.tryParse((j['seen'] as String?) ?? '');
    return ReviewItem(
      questionId: id,
      dueAt: due,
      streak: (j['s'] as num?)?.toInt() ?? 0,
      lastSeenAt: seen,
      timesMissed: (j['miss'] as num?)?.toInt() ?? 1,
    );
  }
}
