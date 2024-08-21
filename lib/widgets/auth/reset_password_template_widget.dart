import 'package:edu_vista_final_project/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';

class ResetPasswordTemplateWidget extends StatefulWidget {
  ResetPasswordTemplateWidget({
    super.key,
    this.onSubmitEmail,
    this.onSubmitpassword,
    required this.body,
  }) {
    assert(
      onSubmitEmail != null || onSubmitpassword != null,
      'onSubmitEmail or onSubmitpassword should not be null',
    );
  }
  final Future<void> Function()? onSubmitEmail;
  final Future<void> Function()? onSubmitpassword;
  final Widget body;

  @override
  State<ResetPasswordTemplateWidget> createState() =>
      _ResetPasswordTemplateWidgetState();
}

class _ResetPasswordTemplateWidgetState
    extends State<ResetPasswordTemplateWidget> {
  bool get isEmailSubmitted => widget.onSubmitEmail != null;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 100,
                ),
                widget.body,
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AppElevatedButton(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Submit'),
                    onPressed: () async {
                      if (isEmailSubmitted) {
                        setState(() {
                          _isLoading = true;
                        });
                        setState(() {
                          _isLoading = false;
                        });
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        await widget.onSubmitpassword?.call();
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
