import 'dart:ui';

typedef void LocaleChangeCallback(Locale locale);

class Translation {
  static final Translation _translation = Translation._internal();

  factory Translation() {
    return _translation;
  }

  Translation._internal();

  final List<String> supportedLanguages = [
    "English",
    "မြန်မာ ",
  ];

  final List<String> supportedLanguagesCodes = ["en", "mu"];
  static Locale defaultLocale = const Locale("en");

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback? onLocaleChanged;
}
