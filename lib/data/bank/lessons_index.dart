import '../models/lesson.dart';
import 'lessons_a.dart';
import 'lessons_b.dart';
import 'lessons_c.dart';

/// All reinforcement lessons, in one place.
///
/// Lessons are authored per skill so the coach can drop exactly the one the
/// learner needs after a diagnostic, instead of a generic "study math" page.
List<Lesson> get allLessons => <Lesson>[...lessonsA, ...lessonsB, ...lessonsC];

abstract final class LessonRepository {
  static final Map<String, Lesson> _bySkill = <String, Lesson>{
    for (final l in allLessons) l.skillId: l,
  };

  static List<Lesson> get all => allLessons;

  static Lesson? bySkill(String skillId) => _bySkill[skillId];

  static bool has(String skillId) => _bySkill.containsKey(skillId);

  static int get count => allLessons.length;
}
