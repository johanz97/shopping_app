import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/parking_lot/users_device_info/users_device_info.dart';

part 'users_device_info_serializer.freezed.dart';
part 'users_device_info_serializer.g.dart';

@freezed
class UsersDeviceInfoSerializer with _$UsersDeviceInfoSerializer {
  @JsonSerializable(createToJson: true)
  factory UsersDeviceInfoSerializer({
    required String publicIp,
    required String privateIp,
  }) = _UsersDeviceInfoSerializer;

  const UsersDeviceInfoSerializer._();

  factory UsersDeviceInfoSerializer.fromJson(Map<String, dynamic> json) =>
      _$UsersDeviceInfoSerializerFromJson(json);

  factory UsersDeviceInfoSerializer.fromDomain(
    UsersDeviceInfo usersDeviceInfo,
  ) =>
      UsersDeviceInfoSerializer(
        publicIp: usersDeviceInfo.publicIp,
        privateIp: usersDeviceInfo.privateIp,
      );

  UsersDeviceInfo toDomain() => UsersDeviceInfo(
        publicIp: publicIp,
        privateIp: privateIp,
      );
}
