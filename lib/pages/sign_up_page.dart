import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_text_field_widget.dart';
import 'package:edu_vista_final_project/widgets/auth/auth_template_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String id = 'SignUp';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onSignUp: () async {
        await context.read<AuthCubit>().signUp(
            context: context,
            emailController: _emailController,
            nameController: _nameController,
            passwordController: _passwordController);
      },
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFieldWidget(
                  title: 'Full Name',
                  controller: _nameController,
                  hint: 'Muhammed Rafey',
                  validator: _nameValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFieldWidget(
                  title: 'Email',
                  controller: _emailController,
                  hint: 'demo@mail.com',
                  validator: _emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
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
                  validator: (value) => _confirmPasswordValidator(
                      value, _passwordController.text),
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

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }

    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter a valid name';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.trim().split(' ').length < 2) {
      return 'Please enter your first and last name';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
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
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
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
