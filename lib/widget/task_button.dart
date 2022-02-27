import 'package:absq/helper/theme.dart';
import 'package:absq/widget/local_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef BtnCallback();

/// TaskButton is used to navigate to eash task
class TaskButton extends StatelessWidget {
  final String titleKey;
  final String? subTitle;
  final IconData? icon;
  final Widget? imageIcon;
  final BtnCallback? btnCallback;
  final Widget child;
  final Color color;
  final double height;

  const TaskButton(this.titleKey,
      {Key? key,
      this.subTitle,
      this.icon,
      this.imageIcon,
      this.btnCallback,
      required this.child,
      this.height = 300,
      this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Material(
          elevation: 30.0,
          // shadowColor: Color(0x80f97976),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: btnCallback,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Row(
                        children: <Widget>[
                          icon == null
                              ? imageIcon == null
                                  ? Container()
                                  : imageIcon!
                              : Icon(icon, color: color),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              children: [
                                LocalText(
                                  context,
                                  titleKey,
                                  color: primaryColor,
                                ),
                                subTitle != null
                                    ? Text(
                                        subTitle!,
                                        style: TextStyle(color: Colors.grey.shade600),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
