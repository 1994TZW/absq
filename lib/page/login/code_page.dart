// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/auth_result.dart';
import 'package:absq/vo/auth_status.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:provider/provider.dart';
import '../../widget/local_text.dart';
import '../util.dart';
import 'signin_logic.dart';

const resend_count_sec = 30;

class CodePage extends StatefulWidget {
  final String phoneNumber;
  const CodePage({Key? key, required this.phoneNumber}) : super(key: key);
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  bool _isLoading = false;
  late String pin;
  late bool allNumberEntered;
  late Timer _timer;
  int _start = resend_count_sec;
  bool canResend = false;

  @override
  void initState() {
    pin = "";
    allNumberEntered = false;
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) => setState(
        () {
          if (_start < 1) {
            t.cancel();
            canResend = true;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LocalProgress(
        inAsyncCall: _isLoading,
        child: Scaffold(
          body: Container(
            color: primaryColor,
            child: ListView(
              padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 40),
                      child: LocalText(
                        context,
                        'singup.verify.title',
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "'" + widget.phoneNumber != null &&
                                widget.phoneNumber.startsWith("+959")
                            ? "0${widget.phoneNumber.substring(3)}"
                            : widget.phoneNumber + "'",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      child: LocalText(context, 'singup.code_sent',
                          fontSize: 15, color: Colors.white),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: PinInputTextField(
                        pinLength: 6,
                        decoration: const BoxLooseDecoration(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 20),
                            strokeColorBuilder:
                                FixedColorBuilder(Colors.white)),
                        textInputAction: TextInputAction.done,
                        autoFocus: true,
                        onChanged: _pinChange,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20, right: 20),
                          child: InkWell(
                            onTap: allNumberEntered ? _verify : null,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: allNumberEntered
                                  ? Colors.white
                                  : Colors.white,
                              child: const Icon(
                                Icons.check,
                                color: primaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: canResend ? _resend : null,
                            color: canResend ? Colors.grey[400] : Colors.grey,
                            child: LocalText(context, 'singup.resend',
                                fontSize: 16,
                                color: canResend
                                    ? primaryColor
                                    : Colors.grey[400]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: canResend
                                        ? primaryColor
                                        : Colors.grey.shade400)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          LocalText(
                            context,
                            'singup.smscode.retry',
                            fontSize: 15,
                            translationVariables: [_start.toString()],
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _pinChange(pin) {
    setState(() {
      this.pin = pin;
      allNumberEntered = this.pin.length == 6;
    });
  }

  _resend() async {}

  _verify() async {
    setState(() {
      _isLoading = true;
    });
    try {
      context.read<MainModel>().signIn(widget.phoneNumber);
      await Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      // AuthResult auth = await context.read<MainModel>().signin(this.pin);
      // if (auth.authStatus == AuthStatus.AUTH_VERIFIED) {
      // await navigateAfterAuthVerified(context);
      // }
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
