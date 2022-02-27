import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';

import '../util.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;
  TextEditingController nameCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: primaryColor,
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 40),
          child: LocalText(
            context,
            'user_edit.welcome',
            fontSize: 21,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 25),
          child: LocalText(
            context,
            'user_edit.name',
            color: labelColor,
            fontSize: 16,
          ),
        ),
        Container(
            padding: const EdgeInsets.only(top: 0, bottom: 10),
            child: TextFormField(
              controller: nameCtl,
              cursorColor: primaryColor,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0)),
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () => _submit(),
              child: const CircleAvatar(
                minRadius: 25,
                backgroundColor: primaryColor,
                child: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<MainModel>().joinInvite(nameCtl.text);
      Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
