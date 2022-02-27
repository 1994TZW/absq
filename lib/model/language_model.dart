import 'package:flutter/painting.dart';
import 'package:absq/helper/localization/transalation.dart';
import 'package:absq/helper/shared_pref.dart';

import 'base_model.dart';

class LanguageModel extends BaseModel {
  late String language;
  bool get isEng => language == languagesList[0];
  List<bool> get currentState => isEng ? [true, false] : [false, true];

  static final List<String> languageCodesList =
      Translation().supportedLanguagesCodes;
  static final List<String> languagesList = Translation().supportedLanguages;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };
  LanguageModel() {
    load();
  }
  @override
  logout() async {}

  Future<String> load() async {
    var data = await SharedPref.getLang();
    String result = languagesList[0]; // defalut to english
    if (data != null) {
      result = data;
    }
    language = result;
    Translation().onLocaleChanged!(Locale(languagesMap[language]));
    notifyListeners();
    return result;
  }

  void saveLanguage(String language) async {
    Translation().onLocaleChanged!(Locale(languagesMap[language]));

    SharedPref.saveLang(language);
    this.language = language;
    notifyListeners();
  }
}
