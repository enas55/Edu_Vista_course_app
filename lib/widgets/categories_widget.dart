import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/models/category.dart';
import 'package:edu_vista_final_project/pages/category_courses_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          }

          if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
            return const Center(
              child: Text('No categories found'),
            );
          }

          var categories = List<Category>.from(snapshot.data?.docs
                  .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CategoryCoursesPage.id,
                  arguments: categories[index].name,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorsUtility.veryLightGrey,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    categories[index].name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
