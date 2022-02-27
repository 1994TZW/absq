import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';

import 'local_text.dart';

class LocalTitle extends StatelessWidget {
  final String textKey;
  final Widget? trailing;

  const LocalTitle({Key? key, required this.textKey, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 18),
          child: Row(
            children: [
              LocalText(
                context,
                textKey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              trailing != null ? const Spacer() : Container(),
              trailing ?? Container()
            ],
          ),
        ),
        // Divider(
        //   thickness: 2,
        //   color: primaryColor,
        // )
      ],
    );
  }
}
