import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/models/category.dart';
import 'package:edu_vista_final_project/pages/category_courses_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_expansion_tile_widget.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:flutter/material.dart';

class SeeAllCategoriesPage extends StatelessWidget {
  const SeeAllCategoriesPage({
    super.key,
  });

  static const String id = 'SeeAllCategoriesPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: const Center(
          child: Text(
            'Categories',
            style: TextStyle(
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
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('categories').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                log('Error fetching categories: ${snapshot.error}');
                return const Center(
                  child: Text('Error occurred'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No categories found'),
                );
              }

              var categories = List<Category>.from(snapshot.data?.docs
                      .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
                      .toList() ??
                  []);

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppExpansionTileWidget(
                        title: categories[index].name ?? 'No Name',
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    CategoryCoursesPage.id,
                                    arguments: categories[index].name,
                                  );
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CoursesWidget(
                            futureCall: FirebaseFirestore.instance
                                .collection('courses')
                                .where('category.id',
                                    isEqualTo: categories[index].id)
                                .get(),
                          ),
                        ],
                      ));
                },
              );
            }),
      ),
    );
  }
}
