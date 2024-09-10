import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class AppExpansionTileWidget extends StatefulWidget {
  const AppExpansionTileWidget({
    super.key,
    this.course,
    required this.title,
    required this.children,
  });
  final Course? course;
  final String title;
  final List<Widget> children;

  @override
  State<AppExpansionTileWidget> createState() => _AppExpansionTileWidgetState();
}

class _AppExpansionTileWidgetState extends State<AppExpansionTileWidget> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) {
        isExpanded = value;
        setState(() {});
      },
      collapsedBackgroundColor: ColorsUtility.veryLightGrey,
      backgroundColor: ColorsUtility.scaffoldBackground,
      textColor: ColorsUtility.secondry,
      iconColor: ColorsUtility.secondry,
      shape: const BeveledRectangleBorder(),
      collapsedShape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        isExpanded
            ? Icons.keyboard_double_arrow_down_outlined
            : Icons.double_arrow_outlined,
      ),
      childrenPadding: const EdgeInsets.all(20),
      children: widget.children,
    );
  }
}
