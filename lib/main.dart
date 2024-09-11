import 'dart:developer';
import 'package:edu_vista_final_project/blocs/cart/cart_bloc.dart';
import 'package:edu_vista_final_project/blocs/course/course_bloc.dart';
import 'package:edu_vista_final_project/blocs/lectures/lectures_bloc.dart';
import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/firebase_options.dart';
import 'package:edu_vista_final_project/pages/cart_page.dart';
import 'package:edu_vista_final_project/pages/category_courses_page.dart';
import 'package:edu_vista_final_project/pages/course_datails_page.dart';
import 'package:edu_vista_final_project/pages/home_page.dart';
import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:edu_vista_final_project/pages/onboarding_slider_page.dart';
import 'package:edu_vista_final_project/pages/payment_method_page.dart';
import 'package:edu_vista_final_project/pages/reset_password_page.dart';
import 'package:edu_vista_final_project/pages/see_all_categories_page.dart';
import 'package:edu_vista_final_project/pages/see_all_courses_page.dart';
import 'package:edu_vista_final_project/pages/sign_up_page.dart';
import 'package:edu_vista_final_project/pages/splash_page.dart';
import 'package:edu_vista_final_project/services/pref_service.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('Failed to initialize firebase : $e');
  }
  await dotenv.load(fileName: ".env");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (ctx) => AuthCubit(),
      ),
      BlocProvider(
        create: (ctx) => CourseBloc(),
      ),
      BlocProvider(
        create: (ctx) => LecturesBloc(),
      ),
      BlocProvider(
        create: (context) => CartBloc(),
      ),
    ],
    child: DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
        final dynamic data = settings.arguments;
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
          case CourseDatailsPage.id:
            return MaterialPageRoute(
                builder: (context) => CourseDatailsPage(
                      course: data,
                    ));
          case SeeAllCategoriesPage.id:
            return MaterialPageRoute(
                builder: (context) => const SeeAllCategoriesPage());
          case CartPage.id:
            return MaterialPageRoute(builder: (context) => const CartPage());
          case PaymentMethodPage.id:
            return MaterialPageRoute(
                builder: (context) => const PaymentMethodPage());
          case SeeAllCoursesPage.id:
            if (data is String) {
              return MaterialPageRoute(
                builder: (context) => SeeAllCoursesPage(
                  rankValue: data,
                ),
              );
            } else {
              return null;
            }
          case CategoryCoursesPage.id:
            return MaterialPageRoute(
                builder: (context) => CategoryCoursesPage(
                      categoryName: data,
                    ));
          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      initialRoute: SplashPage.id,
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
