import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/categories_widget.dart';
import 'package:edu_vista_final_project/widgets/courses_widget.dart';
import 'package:edu_vista_final_project/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool isNewUser = false;

  int _currentIndex = 0;

  @override
  void initState() {
    context.read<AuthCubit>().checkUserStatus();
    super.initState();
  }

  // Future<void> _checkUserStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool? firstLogin = prefs.getBool('first_login');

  //   if (firstLogin == null || firstLogin == true) {
  //     isNewUser = true;
  //     setState(() {});
  //     await prefs.setBool('first_login', false);
  //   }
  // }

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
          child: SingleChildScrollView(
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
                const SizedBox(
                  height: 20,
                ),
                LabelWidget(
                  name: 'Top Seller Courses',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(
                  rankValue: 'top seller',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        selectedItemColor: ColorsUtility.secondry,
        unselectedItemColor: ColorsUtility.mediumBlack,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
