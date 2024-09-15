part of 'course_bloc.dart';

@immutable
sealed class CourseState {}

final class CourseInitial extends CourseState {}

final class OnSelectedCourseOptionState extends CourseState {
  final CourseOptions courseOption;

  OnSelectedCourseOptionState(this.courseOption);
}

