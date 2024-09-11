import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/pages/cart_page.dart';
import 'package:edu_vista_final_project/pages/see_all_categories_page.dart';
import 'package:edu_vista_final_project/pages/see_all_courses_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/categories_widget.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:edu_vista_final_project/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageContentWidget extends StatefulWidget {
  const HomePageContentWidget({
    super.key,
  });

  @override
  State<HomePageContentWidget> createState() => _HomePageContentWidgetState();
}

class _HomePageContentWidgetState extends State<HomePageContentWidget> {
  @override
  void initState() {
    context.read<AuthCubit>().checkUserStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is NewUser) {
                        return const Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      } else if (state is OldUser) {
                        return const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName
                            ?.toUpperCase() ??
                        'User'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorsUtility.mediumTeal),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  CartPage.id,
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                LabelWidget(
                  name: 'Categories',
                  onSeeAllClicked: () {
                    Navigator.pushNamed(context, SeeAllCategoriesPage.id);
                  },
                ),
                const CategoriesWidget(),
                const SizedBox(
                  height: 20,
                ),
                LabelWidget(
                  name: 'Top Rated',
                  onSeeAllClicked: () {
                    Navigator.pushNamed(
                      context,
                      SeeAllCoursesPage.id,
                      arguments: 'top rated',
                    );
                  },
                ),
                CoursesWidget(
                  futureCall: FirebaseFirestore.instance
                      .collection('courses')
                      .where('rank', isEqualTo: 'top rated')
                      .orderBy('created_date', descending: true)
                      .get(),
                  rankValue: 'top rated',
                ),
                const SizedBox(
                  height: 20,
                ),
                LabelWidget(
                  name: 'Top Seller',
                  onSeeAllClicked: () {
                    Navigator.pushNamed(
                      context,
                      SeeAllCoursesPage.id,
                      arguments: 'top seller',
                    );
                  },
                ),
                CoursesWidget(
                  futureCall: FirebaseFirestore.instance
                      .collection('courses')
                      .where('rank', isEqualTo: 'top seller')
                      .orderBy('created_date', descending: true)
                      .get(),
                  rankValue: 'top seller',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
