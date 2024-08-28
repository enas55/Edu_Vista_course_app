import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  }

  Course? course;

  Future<List<Lecture>?> getLectures() async {
    if (course == null) {
      return null;
    }
    try {
      var result = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course!.id)
          .collection('lectures')
          .orderBy("sort", descending: false)
          .get();

      return result.docs
          .map((e) => Lecture.fromJson({
                'id': e.id,
                ...e.data(),
              }))
          .toList();
    } catch (e) {
      return null;
    }
  }

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
}
