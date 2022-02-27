import 'package:absq/helper/api_helper.dart';
import 'package:absq/helper/firebase_helper.dart';
import 'package:absq/vo/about.dart';
import 'package:absq/vo/contact.dart';
import 'package:logging/logging.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/term.dart';

class CommonDataProvider {
  final log = Logger('CommonDataProvider');

  Future<void> saveContact(Contact contact) async {
    return requestAPI("/contact", "PUT",
        payload: contact.toMap(), token: await getToken());
  }

  Future<void> saveSetting(Setting setting) async {
    return requestAPI("/setting", "PUT",
        payload: setting.toMap(), token: await getToken());
  }

  Future<void> saveTerm(Term term) async {
    return requestAPI("/terms", "PUT",
        payload: term.toMap(), token: await getToken());
  }

  Future<void> saveAbout(About about) async {
    return requestAPI("/abouts", "PUT",
        payload: about.toMap(), token: await getToken());
  }

  Future<String?> getDaisyToken(String appID) async {
    try {
      var token = await requestAPI("/daisy_token", "POST",
          payload: {"app_id": appID}, token: await getToken());

      return token;
    } catch (e) {
      log.warning("getDaisyToken error:" + e.toString());
      return null;
    }
  }
}
