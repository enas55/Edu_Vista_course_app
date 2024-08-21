import 'package:edu_vista_final_project/models/course.dart';
import 'package:flutter/material.dart';

class CourseDatailsPage extends StatelessWidget {
  const CourseDatailsPage({
    super.key,
    required this.course,
  });
  final Course course;
  static const String id = 'CourseDatails';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title ?? 'Course Details',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              course.instructor?.name ?? 'No name',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
