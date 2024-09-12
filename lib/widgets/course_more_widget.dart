import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_expansion_tile_widget.dart';
import 'package:flutter/material.dart';

class CourseMoreWidget extends StatefulWidget {
  const CourseMoreWidget({
    super.key,
    required this.course,
  });
  final Course course;

  @override
  State<CourseMoreWidget> createState() => _CourseMoreWidgetState();
}

class _CourseMoreWidgetState extends State<CourseMoreWidget> {
  bool isExpanded = false;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('courses')
        .orderBy('created_date', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppExpansionTileWidget(
          course: widget.course,
          title: 'About Instructor ',
          children: [
            ListTile(
              title: Text(
                widget.course.instructor?.name ?? 'No Title Found',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorsUtility.mediumTeal,
                ),
              ),
              subtitle: Text(
                'Years of Experience: ${widget.course.instructor?.years_of_experience ?? 'Not Found'} years',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorsUtility.mediumTeal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
