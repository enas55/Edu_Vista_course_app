import 'package:edu_vista_final_project/models/course.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseCertificateWidget extends StatelessWidget {
  const CourseCertificateWidget({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: ColorsUtility.scaffoldBackground,
      // elevation: 5,
      shadowColor: ColorsUtility.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Certificate of Completion',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 13.88,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This Certifies that',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 9.02,
                  color: ColorsUtility.semiBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${FirebaseAuth.instance.currentUser?.displayName!.toUpperCase()}',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13.88,
                  color: ColorsUtility.mediumTeal,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Has Successfully Completed the Course',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 9.02,
                  color: ColorsUtility.semiBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                course.title ?? 'No Title',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11.11,
                  color: ColorsUtility.deepPurple,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Issued on ${DateFormat('MMMM d, y').format(DateTime.now())}',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 9.02,
                  color: ColorsUtility.semiBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ID: ${course.id}',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 9.02,
                  color: ColorsUtility.deepBrown,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                course.instructor?.name ?? 'No Name',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.66,
                  color: ColorsUtility.mediumTeal,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Virginia M. Patterso',
                style: TextStyle(
                  fontFamily: 'Helena Johnsmith',
                  fontSize: 17.35,
                  color: ColorsUtility.secondry,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Virginia M. Patterso',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 11.11,
                  color: ColorsUtility.deepPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Issued on ${DateFormat('MMMM d, y').format(DateTime.now())}',
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 9.02,
                  color: ColorsUtility.semiBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
