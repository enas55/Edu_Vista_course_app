import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class PageViewWidgetItems extends StatelessWidget {
  const PageViewWidgetItems({
    required this.imagePath,
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String imagePath;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 200,
          width: 400,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          subTitle,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: ColorsUtility.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
