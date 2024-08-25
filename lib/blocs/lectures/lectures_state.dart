part of 'lectures_bloc.dart';

@immutable
sealed class LecturesState {}

final class LecturesInitial extends LecturesState {}

class LectureState extends LecturesState {}

class LectureChosenState extends LecturesState {
  final Lecture? lecture;

  LectureChosenState(this.lecture);
}
