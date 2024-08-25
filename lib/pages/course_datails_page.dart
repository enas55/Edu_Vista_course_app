import 'package:edu_vista_final_project/blocs/course/course_bloc.dart';
import 'package:edu_vista_final_project/blocs/lectures/lectures_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/widgets/course_options_widget.dart';
import 'package:edu_vista_final_project/widgets/lecture_chips_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_box/video_box.dart';

class CourseDatailsPage extends StatefulWidget {
  const CourseDatailsPage({
    super.key,
    required this.course,
  });
  final Course course;
  static const String id = 'CourseDatails';

  @override
  State<CourseDatailsPage> createState() => _CourseDatailsPageState();
}

class _CourseDatailsPageState extends State<CourseDatailsPage> {
  double? height;

  @override
  void initState() {
    context.read<CourseBloc>().add(
          GetCourseEvent(widget.course),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LecturesBloc, LecturesState>(
            builder: (context, state) {
              if (state is LectureChosenState) {
                return Container(
                  height: 250,
                  color: Colors.red,
                  child: VideoBox(
                    controller: VideoController(
                      source: VideoPlayerController.networkUrl(
                        Uri.parse(state.lecture!.lecture_url!),
                      ),
                    ),
                  ),
                );
              }
              {
                return const SizedBox();
              }
            },
          ),

          // if (state is! LectureState) return const SizedBox();
          // var stateEx = state is LectureChosenState ? state : null;

          // log('$stateEx');

          // return Container(
          //   height: 250,
          //   color: Colors.red,
          //   child: VideoBox(
          //     controller: VideoController(
          //       source: VideoPlayerController.networkUrl(
          //         Uri.parse(stateEx!.lecture.lecture_url!),
          //       ),
          //     ),
          //   ),
          // );

          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<LecturesBloc, LecturesState>(
              buildWhen: (previous, current) => current is LectureState,
              builder: (context, state) {
                // var changes = state is LectureChosenState ? true : false;
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.course.title ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.course.instructor?.name ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: BlocBuilder<CourseBloc, CourseState>(
                            builder: (cxt, state) {
                              return Column(
                                children: [
                                  LectureChipsWidget(
                                    selectedChip:
                                        (state is OnSelectedCourseOptionState)
                                            ? state.courseOption
                                            : null,
                                    onChanged: (courseOptions) {
                                      context.read<CourseBloc>().add(
                                          GetCourseOptionEvent(courseOptions));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: (state
                                            is OnSelectedCourseOptionState)
                                        ? CourseOptionsWidget(
                                            onClicked: (lecture) {
                                              // context.read<CourseBloc>().add(
                                              //     LectureChosenEvent(
                                              //         lecture));

                                              context.read<LecturesBloc>().add(
                                                    LectureChosenEvent(lecture),
                                                  );
                                            },
                                            course: context
                                                .read<CourseBloc>()
                                                .course!,
                                            courseOption: state.courseOption,
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
