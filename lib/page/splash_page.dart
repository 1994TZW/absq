import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:absq/helper/theme.dart';
import 'package:absq/model/main_model.dart';
import 'package:absq/page/util.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/widget/local_button.dart';
import 'package:absq/widget/local_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String page = "/language_selection";
  bool _loaded = false;
  bool _isSupport = true;
  bool _isOnline = true;
  late Timer timer;

  startTime() async {
    var _duration = const Duration(milliseconds: 3000);
    timer = Timer.periodic(_duration, navigationPage);
  }

  void navigationPage(Timer timer) async {
    if (_loaded && _isOnline && _isSupport) {
      timer.cancel();
      Navigator.of(context).pushReplacementNamed(page);
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
    if (timer.isActive) timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    PackageInfo? _packageInfo = mainModel.packageInfo;

    _isSupport = mainModel.isSupport();
    _isOnline = mainModel.isOnline;
    if (mainModel.isLoaded) {
      if (mainModel.isFirstLaunch) {
        page = "/language_selection";
      } else if (mainModel.isLogin()) {
        page = "/home";
      } else {
        page = "/login";
      }
      _loaded = mainModel.isLoaded && (mainModel.setting != null);
    }

    final upgradeAppButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: primaryColor,
          textStyle: const TextStyle(fontSize: 20, color: primaryColor),
          shadowColor: Colors.transparent),
      onPressed: () {
        _upgradeApp(
          context,
          int.tryParse(_packageInfo?.buildNumber ?? "0") ?? 1,
        );
      },
      child: LocalText(
        context,
        "app.app_upgrade",
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );

    return Scaffold(
       backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "logo",
                child: Image.asset(
                  "assets/logo.jpg",
                  height: 100,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Column(
              children: const <Widget>[
                Text(
                  "Cambridge Exam Centre",
                  style: welcomeSubLabelStyle,
                ),
              ],
            ),
          const SizedBox(
            height: 20,
          ),
          _loaded && !_isOnline
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      LocalText(context, "offline.status"),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 25,
          ),
          _loaded
              ? Column(
                  children: [
                    Text(
                        !_isSupport
                            ? "Version outdated, please update your app!"
                            : "",
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    !_isSupport ? upgradeAppButton : const SizedBox()
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  _upgradeApp(BuildContext context, int buildNum) async {
    MainModel mainModel = Provider.of<MainModel>(context, listen: false);
    Setting _setting = mainModel.setting!;
    if (_setting == null) return;
    if (_setting.supportBuildNum <= buildNum) {
      // showMsgSnackBar(context, getLocalString(context, "app.latest_version"),
      //     backgroundColor: Colors.green.shade400);
      return;
    } else if (_setting.supportBuildNum > buildNum) {
      await launch(_setting.latestBuildUrl);
    }
  }
}
