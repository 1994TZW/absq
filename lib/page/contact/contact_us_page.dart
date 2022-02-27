import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/page/contact/contact_us_editor.dart';
import 'package:absq/vo/contact.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/user.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  List<ContactData> _data = [];

  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<MainModel>(context).user;
    if (_user == null) {
      return Container();
    }

    Setting setting = Provider.of<MainModel>(context).setting!;
    _data = [
      ContactData(
          iconData: CupertinoIcons.phone,
          title: "contact.phone",
          text: setting.contactNumber,
          contactType: ContactType.PhoneContact),
      ContactData(
          iconData: CupertinoIcons.mail,
          title: "contact.email",
          contactType: ContactType.EmailContact,
          text: setting.email),
      ContactData(
          iconData: FontAwesomeIcons.facebook,
          title: "contact.facebook",
          contactType: ContactType.FacebookContact,
          text: setting.facebookLink),
      ContactData(
          iconData: FontAwesomeIcons.chrome,
          title: "contact.google",
          contactType: ContactType.WebsiteContact,
          text: setting.website),
      ContactData(
          iconData: CupertinoIcons.location,
          title: "contact.address",
          contactType: ContactType.AddressContact,
          text: setting.address),
    ];
    return Scaffold(
      appBar: LocalAppBar(
        labelKey: "contact.title",
        backgroundColor: Colors.white,
        labelColor: primaryColor,
        arrowColor: primaryColor,
        actions: [
          _user.hasAdmin()
              ? IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: primaryColor,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ContactUsEditor(
                                contact: Contact.fromSetting(setting),
                              )),
                    );
                  })
              : const SizedBox()
        ],
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 20),
          child:
              Timeline(children: _models(), position: TimelinePosition.Left)),
    );
  }

  List<TimelineModel> _models() {
    return _data
        .map((e) => TimelineModel(
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LocalText(
                          context,
                          e.title,
                          color: primaryColor,
                          fontSize: 16,
                        ),
                        Text(e.text),
                      ],
                    ),
                  ),
                ),
                e.contactType == ContactType.AddressContact
                    ? Container()
                    : IconButton(
                        onPressed: () => _launch(e),
                        icon: Icon(Icons.open_in_new),
                        color: primaryColor)
              ],
            ),
            iconBackground: primaryColor,
            icon: Icon(
              e.iconData,
              color: Colors.white,
            )))
        .toList();
  }

  _launch(ContactData contactData) {
    if ((contactData.text.trim()) == "") return;
    if (contactData.contactType == ContactType.PhoneContact) {
      launch("tel:${contactData.text.trim().replaceAll(' ', '')}");
    } else if (contactData.contactType == ContactType.EmailContact) {
      launch("mailto:${contactData.text}");
    } else if (contactData.contactType == ContactType.FacebookContact ||
        contactData.contactType == ContactType.WebsiteContact) {
      launch("${contactData.text}");
    }
  }
}

enum ContactType {
  PhoneContact,
  EmailContact,
  FacebookContact,
  WebsiteContact,
  AddressContact
}

class ContactData {
  IconData iconData;
  String title;
  String text;
  ContactType contactType;
  ContactData(
      {required this.iconData,
      required this.title,
      required this.text,
      required this.contactType});
}
