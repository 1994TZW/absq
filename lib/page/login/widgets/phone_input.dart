import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';

import '../../util.dart';

typedef OnValueChange = Function(String value);

class InputPhone extends StatefulWidget {
  final OnValueChange onValueChange;

  const InputPhone({Key? key, required this.onValueChange}) : super(key: key);

  @override
  _InputPhoneState createState() => _InputPhoneState();
}

class _InputPhoneState extends State<InputPhone> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Theme(
          data: ThemeData(
            primaryColor: Colors.white38,
            primaryColorDark: Colors.white38,
          ),
          child: TextField(
            keyboardType: TextInputType.phone,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70, width: 1.0),
                ),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                fillColor: Colors.white70,
                labelText: getLocalString(context, "signup.phone"),
                labelStyle: const TextStyle(
                  color: Colors.white70,
                ),
                prefix: const Text("09 ",
                    style: TextStyle(
                      color: thirdColor,
                    )),
                prefixIcon: const Icon(
                  Icons.phone,
                  color: Colors.white70,
                )),
            onChanged: (value) => widget.onValueChange(value),
          ),
        ),
      ),
    );
  }
}
