import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/localization/app_translations.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';

class InputText extends StatelessWidget {
  final String? labelTextKey;
  final IconData? iconData;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final bool withBorder;
  final TextInputType? textInputType;
  final bool autoFocus;
  final TextAlign? textAlign;
  final bool? enabled;
  final Widget? imageIcon;

  const InputText(
      {Key? key,
      this.labelTextKey,
      this.iconData,
      this.controller,
      this.validator,
      this.maxLines = 1,
      this.withBorder = false,
      this.autoFocus = false,
      this.textInputType,
      this.enabled = true,
      this.textAlign,
      this.imageIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var languageModel = Provider.of<LanguageModel>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5),
      child: TextFormField(
          enabled: enabled,
          controller: controller,
          autofocus: autoFocus,
          cursorColor: primaryColor,
          style: textStyle,
          maxLines: maxLines,
          keyboardType: textInputType,
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              height: 1.5,
            ),
            labelText: labelTextKey == null
                ? null
                : AppTranslations.of(context).text(labelTextKey!),
            labelStyle: languageModel.isEng
                ? newLabelStyle(color: Colors.black54, fontSize: 17)
                : newLabelStyleMM(color: Colors.black54, fontSize: 17),
            icon: iconData == null
                ? imageIcon == null
                    ? Container()
                    : imageIcon
                : Icon(
                    iconData,
                    color: primaryColor,
                  ),
            enabledBorder: withBorder
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0)),
            focusedBorder: withBorder
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0)),
          ),
          validator: validator),
    );
  }
}
