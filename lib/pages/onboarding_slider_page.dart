import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:edu_vista_final_project/services/pref_service.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/utils/images_utility.dart';
import 'package:edu_vista_final_project/widgets/app_elevated_button.dart';
import 'package:edu_vista_final_project/widgets/page_view_widget_items.dart';
import 'package:flutter/material.dart';

class OnboardingSliderPage extends StatefulWidget {
  const OnboardingSliderPage({super.key});
  static const String id = 'OnBoardingSlider';

  @override
  State<OnboardingSliderPage> createState() => _OnboardingSliderPageState();
}

class _OnboardingSliderPageState extends State<OnboardingSliderPage> {
  var pageViewController = PageController();
  int currentPage = 0;
  int pagesNum = 4;

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        actions: [
          TextButton(
            onPressed: () {
              // if (currentPage < pagesNum - 1) {
              //   pageViewController.nextPage(
              //     duration: const Duration(seconds: 1),
              //     curve: Curves.easeIn,
              //   );
              // }
              currentPage == 3
                  ? pageViewController.jumpToPage(0)
                  : pageViewController.jumpToPage(pagesNum - 1);
            },
            child: Text(
              currentPage == 3 ? 'Back' : 'Skip',
              style: const TextStyle(
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
          Expanded(
            flex: 3,
            child: PageView(
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
                  subTitle:
                      'Earn a certificate after completion of every course',
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              children: List.generate(pagesNum, (index) {
                return Container(
                  width: currentPage == index ? 40 : 20,
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(128),
                    shape: BoxShape.rectangle,
                    color: currentPage == index
                        ? ColorsUtility.secondry
                        : ColorsUtility.mediumBlack,
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: currentPage == 3
                ? AppElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => onLogin(),
                  )
                : Row(
                    mainAxisAlignment: currentPage == 0
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentPage > 0)
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: ColorsUtility.lightGrey,
                          child: IconButton(
                            onPressed: () {
                              pageViewController.previousPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: ColorsUtility.scaffoldBackground,
                              size: 30,
                            ),
                          ),
                        ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: ColorsUtility.secondry,
                        child: IconButton(
                          onPressed: () {
                            if (currentPage < pagesNum - 1) {
                              pageViewController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: ColorsUtility.scaffoldBackground,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  void onLogin() {
    PrefService.isOnBoardingSeen = true;
    Navigator.pushReplacementNamed(context, LoginPage.id);
  }
}
