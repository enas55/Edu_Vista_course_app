import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatefulWidget {
  const AppElevatedButton({super.key, this.onPressed, required this.title});
  final void Function()? onPressed;
  final String title;
  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
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
      child: Text(widget.title),
    );
  }
}
