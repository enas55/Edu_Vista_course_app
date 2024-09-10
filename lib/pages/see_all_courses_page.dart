import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:flutter/material.dart';

class SeeAllCoursesPage extends StatelessWidget {
  const SeeAllCoursesPage({
    super.key,
    required this.rankValue,
  });
  final String rankValue;

  static const String id = 'SeeAllCoursesPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: Center(
          child: Text(
            '$rankValue courses'.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CoursesWidget(
            futureCall: FirebaseFirestore.instance
                .collection('courses')
                .where('rank', isEqualTo: rankValue)
                .orderBy('created_date', descending: true)
                .get(),
            rankValue: rankValue),
      ),
    );
  }
}
