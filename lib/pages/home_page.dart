import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/categories_widget.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:edu_vista_final_project/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${FirebaseAuth.instance.currentUser?.displayName}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorsUtility.mediumTeal),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              LabelWidget(
                name: 'Categories',
                onSeeAllClicked: () {},
              ),
              const CategoriesWidget(),
              const SizedBox(
                height: 20,
              ),
              LabelWidget(
                name: 'Top Rated Courses',
                onSeeAllClicked: () {},
              ),
              const CoursesWidget(
                rankValue: 'top rated',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
