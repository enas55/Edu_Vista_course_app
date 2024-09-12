import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/pages/course_datails_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class CoursesWidget extends StatelessWidget {

  const CoursesWidget(
      {this.rankValue,
      super.key,
      required this.futureCall,
      });


  final String? rankValue;
  final Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  
  

  
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
            child: Text('No courses found'),
          );
        }

        var courses = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: courses.length,
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
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                            courses[index].image ?? 'No Image Found',
                          ),
                          fit: BoxFit.fill,
                        ),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            return FutureBuilder(
                              future: context
                                  .read<CartBloc>()
                                  .isCourseInCart(courses[index]),
                              builder: (context, snapshot) {
                                var isInCart = snapshot.data ?? false;
                                return TextButton(
                                  onPressed: isInCart
                                      ? null
                                      : () {
                                          context
                                              .read<CartBloc>()
                                              .add(AddToCart(courses[index]));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${courses[index].title} added to cart'),
                                            ),
                                          );
                                        },
                                  child: Text(
                                    isInCart ? 'Added' : 'Add to cart',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
