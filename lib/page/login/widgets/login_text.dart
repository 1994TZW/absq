import 'package:flutter/material.dart';
import '../../util.dart';

class TextLogin extends StatefulWidget {
  @override
  _TextLoginState createState() => _TextLoginState();
}

class _TextLoginState extends State<TextLogin> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          getLocalString(context, "signup.mg"),
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Hero(
              tag: "logo",
              child: Image.asset(
                "assets/logo.jpg",
                height: 50,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
