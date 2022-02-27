import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  Locale locale;
  static Map<dynamic, dynamic>? _localisedValues;

  AppTranslations(this.locale);

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);
    String jsonContent = await rootBundle
        .loadString("assets/local/localization_${locale.languageCode}.json");
    _localisedValues = json.decode(jsonContent);
    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key, {List<String>? translationVariables}) {
    String? value = _localisedValues![key];
    if (value == null) {
      return "$key not found";
    }
    if (translationVariables != null) {
      translationVariables.asMap().forEach((i, s) {
        value = value!.replaceAll("{$i}", s);
      });
    }
    return value!;
  }
}
