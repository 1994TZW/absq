import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/widget/input_text.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_button.dart';
import 'package:absq/widget/local_progress.dart';

import '../util.dart';

class FrequentIssueEditor extends StatefulWidget {
  final String? issue;
  final int? index;

  const FrequentIssueEditor({Key? key, this.issue, this.index})
      : super(key: key);

  @override
  _FrequentIssueEditorState createState() => _FrequentIssueEditorState();
}

class _FrequentIssueEditorState extends State<FrequentIssueEditor> {
  bool _isLoading = false;
  String? selectedLanguage;
  TextEditingController issueController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.issue != null) {
      issueController.text = widget.issue ?? "";
    } else {
      issueController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final namebox = InputText(
      controller: issueController,
      labelTextKey: "frequent_issue.name",
      iconData: Icons.text_format,
    );

    final saveBtn = Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: LocalButton(
        text: widget.issue == null ? "btn.save" : "btn.update",
        onTap: () async {
          setState(() {
            _isLoading = true;
          });
          // if (widget.issue == null) return;
          MainModel mainModel = Provider.of<MainModel>(context, listen: false);
          try {
            await mainModel.saveFrequentIssuse(
                issueController.text, widget.index);
            Navigator.pop(context);
          } catch (e) {
            showMsgDialog(context, "Error", e.toString());
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: const LocalAppBar(
          labelKey: "frequent_issue.form.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          shrinkWrap: true,
          children: <Widget>[
            namebox,
            // const Divider(
            //   height: 2,
            // ),
            saveBtn
          ],
        ),
      ),
    );
  }
}
