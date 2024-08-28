import 'package:edu_vista_final_project/blocs/course/course_bloc.dart';
import 'package:edu_vista_final_project/blocs/lectures/lectures_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/course_options_widget.dart';
import 'package:edu_vista_final_project/widgets/lecture_chips_widget.dart';
import 'package:edu_vista_final_project/widgets/video_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool applyChanges = false;

  @override
  void initState() {
    context.read<CourseBloc>().add(
          GetCourseEvent(widget.course),
        );
    context.read<LecturesBloc>().add(LectureEventInitial());
    super.initState();
  }

  void initAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        applyChanges = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    initAnimation();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LecturesBloc, LecturesState>(builder: (ctx, state) {
            var stateEx = state is LectureChosenState ? state : null;

            if (stateEx == null) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              height: 250,
              child: stateEx.lecture!.lecture_url == null ||
                      stateEx.lecture!.lecture_url == ''
                  ? const Center(
                      child: Text(
                      'No Video Found',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))
                  : VideoBoxWidget(
                      url: stateEx.lecture!.lecture_url ?? '',
                    ),
            );
          }),

          // BlocBuilder<LecturesBloc, LecturesState>(
          //   builder: (context, state) {
          //     if (state is LectureChosenState) {
          //       return Container(
          //         height: 250,
          //         // color: Colors.red,
          //         child: VideoBoxWidget(
          //           url: state.lecture!.lecture_url ?? '',
          //         ),
          //       );
          //     }
          //     {
          //       return const Center(
          //         child: Text(
          //           'Begin your Course',
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       );
          //     }
          //   },
          // ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              height:
                  applyChanges ? MediaQuery.sizeOf(context).height - 220 : null,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              duration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
              curve: Curves.easeInOut,
              child: BlocBuilder<LecturesBloc, LecturesState>(
                buildWhen: (previous, current) => current is LectureState,
                builder: (context, state) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Wrap(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: ColorsUtility.mediumBlack,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.course.title ?? 'No Title',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
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
                                            GetCourseOptionEvent(
                                                courseOptions));
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

                                                context
                                                    .read<LecturesBloc>()
                                                    .add(
                                                      LectureChosenEvent(
                                                          lecture),
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
            ),
          ),
        ],
      ),
    );
  }
}
