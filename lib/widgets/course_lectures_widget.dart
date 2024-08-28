import 'package:edu_vista_final_project/widgets/course_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';

class CourseLectureWidget extends StatefulWidget {
  const CourseLectureWidget({
    super.key,
    required this.lectures,
    required this.onClicked,
  });
  final List<Lecture>? lectures;
  final void Function(Lecture) onClicked;

  @override
  State<CourseLectureWidget> createState() => _CourseLectureWidgetState();
}

class _CourseLectureWidgetState extends State<CourseLectureWidget> {
  Lecture? selectedLecture;
  bool isLoading = false;
  int selectedIndex = 0;

  @override
  void initState() {
    if (selectedIndex < widget.lectures!.length - 1) {
      widget.onClicked(widget.lectures![selectedIndex]);
      selectedLecture = widget.lectures![selectedIndex];
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lectures == null || widget.lectures!.isEmpty) {
      return const Center(
        child: Text('No Lectures Found'),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: widget.lectures!.length,
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () {
            widget.onClicked(widget.lectures![index]);
            setState(() {
              selectedLecture = widget.lectures![index];
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: selectedLecture?.id == widget.lectures![index].id
                ? ColorsUtility.secondry
                : ColorsUtility.veryLightGrey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.lectures![index].title ?? 'No Title',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: selectedLecture?.id ==
                                      widget.lectures![index].id
                                  ? Colors.white
                                  : ColorsUtility.mediumBlack,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${widget.lectures![index].sort}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: selectedLecture?.id ==
                                      widget.lectures![index].id
                                  ? Colors.white
                                  : ColorsUtility.mediumBlack,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.download_outlined,
                        color: selectedLecture?.id == widget.lectures![index].id
                            ? Colors.white
                            : ColorsUtility.mediumBlack,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.lectures![index].description ?? 'No description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selectedLecture?.id == widget.lectures![index].id
                          ? Colors.white
                          : ColorsUtility.mediumBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Lorem Ipsum is simply dummy text',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: selectedLecture?.id == widget.lectures![index].id
                          ? Colors.white
                          : ColorsUtility.mediumBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Duration: ${formatDuration(widget.lectures![index].duration ?? 0)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color:
                              selectedLecture?.id == widget.lectures![index].id
                                  ? Colors.white
                                  : ColorsUtility.mediumBlack,
                        ),
                      ),
                      Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: selectedLecture?.id == widget.lectures![index].id
                            ? Colors.white
                            : ColorsUtility.mediumBlack,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
