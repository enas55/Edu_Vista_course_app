import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/pages/course_datails_page.dart';
import 'package:edu_vista_final_project/pages/payment_methods_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const String id = 'CartPage';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    context.read<CartBloc>().add(LoadCart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: const Text('Your Cart'),
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
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.cartItems.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      var course = state.cartItems[index];
                      var rate = course.rating;
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            CourseDatailsPage.id,
                            arguments: course,
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
                                    course.image ?? 'No Image Found',
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
                                                selectedColor:
                                                    ColorsUtility.mediumTeal,
                                                unSelectedColor:
                                                    ColorsUtility.grey,
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
                              course.title ?? 'No Title',
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
                                  course.instructor?.name ?? 'No name',
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
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${course.price ?? 'Not found'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: ColorsUtility.mediumTeal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirm '),
                                            content: const Text(
                                                'Are you sure you want to remove this course from your cart?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context.read<CartBloc>().add(
                                                      RemoveFromCart(course));
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '\$${state.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17.54,
                                color: ColorsUtility.mediumTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, PaymentMethodsPage.id);
                        },
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text('Your cart is empty'),
          );
        },
      ),
    );
  }
}
