import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/page/setting/frequent_issuse_editor.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_progress.dart';
import 'package:absq/widget/local_text.dart';

class FrequentIssueList extends StatefulWidget {
  const FrequentIssueList({Key? key}) : super(key: key);

  @override
  _FrequentIssueListState createState() => _FrequentIssueListState();
}

class _FrequentIssueListState extends State<FrequentIssueList> {
  var dateFormatter = DateFormat('dd MMM yyyy - hh:mm:ss a');
  final double dotSize = 15.0;
  final bool _isLoading = false;
  late List<String> _issues = [];

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    Setting setting = mainModel.setting!;
    _issues = setting.frequentIssues;

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: const LocalAppBar(
          labelKey: "frequent_issue.title",
          backgroundColor: primaryColor,
          labelColor: Colors.white,
          arrowColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => const FrequentIssueEditor()));
          },
          icon: const Icon(Icons.add),
          label: LocalText(context, "frequent_issue.new", color: Colors.white),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                      height: 1,
                    ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _issues.length,
                itemBuilder: (BuildContext context, int index) {
                  String _i = _issues[index];
                  return Slidable(
                    child: _item(_i, index),
                    actionPane: const SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          MainModel mainModel =
                              Provider.of<MainModel>(context, listen: false);
                          await mainModel.deleteFrequentIssuse(_i);
                        },
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _item(String issue, int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => FrequentIssueEditor(
                  issue: issue,
                  index: index,
                )));
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
                      child: const Icon(
                        FontAwesomeIcons.exclamationTriangle,
                        color: primaryColor,
                        size: 40,
                      )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          issue,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
