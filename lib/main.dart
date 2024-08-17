import 'package:edu_vista_final_project/pages/home_page.dart';
import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:edu_vista_final_project/pages/onboarding_slider_page.dart';
import 'package:edu_vista_final_project/pages/reset_password_page.dart';
import 'package:edu_vista_final_project/pages/sign_up_page.dart';
import 'package:edu_vista_final_project/pages/splash_page.dart';
import 'package:edu_vista_final_project/services/pref_service.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsUtility.scaffoldBackground,
        fontFamily: 'PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsUtility.mediumTeal),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final Map? data = settings.arguments as Map?;
        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case SignUpPage.id:
            return MaterialPageRoute(builder: (context) => const SignUpPage());
          case ResetPasswordPage.id:
            return MaterialPageRoute(
                builder: (context) => const ResetPasswordPage());
          case OnboardingSliderPage.id:
            return MaterialPageRoute(
                builder: (context) => const OnboardingSliderPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => const HomePage());
          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      initialRoute: SplashPage.id,
    );
  }
}
