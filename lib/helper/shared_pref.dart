import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absq/vo/background_msg.dart';
import 'package:absq/vo/user.dart';

final log = Logger('SharedPref');

class SharedPref {
  static final SharedPref instance = SharedPref._();
  SharedPref._();

  static Future<bool?> isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('first_launch');
  }

  static Future<bool> finishFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('first_launch', false);
  }

  static Future<String?> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }

  static Future<void> saveLang(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', lang);
  }

  static Future<bool?> getStaffMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('staff_mode_on');
  }

  static Future<void> saveStaffMode(bool staffMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('staff_mode_on', staffMode);
  }

  static Future<void> saveUser(User user) async {
    await _save("user", user.toJson());
  }

  static Future<User?> getUser() async {
    try {
      return User.fromJson(await _read("user"));
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveBackgroundMsg(BackgroundMsg msg) async {
    await _save("background_msg", msg.toJson());
  }

  static Future<BackgroundMsg?> getBackgroundMsg() async {
    try {
      return BackgroundMsg.fromJson(await _read("background_msg"));
    } catch (e) {
      return null;
    }
  }

  static Future<void> removeBackgroundMsg() async {
    return await _remove("background_msg");
  }

  static Future<User> removeUser() async {
    return await _remove("user");
  }

  static Future<void> saveSkippedRecoverEmail(bool skipped) async {
    await _save("skipped_recovery_email", skipped);
  }

  static Future<bool?> getSkippedRecoverEmail() async {
    try {
      bool _skipped = await _read("skipped_recovery_email");
      return _skipped;
    } catch (e) {
      return null;
    }
  }

  static _read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return json.decode(prefs.getString(key) ?? "{}");
    } catch (e) {
      log.info("Error:$e");
    }
  }

  static _save(String key, value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, json.encode(value));
    } catch (e) {
      log.info("Error:$e");
    }
  }

  static _remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
