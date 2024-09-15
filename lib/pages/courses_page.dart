import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/pages/cart_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:edu_vista_final_project/widgets/paid_courses_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _showAllCourses = true;

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
                    _showAllCourses = true;
                    setState(() {});
                  },
                  child: Chip(
                    label: Text(
                      'All',
                      style: TextStyle(
                        color: _showAllCourses
                            ? Colors.white
                            : ColorsUtility.mediumBlack,
                      ),
                    ),
                    backgroundColor: _showAllCourses
                        ? ColorsUtility.secondry
                        : ColorsUtility.veryLightGrey,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: ColorsUtility.veryLightGrey,
                      ),
                    ),
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      _showAllCourses = false;

                      context.read<CartBloc>().add(LoadPaidCourses());

                      setState(() {});
                    },
                    child: Chip(
                      label: Text(
                        'Your Courses',
                        style: TextStyle(
                          color: !_showAllCourses
                              ? Colors.white
                              : ColorsUtility.mediumBlack,
                        ),
                      ),
                      backgroundColor: !_showAllCourses
                          ? ColorsUtility.secondry
                          : ColorsUtility.veryLightGrey,
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        side: BorderSide(
                          color: ColorsUtility.veryLightGrey,
                        ),
                      ),
                    ),
                  );
                }),
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
                : BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is PaidCoursesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PaidCoursesLoaded) {
                        if (state.paidCourses.isEmpty) {
                          return const Center(child: Text('No courses found'));
                        } else {
                          return PaidCoursesWidget(
                              paidCourses: state.paidCourses);
                        }
                      } else if (state is PaidCoursesFailed) {
                        return Center(
                            child: Text(
                                'Failed to load paid courses: ${state.error}'));
                      }
                      return const Center(child: Text('No paid courses found'));
                    },
                  ),

            //  Image.asset(
            //     ImageUtility.frame,
            //   ),
          ),
        ],
      ),
    );
  }
}
