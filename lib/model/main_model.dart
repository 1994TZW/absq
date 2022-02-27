import 'dart:async';

import 'package:daisy_client/daisy.dart';
import 'package:flutter/foundation.dart';
import 'package:absq/helper/network_connectivity.dart';
import 'package:absq/helper/shared_pref.dart';
import 'package:absq/service/services.dart';
import 'package:absq/vo/about.dart';
import 'package:absq/vo/auth_result.dart';
import 'package:absq/vo/contact.dart';
import 'package:absq/vo/service.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/term.dart';
import 'package:absq/vo/user.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'base_model.dart';

class MainModel extends ChangeNotifier {
  List<BaseModel> models = [];

  String? messagingToken;
  User? user;
  PackageInfo? packageInfo;

  set setMessaginToken(token) {
    messagingToken = token;
    uploadMsgToken();
  }

  Setting? setting;
  bool isLoaded = false;
  bool isOnline = false;
  bool isFirstLaunch = false;

  MainModel() {
    NetworkConnectivity.instance.statusStream.listen((data) {
      bool _isOnline = data["isOnline"];
      if (_isOnline && !isOnline) {
        _init();
      }
      isOnline = _isOnline;
      notifyListeners();
    });
  }
  bool isLogin() {
    return user != null;
  }

  bool isCustomer() {
    return false;
  }

  bool isSysAdmin() {
    return user?.hasSysAdmin() ?? false;
  }

  bool isAdmin() {
    return user?.hasAdmin() ?? false;
  }

  StreamSubscription<User?>? userListener;

  _init() async {
    await _listenSetting();
    isFirstLaunch = (await SharedPref.isFirstLaunch()) ?? false;
    packageInfo = await PackageInfo.fromPlatform();

    userListener?.cancel();
    userListener =
        Services.instance.authService.getUserStream().listen((_user) async {
      if (_user != null) {
        for (final m in models) {
          m.initUser(_user);
        }
        // call diffPrivileges if privilege changed or first time login
        if (user == null || _user.diffPrivileges(user!)) {
          for (final m in models) {
            m.privilegeChanged();
          }
        }
        if (user == null) {
          await uploadMsgToken();
        }
        initDaisy();
      } else {
        if (user != null) {
          for (final m in models) {
            m.logout();
          }
        }
      }
      user = _user;
      isLoaded = true;
      notifyListeners();
    });
  }

  void addModel(BaseModel model) {
    models.add(model);
  }

  Future<void> initDaisy() async {
    try {
      String? token = await Services.instance.commonService
          .getDaisyToken(Daisy.app().options!.appID);
      await Daisy.app().verifyToken(token!);
    } on Exception catch (e) {
      log.info("initDaisy: $e");
    }
  }

  Future<void> _listenSetting() async {
    try {
      Services.instance.authService.getSetting().listen((event) {
        setting = event;
        for (final m in models) {
          m.initSetting(event);
        }
        notifyListeners();
      });
    } finally {}
  }

  bool isSupport() {
    return true;
    // if (packageInfo == null || setting == null) return false;
    // return (int.tryParse(packageInfo!.buildNumber) ?? 0) >=
    //     setting!.supportBuildNum;
  }

  Future<void> removeMsgToken() {
    if (messagingToken == null || user == null) return Future.value();
    return Services.instance.userService.removeMsgToken(messagingToken!);
  }

  Future<void> uploadMsgToken() {
    if (messagingToken == null || user == null) return Future.value();
    return Services.instance.userService.uploadMsgToken(messagingToken!);
  }

  Future<AuthResult> sendSms(String phoneNumber) {
    return Services.instance.authService.sendSmsCodeToPhoneNumber(phoneNumber);
  }

  signIn(String phone) {
    user = User(
        id: "1",
        name: phone == "+959111111111" ? "Mg Mg" : "Mg Zaw Tun",
        phoneNumber: phone,
        isAdmin: phone == "+959111111111" ? true : false,
        storeName: phone == "+959111111111" ? "" : "Lanmadaw Store");
    notifyListeners();
  }

  Future<AuthResult> _signin(String smsCode) async {
    AuthResult authResult =
        await Services.instance.authService.signInWithSmsCode(smsCode);
    return authResult;
  }

  Future<void> signup(String userName) async {
    await Services.instance.authService.signup(userName);
  }

  Future<void> joinInvite(String userName) async {
    await Services.instance.authService.joinInvite(userName);
    notifyListeners();
  }

  Future<bool> hasInvite() async {
    return Services.instance.userService.hasInvite();
  }

  Future<void> signout() async {
    user = null;
    notifyListeners();
    // try {
    //   await removeMsgToken();
    // } catch (e) {}
    // await Services.instance.authService.signout();
    // models.forEach((m) => m.logout());
  }

  Future<void> scanQrcode(String qrcode) {
    return Services.instance.authService.scanQrcode(qrcode);
  }

  Future<void> saveSetting(Setting _setting) {
    return Services.instance.commonService.saveSetting(_setting);
  }

  Future<void> updateContact(Contact contact) {
    return Services.instance.dataService.update({
      "contact_number": contact.contactNumber,
      "email_address": contact.emailAddress,
      "facebook_link": contact.facebookLink,
      "address": contact.address,
      "website": contact.website
    }, "/contact");
    // return Services.instance.commonService.updateContact(contact);
  }

  Future<void> saveFrequentIssuse(String issue, int? index) {
    Setting _setting = setting!.clone();
    List<String> _list = _setting.frequentIssues;
    if (index != null) {
      _list[index] = issue;
    } else {
      _list.add(issue);
    }
    _setting.frequentIssues = _list;
    return Services.instance.commonService.saveSetting(_setting);
  }

  Future<void> deleteFrequentIssuse(String issue) {
    Setting _setting = setting!.clone();
    List<String> _list = _setting.frequentIssues;
    _list.remove(issue);
    _setting.frequentIssues = _list;
    return Services.instance.commonService.saveSetting(_setting);
  }

  Future<void> saveTerm(Term term) async {
    return Services.instance.commonService.saveTerm(term);
  }

  Future<void> saveAbout(About about) async {
    return Services.instance.commonService.saveAbout(about);
  }
}
