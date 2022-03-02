import 'package:absq/model/main_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../helper/theme.dart';
import '../../widget/local_progress.dart';
import '../../widget/local_text.dart';
import '../admin_tab_page.dart';
import '../util.dart';
import 'package:provider/provider.dart';

class SigninEmail extends StatefulWidget {
  const SigninEmail({Key? key}) : super(key: key);

  @override
  _SigninEmailState createState() => _SigninEmailState();
}

class _SigninEmailState extends State<SigninEmail> {
  bool _isLoading = false;
  TextEditingController emailCtl = TextEditingController();

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
              controller: emailCtl,
              cursorColor: primaryColor,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              autofocus: true,
              style: const TextStyle(fontSize: 18),
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
    if (emailCtl.text == "") {
      showMsgDialog(context, "Error", "Invalid email");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      context.read<MainModel>().signIn(emailCtl.text );
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const AdminTabPage()),
      );
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
