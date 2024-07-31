import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/utils/images_utility.dart';
import 'package:edu_vista_final_project/widgets/page_view_widget_items.dart';
import 'package:flutter/material.dart';

class OnboardingSliderPage extends StatefulWidget {
  const OnboardingSliderPage({super.key});

  @override
  State<OnboardingSliderPage> createState() => _OnboardingSliderPageState();
}

class _OnboardingSliderPageState extends State<OnboardingSliderPage> {
  var pageViewController = PageController();
  int currentPage = 0;
  int pagesNum = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        actions: [
          TextButton(
            onPressed: () {
              pageViewController.jumpToPage(pagesNum - 1);
              setState(() {});
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ColorsUtility.skipColor),
            ),
          ),
        ],
      ),
      backgroundColor: ColorsUtility.scaffoldBackground,
      body: Column(
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            controller: pageViewController,
            onPageChanged: (value) {
              currentPage = value;
              setState(() {});
            },
            children: const [
              PageViewWidgetItems(
                imagePath: ImageUtility.certificate,
                title: 'Certification and Badges',
                subTitle: 'Earn a certificate after completion of every course',
              ),
              PageViewWidgetItems(
                imagePath: ImageUtility.progressTracking,
                title: 'Progress Tracking',
                subTitle: 'Check your Progress of every course',
              ),
              PageViewWidgetItems(
                imagePath: ImageUtility.offlineAccess,
                title: 'Offline Access',
                subTitle: 'Make your course available offline',
              ),
              PageViewWidgetItems(
                imagePath: ImageUtility.courseCatalog,
                title: 'Course Catalog',
                subTitle: 'View in which courses you are enrolled',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
