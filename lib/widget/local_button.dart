import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';

import 'local_text.dart';

class LocalButton extends StatefulWidget {
  final String text;
  final GestureTapCallback onTap;
  final Color? color;
  final IconData? iconData;

  const LocalButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color,
      this.iconData})
      : super(key: key);

  @override
  _LocalButtonState createState() => _LocalButtonState();
}

class _LocalButtonState extends State<LocalButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Center(
              child: Container(
            width: 250,
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.iconData == null
                      ? Container()
                      : Icon(
                          widget.iconData,
                          color: Colors.white,
                        ),
                  SizedBox(
                    width: 15,
                  ),
                  LocalText(context, widget.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ],
              ),
              color: widget.color ?? primaryColor,
              textColor: Colors.white,
              onPressed: () {
                widget.onTap();
              },
            ),
          ))),
    );
  }
}
