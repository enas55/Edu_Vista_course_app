import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });
  final void Function()? onPressed;
  // final String title;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(ColorsUtility.secondry),
        foregroundColor:
            WidgetStatePropertyAll(ColorsUtility.scaffoldBackground),
        fixedSize: WidgetStatePropertyAll(
          Size(316, 57),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 18),
        ),
      ),
      child: child,
    );
  }
}
