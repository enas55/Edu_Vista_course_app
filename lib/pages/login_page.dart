import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/pages/reset_password_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_text_field_widget.dart';
import 'package:edu_vista_final_project/widgets/auth/auth_template_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = 'LogIn';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onLogin: () async {
        if (_formKey.currentState!.validate()) {
          await context.read<AuthCubit>().login(
                context: context,
                emailController: _emailController,
                passwordController: _passwordController,
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
                  controller: _emailController,
                  validator: _emailValidator,
                  title: 'Email',
                  hint: 'demo@mail.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextFieldWidget(
                  controller: _passwordController,
                  validator: _passwordValidator,
                  title: 'Password',
                  hint: '*********',
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      isVisible = !isVisible;
                      setState(() {});
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: ColorsUtility.grey,
                    ),
                  ),
                  obscureText: isVisible,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pushReplacementNamed(
                        context, ResetPasswordPage.id);
                    await context.read<AuthCubit>().forgotPassword(
                          emailController: _emailController,
                          context: context,
                        );
                  },
                  child: const Text(
                    'Forget Password ?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorsUtility.secondry,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 70,
          ),
        ],
      ),
    );
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
    return null;
  }

  void onForgetPassword(
    BuildContext context,
  ) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Enter your email',
              hintText: 'example@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await context.read<AuthCubit>().forgotPassword(
                    emailController: emailController, context: context);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Send reset link'),
            ),
          ],
        );
      },
    );
  }
}
