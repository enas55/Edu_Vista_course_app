part of 'lectures_bloc.dart';

@immutable
sealed class LecturesEvent {}

class LectureChosenEvent extends LecturesEvent {
  final Lecture? lecture;

  LectureChosenEvent(this.lecture);
}
