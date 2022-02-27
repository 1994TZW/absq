import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/widget/input_text.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_button.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';

import '../util.dart';

typedef void ProfileCallback();

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController nameController = new TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    nameController.text = mainModel.user!.name;
  }

  @override
  Widget build(BuildContext context) {
    final nameBox = InputText(
      labelTextKey: "profile.name",
      iconData: Icons.person,
      controller: nameController,
    );

    final saveBtn = Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: LocalButton(
        iconData: Icons.save,
        text: "btn.save",
        onTap: _save,
      ),
    );
    return LocalProgress(
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: const LocalAppBar(
          labelKey: "profile.edit.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(child: nameBox),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: saveBtn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _save() async {
    setState(() {
      _loading = true;
    });
    try {
      Navigator.pop(context);
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
