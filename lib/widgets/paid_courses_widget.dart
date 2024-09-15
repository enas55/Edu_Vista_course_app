import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/pages/course_datails_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class PaidCoursesWidget extends StatelessWidget {
  const PaidCoursesWidget({super.key, required this.paidCourses});
  final List<Course> paidCourses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: paidCourses.length,
        itemBuilder: (context, index) {
          var rate = paidCourses[index].rating;
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                CourseDatailsPage.id,
                arguments: paidCourses[index],
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
                        paidCourses[index].image ?? 'No Image Found',
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
                  paidCourses[index].title ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        // context
                        //     .read<CartBloc>()
                        //     .add(DeletePaidCourse(paidCourses[index]));

                        var shouldDelete = await _onDeleteCourse(context);

                        if (shouldDelete == true) {
                          if (context.mounted) {
                            context
                                .read<CartBloc>()
                                .add(DeletePaidCourse(paidCourses[index]));
                          }
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _onDeleteCourse(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
    return shouldDelete;
  }
}
