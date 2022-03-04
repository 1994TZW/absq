import 'package:absq/helper/theme.dart';
import 'package:absq/model/announcement_model.dart';
import 'package:absq/model/main_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../../vo/announcement.dart';
import '../../vo/user.dart';
import '../../widget/absq_local_app_bar.dart';
import '../../widget/expandable_text.dart';
import '../../widget/local_text.dart';
import '../../widget/show_img.dart';
import '../contact/contact_us_page.dart';
import '../profile/profile_page.dart';
import 'announcement_editor.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({Key? key}) : super(key: key);

  @override
  State<AnnouncementList> createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  @override
  Widget build(BuildContext context) {
    User? _user = Provider.of<MainModel>(context).user;
    var announceModel = Provider.of<AnnouncementModel>(context);

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
        title: const Text("Knowledge Garden",
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
                    builder: (context) => const AnnouncementEditor()));
              },
              icon: const Icon(Icons.add, color: primaryColor),
              label:
                  LocalText(context, "announcement.new", color: primaryColor),
              backgroundColor: Colors.white,
            )
          : null,
      body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: announceModel.announcements.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(announceModel.announcements[index], context);
          }),
    );
  }

  Widget _item(Announcement announcement, BuildContext context) {
     User? _user = Provider.of<MainModel>(context).user;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => ShowImage(localImage: announcement.url!)));
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
                        text: announcement.desc ?? "",
                      )),
                      _user == null?
                      InkWell(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8, top: 8),
                          child: Icon(
                            Icons.download,
                            color: Colors.grey,
                          ),
                        ),
                      ):InkWell(
                        onTap: () {
                           showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        actionSheet(context, announcement));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8, top: 8),
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
                  announcement.url ?? "",
                  fit: BoxFit.cover,
                ),
              ],
            ),
          )),
    );
  }

   CupertinoActionSheet actionSheet(BuildContext context, Announcement announcement) {
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
                "Edit knowledge garden",
                style: TextStyle(color: primaryColor, fontSize: 15),
              )
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AnnouncementEditor(announcement: announcement)),
            );
            
          },
        )
      ],
    );
  }
}
