import 'package:edu_vista_final_project/utils/app_enums.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class LectureChipsWidget extends StatefulWidget {
  const LectureChipsWidget({
    super.key,
    this.selectedChip,
    required this.onChanged,
  });
  final CourseOptions? selectedChip;
  final void Function(CourseOptions) onChanged;

  @override
  State<LectureChipsWidget> createState() => _LectureChipsWidgetState();
}

class _LectureChipsWidgetState extends State<LectureChipsWidget> {
  List<CourseOptions> chips = [
    CourseOptions.Lecture,
    CourseOptions.Download,
    CourseOptions.Certificate,
    CourseOptions.More
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: chips.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.onChanged(chips[index]);
            },
            child: _ChipWidget(
              isSelected: chips[index] == widget.selectedChip,
              label: chips[index].name,
            ),
          );
        },
      ),
    );
  }
}

class _ChipWidget extends StatelessWidget {
  const _ChipWidget({
    required this.isSelected,
    required this.label,
  });
  final bool isSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : ColorsUtility.mediumBlack,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor:
          isSelected ? ColorsUtility.secondry : ColorsUtility.veryLightGrey,
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.all(8),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
    );
  }
}
