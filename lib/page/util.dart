import 'package:absq/vo/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:absq/model/main_model.dart';

import '../constants.dart';
import '../helper/localization/app_translations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/theme.dart';
import '../model/language_model.dart';
import '../widget/local_text.dart';

heroTransition(BuildContext context, Widget page,
    {int durationMilliSec = 1000}) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: durationMilliSec),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Align(
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}

heroTransitionPush(BuildContext context, Widget page,
    {int durationMilliSec = 300}) async {
  await Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: durationMilliSec),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Align(
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    ),
  );
}

Future<void> showMsgDialog(
    BuildContext context, String title, String msg) async {
  await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(msg),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showConfirmDialog(
    BuildContext context, String translationKey, ok(),
    {List<String>? translationVariables}) async {
  await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: LocalText(
              context,
              translationKey,
              translationVariables: translationVariables,
              color: primaryColor,
            ),
          ),
          content: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    child: Text(
                      AppTranslations.of(context).text('btn.cancel'),
                      style: Provider.of<LanguageModel>(context).isEng
                          ? const TextStyle()
                          : const TextStyle(fontFamily: 'Pyidaungsu'),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    color: primaryColor,
                    child: Text(AppTranslations.of(context).text('btn.ok'),
                        style: Provider.of<LanguageModel>(context).isEng
                            ? const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)
                            : const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pyidaungsu')),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await ok();
                    })
              ],
            ),
          ),
        );
      });
}

call(BuildContext context, String phone) {
  showConfirmDialog(context, "contact.phone.confim", () => launch("tel:$phone"),
      translationVariables: ["$phone"]);
}

String getLocalString(BuildContext context, String key,
    {List<String>? translationVaraibles}) {
  return AppTranslations.of(context)
      .text(key, translationVariables: translationVaraibles);
}

Widget getStatus(String status) {
  return status == supportPendingStatus
      ? Text(status,
          style: const TextStyle(
              color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold))
      : status == supportStartStatus
          ? Text(
              status,
              style: const TextStyle(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          : status == supportEndStatus
              ? Text(
                  status,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                )
              : status == supportAckStatus
                  ? Text(
                      status,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  : status == "Servicing Start"
                      ? Text(
                          status,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      : status == "Servicing End"
                          ? Text(
                              status,
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          : status == supportClosedStatus
                              ? Text(
                                  status,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              : status == "Approved"
                                  ? Text(
                                      status,
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : status == "Pending Calibration"
                                      ? Text(
                                          status,
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : status == "Calibrated"
                                          ? Text(
                                              status,
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : status == "Pending Filter Change"
                                              ? Text(
                                                  status,
                                                  style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Text(
                                                  status,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                );
}

double scale(double input, double min, double max, double inMin, double inMax) {
  double percent = (input - inMin) / (inMax - inMin);
  return percent * (max - min) + min;
}

getInt(dynamic val) {
  return (val is int)
      ? val
      : (val is String)
          ? int.tryParse(val)
          : 0;
}

getDouble(dynamic val) {
  return (val is double)
      ? val
      : (val is int)
          ? double.tryParse(val.toString())
          : (val is String)
              ? double.tryParse(val)
              : 0.0;
}

getBool(dynamic val) {
  return (val is bool)
      ? val
      : (val is String)
          ? (val == 'true')
          : false;
}

var numberFormatter = NumberFormat("#,###");

String currency(BuildContext context, double? amt) {
  Setting? setting = Provider.of<MainModel>(context).setting;
  if (setting == null) return "";
  if (amt == null) return "${setting.currencySymbol} 0";
  return "${setting.currencySymbol} ${numberFormatter.format(amt)}";
}

var dateFormatter = DateFormat('dd MMM yyyy');
String date(DateTime? dateTime) {
  if (dateTime == null) return "";
  return dateFormatter.format(dateTime);
}
