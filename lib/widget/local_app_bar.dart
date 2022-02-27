import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'local_text.dart';

class LocalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String labelKey;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? arrowColor;
  final List<Widget>? actions;
  final bool showArrow;

  const LocalAppBar(
      {Key? key,
      required this.labelKey,
      this.backgroundColor,
      this.labelColor,
      this.arrowColor,
      this.actions,
      this.showArrow = true})
      : super(key: key);
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: showArrow
          ? IconButton(
              icon: Icon(CupertinoIcons.back, color: arrowColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      shadowColor: Colors.transparent,
      backgroundColor: backgroundColor,
      title: LocalText(
        context,
        labelKey,
        color: labelColor,
        fontSize: 20,
      ),
      actions: actions,
    );
  }
}
