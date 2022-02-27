import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:absq/data/common_data_provider.dart';
import 'package:absq/vo/about.dart';
import 'package:absq/vo/contact.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/term.dart';

import 'common_service.dart';

class CommonServiceImp implements CommonService {
  CommonServiceImp({
    this.connectivity,
    required this.commonDataProvider,
  });

  final Connectivity? connectivity;
  final CommonDataProvider commonDataProvider;

  @override
  Future<void> updateContact(Contact contact) {
    return commonDataProvider.saveContact(contact);
  }

  @override
  Future<void> saveSetting(Setting setting) {
    return commonDataProvider.saveSetting(setting);
  }

  @override
  Future<void> saveTerm(Term term) {
    return commonDataProvider.saveTerm(term);
  }

  @override
  Future<void> saveAbout(About about) {
    return commonDataProvider.saveAbout(about);
  }

  @override
  Future<String?> getDaisyToken(String appID) async {
    return commonDataProvider.getDaisyToken(appID);
  }
}
