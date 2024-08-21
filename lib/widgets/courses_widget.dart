import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/pages/course_datails_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class CoursesWidget extends StatefulWidget {
  const CoursesWidget({required this.rankValue, super.key});
  final String rankValue;

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  // var futureCallex = FirebaseFirestore.instance
  //       .collection('courses')
  //       .where('rank', isEqualTo: widget.rankValue)
  //       .orderBy('created_date', descending: true)
  //       .get();
  // widget should be asserted in a life cycle so we put it in init state, otherwise it'll give us an error

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        // .where('rank', isEqualTo: widget.rankValue)
        .orderBy('created_date', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureCall,
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

          var courses = List<Course>.from(snapshot.data?.docs
                  .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                  .toList() ??
              []);

          return GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(courses.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    CourseDatailsPage.id,
                    arguments: courses[index],
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      courses[index].image ?? 'No Image',
                      fit: BoxFit.cover,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${courses[index].rating ?? 'No rank'}',
                            style: const TextStyle(
                              color: ColorsUtility.grey,
                              fontSize: 11.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      courses[index].title ?? 'No title',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.person_2_outlined),
                          Text(
                            courses[index].instructor?.name ?? 'No name',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        '\$${courses[index].price ?? 'Not found'}',
                        style: const TextStyle(
                          fontSize: 17.54,
                          fontWeight: FontWeight.w800,
                          color: ColorsUtility.mediumTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }
}
