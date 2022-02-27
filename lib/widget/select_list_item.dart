import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/page/util.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';
import 'local_app_bar.dart';

typedef OnAdd = Function();
typedef OnEdit = Function(dynamic);
typedef OnDelete = Function(dynamic);

class SelectListItem<T> extends StatefulWidget {
  final String? labelTitleKey;
  final String? addLabelKey;
  final List<T> values;
  final Function(T)? callback;
  final T? currentItem;
  final IconData? iconData;
  final Widget? imageIcon;
  final String? item;
  final OnAdd? onAdd;
  final OnEdit? onEdit;
  final OnDelete? onDelete;
  final bool phoneNumber;

  const SelectListItem(
      {Key? key,
      this.labelTitleKey,
      this.addLabelKey,
      required this.values,
      this.callback,
      this.currentItem,
      this.iconData,
      this.imageIcon,
      this.item,
      this.onAdd,
      this.onEdit,
      this.onDelete,
      this.phoneNumber = false})
      : super(key: key);

  @override
  State<SelectListItem<T>> createState() => _SelectListItemState<T>();
}

class _SelectListItemState<T> extends State<SelectListItem<T>> {
  final dateFormatter = DateFormat('dd MMM yyyy - hh:mm:ss a');

  final double dotSize = 15.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: LocalAppBar(
          labelKey: widget.labelTitleKey!,
          backgroundColor: primaryColor,
          labelColor: Colors.white,
          arrowColor: Colors.white,
        ),
        floatingActionButton: widget.onAdd == null
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  if (widget.onAdd != null) widget.onAdd!();
                },
                icon: const Icon(Icons.add),
                label: LocalText(context, widget.addLabelKey!,
                    color: Colors.white),
                backgroundColor: primaryColor,
              ),
        body: ListView.separated(
            controller: ScrollController(),
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.black, height: 1),
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.values.length,
            itemBuilder: (BuildContext context, int index) {
              var item = widget.values[index];
              return _item(context, item);
            }),
      ),
    );
  }

  Widget _item<T>(BuildContext context, item) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                widget.callback!(item);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: widget.currentItem != null &&
                              widget.currentItem == item
                          ? const Icon(Icons.check, color: primaryColor)
                          : const SizedBox(width: 23),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: widget.iconData == null
                          ? widget.imageIcon == null
                              ? Container()
                              : widget.imageIcon!
                          : Icon(
                              widget.iconData,
                              color: primaryColor,
                            ),
                    ),
                    widget.phoneNumber
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.phoneNumber}',
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                '${item.name}',
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            ],
                          )
                        : Text(
                            '${item.name}',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                  ],
                ),
              ),
            ),
          ),
          widget.onEdit != null
              ? IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    if (widget.onEdit != null) widget.onEdit!(item);
                  })
              : const SizedBox(),
        ],
      ),
      secondaryActions: widget.onDelete != null
          ? <Widget>[
              widget.onDelete == null
                  ? Container()
                  : IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _remove(item),
                    ),
            ]
          : null,
    );
  }

  _remove(dynamic item) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.onDelete != null) await widget.onDelete!(item);
    } catch (e) {
      showMsgDialog(context, "Error", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
