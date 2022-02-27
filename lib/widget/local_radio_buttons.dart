import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:absq/helper/theme.dart';

class LocalRadioButtons<T> extends StatelessWidget {
  final Function(T?) callback;
  final IconData? iconData;
  final T? selectedValue;
  final List<T> values;
  final bool readOnly;
  final bool hideUnselected;

  const LocalRadioButtons(
      {Key? key,
      required this.callback,
      this.iconData,
      this.selectedValue,
      required this.values,
      this.readOnly = false,
      this.hideUnselected = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: readOnly ? getReadonlyChildren() : getChildren());
  }

  List<Widget> getChildren() {
    return values
        .toList()
        .map((e) => SizedBox(
            height: 30,
            child: InkWell(
              onTap: () => callback(e),
              child: Row(children: <Widget>[
                Radio<T>(
                  activeColor: primaryColor,
                  groupValue: selectedValue,
                  value: e,
                  onChanged: (T? value) {
                    callback(value);
                  },
                ),
                Text(e.toString()),
              ]),
            )))
        .toList();
  }

  List<Widget> getReadonlyChildren() {
    return values
        .toList()
        .map((e) => hideUnselected && e == selectedValue
            ? SizedBox(
                height: 30,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          e == selectedValue ? Icons.check : Icons.remove,
                          color:
                              e == selectedValue ? primaryColor : Colors.grey,
                        ),
                      ),
                      Text(e.toString()),
                    ]),
              )
            : Container())
        .toList();
  }
}
