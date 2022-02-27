import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/contact.dart';
import 'package:absq/widget/input_text.dart';
import 'package:absq/widget/local_button.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';

import '../util.dart';

class ContactUsEditor extends StatefulWidget {
  final Contact? contact;
  const ContactUsEditor({Key? key, this.contact}) : super(key: key);

  @override
  _ContactUsEditorState createState() => _ContactUsEditorState();
}

class _ContactUsEditorState extends State<ContactUsEditor> {
  TextEditingController _contactCtl = TextEditingController();
  TextEditingController _addressCtl = TextEditingController();
  TextEditingController _emailCtl = TextEditingController();
  TextEditingController _websiteCtl = TextEditingController();
  TextEditingController _facebookCtl = TextEditingController();

  Contact? contact;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      contact = widget.contact!;
      _contactCtl.text = contact?.contactNumber ?? "";
      _addressCtl.text = contact?.address ?? '';
      _emailCtl.text = contact?.emailAddress ?? '';
      _websiteCtl.text = contact?.website ?? '';
      _facebookCtl.text = contact?.facebookLink ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactBox = InputText(
        labelTextKey: 'contact.phone',
        iconData: CupertinoIcons.phone,
        controller: _contactCtl);

    final addressBox = InputText(
        labelTextKey: 'contact.address',
        iconData: CupertinoIcons.location,
        maxLines: 3,
        controller: _addressCtl);

    final emailBox = InputText(
        labelTextKey: 'contact.email',
        iconData: CupertinoIcons.mail,
        controller: _emailCtl);

    final websiteBox = InputText(
        labelTextKey: 'contact.google',
        iconData: Fontisto.world_o,
        controller: _websiteCtl);

    final faceBookBox = InputText(
        labelTextKey: 'contact.facebook',
        iconData: FontAwesomeIcons.facebook,
        controller: _facebookCtl);

    final saveBox = LocalButton(text: 'btn.save', onTap: _save);

    return LocalProgress(
        inAsyncCall: _isLoading,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.back, color: primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: LocalText(
                context,
                'contact.edit.title',
                color: primaryColor,
                fontSize: 20,
              )),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  children: [
                    contactBox,
                    addressBox,
                    emailBox,
                    faceBookBox,
                    websiteBox,
                    const SizedBox(
                      height: 10,
                    ),
                    saveBox,
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _save() async {
    setState(() {
      _isLoading = true;
    });
    Contact contact = Contact(
        contactNumber: _contactCtl.text,
        address: _addressCtl.text,
        emailAddress: _emailCtl.text,
        website: _websiteCtl.text,
        facebookLink: _facebookCtl.text);
    try {
      var mainModel = Provider.of<MainModel>(context, listen: false);
      await mainModel.updateContact(contact);
      Navigator.pop(context, true);
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
