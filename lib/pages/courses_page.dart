import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/pages/cart_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/utils/images_utility.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _showAllCourses = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: const Text(
          'Courses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartPage.id);
                },
                icon: const Icon(Icons.shopping_cart_outlined)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _showAllCourses = !_showAllCourses;
                    setState(() {});
                  },
                  child: const Chip(
                    label: Text('All'),
                    backgroundColor: ColorsUtility.veryLightGrey,
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: CircleBorder(
                      side: BorderSide(color: ColorsUtility.veryLightGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: _showAllCourses
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CoursesWidget(
                      futureCall: FirebaseFirestore.instance
                          .collection('courses')
                          .orderBy('created_date', descending: true)
                          .get(),
                    ),
                  )
                : Image.asset(
                    ImageUtility.frame,
                  ),
          ),
        ],
      ),
    );
  }
}
