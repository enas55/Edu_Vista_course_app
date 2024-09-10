import 'package:edu_vista_final_project/pages/courses_page.dart';
import 'package:edu_vista_final_project/pages/profile_page.dart';
import 'package:edu_vista_final_project/pages/search_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/utils/images_utility.dart';
import 'package:edu_vista_final_project/widgets/home_page_content_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  static const String id = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePageContentWidget();
      case 1:
        return const CoursesPage();
      case 2:
        return const SearchPage();
      case 3:
        return const ProfilePage();
      default:
        return const HomePageContentWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
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
          _currentIndex = index;
          setState(() {});
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            label: 'Menu',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: FirebaseAuth.instance.currentUser?.photoURL !=
                          null &&
                      FirebaseAuth.instance.currentUser!.photoURL!.isNotEmpty
                  ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                  : const AssetImage(ImageUtility.userProfile),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
