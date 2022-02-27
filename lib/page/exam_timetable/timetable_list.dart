import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/model/timetable_model.dart';
import 'package:absq/vo/timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../vo/user.dart';
import '../../widget/absq_local_app_bar.dart';
import '../profile/profile_page.dart';

class TimeTabelList extends StatefulWidget {
  const TimeTabelList({Key? key}) : super(key: key);

  @override
  State<TimeTabelList> createState() => _TimeTabelListState();
}

class _TimeTabelListState extends State<TimeTabelList> {
  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<MainModel>(context).user;
    if (_user == null) {
      return Container();
    }
    User user = Provider.of<MainModel>(context).user!;

    var timetableModel = Provider.of<TimetableModel>(context);

    return Scaffold(
      appBar: AbsqLocalAppBar(
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
        title: const Text("Exam Timetable",
            style: TextStyle(color: primaryColor, fontSize: 18)),
        actions: [
          IconButton(
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
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(10),
          itemCount: timetableModel.timeTables.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(timetableModel.timeTables[index], context);
          }),
    );
  }

  Widget _item(TimeTable timeTable, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Image.asset(timeTable.url ?? "",fit: BoxFit.cover,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timeTable.desc??""),
                Icon(Icons.download,color: Colors.grey,)
              ],
            )
          ],
        ),
      ),
      // child: Card(
      //   elevation: 1,
      //    shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15.0),

      // ),
      //   child: Image.asset(timeTable.url ?? ""),
      // ),
    );
  }
}
