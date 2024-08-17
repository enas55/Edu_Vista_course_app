import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:edu_vista_final_project/pages/sign_up_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';

class AuthTemplateWidget extends StatelessWidget {
  AuthTemplateWidget({
    super.key,
    this.onLogin,
    this.onSignUp,
    required this.body,
  }) {
    assert(
      onLogin != null || onSignUp != null,
      'onLogin or onSignUp should not be null',
    );
  }
  final void Function()? onLogin;
  final void Function()? onSignUp;
  final Widget body;

  bool get isLogin => onLogin != null;

  String get title => isLogin ? 'Login' : 'Sign Up';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 100,
              ),
              body,
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
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
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AppElevatedButton(
                  title: title,
                  onPressed: () {
                    isLogin ? onLogin! : onSignUp!;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: ColorsUtility.grey,
                    ),
                  ),
                  Text(
                    'Or Sign In With',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: ColorsUtility.grey,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton.icon(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      fixedSize: WidgetStatePropertyAll(
                        Size(250, 46),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    label: const Text(
                      'Sign In With Facebook',
                    ),
                    icon: const Icon(
                      Icons.facebook,
                    ),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 82,
                        height: 46,
                        decoration: BoxDecoration(
                            color: ColorsUtility.scaffoldBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsUtility.lightGrey)),
                        child: Image.asset(
                          'assets/images/google_logo.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? 'Don\'t have an account?'
                        : 'Already have an account?',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        isLogin ? SignUpPage.id : LoginPage.id,
                      );
                    },
                    child: Text(
                      isLogin ? 'Sign Up Here' : 'Login Here',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: ColorsUtility.secondry),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
