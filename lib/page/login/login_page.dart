import 'package:country_code_picker/country_code_picker.dart';
import 'package:absq/widget/local_text.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/auth_result.dart';
import 'package:absq/vo/auth_status.dart';
import 'package:absq/widget/local_progress.dart';
import 'code_page.dart';
import '../util.dart';
import 'signin_logic.dart';
import 'widgets/login_button.dart';
import 'widgets/phone_input.dart';
import 'widgets/login_text.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? phone;
  bool _isLoading = false;
  late String dialCode;

  TextEditingController phonenumberCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    phonenumberCtl = TextEditingController(text: "09");
    phonenumberCtl.selection = TextSelection.fromPosition(
        TextPosition(offset: phonenumberCtl.text.length));

    dialCode = "+95";
  }

  @override
  Widget build(BuildContext context) {
    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [primaryColor, primaryColor]),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 48.0, bottom: 30),
                child: TextLogin(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                child: LocalText(
                  context,
                  'signup.phone',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade400, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: CountryCodePicker(
                        onChanged: _countryChange,
                        initialSelection: dialCode,
                        countryFilter: const ['mm', 'sg', 'la'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        textStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          controller: phonenumberCtl,
                          textAlign: TextAlign.left,
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 8),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // InputPhone(
              //   onValueChange: (value) {
              //     phone = value;
              //   },
              // ),
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 48.0),
                    child: LoginButton(
                      loginCallback: () {
                        _login();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _countryChange(CountryCode countryCode) {
    setState(() {
      dialCode = countryCode.dialCode ?? '+95';
    });
  }

  _login() async {
    String phoneNumber = phonenumberCtl.text;
    if (phoneNumber.length < 5) {
      showMsgDialog(context, "Error", "Invalid phone number");
      return;
    }

    // setState(() {
    //   _isLoading = true;
    // });

    try {
      phoneNumber = phoneNumber[0] == "0"
          ? phoneNumber.replaceFirst("0", "")
          : phoneNumber;
      phoneNumber = dialCode + phoneNumber;

      // AuthResult auth = await context.read<MainModel>().sendSms(phoneNumber);
      // if (auth.authStatus == AuthStatus.SMS_SENT) {
      await heroTransitionPush(
        context,
        CodePage(phoneNumber: phoneNumber),
      );
      Navigator.pop(context);
      // } else if (auth.authStatus == AuthStatus.AUTH_VERIFIED) {
      //   await navigateAfterAuthVerified(context);
      // }
      // if (auth.authStatus == AuthStatus.ERROR) {
      //   showMsgDialog(context, "Error", auth.authErrorMsg!);
      // }
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }
}
