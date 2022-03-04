import 'package:absq/vo/timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/theme.dart';
import '../../widget/input_text.dart';
import '../../widget/local_app_bar.dart';
import '../../widget/local_button.dart';
import '../../widget/local_progress.dart';
import '../../widget/multi_img_controller.dart';
import '../../widget/multi_img_file.dart';

class TimetableEditor extends StatefulWidget {
  final TimeTable? timeTable;

  const TimetableEditor({Key? key, this.timeTable}) : super(key: key);
  @override
  _TimetableEditorState createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _descCtl = new TextEditingController();
  MultiImgController _multiImgController = MultiImgController();

  bool _isLoading = false;
  bool isNew = true;
  TimeTable? _timeTable;

  @override
  void initState() {
    super.initState();
    if (widget.timeTable != null) {
      _timeTable = widget.timeTable;
      _descCtl.text = _timeTable?.desc ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final descBox = InputText(
      labelTextKey: "timetable.desc",
      iconData: Icons.text_format,
      controller: _descCtl,
      maxLines: 2,
    );

    final img = MultiImageFile(
      enabled: true,
      controller: _multiImgController,
      title: "file",
      titleKey: "timetable.image",
    );

    final addBtn = Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: LocalButton(
        text: "btn.save",
        onTap: _create,
      ),
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: const LocalAppBar(
          labelKey: "timetable.form.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            children: <Widget>[
              descBox,
              Container(padding: const EdgeInsets.only(left: 5), child: img),
              const SizedBox(height: 20),
              addBtn
            ],
          ),
        ),
      ),
    );
  }

  // Station _getPayload() {
  //   Station station = Station(location: Location());

  //   try {
  //     station.id = _station.id;
  //     station.name = _nameCtl.text;
  //     station.address = _descCtl.text;
  //     station.minVariance = _minCtl.text == "" ? 0 : double.parse(_minCtl.text);
  //     station.maxVariance = _maxCtl.text == "" ? 0 : double.parse(_maxCtl.text);
  //     station.customerID = _customer?.id;
  //     station.customerName = _customer?.name;
  //     station.location!.latitude =
  //         _latiCtl.text == "" ? 0 : double.parse(_latiCtl.text);
  //     station.location!.longitude =
  //         _lonCtl.text == "" ? 0 : double.parse(_lonCtl.text);
  //     // station.location!.latitude = _location?.latitude;
  //     // station.location!.longitude = _location?.longitude;
  //   } catch (e) {
  //     showMsgDialog(context, "Error", e.toString()); // shold never happen
  //   }
  //   return station;
  // }

  // Future<bool> _validate(Station station) async {
  //   if (station.name == "") {
  //     await showMsgDialog(context, "Error", "Invalid station name!");
  //     return false;
  //   }
  //   if (station.customerID == null) {
  //     await showMsgDialog(context, "Error", "Invalid Customer!");
  //     return false;
  //   }
  //   if (station.address == null) {
  //     await showMsgDialog(context, "Error", "Invalid address!");
  //     return false;
  //   }
  //   if (station.minVariance == null) {
  //     await showMsgDialog(context, "Error", "Invalid Min Variance!");
  //     return false;
  //   }
  //   if (station.maxVariance == null) {
  //     await showMsgDialog(context, "Error", "Invalid Max Variance!");
  //     return false;
  //   }
  //   return true;
  // }

  Future<void> _create() async {
    // Station station = _getPayload();
    // bool valid = await _validate(station);
    // if (!valid) {
    //   return;
    // }
    // setState(() {
    //   _isLoading = true;
    // });
    // var stationModel = Provider.of<StationModel>(context, listen: false);
    // try {
    //   await stationModel.create(station);
    //   Navigator.pop(context);
    // } catch (e) {
    //   showMsgDialog(context, "Error", e.toString());
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }
}
