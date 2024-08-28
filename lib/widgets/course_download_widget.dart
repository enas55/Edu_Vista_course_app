import 'package:edu_vista_final_project/models/lecture.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/course_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDownloadWidget extends StatelessWidget {
  const CourseDownloadWidget({super.key, this.lectures});

  final List<Lecture>? lectures;

  @override
  Widget build(BuildContext context) {
    if (lectures == null || lectures!.isEmpty) {
      return const Center(
        child: Text('No Downloaded Lectures'),
      );
    } else {
      return ListView.builder(
        itemCount: lectures!.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Row(
              children: [
                Text(
                  lectures![index].title ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorsUtility.mediumBlack,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  '${lectures![index].sort}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorsUtility.mediumBlack,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Duration: ${formatDuration(lectures![index].duration ?? 0)}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () {
                _launchLectureURL(
                    lectures![index].lecture_url ?? 'No URL Found');
              },
            ),
          );
        },
      );
    }
  }
}

void _launchLectureURL(String url) async {
  final Uri lectureUrl = Uri.parse(url);
  if (await canLaunchUrl(lectureUrl)) {
    await launchUrl(lectureUrl);
  } else {
    throw 'Could not launch $lectureUrl';
  }
}
