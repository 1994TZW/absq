import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/page/setting/frequent_issuse_list.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/user.dart';
import 'package:absq/widget/display_text.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';

import 'setting_editor.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  final bool _isLoading = false;
  final numberFormatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    Setting setting = mainModel.setting!;
    if (mainModel.user == null) return Container();
    User user = mainModel.user!;

    final issuseBox = ListTile(
      title: const Text(
        "Frequent issues",
        style: TextStyle(fontSize: 16, color: primaryColor),
      ),
      onTap: () {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => FrequentIssueList()));
      },
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: LocalAppBar(
          labelKey: "setting.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
          actions: [
            user.hasSysAdmin() || user.hasAdmin()
                ? IconButton(
                    icon: const Icon(Icons.edit, color: primaryColor),
                    onPressed: () {
                      Navigator.of(context).push<void>(CupertinoPageRoute(
                          builder: (context) =>
                              SettingEditor(setting: mainModel.setting)));
                    },
                  )
                : const SizedBox()
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildSettingTile(
                  context: context,
                  text: "${setting.filterChangeLimit} L",
                  labelTextKey: "setting.filter_change_limit"),
              buildSettingTile(
                  context: context,
                  text: "${setting.calibrationVolume} L",
                  labelTextKey: "setting.calibration_volume"),
              buildSettingTile(
                  context: context,
                  text: "${setting.customerWarrantyPeriod} months",
                  labelTextKey: "setting.customer_warranty_period"),
              buildSettingTile(
                  context: context,
                  text: "${setting.vendorWarrantyPeriod} months",
                  labelTextKey: "setting.vendor_warranty_period"),
              issuseBox
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSettingTile({
  required BuildContext context,
  required String text,
  required String labelTextKey,
}) {
  return ListTile(
    dense: true,
    title: LocalText(
      context,
      labelTextKey,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
    ),
    trailing: Text(text),
  );
}
