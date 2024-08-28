import 'package:edu_vista_final_project/blocs/course/course_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:edu_vista_final_project/utils/app_enums.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/course_certificate_widget.dart';
import 'package:edu_vista_final_project/widgets/course_download_widget.dart';
import 'package:edu_vista_final_project/widgets/course_lectures_widget.dart';
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
        return CourseCertificateWidget(course: widget.course);

      case CourseOptions.More:
        return const SizedBox.shrink();
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



      // if (isLoading) {
      //   return const Center(
      //     child: CircularProgressIndicator(
      //       color: ColorsUtility.mediumTeal,
      //     ),
      //   );
      // }
      // if (lectures == null || lectures!.isEmpty) {
      //   return const Center(
      //     child: Text('No Lectures Found'),
      //   );
      // } else {
      //   return GridView.builder(
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      //       childAspectRatio: 1,
      //       mainAxisSpacing: 10,
      //       crossAxisSpacing: 10,
      //     ),
      //     itemCount: lectures!.length,
      //     itemBuilder: (ctx, index) {
      //       return InkWell(
      //         onTap: () {
      //           widget.onClicked(lectures![index]);
      //           selectedLecture = lectures![index];
      //           setState(() {});
      //         },
      //         child: Card(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           color: selectedLecture?.id == lectures![index].id
      //               ? ColorsUtility.secondry
      //               : ColorsUtility.veryLightGrey,
      //           child: Padding(
      //             padding: const EdgeInsets.all(15.0),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Row(
      //                       children: [
      //                         Text(
      //                           lectures![index].title ?? 'No Title',
      //                           style: TextStyle(
      //                             fontSize: 14,
      //                             fontWeight: FontWeight.w700,
      //                             color: selectedLecture?.id ==
      //                                     lectures![index].id
      //                                 ? Colors.white
      //                                 : ColorsUtility.mediumBlack,
      //                           ),
      //                         ),
      //                         const SizedBox(
      //                           width: 3,
      //                         ),
      //                         Text(
      //                           '${lectures![index].sort}',
      //                           style: TextStyle(
      //                             fontSize: 14,
      //                             fontWeight: FontWeight.w700,
      //                             color: selectedLecture?.id ==
      //                                     lectures![index].id
      //                                 ? Colors.white
      //                                 : ColorsUtility.mediumBlack,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     Icon(
      //                       Icons.download_outlined,
      //                       color: selectedLecture?.id == lectures![index].id
      //                           ? Colors.white
      //                           : ColorsUtility.mediumBlack,
      //                     ),
      //                   ],
      //                 ),
      //                 const SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   lectures![index].description ?? 'No description',
      //                   style: TextStyle(
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w700,
      //                     color: selectedLecture?.id == lectures![index].id
      //                         ? Colors.white
      //                         : ColorsUtility.mediumBlack,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   'Lorem Ipsum is simply dummy text',
      //                   style: TextStyle(
      //                     fontSize: 12,
      //                     fontWeight: FontWeight.w300,
      //                     color: selectedLecture?.id == lectures![index].id
      //                         ? Colors.white
      //                         : ColorsUtility.mediumBlack,
      //                   ),
      //                 ),
      //                 const SizedBox(
      //                   height: 20,
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(
      //                       'Duration: ${formatDuration(lectures![index].duration ?? 0)}',
      //                       style: TextStyle(
      //                         fontSize: 12,
      //                         fontWeight: FontWeight.w300,
      //                         color:
      //                             selectedLecture?.id == lectures![index].id
      //                                 ? Colors.white
      //                                 : ColorsUtility.mediumBlack,
      //                       ),
      //                     ),
      //                     Icon(
      //                       Icons.play_circle_outline,
      //                       size: 40,
      //                       color: selectedLecture?.id == lectures![index].id
      //                           ? Colors.white
      //                           : ColorsUtility.mediumBlack,
      //                     )
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // }
