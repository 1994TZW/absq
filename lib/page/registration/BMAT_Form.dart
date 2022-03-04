import 'package:absq/model/registration_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../helper/localization/app_translations.dart';
import '../../helper/theme.dart';
import '../../model/language_model.dart';
import '../../widget/input_text.dart';
import '../../widget/local_app_bar.dart';
import '../../widget/local_button.dart';
import '../../widget/local_progress.dart';

class BMATForm extends StatefulWidget {
  const BMATForm({Key? key}) : super(key: key);

  @override
  _BMATFormState createState() => _BMATFormState();
}

class _BMATFormState extends State<BMATForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameCtl = new TextEditingController();
  TextEditingController _addressCtl = new TextEditingController();
  TextEditingController _emailCtl = new TextEditingController();
  TextEditingController _dateOfBirthCtl = new TextEditingController();
  TextEditingController _phoneCtl = new TextEditingController();
  TextEditingController _schoolCtl = new TextEditingController();
  String? level;

  bool _isLoading = false;

  int val = 1;

  @override
  Widget build(BuildContext context) {
    var languageModel = Provider.of<LanguageModel>(context);
    var regModel = Provider.of<RegistrationModel>(context);

    final nameBox = InputText(
      labelTextKey: "registration.name",
      iconData: MaterialCommunityIcons.account,
      controller: _nameCtl,
    );

    final addressBox = InputText(
      labelTextKey: "registration.address",
      iconData: Icons.location_on,
      controller: _addressCtl,
      maxLines: 2,
    );

    final dateOfBirthBox = InputText(
      labelTextKey: "registration.date_of_birth",
      iconData: Icons.date_range,
      controller: _dateOfBirthCtl,
    );

    final emailBox = InputText(
      labelTextKey: "registration.email",
      iconData: MaterialCommunityIcons.email,
      controller: _emailCtl,
    );

    final phoneBox = InputText(
      labelTextKey: "registration.phone",
      iconData: MaterialCommunityIcons.phone,
      controller: _emailCtl,
    );

    final schoolBox = InputText(
      labelTextKey: "bmat.candidate_name",
      iconData: FontAwesome5Solid.user_graduate,
      controller: _schoolCtl,
    );

    final genderBox = Container(
        padding: const EdgeInsets.only(left: 5, top: 15),
        child: Row(
          children: [
            Text(
              "Gender :",
              style: newLabelStyle(color: Colors.black54, fontSize: 17),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: ListTile(
                onTap: () {
                  setState(() {
                    val = 1;
                  });
                },
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Male"),
                leading: Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: 1,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value as int;
                      });
                    },
                    activeColor: primaryColor),
              ),
            ),
            Flexible(
              child: ListTile(
                onTap: () {
                  setState(() {
                    val = 2;
                  });
                },
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Female"),
                leading: Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: 2,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value as int;
                      });
                    },
                    activeColor: primaryColor),
              ),
            ),
          ],
        ));

    final addBtn = Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: LocalButton(
        text: "btn.save",
        onTap: _create,
      ),
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: const LocalAppBar(
          labelKey: "bmat.form.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            children: <Widget>[
              nameBox,
              dateOfBirthBox,
              addressBox,
              emailBox,
              phoneBox,
              genderBox,
              schoolBox,
              const SizedBox(height: 20),
              addBtn
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _create() async {
    // Station station = _getPayload();
    // bool valid = await _validate(station);
    // if (!valid) {
    //   return;
    // }
    // setState(() {
    //   _isLoading = true;
    // });
    // var stationModel = Provider.of<StationModel>(context, listen: false);
    // try {
    //   await stationModel.create(station);
    //   Navigator.pop(context);
    // } catch (e) {
    //   showMsgDialog(context, "Error", e.toString());
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }
}
