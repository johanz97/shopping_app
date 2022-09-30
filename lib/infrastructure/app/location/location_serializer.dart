import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/app/location/location.dart';
import '../center_view_port/center_view_port_serializer.dart';
import '../search/search_serializer.dart';

part 'location_serializer.freezed.dart';
part 'location_serializer.g.dart';

@freezed
class LocationSerializer with _$LocationSerializer {
  @JsonSerializable(explicitToJson: true)
  factory LocationSerializer({
    @JsonKey(name: "search") required SearchSerializer searchSerializer,
    @JsonKey(name: "centerViewport")
        required CenterViewportSerializer centerViewportSerializer,
    @JsonKey(name: "logo") required CenterViewportSerializer logoSerializer,
  }) = _LocationSerializer;

  const LocationSerializer._();

  factory LocationSerializer.fromJson(Map<String, dynamic> json) =>
      _$LocationSerializerFromJson(json);

  Location toDomain() => Location(
        search: searchSerializer.toDomain(),
        centerViewport: centerViewportSerializer.toDomain(),
        logo: logoSerializer.toDomain(),
      );
}
