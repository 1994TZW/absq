import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/localization/app_translations.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';

class DisplayText extends StatelessWidget {
  final String? text;
  final String? labelTextKey;
  final IconData? iconData;
  final int maxLines;
  final bool withBorder;
  final Widget? icon;
  final Widget? textWidget;
  final bool rightAlign;

  const DisplayText({
    Key? key,
    this.text,
    this.textWidget,
    this.labelTextKey,
    this.iconData,
    this.maxLines = 1,
    this.withBorder = false,
    this.icon,
    this.rightAlign = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var languageModel = Provider.of<LanguageModel>(context);

    var labelStyle = languageModel.isEng
        ? const TextStyle(
            color: Colors.black54,
          )
        : const TextStyle(color: Colors.black54, fontFamily: "Pyidaungsu");
    var textStyle = languageModel.isEng
        ? const TextStyle(
            color: primaryColor,
          )
        : const TextStyle(color: primaryColor, fontFamily: "Pyidaungsu");

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Row(
        children: [
          iconData != null && icon != null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                      left: .0, right: 15.0, top: 8.0, bottom: 8.0),
                  child: iconData == null
                      ? icon ?? Container()
                      : Icon(
                          iconData,
                          color: primaryColor,
                        ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: rightAlign
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                labelTextKey == null
                    ? Container()
                    : Text(
                        AppTranslations.of(context).text(labelTextKey!),
                        style: labelStyle,
                      ),
                textWidget != null
                    ? textWidget!
                    : text == null
                        ? Container()
                        : Text(
                            text!,
                            style: textStyle,
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
