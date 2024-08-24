part of 'course_bloc.dart';

@immutable
sealed class CourseEvent {}

class GetCourseEvent extends CourseEvent {
  final Course course;

  GetCourseEvent(this.course);
}

class GetCourseOptionEvent extends CourseEvent {
  final CourseOptions courseOption;

  GetCourseOptionEvent(this.courseOption);
}

class LectureChosenEvent extends CourseEvent {
  final Lecture? lecture;

  LectureChosenEvent(this.lecture);
}
