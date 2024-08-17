import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget({
    super.key,
    this.controller,
    required this.hint,
    this.validator,
    required this.title,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String title;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        TextFormField(
          keyboardType: keyboardType,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hint,
            hintStyle: const TextStyle(color: ColorsUtility.grey),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorsUtility.mediumTeal),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorsUtility.lightGrey),
            ),
            constraints: const BoxConstraints(maxWidth: 316, maxHeight: 60),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
}
