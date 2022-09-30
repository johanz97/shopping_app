import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  const DeviceInfo();
  static Future<String> getUserAgent() async {
    final osVersion = await getOsVersion();
    final model = await getModel();
    final manufacturer = await getManufacturer();
    return "$osVersion, $model $manufacturer";
  }

  static Future<String> getOsVersion() async {
    String osVersion;
    if (Platform.isIOS) {
      final iosInfoModel = await iosInfo();
      osVersion = "IOS ${iosInfoModel.systemVersion}";
    } else {
      final androidInfoModel = await andoirdInfo();
      osVersion = "Android ${androidInfoModel.version.sdkInt}";
    }

    return osVersion;
  }

  static Future<String> getManufacturer() async {
    if (Platform.isIOS) {
      return "Apple";
    } else {
      final info = await andoirdInfo();
      return info.manufacturer!;
    }
  }

  static Future<String> getModel() async {
    if (Platform.isIOS) {
      final info = await iosInfo();
      return info.name!;
    } else {
      final info = await andoirdInfo();
      return info.model!;
    }
  }

  static Future<IosDeviceInfo> iosInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo;
  }

  static Future<AndroidDeviceInfo> andoirdInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo;
  }
}
