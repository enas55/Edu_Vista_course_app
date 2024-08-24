import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:edu_vista_final_project/utils/app_enums.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('courses')
                .doc(widget.course.id)
                .collection('lectures')
                .orderBy('sort', descending: false)
                .get(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error occurred'),
                );
              }

              if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
                return const Center(
                  child: Text('No lectures found'),
                );
              }

              var lectures = List<Lecture>.from(snapshot.data?.docs
                      .map((e) => Lecture.fromJson({'id': e.id, ...e.data()}))
                      .toList() ??
                  []);

              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: lectures.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () => widget.onClicked(lectures[index]),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: ColorsUtility.veryLightGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        lectures[index].title ?? 'No Title',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        '${lectures[index].sort}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.download_outlined),
                                  ),
                                ],
                              ),
                              Text(
                                lectures[index].description ?? 'No description',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Lorem Ipsum is simply dummy text',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Duration: ${formatDuration(lectures[index].duration ?? 0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.play_circle_outline,
                                    size: 35,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            });
      case CourseOptions.Download:
        return const SizedBox.shrink();
      case CourseOptions.Certificate:
        return const SizedBox.shrink();
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
