import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:absq/data/auth_fb.dart';
import 'package:absq/vo/auth_result.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/user.dart';

import 'auth_service.dart';

class AuthServiceImp implements AuthService {
  AuthServiceImp({
    required this.authFb,
    this.connectivity,
  });

  final Connectivity? connectivity;
  final AuthFb authFb;

  @override
  Future<AuthResult> sendSmsCodeToPhoneNumber(String phoneNumber) {
    return authFb.sendSmsCodeToPhoneNumber(phoneNumber);
  }

  @override
  Future<AuthResult> signInWithSmsCode(String smsCode) {
    return authFb.signInWithPhoneNumber(smsCode);
  }

  @override
  Future<void> signout() {
    return authFb.signout();
  }

  @override
  Stream<User?> getUserStream() {
    return authFb.user();
  }

  @override
  Stream<Setting> getSetting() {
    return authFb.settings();
  }

  @override
  Future<void> signup(String userName) {
    return authFb.signup(userName);
  }

  @override
  Future<void> joinInvite(String userName) {
    return authFb.joinInvite(userName);
  }

  @override
  Future<String> getToken() {
    return authFb.getToken();
  }

  @override
  Future<void> scanQrcode(String qrCode) {
    return authFb.scanQrcode(qrCode);
  }
}
