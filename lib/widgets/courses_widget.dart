import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/pages/course_datails_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

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
        .where('rank', isEqualTo: widget.rankValue)
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

        return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: courses.length,
            // scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var rate = courses[index].rating;
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CourseDatailsPage.id,
                    arguments: courses[index],
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        courses[index].image ?? 'No Image',
                        height: 105,
                        width: 170,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            '${rate ?? 'No rank'}',
                            style: const TextStyle(
                              color: ColorsUtility.grey,
                              fontSize: 11.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: PannableRatingBar(
                              rate: rate ?? 0,
                              items: List.generate(
                                  5,
                                  (index) => const RatingWidget(
                                        selectedColor: ColorsUtility.mediumTeal,
                                        unSelectedColor: ColorsUtility.grey,
                                        child: Icon(
                                          Icons.star,
                                          size: 10,
                                        ),
                                      )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      courses[index].title ?? 'No Title',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person_2_outlined),
                        Text(
                          courses[index].instructor?.name ?? 'No name',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      child: Text(
                        '\$${courses[index].price ?? 'Not found'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: ColorsUtility.mediumTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

 // GridView.count(
    //   mainAxisSpacing: 15,
    //   crossAxisSpacing: 15,
    //   shrinkWrap: true,
    //   crossAxisCount: 2,
    //   children: List.generate(courses.length, (index) {
    //     var rate = courses[index].rating;
    //     return InkWell(
    //       onTap: () {
    //         Navigator.pushNamed(
    //           context,
    //           CourseDatailsPage.id,
    //           arguments: courses[index],
    //         );
    //       },
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //             ),
    //             child: Image.network(
    //               courses[index].image ?? 'No Image',
    //               height: 105,
    //               width: 170,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(
    //               top: 5,
    //             ),
    //             child: Row(
    //               children: [
    //                 Text(
    //                   '${rate ?? 'No rank'}',
    //                   style: const TextStyle(
    //                     color: ColorsUtility.grey,
    //                     fontSize: 11.4,
    //                     fontWeight: FontWeight.w700,
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   width: 3,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 3),
    //                   child: PannableRatingBar(
    //                     rate: rate ?? 0,
    //                     items: List.generate(
    //                         5,
    //                         (index) => const RatingWidget(
    //                               selectedColor: ColorsUtility.mediumTeal,
    //                               unSelectedColor: ColorsUtility.grey,
    //                               child: Icon(
    //                                 Icons.star,
    //                                 size: 11.4,
    //                               ),
    //                             )),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //           Text(
    //             courses[index].title ?? 'No title',
    //             style: const TextStyle(
    //               fontSize: 15,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Row(
    //             children: [
    //               const Icon(Icons.person_2_outlined),
    //               Text(
    //                 courses[index].instructor?.name ?? 'No name',
    //                 style: const TextStyle(
    //                   fontSize: 14,
    //                   fontWeight: FontWeight.w400,
    //                 ),
    //               )
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(
    //               left: 5,
    //             ),
    //             child: Text(
    //               '\$${courses[index].price ?? 'Not found'}',
    //               style: const TextStyle(
    //                 fontSize: 17.54,
    //                 fontWeight: FontWeight.w800,
    //                 color: ColorsUtility.mediumTeal,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   }),
    // );
