import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_device_info.freezed.dart';

@freezed
class UsersDeviceInfo with _$UsersDeviceInfo {
  const factory UsersDeviceInfo({
    required String publicIp,
    required String privateIp,
  }) = _UsersDeviceInfo;

  factory UsersDeviceInfo.test() {
    return const UsersDeviceInfo(
      privateIp: '123',
      publicIp: '123',
    );
  }
}
