import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/app/location/center-viewPort/center_view_port.dart';

part 'center_view_port_serializer.freezed.dart';
part 'center_view_port_serializer.g.dart';

@freezed
class CenterViewportSerializer with _$CenterViewportSerializer {
  @JsonSerializable(createToJson: true)
  factory CenterViewportSerializer({
    required double lat,
    required double lon,
  }) = _CenterViewportSerializer;

  const CenterViewportSerializer._();

  factory CenterViewportSerializer.fromJson(Map<String, dynamic> json) =>
      _$CenterViewportSerializerFromJson(json);

  CenterViewport toDomain() => CenterViewport(
        lat: lat,
        lon: lon,
      );
}
