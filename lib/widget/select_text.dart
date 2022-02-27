import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/localization/app_translations.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/language_model.dart';

import 'select_list_item.dart';

class SelectText<T> extends StatefulWidget {
  final String? text;
  final String? labelTextKey;
  final String? labelTitleKey;
  final String? addLabelKey;
  final IconData? iconData;
  final int maxLines;
  final bool withBorder;
  final Color? borderColor;
  final Widget? icon;
  final Widget? actionIcon;
  final List<T>? items;
  final T? currentValue;
  final Function(T)? callbackSelectItem;
  final String item;
  final OnAdd? onAdd;
  final OnEdit? onEdit;
  final OnDelete? onDelete;
  final bool phoneNumber;

  const SelectText(
      {Key? key,
      this.text,
      this.labelTextKey,
      this.addLabelKey,
      this.iconData,
      this.maxLines = 1,
      this.withBorder = false,
      this.borderColor,
      this.icon,
      required this.items,
      this.labelTitleKey,
      this.callbackSelectItem,
      this.currentValue,
      required this.item,
      this.onAdd,
      this.onEdit,
      this.onDelete,
      this.actionIcon,
      this.phoneNumber = false})
      : super(key: key);

  @override
  _SelectTextState<T> createState() => _SelectTextState<T>();
}

class _SelectTextState<T> extends State<SelectText<T>> {
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
                    : widget.icon
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
                icon: widget.actionIcon ??
                    const Icon(
                      Icons.playlist_add_check,
                      color: primaryColor,
                    ),
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => SelectListItem(
                      labelTitleKey: widget.labelTitleKey!,
                      addLabelKey: widget.addLabelKey,
                      values: widget.items!,
                      currentItem: widget.currentValue,
                      iconData: widget.iconData,
                      imageIcon: widget.icon,
                      item: widget.item,
                      phoneNumber: widget.phoneNumber,
                      onAdd: widget.onAdd,
                      onEdit: widget.onEdit,
                      onDelete: widget.onDelete,
                      callback: (T? item) {
                        widget.callbackSelectItem!(item!);
                      }),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
