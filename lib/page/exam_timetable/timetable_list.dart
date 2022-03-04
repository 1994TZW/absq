import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/model/timetable_model.dart';
import 'package:absq/vo/timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../../vo/user.dart';
import '../../widget/absq_local_app_bar.dart';
import '../../widget/expandable_text.dart';
import '../../widget/local_text.dart';
import '../../widget/show_img.dart';
import '../contact/contact_us_page.dart';
import '../profile/profile_page.dart';
import 'timetable_editor.dart';

class TimeTabelList extends StatefulWidget {
  const TimeTabelList({Key? key}) : super(key: key);

  @override
  State<TimeTabelList> createState() => _TimeTabelListState();
}

class _TimeTabelListState extends State<TimeTabelList> {
  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<MainModel>(context).user;
    var timetableModel = Provider.of<TimetableModel>(context);

    return Scaffold(
      appBar: AbsqLocalAppBar(
        backgroundColor: Colors.white,
        leading: Hero(
            tag: "sme_logo",
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                child: Image.asset(
                  "assets/logo.jpg",
                  height: 40,
                  filterQuality: FilterQuality.medium,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            )),
        title: const Text("Exam Timetables",
            style: TextStyle(color: primaryColor, fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
              },
              icon: const Icon(
                Icons.phone,
                color: primaryColor,
                size: 30,
              )),
          _user != null
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const Profile()),
                    );
                  },
                  icon: const Icon(
                    Icons.account_circle,
                    color: primaryColor,
                    size: 30,
                  ))
              : const SizedBox()
        ],
      ),
      floatingActionButton: _user != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => const TimetableEditor()));
              },
              icon: const Icon(Icons.add, color: primaryColor),
              label: LocalText(context, "timetabel.new", color: primaryColor),
              backgroundColor: Colors.white,
            )
          : null,
      body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: timetableModel.timeTables.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(timetableModel.timeTables[index], context);
          }),
    );
  }

  Widget _item(TimeTable timeTable, BuildContext context) {
    User? _user = Provider.of<MainModel>(context).user;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => ShowImage(localImage: timeTable.url!)));
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ExpandableText(
                        text: timeTable.desc ?? "",
                      )),
                      _user == null
                          ? InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Icon(
                                  Icons.download,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        actionSheet(context, timeTable));
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Icon(
                                  Feather.more_vertical,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Image.asset(
                  timeTable.url ?? "",
                  fit: BoxFit.cover,
                ),
              ],
            ),
          )),
    );
  }

  CupertinoActionSheet actionSheet(BuildContext context, TimeTable timeTable) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          child: Row(children: const [
            SizedBox(width: 10),
            Icon(
              Icons.download,
              color: primaryColor,
              // size: 30,
            ),
            SizedBox(width: 15),
            Text(
              "Download file",
              style: TextStyle(color: primaryColor, fontSize: 15),
            )
          ]),
          onPressed: () => {},
        ),
        CupertinoActionSheetAction(
          child: Row(
            children: const [
              SizedBox(width: 10),
              Icon(
                Icons.edit,
                color: primaryColor,
              ),
              SizedBox(width: 15),
              Text(
                "Edit timetable",
                style: TextStyle(color: primaryColor, fontSize: 15),
              )
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => TimetableEditor(timeTable: timeTable)),
            );
            
          },
        )
      ],
    );
  }
}
