import 'package:flutter/material.dart';

typedef OnValueChange(String value);
class PasswordInput extends StatefulWidget {
  final OnValueChange onValueChange;

  const PasswordInput({Key? key, required this.onValueChange}) : super(key: key);
  
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Theme(
          data: new ThemeData(
            primaryColor: Colors.white38,
            primaryColorDark: Colors.white38,            
          ),
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            obscureText: true,
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.yellow)),
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.white70,
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.white70)),
                onChanged: (value) => widget.onValueChange(value),
          ),

        ),
      ),
    );
  }
}
