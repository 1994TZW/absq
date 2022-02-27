import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/widget/input_text.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_button.dart';
import 'package:absq/widget/local_progress.dart';
import '../util.dart';

class SettingEditor extends StatefulWidget {
  final Setting? setting;
  const SettingEditor({Key? key, this.setting}) : super(key: key);

  @override
  _SettingEditorState createState() => _SettingEditorState();
}

class _SettingEditorState extends State<SettingEditor> {
  bool _isLoading = false;
  TextEditingController filterChangeLimitCtl = TextEditingController();
  TextEditingController calibrationVolumeCtl = TextEditingController();
  TextEditingController customerWarrantyCtl = TextEditingController();
  TextEditingController vendorWarrantyCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.setting != null) {
      filterChangeLimitCtl.text = widget.setting!.filterChangeLimit.toString();
      calibrationVolumeCtl.text = widget.setting!.calibrationVolume.toString();
      customerWarrantyCtl.text =
          widget.setting!.customerWarrantyPeriod.toString();
      vendorWarrantyCtl.text = widget.setting!.vendorWarrantyPeriod.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterChangeLimitBox = InputText(
        labelTextKey: 'setting.filter_change_limit',
        iconData: Icons.confirmation_number,
        controller: filterChangeLimitCtl);

    final calibrationVolumeBox = InputText(
        labelTextKey: 'setting.calibration_volume',
        iconData: Icons.confirmation_number,
        controller: calibrationVolumeCtl);

    final customerWarrantyBox = InputText(
        labelTextKey: 'setting.customer_warranty_period',
        iconData: Icons.confirmation_number,
        controller: customerWarrantyCtl);

    final vendorWarrantyBox = InputText(
        labelTextKey: 'setting.vendor_warranty_period',
        iconData: Icons.confirmation_number,
        controller: vendorWarrantyCtl);

    final updateButton = Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: LocalButton(text: "btn.save", onTap: _save),
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: const LocalAppBar(
          labelKey: "setting.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          shrinkWrap: true,
          children: <Widget>[
            filterChangeLimitBox,
            calibrationVolumeBox,
            customerWarrantyBox,
            vendorWarrantyBox,
            const SizedBox(height: 20),
            updateButton,
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    Setting _setting = mainModel.setting!.clone();
    _setting.customerWarrantyPeriod =
        int.tryParse(customerWarrantyCtl.text) ?? 0;
    _setting.vendorWarrantyPeriod = int.tryParse(vendorWarrantyCtl.text) ?? 0;
    _setting.filterChangeLimit = int.tryParse(filterChangeLimitCtl.text) ?? 0;
    _setting.calibrationVolume = int.tryParse(calibrationVolumeCtl.text) ?? 0;
    try {
      await mainModel.saveSetting(_setting);
      Navigator.pop(context);
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
