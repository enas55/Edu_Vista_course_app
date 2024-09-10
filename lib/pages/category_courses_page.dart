import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:flutter/material.dart';

class CategoryCoursesPage extends StatelessWidget {
  const CategoryCoursesPage({
    super.key,
    required this.categoryName,
  });
  final String categoryName;

  static const String id = 'CategoryCoursesPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: Text('$categoryName Courses'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorsUtility.mediumTeal,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CoursesWidget(
          futureCall: FirebaseFirestore.instance
              .collection('courses')
              .where('category.name', isEqualTo: categoryName)
              .get(),
        ),
      ),
    );
  }
}
