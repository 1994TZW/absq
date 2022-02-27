import 'package:absq/vo/about.dart';
import 'package:absq/vo/contact.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/term.dart';

abstract class CommonService {
  Future<void> updateContact(Contact contact);
  Future<void> saveSetting(Setting setting);
  Future<void> saveTerm(Term term);
  Future<void> saveAbout(About about);
  Future<String?> getDaisyToken(String appID);
}
