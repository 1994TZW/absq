import 'setting.dart';

class About {
  String? aboutEng;
  String? aboutMm;

  About({this.aboutEng, this.aboutMm});

  factory About.fromSetting(Setting setting) {
    return About(aboutEng: setting.aboutEng, aboutMm: setting.aboutMm);
  }

  Map<String, dynamic> toMap() {
    return {
      'about_eng': aboutEng,
      'about_mm': aboutMm,
    };
  }

  @override
  String toString() {
    return 'About{about_eng:$aboutEng}';
  }
}
