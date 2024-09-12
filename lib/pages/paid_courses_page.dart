import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaidCoursesPage extends StatelessWidget {
  const PaidCoursesPage({super.key});

  static const String id = 'PaidCoursesPage';

  @override
  Widget build(BuildContext context) {
    final List<Course> cartItems =
        ModalRoute.of(context)?.settings.arguments as List<Course>? ?? [];
    return BlocProvider(
      create: (context) => CartBloc()..add(LoadPaidCourses()),
      child: Scaffold(
        appBar: AppBar(
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
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorsUtility.mediumBlack,
            ),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              final paidCourses = state.cartItems;
              if (paidCourses.isEmpty) {
                return const Center(child: Text('No paid courses for you'));
              }
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final course = cartItems[index];
                  return ListTile(
                    title: Text(course.title ?? 'No Name'),
                    subtitle: Text('Price: \$${course.price}'),
                  );
                },
              );
            }else if (state is CartLoadingFailed) {
              return const Center(child: Text('Failed to load paid courses'));
            } else {
              return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }
}
