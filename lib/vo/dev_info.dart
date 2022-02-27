import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class DevInfo {
  bool isAndroid = false;
  bool isIOS = false;
  String deviceID = "";
  String id = "";
  String model = "";

  static DevInfo? _instance;

  static Future<DevInfo> getDevInfo() async {
    if (_instance != null) return Future.value(_instance);

    _instance = DevInfo();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _instance!.deviceID = androidInfo.androidId ?? "";
      _instance!.id = androidInfo.id ?? "";
      _instance!.model = androidInfo.model ?? "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      _instance!.deviceID = iosDeviceInfo.identifierForVendor ?? "";
      _instance!.id = iosDeviceInfo.utsname.release ?? "";
      _instance!.model = iosDeviceInfo.model ?? "";
    }
    return Future.value(_instance);
  }
}
