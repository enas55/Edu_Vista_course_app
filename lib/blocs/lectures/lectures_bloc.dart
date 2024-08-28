import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:meta/meta.dart';

part 'lectures_event.dart';
part 'lectures_state.dart';

class LecturesBloc extends Bloc<LecturesEvent, LecturesState> {
  LecturesBloc() : super(LecturesInitial()) {
    on<LectureChosenEvent>(_onLectureChosen);
    on<LectureEventInitial>((event, emit) {
      emit(LecturesInitial());
    });
  }
}

FutureOr<void> _onLectureChosen(
    LectureChosenEvent event, Emitter<LecturesState> emit) {
  emit(
    LectureChosenState(event.lecture),
  );
}
