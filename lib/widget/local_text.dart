import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/localization/app_translations.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';

class LocalText extends Text {
  final BuildContext context;
  LocalText(this.context, String translationKey,
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      List<String>? translationVariables,
      String? text,
      bool underline = false})
      : super(
            text ??
                AppTranslations.of(context).text(translationKey,
                    translationVariables: translationVariables),
            style: Provider.of<LanguageModel>(context, listen: false).isEng
                ? newLabelStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    underline: underline)
                : newLabelStyleMM(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    underline: underline));
}

class LocalLargeTitle extends Text {
  final BuildContext context;
  LocalLargeTitle(
    this.context,
    String translationKey, {
    Color? color,
    List<String>? translationVariables,
  }) : super(
            AppTranslations.of(context).text(translationKey,
                translationVariables: translationVariables),
            style: Provider.of<LanguageModel>(context).isEng
                ? TextStyle(color: color)
                : TextStyle(color: color, fontFamily: "Pyidaungsu"));
}

class TextLocalStyle extends Text {
  final BuildContext context;
  TextLocalStyle(this.context, String text,
      {Color? color, double? fontSize, FontWeight? fontWeight})
      : super(text,
            style: Provider.of<LanguageModel>(context).isEng
                ? TextStyle(
                    color: color, fontSize: fontSize, fontWeight: fontWeight)
                : TextStyle(
                    color: color,
                    fontFamily: "Pyidaungsu",
                    fontSize: fontSize,
                    fontWeight: fontWeight));
}
