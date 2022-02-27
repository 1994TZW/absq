import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/vo/user.dart';
import 'package:absq/widget/display_text.dart';
import 'package:absq/widget/local_app_bar.dart';
import 'package:absq/widget/local_progress.dart';

import '../../widget/local_button.dart';
import '../util.dart';
import 'profile_edit.dart';

typedef ProfileCallback = void Function();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey key = GlobalKey();
  bool _isLoading = false;
  TextEditingController bizNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    if (mainModel.user == null) {
      return Container();
    }

    final namebox = DisplayText(
      text: mainModel.user?.name ?? "Admin",
      labelTextKey: "profile.name",
      iconData: Icons.person,
    );

    final phonenumberbox = DisplayText(
      text: mainModel.user!.phone,
      labelTextKey: "profile.phone",
      iconData: Icons.phone,
    );

    final statusBox = DisplayText(
      text: mainModel.user!.status,
      labelTextKey: "profile.status",
      icon: const ImageIcon(
        AssetImage(
          "assets/icons/status.png",
        ),
        color: primaryColor,
      ),
    );

    // final versionBox = Text(
    //     "${mainModel.packageInfo.version}+${mainModel.packageInfo.buildNumber}");

    final customerBox = DisplayText(
      text: mainModel.user!.customerName,
      labelTextKey: "customer.customer_name",
      iconData: FontAwesomeIcons.building,
    );

    final stationBox = DisplayText(
      text: mainModel.user!.stationName,
      labelTextKey: "customer.station",
      icon: const ImageIcon(
        AssetImage(
          "assets/icons/station.png",
        ),
        color: primaryColor,
      ),
    );

    final logoutBtn = Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: LocalButton(
        iconData: Icons.exit_to_app,
        text: "btn.logout",
        onTap: () {
          _logout();
        },
      ),
    );

    return LocalProgress(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: key,
        appBar: const LocalAppBar(
          labelKey: "profile.title",
          backgroundColor: Colors.white,
          labelColor: primaryColor,
          arrowColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: namebox),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 0),
                  //   child: IconButton(
                  //       icon: const Icon(Icons.edit, color: Colors.grey),
                  //       onPressed: _editName),
                  // )
                ],
              ),
              const Divider(),
              phonenumberbox,
              const Divider(),
              // statusBox,
              // const Divider(),
              mainModel.user!.isCustomer() ? customerBox : const SizedBox(),
              mainModel.user!.isCustomer() ? const Divider() : const SizedBox(),
              mainModel.user!.isCustomer() ? stationBox : const SizedBox(),
              mainModel.user!.isCustomer() ? const Divider() : const SizedBox(),

              SizedBox(height: 25),
              logoutBtn
              // Center(child: versionBox),
            ],
          ),
        ),
      ),
    );
  }

  _copy(String title, String data) {
    Clipboard.setData(ClipboardData(text: data));
    _showToast(title);
  }

  _showToast(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('copied "$title" data to clipboard'),
        backgroundColor: secondaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  _editName() {
    Navigator.of(context)
        .push<void>(CupertinoPageRoute(builder: (context) => ProfileEdit()));
  }

  _logout() {
    showConfirmDialog(context, "home.logout.confirm", () async {
      setState(() {
        _isLoading = true;
      });
      try {
        await context.read<MainModel>().signout();
      } catch (e) {
        print(e);
      } finally {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/login", ModalRoute.withName('/login'));
      }
    });
  }
}
