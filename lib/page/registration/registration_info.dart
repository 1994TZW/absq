import 'package:absq/vo/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/theme.dart';
import '../../widget/display_text.dart';
import '../../widget/local_app_bar.dart';
import '../../widget/local_button.dart';
import '../../widget/local_progress.dart';
import '../util.dart';

class RegistrationInfo extends StatefulWidget {
  final Registration registration;

  const RegistrationInfo({Key? key, required this.registration})
      : super(key: key);

  @override
  _RegistrationInfoState createState() => _RegistrationInfoState();
}

class _RegistrationInfoState extends State<RegistrationInfo> {
  final dateFormatter = DateFormat('dd MMM yyyy');
  bool _isLoading = false;
  late Registration _registration;

  @override
  void initState() {
    super.initState();
    _registration = widget.registration;
  }

  @override
  Widget build(BuildContext context) {
    final centerNamebox = DisplayText(
      text: _registration.centerName ?? "",
      labelTextKey: "registration.center_name",
      iconData: FontAwesome5Regular.building,
    );

    final centerNumberbox = DisplayText(
      text: _registration.centerNumber ?? "",
      labelTextKey: "registration.center_no",
      iconData: AntDesign.slack_square,
    );

    final namebox = DisplayText(
      text: _registration.name ?? "",
      labelTextKey: "registration.name",
      iconData: MaterialCommunityIcons.account_box,
    );

    final datebox = DisplayText(
      text: dateFormatter.format(_registration.date!),
      labelTextKey: "registration.date",
      iconData: Icons.date_range,
    );

    final idNumberBox = DisplayText(
      text: _registration.idNumber,
      labelTextKey: "registration.id_number",
      iconData: FontAwesome5Brands.slack_hash,
    );

    final genderBox = DisplayText(
      text: _registration.gender,
      labelTextKey: "registration.gender",
      iconData: Foundation.male_female,
    );

    final phonenumberbox = Container(
      child: Row(
        children: [
          Expanded(
            child: DisplayText(
              text: _registration.phone ?? "",
              labelTextKey: "registration.phone",
              iconData: Icons.phone,
            ),
          ),
          IconButton(
              icon: const Icon(Icons.open_in_new, color: primaryColor),
              onPressed: () {
                launch(
                    "tel:${_registration.phone ?? "".trim().replaceAll(' ', '')}");
              })
        ],
      ),
    );

    final emailbox = Container(
      child: Row(
        children: [
          Expanded(
            child: DisplayText(
              text: _registration.email ?? "",
              labelTextKey: "registration.email",
              iconData: Icons.email,
            ),
          ),
          IconButton(
              icon: const Icon(Icons.open_in_new, color: primaryColor),
              onPressed: () {
                launch("mailto:${_registration.email ?? ""}");
              })
        ],
      ),
    );

    final dateOfBirthbox = DisplayText(
      text: dateFormatter.format(_registration.dateOfBirth!),
      labelTextKey: "registration.date_of_birth",
      iconData: Icons.date_range,
    );

    final addressBox = DisplayText(
        text: _registration.address,
        labelTextKey: "registration.address",
        iconData: Ionicons.location_outline);

    final schoolBox = DisplayText(
      text: _registration.schoolNameAndTeacher,
      labelTextKey: "registration.school_name",
      iconData: MaterialCommunityIcons.school,
    );

    final levelBox = DisplayText(
      text: _registration.level,
      labelTextKey: "registration.level",
      iconData: Icons.perm_device_information,
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: LocalAppBar(
          labelKey: "registration.form.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download, color: primaryColor))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: centerNamebox),
                Flexible(child: centerNumberbox),
              ],
            ),
            const Divider(
              height: 2,
            ),
            Row(
              children: [
                Flexible(child: datebox),
                Flexible(child: idNumberBox),
              ],
            ),
            const Divider(
              height: 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: schoolBox),
                Flexible(child: levelBox),
              ],
            ),
            const Divider(
              height: 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: namebox),
                Flexible(child: genderBox),
              ],
            ),
            const Divider(
              height: 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: dateOfBirthbox),
                Flexible(child: addressBox),
              ],
            ),
            const Divider(
              height: 2,
            ),
            phonenumberbox,
            const Divider(
              height: 2,
            ),
            emailbox,
            const Divider(
              height: 2,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
