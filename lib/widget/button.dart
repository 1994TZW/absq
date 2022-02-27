import 'package:absq/helper/localization/app_translations.dart';
import 'package:absq/model/language_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef BtnCallback = Function();

/// WidgetButton is used to navigate to eash widget task
class WidgetButton extends StatelessWidget {
  final String? titleKey;
  final IconData? icon;
  final Widget? image;
  final BtnCallback? btnCallback;

  const WidgetButton(this.titleKey,
      {Key? key, this.icon, this.btnCallback, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var languageModel = Provider.of<LanguageModel>(context);
    return InkWell(
      onTap: btnCallback ?? () => {},
      child: Container(
        width: 120,
        height: 155,
        padding: const EdgeInsets.only(top: 0.0, left: 5, right: 5),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.black54, // button color
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: icon != null
                        ? Icon(icon, color: Colors.white, size: 50)
                        : image),
              ),
            ),
            Container(
              height: 45,
              alignment: Alignment.topCenter,
              child: Text(AppTranslations.of(context).text(titleKey!),
                  textAlign: TextAlign.center,
                  style: languageModel.isEng
                      ? const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          fontFamily: "Roboto")
                      : const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          fontFamily: "Myanmar3")),
            ),
          ]),
        ),
      ),
    );
  }
}
