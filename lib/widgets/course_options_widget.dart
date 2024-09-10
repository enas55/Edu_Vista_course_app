import 'package:edu_vista_final_project/blocs/course/course_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:edu_vista_final_project/utils/app_enums.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/course_certificate_widget.dart';
import 'package:edu_vista_final_project/widgets/course_download_widget.dart';
import 'package:edu_vista_final_project/widgets/course_lectures_widget.dart';
import 'package:edu_vista_final_project/widgets/course_more_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseOptionsWidget extends StatefulWidget {
  const CourseOptionsWidget({
    super.key,
    required this.courseOption,
    required this.course,
    required this.onClicked,
  });
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onClicked;

  @override
  State<CourseOptionsWidget> createState() => _CourseOptionsWidgetState();
}

class _CourseOptionsWidgetState extends State<CourseOptionsWidget> {
  // Lecture? selectedLecture;
  List<Lecture>? lectures;
  bool isLoading = false;
  // int selectedIndex = 0;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200), () async {});
    if (!mounted) return;
    lectures = await context.read<CourseBloc>().getLectures();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = false;
      });
    });

    // if (selectedIndex < lectures!.length - 1) {
    //   widget.onClicked(lectures![selectedIndex]);
    //   selectedLecture = lectures![selectedIndex];
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorsUtility.mediumTeal,
            ),
          );
        } else {
          return CourseLectureWidget(
            lectures: lectures,
            onClicked: widget.onClicked,
          );
        }

      case CourseOptions.Download:
        return CourseDownloadWidget(
          lectures: lectures,
        );

      case CourseOptions.Certificate:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showCourseCertificateDialog(context, widget.course);
        });
        return const SizedBox.shrink();

      case CourseOptions.More:
        return CourseMoreWidget(
          course: widget.course,
        );
      default:
        return Text('InvalidOption : ${widget.courseOption.name}');
    }
  }
}

String formatDuration(int? durationInSeconds) {
  final Duration duration = Duration(seconds: durationInSeconds ?? 0);
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '$hours hr : $minutes min';
  } else {
    return '$minutes min';
  }
}

void _showCourseCertificateDialog(context, Course course) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CourseCertificateWidget(course: course);
    },
  );
}
