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
  late PageController _controller;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContentWidget(),
    const CoursesPage(),
    const SearchPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    _controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
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
        onTap: _onTab,
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
