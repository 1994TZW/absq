import 'setting.dart';

class Term {
  String? termEng;
  String? termMm;

  Term({this.termEng, this.termMm});

  factory Term.fromSetting(Setting setting) {
    return Term(termEng: setting.termsEng, termMm: setting.termsMm);
  }

  Map<String, dynamic> toMap() {
    return {
      'terms_eng': termEng,
      'terms_mm': termMm,
    };
  }

  @override
  String toString() {
    return 'Contact{terms_eng:$termEng}';
  }
}
