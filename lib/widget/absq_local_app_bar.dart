import 'package:absq/helper/theme.dart';
import 'package:flutter/material.dart';

class AbsqLocalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;

  const AbsqLocalAppBar({
    Key? key,
    this.title,
    this.backgroundColor = kBackgroundColor,
    this.actions,
    this.leading,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      leading: leading,
      backgroundColor: backgroundColor,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
