import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/localization/app_translations.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';

import 'select_list_item.dart';

class FilterSelectText<T> extends StatefulWidget {
  final String? text;
  final String? labelTextKey;
  final String? labelTitleKey;
  final IconData? iconData;
  final int maxLines;
  final bool withBorder;
  final Color? borderColor;
  final Widget? icon;
  final List<T> items;
  final T? currentValue;
  final Function(T)? callbackSelectItem;
  final Function? callbackDeleteItem;

  const FilterSelectText({
    Key? key,
    this.text,
    this.labelTextKey,
    this.iconData,
    this.maxLines = 1,
    this.withBorder = false,
    this.borderColor,
    this.icon,
    required this.items,
    this.labelTitleKey,
    this.callbackSelectItem,
    this.callbackDeleteItem,
    this.currentValue,
  }) : super(key: key);

  @override
  _FilterSelectTextState<T> createState() => _FilterSelectTextState<T>();
}

class _FilterSelectTextState<T> extends State<FilterSelectText<T>> {
  @override
  Widget build(BuildContext context) {
    var languageModel = Provider.of<LanguageModel>(context);

    var labelStyle = languageModel.isEng
        ? const TextStyle(
            color: Colors.black54,
          )
        : const TextStyle(color: Colors.black54, fontFamily: "Pyidaungsu");
    var textStyle = languageModel.isEng
        ? const TextStyle(
            color: primaryColor,
          )
        : const TextStyle(color: primaryColor, fontFamily: "Pyidaungsu");

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: .0, right: 15.0, top: 8.0, bottom: 8.0),
            child: widget.iconData == null
                ? widget.icon == null
                    ? Container()
                    : widget.icon!
                : Icon(
                    widget.iconData,
                    color: primaryColor,
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.labelTextKey == null
                    ? Container()
                    : Text(
                        AppTranslations.of(context).text(widget.labelTextKey!),
                        style: labelStyle,
                      ),
                widget.text == null
                    ? Container()
                    : Text(
                        widget.text!,
                        style: textStyle,
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: .0, right: 0.0, top: 0.0, bottom: 0.0),
            child: SizedBox(
              height: 40,
              child: IconButton(
                icon: const Icon(
                  Icons.playlist_add_check,
                  color: primaryColor,
                ),
                onPressed: () {},
                // onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                //   builder: (context) => SelectListItem(
                //       labelTitleKey: widget.labelTitleKey,
                //       values: widget.items,
                //       currentItem: widget.currentValue,
                //       iconData: widget.iconData,
                //       imageIcon: widget.icon,
                //       callback: (T item) {
                //         // widget.callbackSelectItem!(item);
                //       }),
                // )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: .0, right: 0.0, top: 0.0, bottom: 0.0),
            child: SizedBox(
              height: 40,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: primaryColor,
                ),
                onPressed: () {
                  widget.callbackDeleteItem!(true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
