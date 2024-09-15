import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/pages/home_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/paid_courses_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaidCoursesPage extends StatelessWidget {
  const PaidCoursesPage({super.key, required this.paidCourses});
  final List<Course> paidCourses;

  static const String id = 'PaidCoursesPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(LoadPaidCourses()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUtility.scaffoldBackground,
          title: const Text(
            'Your Courses',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, HomePage.id);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorsUtility.mediumTeal,
            ),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is PaidCoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PaidCoursesLoaded) {
              if (state.paidCourses.isEmpty) {
                return const Center(child: Text('No courses found'));
              } else {
                return PaidCoursesWidget(paidCourses: state.paidCourses);
              }
            } else if (state is PaidCoursesFailed) {
              return Center(
                  child: Text('Failed to load courses: ${state.error}'));
            }
            return const Center(child: Text('No paid courses found'));
          },
        ),
      ),
    );
  }
}
