import 'package:absq/vo/auth_result.dart';
import 'package:absq/vo/setting.dart';
import 'package:absq/vo/user.dart';

abstract class AuthService {
  Future<void> signup(String userName);

  Future<AuthResult> sendSmsCodeToPhoneNumber(String phoneNumber);
  Future<AuthResult> signInWithSmsCode(String smsCode);
  Future<void> signout();
  Future<void> joinInvite(String userName);
  Stream<User?> getUserStream();
  Stream<Setting> getSetting();
  Future<String> getToken();
  Future<void> scanQrcode(String qrCode);
}
