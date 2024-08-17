import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefService {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      log('Prefs is created sucessfully');
    } catch (e) {
      log('Failed to initialize preferences : $e');
    }
  }

  static bool get isOnBoardingSeen =>
      prefs!.getBool('isOnBoardingSeen') ?? false;

  static set isOnBoardingSeen(bool value) =>
      prefs!.setBool('isOnBoardingSeen', value);
}
