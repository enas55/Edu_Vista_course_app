import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:edu_vista_final_project/utils/app_enums.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc()
      : super(
          CourseInitial(),
        ) {
    on<GetCourseEvent>(_onGetCourse);
    on<GetCourseOptionEvent>(_onGetCourseOption);
    on<LectureChosenEvent>(_onLectureChosen);
  }

  Course? course;

  FutureOr<void> _onGetCourse(GetCourseEvent event, Emitter<CourseState> emit) {
    if (course != null) {
      course = null;
    }
    course = event.course;
    emit(
      OnSelectedCourseOptionState(CourseOptions.Lecture),
    );
  }

  FutureOr<void> _onGetCourseOption(
      GetCourseOptionEvent event, Emitter<CourseState> emit) {
    emit(
      OnSelectedCourseOptionState(event.courseOption),
    );
  }

  FutureOr<void> _onLectureChosen(
      LectureChosenEvent event, Emitter<CourseState> emit) {
    emit(
      LectureChosenState(event.lecture),
    );
  }
}
