import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('home'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
              child: Text('go'),
            ),
          ],
        ),
      ),
    );
  }
}
