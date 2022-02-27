import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';

import '../../util.dart';

typedef LoginCallback();

class LoginButton extends StatefulWidget {
  final LoginCallback loginCallback;

  const LoginButton({Key? key, required this.loginCallback}) : super(key: key);
  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      height: 50,
      width: 130,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              5.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FlatButton(
        onPressed: () {
          widget.loginCallback();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              getLocalString(context, "signup.continue"),
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
