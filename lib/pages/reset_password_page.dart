import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/pages/confirm_reset_password_page.dart';
import 'package:edu_vista_final_project/widgets/app_text_field_widget.dart';
import 'package:edu_vista_final_project/widgets/auth/reset_password_template_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  static const String id = 'ResetPassword';

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResetPasswordTemplateWidget(
      onSubmitEmail: () async {
        if (_formKey.currentState!.validate()) {
          await context.read<AuthCubit>().forgotPassword(
              emailController: _emailController, context: context);
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
              ],
            ),
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
}
