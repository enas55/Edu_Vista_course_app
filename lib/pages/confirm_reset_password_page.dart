import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_text_field_widget.dart';
import 'package:edu_vista_final_project/widgets/auth/reset_password_template_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmResetPasswordPage extends StatefulWidget {
  const ConfirmResetPasswordPage({super.key});
  static const String id = 'ConfirmResetPassword';

  @override
  State<ConfirmResetPasswordPage> createState() =>
      _ConfirmResetPasswordPageState();
}

class _ConfirmResetPasswordPageState extends State<ConfirmResetPasswordPage> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResetPasswordTemplateWidget(
      onSubmitpassword: () async {
        if (_formKey.currentState!.validate()) {
          await context.read<AuthCubit>().confirmPassword(
                email: _emailController.text,
                newPassword: _passwordController.text,
                context: context,
              );
        }
      },
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFieldWidget(
                  title: 'Password',
                  controller: _passwordController,
                  hint: '*********',
                  validator: _passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: _suffixonIconWidget(
                    isVisible: _isPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  obscureText: _isPasswordVisible,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFieldWidget(
                  title: 'Confirm Password',
                  controller: _confirmPasswordController,
                  hint: '*********',
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: _suffixonIconWidget(
                    isVisible: _isConfirmPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  obscureText: _isConfirmPasswordVisible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Password must include both letters and numbers';
    } else if (_passwordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget? _suffixonIconWidget({
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return IconButton(
      onPressed: toggleVisibility,
      icon: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: ColorsUtility.grey,
      ),
    );
  }
}
