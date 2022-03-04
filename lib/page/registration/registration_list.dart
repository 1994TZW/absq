import 'package:absq/helper/theme.dart';
import 'package:absq/model/registration_model.dart';
import 'package:absq/vo/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widget/absq_local_app_bar.dart';
import '../contact/contact_us_page.dart';
import '../profile/profile_page.dart';
import 'registration_info.dart';

class RegistrationList extends StatefulWidget {
  const RegistrationList({Key? key}) : super(key: key);

  @override
  State<RegistrationList> createState() => _RegistrationListState();
}

class _RegistrationListState extends State<RegistrationList> {
  final dateFormatter = DateFormat('dd MMM yyyy');
  @override
  Widget build(BuildContext context) {
    var regModel = Provider.of<RegistrationModel>(context);

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
        title: const Text("Registrations",
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
          itemCount: regModel.registerations.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(regModel.registerations[index], context);
          }),
    );
  }

  Widget _item(Registration registration, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) =>
                  RegistrationInfo(registration: registration)));
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0 - 15 / 2),
                      child: Icon(
                        Icons.account_circle,
                        color: primaryColor,
                        size: 55,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            registration.name ?? "",
                            style: const TextStyle(fontSize: 15.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              registration.formType,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14.0),
                            ),
                          ),
                          registration.idNumber == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Text(
                                    registration.idNumber ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14.0),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    registration.date == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              dateFormatter.format(registration.date!),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14.0),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
